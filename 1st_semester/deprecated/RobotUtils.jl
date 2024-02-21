using HorizonSideRobots
include("Enums.jl")


# Polymorphic functions

"""
Polymorphic function for moving in a straight line or diagonally.
Either HorizonSide or Diagonal can be supplied as direction.
"""
function move_steps_p!(r::Robot, direction, steps::Integer)
    if isa(direction, HorizonSide)
        move_steps_straight!(r, direction, steps)
    elseif isa(direction, Diagonal)
        move_steps_diagonal!(r, direction, steps)
    else
        throw("[ERROR]: Unsupported type supplied! Direction should be either HorizonSide or Diagonal.")
    end
end

"""
Polymorphic function for moving in a straight line or a diagonal until the first border or mark.
Either HorizonSide or Diagonal can be supplied as direction.
Function retuns a true if robot moved into mark, else returns false.
"""
function move_until_p!(r::Robot, direction; marking::Bool=false, consider_marker::Bool=false)::Bool
    if isa(direction, HorizonSide)
        return move_until_straight!(r, direction, marking=marking, consider_marker=consider_marker)
    elseif isa(direction, Diagonal)
        return move_until_diagonal!(r, direction, marking=marking, consider_marker=consider_marker)
    else
        throw("[ERROR]: Unsupported type supplied! Direction should be either HorizonSide or Diagonal.")
    end
end

"""
Polymorphic function for marking a line or a diagonal.
Either HorizonSide or Diagonal can be supplied as direction.
Function returns the number of competed steps.
"""
function mark_line_p!(r::Robot, direction)::Integer
    if isa(direction, HorizonSide)
        return mark_line_straight!(r, direction)
    elseif isa(direction, Diagonal)
        return mark_line_diagonal!(r, direction)
    else
        throw("[ERROR]: Unsupported type supplied! Direction should be either HorizonSide or Diagonal.")
    end
end

"""
Polymorphic function inversing the supplied direction.
Either HorizonSide or Diagonal can be supplied as direction.
Function returns the inversed direction.
"""
function inverse_p(direction)
    if isa(direction, HorizonSide)
        return inverse_straight(direction)
    elseif isa(direction, Diagonal)
        return inverse_diagonal(direction)
    else
        throw("[ERROR]: Unsupported type supplied! Direction should be either HorizonSide or Diagonal.")
    end
end

"""
Polymorphic function rotating the given direction counter clockwise.
Either HorizonSide or Diagonal can be supplied as direction.
Function returns the inversed direction.
"""
function rotate_p(direction)
    if isa(direction, HorizonSide)
        return rotate_straight(direction)
    elseif isa(direction, Diagonal)
        return rotate_diagonal(direction)
    else
        throw("[ERROR]: Unsupported type supplied! Direction should be either HorizonSide or Diagonal.")
    end
end

"""
Polymorphic function counting markers in a given direction.
Either HorizonSide or Diagonal can be supplied as direction.
Function returns the number of markers counted.
"""
function count_markers_in_line_p!(r::Robot, direction)::Integer
    if isa(direction, HorizonSide)
        return count_markers_in_line_straight!(r, direction)
    elseif isa(direction, Diagonal)
        return count_markers_in_line_diagonal!(r, direction)
    else
        throw("[ERROR]: Unsupported type supplied! Direction should be either HorizonSide or Diagonal.")
    end
end

# Other utility functions

function goto_corner!(r::Robot, corner::Diagonal)::Vector
    side_tuple = associate_diagonal(corner)
    path = []
    while !(isborder(r, side_tuple[1]) && isborder(r, side_tuple[2]))
        if !isborder(r, side_tuple[1])
            move!(r, side_tuple[1])
            push!(path, side_tuple[1])
        end
        if !isborder(r, side_tuple[2])
            move!(r, side_tuple[2])
            push!(path, side_tuple[2])
        end
    end
    return path
end

function invert_path(path::Vector)::Vector
    inv_path = []
    for move in reverse(path)
        move = inverse_p(move)
        push!(inv_path, move)
    end
    return inv_path
end

function go_path!(r::Robot, path::Vector)
    for move in path
        move!(r, move)
    end
end

function mark_outer_perimeter_from_corner!(r::Robot, corner::Diagonal)
    side_tuple = associate_diagonal(corner)
    side = side_tuple[2]
    for _ in 0:4
        putmarker!(r)
        move_until_p!(r, side, marking=true)
        side = rotate_p(side)
    end
end

function mark_inner_perimeter_from_corner!(r::Robot, corner::Diagonal)
    side_tuple = associate_diagonal(corner)
    side = inverse_p(side_tuple[1])
    for _ in 0:4
        mark_until_off_wall!(r, side)
        side = rotate_p(side)
    end
end

function mark_until_off_wall!(r::Robot, side::HorizonSide)
    move!(r, side)
    putmarker!(r)
    while isborder(r, rotate_p(side))
        move!(r, side)
        putmarker!(r)
    end
end

function get_corner(r::Robot)::Diagonal
    if isborder(r, Ost) && isborder(r, Nord)
        return OstNord
    elseif isborder(r, Nord) && isborder(r, West)
        return NordWest
    elseif isborder(r, West) && isborder(r, Sud)
        return WestSud
    else # if isborder(r, Sud) && isborder(r, Ost)
        return SudOst
    end
end

function scan_until_sud_border!(r::Robot, corner::Diagonal)
    if corner == OstNord
        side = West
    elseif corner == NordWest
        side = Ost
    else
        throw("[ERROR]: A starting conner should be either OstNord or NordWest.")
    end
    while !isborder(r, Sud)
        if side == West
            if !isborder(r, West)
                move!(r, West)
            else
                move!(r, Sud)
                side = inverse_p(side)
            end
        elseif side == Ost
            if !isborder(r, Ost)
                move!(r, Ost)
            else
                move!(r, Sud)
                side = inverse_p(side)
            end
        else
            throw("[ERROR]: This code should be unreachable.")
        end
    end
end

function move_until_marker_straight!(r::Robot, side::HorizonSide, steps::Integer)
    while !ismarker(r) && steps > 0
        move!(r, side)
        steps -= 1
        if ismarker(r)
            return true
        end
    end
    return false
end

"""
The function returns the first found border in the order (Ost, Nord, West, Sud).
"""
function check_border(r::Robot)::HorizonSide
    for side in (Ost, Nord, West, Sud)
        if isborder(r, side)
            return side
        end
    end
end

function count_steps_until_border!(r::Robot, side::HorizonSide)::Integer
    count = 0
    while !isborder(r, side)
        move!(r, side)
        count += 1
    end
    move_steps_p!(r, inverse_p(side), count)
    return count
end

function mark_dotted_line!(r::Robot, side::HorizonSide; marker_flag = false)
    while !isborder(r, side)
        if marker_flag
            putmarker!(r)
        end
        move!(r, side)

        if marker_flag
            marker_flag = false
        else
            marker_flag = true
        end
    end
    if marker_flag
        putmarker!(r)
    end
end


# Functions regarding straight movement

function mark_line_straight!(r::Robot, side::HorizonSide)::Integer
    count = 0
    if !ismarker(r)
        putmarker!(r)
    end
    while !isborder(r, side)
        move!(r, side)
        putmarker!(r)
        count += 1
    end
    return count
end

function move_steps_straight!(r::Robot, side::HorizonSide, num_steps::Integer)
    for _ in range(start=1, step=1, stop=num_steps)
        move!(r, side)
    end
end

function move_until_straight!(r::Robot, side::HorizonSide; marking=false, consider_marker=false)::Bool
    moved_into_mark = false
    while !isborder(r, side) && (!ismarker(r) || !consider_marker)
        if marking
            putmarker!(r)
        end
        move!(r, side)
    end
    if ismarker(r) && consider_marker
        move!(r, inverse_straight(side))
        moved_into_mark = true
    end
    return moved_into_mark
end

inverse_straight(side::HorizonSide)::HorizonSide = HorizonSide(mod(Int(side) + 2, 4))

rotate_straight(side::HorizonSide)::HorizonSide = HorizonSide(mod(Int(side) + 1, 4))


# Functions regarding diagonal movement

function mark_line_diagonal!(r::Robot, diagonal::Diagonal)::Integer
    side_tuple = associate_diagonal(diagonal)
    count = 0
    if !ismarker(r)
        putmarker!(r)
    end
    while !(isborder(r, side_tuple[1]) || isborder(r, side_tuple[2]))
        move!(r, side_tuple[1])
        move!(r, side_tuple[2])
        putmarker!(r)
        count += 1
    end
    return count
end

function move_steps_diagonal!(r::Robot, diagonal::Diagonal, steps::Integer)
    side_tuple = associate_diagonal(diagonal)
    for _ in range(start=1, step=1, stop=steps)
        move!(r, side_tuple[2])
        move!(r, side_tuple[1])
    end
end

function move_until_diagonal!(r::Robot, diagonal::Diagonal; marking=false, consider_marker=false)::Bool
    side_tuple = associate_diagonal(diagonal)
    moved_into_mark = false
    while !isborder(r, side_tuple[1]) && !isborder(r, side_tuple[2]) && (!ismarker(r) || !consider_marker)
        if marking
            putmarker!(r)
        end
        move!(r, side_tuple[1])
        move!(r, side_tuple[2])
    end
    if ismarker(r) && consider_marker
        moved_into_mark = true
        inversed_side_tuple = associate_diagonal(inverse_diagonal(diagonal))
        move!(r, inversed_side_tuple[1])
        move!(r, inversed_side_tuple[2])
    end
    return moved_into_mark
end

inverse_diagonal(diagonal::Diagonal)::Diagonal = Diagonal(mod(Int(diagonal) + 2, 4))

rotate_diagonal(diagonal::Diagonal)::Diagonal = Diagonal(mod(Int(diagonal) + 1, 4))

# Functions regarding marker checking and counting

"""
Warning! This function returns true if the checked point lies beyond the grid!
"""
function check_marker!(r::Robot, side::HorizonSide)::Bool
    if !isborder(r, side)
        move!(r, side)
        flag = ismarker(r)
        move!(r, inverse(side))
        return flag
    else
        return true
    end
end

function check_markers!(r::Robot)::Bool
    for side in (HorizonSide(i) for i = 0:3)
        if !check_marker!(r, side)
            return false
        end
    end
    return true
end

function count_markers_in_line_straight!(r::Robot, side::HorizonSide)::Integer
    count = 0
    if ismarker(r)
        count += 1
    end
    while !isborder(r, side)
        move!(r, side)
        if ismarker(r)
            count += 1
        end
    end
    return count
end

function count_markers_in_line_diagonal!(r::Robot, diagonal::Diagonal)::Integer
    side_tuple = associate_diagonal(diagonal)
    count = 0
    if ismarker(r)
        count += 1
    end
    while !isborder(r, side_tuple[1]) && !isborder(r, side_tuple[2])
        move!(r, side_tuple[1])
        move!(r, side_tuple[2])
        if ismarker(r)
            count += 1
        end
    end
    return count
end
