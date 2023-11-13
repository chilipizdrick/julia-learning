using HorizonSideRobots
HSR = HorizonSideRobots
include("AbstractRobot.jl")


mutable struct AreaRobot <: AbstractRobot
    robot::Robot
    coord::Coordinates
    calc_area_flag::Bool
    cur_area::Int64
    checked_borders_set::Set{Tuple{Int64,Int64,HorizonSide}}
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

    return AreaRobot(_robot, Coordinates(0, 0), false, 0, Set())
end

set_calc_area_flag!(ar::AreaRobot, flag::Bool) = ar.calc_area_flag = flag
getarea(ar::AreaRobot)::Int64 = ar.cur_area
function update_area!(ar::AreaRobot, side::HorizonSide)
    if isborder(ar, Sud) && !((ar.coord.x, ar.coord.y, Sud) in ar.checked_borders_set)
        ar.cur_area += ar.coord.y
        push!(ar.checked_borders_set, (ar.coord.x, ar.coord.y, Sud))
    end
    if isborder(ar, Nord) && !((ar.coord.x, ar.coord.y, Nord) in ar.checked_borders_set)
        ar.cur_area -= (ar.coord.y + 1)
        push!(ar.checked_borders_set, (ar.coord.x, ar.coord.y, Nord))
    end
end

function move!(ar::AreaRobot, side::HorizonSide)
    HSR.move!(get_baserobot(ar), side)
    update_coord!(ar, side)
    update_area!(ar, side)
end


function clear_data!(ar::AreaRobot)
    ar.coord = Coordinates(0, 0)
    ar.calc_area_flag = false
    ar.cur_area = 0
    ar.checked_borders_set = Set()
end
