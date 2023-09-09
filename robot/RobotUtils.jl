using HorizonSideRobots


function mark_line!(r::Robot, side::HorizonSide)::Integer
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

function move_steps!(r::Robot, side::HorizonSide, num_steps::Integer)
    for _ in range(start=1, step=1, stop=num_steps)
        move!(r, side)
    end
end

inverse_side(side::HorizonSide)::HorizonSide = HorizonSide(mod(Int(side) + 2, 4))


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

function mark_line_diagonal!(r::Robot, diagonal::Diagonal)::Integer
    direction = assosiate_diagonal(diagonal)
    count = 0
    if !ismarker(r)
        putmarker!(r)
    end
    while !(isborder(r, direction[1]) || isborder(r, direction[2]))
        move!(r, direction[1])
        move!(r, direction[2])
        putmarker!(r)
        count += 1
    end
    return count
end

function move_steps_diagonal!(r::Robot, diagonal::Diagonal, num_steps::Integer)
    direction = assosiate_diagonal(diagonal)
    for _ in range(start=1, step=1, stop=num_steps)
        move!(r, direction[2])
        move!(r, direction[1])
    end
end

inverse_diagonal(direction::Diagonal)::Diagonal = Diagonal(mod(Int(direction) + 2, 4))


function move_until!(r::Robot, side::HorizonSide; marking=false)::Bool
    moved_into_mark = false
    while !isborder(r, side) && !ismarker(r)
        if marking
            putmarker!(r)
        end
        move!(r, side)
    end
    if ismarker(r)
        move!(r, inverse_side(side))
        moved_into_mark = true
    end
    return moved_into_mark
end

"""
Warning! This function returns true if the checked point lies beyond the grid!
"""
function check_marker!(r::Robot, side::HorizonSide)::Bool
    if !isborder(r, side)
        move!(r, side)
        val = ismarker(r)
        move!(r, inverse_side(side))
        return val
    else
        return true
    end
end

function check_markers!(r::Robot)::Bool
    for side in (HorizonSide(i) for i=0:3)
        if !check_marker!(r, side)
            return false
        end
    end
    return true
end

rotate_side(side::HorizonSide)::HorizonSide = HorizonSide(mod(Int(side) + 1, 4))


function count_markers_in_line!(r, side)::Integer
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
