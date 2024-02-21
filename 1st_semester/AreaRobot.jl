using HorizonSideRobots
HSR = HorizonSideRobots
include("AbstractRobot.jl")


mutable struct AreaRobot <: AbstractRobot
    robot::Robot
    coord::Coordinates
    calc_area_flag::Bool
    cur_area::Int64
    # checked_borders_set::Set{Tuple{Int64,Int64,HorizonSide}}
end

function AreaRobot(;
    animate=true,
    file_name=nothing,
    field_length=10,
    field_height=10
)::AreaRobot
    if !isa(file_name, Nothing)
        _robot = HSR.Robot(file_name; animate=animate)
    else
        _robot = HSR.Robot(animate=animate, field_height, field_length)
    end

    return AreaRobot(_robot, Coordinates(0, 0), false, 0)
end

set_calc_area_flag!(ar::AreaRobot, flag::Bool) = ar.calc_area_flag = flag
"""We calculate the area to be twice the actual area and divide it by two."""
getarea(ar::AreaRobot)::Int64 = ar.cur_area / 2

"""
This function uses relative border and movement positions as well as a set of 
already checked borders to determine wether to increment or decrement the area.
"""
function update_area!(ar::AreaRobot, side::HorizonSide)
    rotate(side::HorizonSide) = HorizonSide(mod(Int(side) + 1, 4))
    if isborder(ar, rotate(side))
        if isborder(ar, Sud) &&
            # !((ar.coord.x, ar.coord.y, Sud) in ar.checked_borders_set) &&
            side in (West, Sud)

            ar.cur_area += ar.coord.y
            # push!(ar.checked_borders_set, (ar.coord.x, ar.coord.y, Sud))
        end
        if isborder(ar, Nord) &&
            # !((ar.coord.x, ar.coord.y, Nord) in ar.checked_borders_set) && 
            side in (Ost, Nord)

            ar.cur_area -= (ar.coord.y + 1)
            # push!(ar.checked_borders_set, (ar.coord.x, ar.coord.y, Nord))
        end
    end
end

function move!(ar::AreaRobot, side::HorizonSide)
    if ar.calc_area_flag update_area!(ar, side) end
    HSR.move!(get_baserobot(ar), side)
    update_coord!(ar, side)
    if ar.calc_area_flag update_area!(ar, side) end
end


function clear_data!(ar::AreaRobot)
    ar.coord = Coordinates(0, 0)
    ar.calc_area_flag = false
    ar.cur_area = 0
    # ar.checked_borders_set = Set()
end
