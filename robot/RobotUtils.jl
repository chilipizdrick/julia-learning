using HorizonSideRobots


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
function move_until_p!(r::Robot, direction; marking::Bool=false)::Bool
    if isa(direction, HorizonSide)
        return move_until_straight!(r, direction, marking=marking)
    elseif isa(direction, Diagonal)
        return move_until_diagonal!(r, direction, marking=marking)
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

function move_until_straight!(r::Robot, side::HorizonSide; marking=false)::Bool
    moved_into_mark = false
    while !isborder(r, side) && !ismarker(r)
        if marking
            putmarker!(r)
        end
        move!(r, side)
    end
    if ismarker(r)
        move!(r, inverse_straight(side))
        moved_into_mark = true
    end
    return moved_into_mark
end

inverse_straight(side::HorizonSide)::HorizonSide = HorizonSide(mod(Int(side) + 2, 4))

rotate_straight(side::HorizonSide)::HorizonSide = HorizonSide(mod(Int(side) + 1, 4))

# Diagonal directions implementation

@enum Diagonal NordWest = 0 WestSud = 1 SudOst = 2 OstNord = 3

function associate_diagonal(diagonal::Diagonal)
    if Int(diagonal) === 0
        return (Nord, West)
    elseif Int(diagonal) === 1
        return (West, Sud)
    elseif Int(diagonal) === 2
        return (Sud, Ost)
    else # Int(diagonal) === 3
        return (Ost, Nord)
    end
end

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

function move_until_diagonal!(r::Robot, diagonal::Diagonal; marking=false)::Bool
    side_tuple = associate_diagonal(diagonal)
    moved_into_mark = false
    while !isborder(r, side_tuple[1]) && !isborder(r, side_tuple[2]) && !ismarker(r)
        if marking
            putmarker!(r)
        end
        move!(r, side_tuple[1])
        move!(r, side_tuple[2])
    end
    if ismarker(r)
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
        move!(r, inverse_straight(side))
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
