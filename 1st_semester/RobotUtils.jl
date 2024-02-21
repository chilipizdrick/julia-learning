include("AbstractRobot.jl")
include("SmartRobot.jl")
include("AreaRobot.jl")


rotate(side::HorizonSide) = HorizonSide(mod(Int(side) + 1, 4))
rotate(diagonal::Diagonal) = Diagonal(mod(Int(diagonal) + 1, 4))
rotate_clockwise(side::HorizonSide) = HorizonSide(mod(Int(side) - 1, 4))


"""
This function follows the conture and returns robot into its initial position.
Robot moves following left border relative to its movement direction. 
The function assumes that the robot is located near the border.
"""
function follow_conture!(ar::AbstractRobot)
    last_move = rotate_clockwise(check_borders(ar)[1])
    initial_coord = copy(getcoord(ar))
    
    cur_move = pick_next_move(ar, last_move)
    initial_move = deepcopy(cur_move)
    
    move!(ar, cur_move)
    last_move = cur_move

    while getcoord(ar) != initial_coord || 
        pick_next_move(ar, last_move) != initial_move

        cur_move = pick_next_move(ar, last_move)
        move!(ar, cur_move)
        last_move = cur_move
    end
end

function pick_next_move(ar::AbstractRobot, last_move::HorizonSide)::HorizonSide
    cur_side = rotate(last_move)
    while isborder(ar, cur_side)
        cur_side = rotate_clockwise(cur_side)
    end
    return cur_side
end

function check_borders(ar::AbstractRobot)::Vector{HorizonSide}
    result = []
    for side in (Ost, Nord, West, Sud)
        if isborder(ar, side)
            push!(result, side)
        end
    end
    return result
end


"""
Calculates area of an enclosed conture. Returns positive value if it 
is measured from outside. Returns negative value otherwise. The absolute value 
is always equal to the area of the measured conture.
"""
function calculate_area_determinant!(ar::AreaRobot, border_side::HorizonSide)::Int64
    num_steps = move_until!(ar, border_side)
    clear_data!(ar)
    set_calc_area_flag!(ar, true)
    follow_conture!(ar)
    set_calc_area_flag!(ar, false)
    move_steps!(ar, invert(border_side), num_steps)
    return getarea(ar)
end


# Higher order functions
function mark_line_condition!(
    ar::AbstractRobot,
    direction::Union{HorizonSide,Diagonal},
    mark_condition::Function,
    stop_condition::Function
)::Integer
    steps = 0
    if mark_condition(ar)
        putmarker!(ar)
    end
    while !stop_condition(ar)
        if try_move!(ar, direction)
            if mark_condition(ar)
                putmarker!(ar)
            end
            steps += 1
        else
            break
        end
    end
    return steps
end

function mark_line_steps_condition!(
    ar::AbstractRobot,
    direction::Union{HorizonSide,Diagonal},
    steps::Integer,
    mark_condition::Function,
    stop_condition::Function
)
    if mark_condition(ar)
        putmarker!(ar)
    end
    for _ in 1:steps
        if !stop_condition(ar) && try_move!(ar, direction)
            if mark_condition(ar)
                putmarker!(ar)
            end
        else
            break
        end
    end
end

function mark_shuttle_condition!(
    ar::AbstractRobot,
    direction::Union{HorizonSide,Diagonal},
    mark_condition::Function,
    stop_condition::Function
)
    side = direction
    steps = 0
    while !stop_condition(ar)
        steps += 1
        mark_line_steps_condition!(ar, side, steps, mark_condition, stop_condition)
        if !stop_condition(ar)
            move_steps!(ar, invert(side), steps)
            side = invert(side)
        end
        mark_line_steps_condition!(ar, side, steps, mark_condition, stop_condition)
        if !stop_condition(ar)
            move_steps!(ar, invert(side), steps)
            side = invert(side)
        end
    end
end

function mark_snake_condition!(
    ar::AbstractRobot,
    moving_side::HorizonSide,
    ortogonal_side::HorizonSide,
    mark_condition::Function,
    stop_condition::Function
)
    while !isborder(ar, ortogonal_side)
        mark_line_condition!(ar, moving_side, mark_condition, (r) -> isborder(r, moving_side))
        try_move!(ar, ortogonal_side)
        moving_side = invert(moving_side)
    end
    mark_line_condition!(ar, moving_side, mark_condition, (r) -> isborder(r, moving_side))
end

function mark_spiral_condition!(
    ar::AbstractRobot,
    moving_side::HorizonSide,
    mark_condition::Function,
    stop_condition::Function
)
    steps = 0
    while !stop_condition(ar)
        steps += 1
        mark_line_steps_condition!(ar, moving_side, steps, mark_condition, stop_condition)
        moving_side = rotate(moving_side)
        mark_line_steps_condition!(ar, moving_side, steps, mark_condition, stop_condition)
        moving_side = rotate(moving_side)
    end
end

function avoid_mark_line_condition!(
    ar::AbstractRobot,
    direction::HorizonSide,
    mark_condition::Function,
    stop_condition::Function
)
    if mark_condition(ar)
        putmarker!(ar)
    end
    while !isborder(ar, direction) || avoid_obstacle!(ar, direction)
        if mark_condition(ar)
            putmarker!(ar)
        end
        try_move!(ar, direction)
        if mark_condition(ar)
            putmarker!(ar)
        end
    end
end

function avoid_mark_snake_condition!(
    ar::AbstractRobot,
    moving_side::HorizonSide,
    ortogonal_side::HorizonSide,
    mark_condition::Function,
    stop_condition::Function,
)
    while !isborder(ar, ortogonal_side)
        avoid_mark_line_condition!(ar, moving_side, mark_condition, (r) -> false)
        try_move!(ar, ortogonal_side)
        moving_side = invert(moving_side)
    end
    avoid_mark_line_condition!(ar, moving_side, mark_condition, (r) -> false)
end


function try_move!(
    ar::AbstractRobot,
    direction::Union{HorizonSide,Diagonal}
)::Bool
    if !isborder(ar, direction)
        move!(ar, direction)
        return true
    end
    return false
end

# Rewritten simple functions

function move_until!(ar::AbstractRobot, direction::Union{HorizonSide,Diagonal})::Integer
    return mark_line_condition!(ar, direction, (r) -> false, (r) -> isborder(r, direction))
end

function move_steps!(ar::AbstractRobot, direction::Union{HorizonSide,Diagonal}, steps::Integer)
    return mark_line_steps_condition!(ar, direction, steps, (r) -> false, (r) -> false)
end

function mark_line!(ar::AbstractRobot, direction::Union{HorizonSide,Diagonal})::Integer
    return mark_line_condition!(ar, direction, (r) -> true, (r) -> isborder(r, direction))
end


# Other functions
function avoid_obstacle!(
    ar::AbstractRobot,
    moving_side::HorizonSide
)::Bool
    avoiding_side = rotate(moving_side)
    avoiding_steps = mark_line_condition!(ar, avoiding_side, (r) -> false, (r) -> !isborder(r, moving_side))
    if isborder(ar, moving_side) && isborder(ar, avoiding_side)
        move_steps!(ar, invert(avoiding_side), avoiding_steps)
        return false
    end
    try_move!(ar, moving_side)
    mark_line_condition!(ar, moving_side, (r) -> false, (r) -> !isborder(r, invert(avoiding_side)))
    move_steps!(ar, invert(avoiding_side), avoiding_steps)
    return true
end

function move_to_corner!(ar::AbstractRobot, corner::Diagonal)
    side_tuple = associate_diagonal(corner)
    while !is_corner(ar, corner)
        if !isborder(ar, side_tuple[1])
            move!(ar, side_tuple[1])
        end
        if !isborder(ar, side_tuple[2])
            move!(ar, side_tuple[2])
        end
    end
end

function follow_path!(ar::AbstractRobot, path::Path)
    for move in path.path
        for _ in 1:move[2]
            move!(ar, move[1])
        end
    end
end

function move_around_barier_shuttle!(ar::AbstractRobot, border_side::HorizonSide)::Bool
    ar.path = Path([])
    if border_side == Ost || border_side == West
        side = Nord
    else # if border_side == Nord || border_side == Sud
        side = Ost
    end
    mark_shuttle_condition!(ar, side, (r) -> false, (r) -> !isborder(r, border_side))
    move!(ar, border_side)
    path = copy(ar.path)
    inv_path = invert(path)
    move_steps!(ar, inv_path.path[2][1], div(inv_path.path[2][2], 2) + mod(inv_path.path[2][2], 2))
    return true
end

"""
The function returns the first found border in the order (Ost, Nord, West, Sud).
"""
function check_border(ar::AbstractRobot)::HorizonSide
    for side in (Ost, Nord, West, Sud)
        if isborder(ar, side)
            return side
        end
    end
end


# Checking related functions
function is_corner(ar::AbstractRobot, corner::Diagonal)::Bool
    side_tuple = associate_diagonal(corner)
    return isborder(ar, side_tuple[1]) && isborder(ar, side_tuple[2])
end


# Other functions
function mark_outer_perimeter_from_corner!(ar::AbstractRobot, corner::Diagonal)
    side_tuple = associate_diagonal(corner)
    side = side_tuple[2]
    for _ in 0:4
        putmarker!(ar)
        mark_line!(ar, side)
        side = rotate(side)
    end
end

function check_corner(ar::AbstractRobot)::Diagonal
    for diagonal in (Diagonal(i) for i in 0:3)
        if all(isborder(ar, side) for side in associate_diagonal(diagonal))
            return diagonal
        end
    end
end
