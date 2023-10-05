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


# Movement related functions
function move_until!(sr::SmartRobot, direction::Union{HorizonSide,Diagonal})::Integer
    steps = 0
    while !isborder(sr, direction)
        move!(sr, direction)
        steps += 1
    end
    return steps
end

function move_steps!(sr::SmartRobot, direction::Union{HorizonSide,Diagonal}, steps::Integer)
    for _ in 1:steps
        move!(sr, direction)
    end
end

function mark_line!(sr::SmartRobot, direction::Union{HorizonSide,Diagonal})::Integer
    steps = 0
    putmarker!(sr)
    while !isborder(sr, direction)
        move!(sr, direction)
        putmarker!(sr)
        steps += 1
    end
    return steps
end

function mark_line_condition!(sr::SmartRobot, direction::Union{HorizonSide, Diagonal}, condition::Function)::Integer
    steps = 0
    if condition(sr)
        putmarker!(sr)
    end
    while !isborder(sr, direction)
        move!(sr, direction)
        if condition(sr)
            putmarker!(sr)
        end
        steps += 1
    end
    return steps       
end

function mark_snake_condition!(sr::SmartRobot, condition::Function)
    corner = check_corner(sr)
    if corner == WestSud
        moving_side = Ost
        border_side = Nord
    elseif corner == SudOst
        moving_side = West
        border_side = Nord
    elseif corner == OstNord
        moving_side = West
        border_side = Sud
    else # if corner == NordWest
        moving_side = West
        border_side = Sud
    end
    while !isborder(sr, border_side)
        mark_line_condition!(sr, moving_side, condition)
        move!(sr, border_side)
        moving_side = invert(moving_side)
    end
    mark_line_condition!(sr, moving_side, condition)
end

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

function avoid_obstacle!(sr::SmartRobot, moving_side::HorizonSide, avoiding_side::HorizonSide)::Tuple{Bool, Integer}
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