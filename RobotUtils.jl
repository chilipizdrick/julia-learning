include("SmartRobot.jl")


# Convertation related functions
function invert(object::Union{HorizonSide,Diagonal,Vector{Tuple{HorizonSide,Int64}}})
    if isa(object, HorizonSide)
        return HorizonSide(mod(Int(object) + 2, 4))
    end
    if isa(object, Diagonal)
        return Diagonal(mod(Int(object) + 2, 4))
    end
    if isa(object, Vector{Tuple{HorizonSide,Int64}})
        inv_path = []
        for move in reverse(object)
            move = (invert(move[1]), move[2])
            push!(inv_path, move)
        end
        return inv_path
    end
end

function rotate(direction::Union{HorizonSide,Diagonal})
    if isa(direction, HorizonSide)
        return HorizonSide(mod(Int(direction) + 1, 4))
    end
    if isa(direction, Diagonal)
        return Diagonal(mod(Int(direction) + 1, 4))
    end
end


# Higher order functions

function mark_line_condition!(sr::SmartRobot, direction::Union{HorizonSide,Diagonal}, mark_condition::Function, stop_condition::Function)::Integer
    steps = 0
    if mark_condition(sr)
        putmarker!(sr)
    end
    while !stop_condition(sr)
        if try_move!(sr, direction)
            if mark_condition(sr)
                putmarker!(sr)
            end
            steps += 1
        else
            break
        end
    end
    return steps
end

function mark_line_steps_condition!(sr::SmartRobot, direction::Union{HorizonSide,Diagonal}, steps::Integer, mark_condition::Function, stop_condition::Function)
    if mark_condition(sr)
        putmarker!(sr)
    end
    for _ in 1:steps
        if !stop_condition(sr) && try_move!(sr, direction)
            if mark_condition(sr)
                putmarker!(sr)
            end
        else
            break
        end
    end
end

function mark_shutle_condition!(sr::SmartRobot, direction::Union{HorizonSide,Diagonal}, mark_condition::Function, stop_condition::Function)
    side = direction
    steps = 0
    while !stop_condition(sr)
        steps += 1
        mark_line_steps_condition!(sr, side, steps, mark_condition, stop_condition)
        if !stop_condition(sr)
            move_steps!(sr, invert(side), steps)
            side = invert(side)
        end
        mark_line_steps_condition!(sr, side, steps, mark_condition, stop_condition)
        if !stop_condition(sr)
            move_steps!(sr, invert(side), steps)
            side = invert(side)
        end
    end
end

function mark_snake_condition!(sr::SmartRobot, moving_side::HorizonSide, ortogonal_side::HorizonSide, mark_condition::Function, stop_condition::Function)
    while !isborder(sr, ortogonal_side)
        mark_line_condition!(sr, moving_side, mark_condition, (r) -> isborder(r, moving_side))
        try_move!(sr, ortogonal_side)
        moving_side = invert(moving_side)
    end
    mark_line_condition!(sr, moving_side, mark_condition, (r) -> isborder(r, moving_side))
end

function mark_spiral_condition!(sr::SmartRobot, moving_side::HorizonSide, mark_condition::Function, stop_condition::Function)
    steps = 0
    while !stop_condition(sr)
        steps += 1
        mark_line_steps_condition!(sr, moving_side, steps, mark_condition, stop_condition)
        moving_side = rotate(moving_side)
        mark_line_steps_condition!(sr, moving_side, steps, mark_condition, stop_condition)
        moving_side = rotate(moving_side)
    end
end


function try_move!(sr::SmartRobot, direction::Union{HorizonSide,Diagonal})::Bool
    if !isborder(sr, direction)
        move!(sr, direction)
        return true
    end
    println("[WARNING]: Tried to move into obstacle!")
    return false
end


# Rewritten simple functions

function move_until!(sr::SmartRobot, direction::Union{HorizonSide,Diagonal})::Integer
    return mark_line_condition!(sr, direction, (sr) -> false, (sr) -> isborder(sr, direction))
end

function move_steps!(sr::SmartRobot, direction::Union{HorizonSide,Diagonal}, steps::Integer)
    return mark_line_steps_condition!(sr, direction, steps, (sr) -> false, (sr) -> false)
end

function mark_line!(sr::SmartRobot, direction::Union{HorizonSide,Diagonal})::Integer
    return mark_line_condition!(sr, direction, (sr) -> true, (sr) -> isborder(sr, direction))
end


# Other functions

function move_around_steps!(sr::SmartRobot, side::HorizonSide, steps::Integer)
    while steps > 0
        if isborder(sr, side)
            result = avoid_obstacle!(sr, side, rotate(side))
            if !result[1]
                result = avoid_obstacle!(sr, side, invert(rotate(side)))
            end
            if !result[1]
                println("[WARNING]: Could not avoid obstacle!")
                break
            end
            steps -= result[2]
        else
            move!(sr, side)
            steps -= 1
        end
    end
end

function avoid_obstacle!(sr::SmartRobot, moving_side::HorizonSide, avoiding_side::HorizonSide)::Tuple{Bool,Integer}
    steps = 0
    avoiding_steps = 0
    while isborder(sr, moving_side) && !isborder(sr, avoiding_side)
        move!(sr, avoiding_side)
        avoiding_steps += 1
    end
    if isborder(sr, moving_side) && isborder(sr, avoiding_side)
        for _ in 1:avoiding_steps
            move!(sr, invert(avoiding_side))
        end
        return (false, 0)
    else
        move!(sr, moving_side)
        steps += 1
        while isborder(sr, invert(avoiding_side))
            move!(sr, moving_side)
            steps += 1
        end
        move_steps!(sr, invert(avoiding_side), avoiding_steps)
    end
    return (true, steps)
end

function move_to_corner!(sr::SmartRobot, corner::Diagonal)
    side_tuple = associate_diagonal(corner)
    while !is_corner(sr, corner)
        if !isborder(sr, side_tuple[1])
            move!(sr, side_tuple[1])
        end
        if !isborder(sr, side_tuple[2])
            move!(sr, side_tuple[2])
        end
    end
end

function follow_path!(sr::SmartRobot, path::Vector{Any})
    for move in path
        for _ in 1:move[2]
            move!(sr, move[1])
        end
    end
end


# Checking related functions
function is_corner(sr::SmartRobot, corner::Diagonal)::Bool
    side_tuple = associate_diagonal(corner)
    return isborder(sr, side_tuple[1]) && isborder(sr, side_tuple[2])
end


# Other functions
function mark_outer_perimeter_from_corner!(sr::SmartRobot, corner::Diagonal)
    side_tuple = associate_diagonal(corner)
    side = side_tuple[2]
    for _ in 0:4
        putmarker!(sr)
        mark_line!(sr, side)
        side = rotate(side)
    end
end

function check_corner(sr::SmartRobot)::Diagonal
    for diagonal in (Diagonal(i) for i in 0:3)
        if all(isborder(sr, side) for side in associate_diagonal(diagonal))
            return diagonal
        end
    end
end