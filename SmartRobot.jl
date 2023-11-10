using HorizonSideRobots
HSR = HorizonSideRobots
include("AbstractRobot.jl")


mutable struct SmartRobot <: AbstractRobot
    robot::Robot
    coord::Coordinates
    path::Path
    marker_set::MarkerSet
end

function SmartRobot(;
    animate=true,
    file_name=nothing,
    field_length=10,
    field_height=10
)::SmartRobot
    if !isa(file_name, Nothing)
        _robot = HSR.Robot(file_name; animate=animate)
    else
        _robot = HSR.Robot(animate=animate, field_height, field_length)
    end

    marker_set = MarkerSet(Set())
    if HSR.ismarker(_robot)
        push!(marker_set.set, (0, 0))
    end

    return SmartRobot(
        _robot,
        Coordinates(0, 0),
        Path([]),
        marker_set
    )
end


function move!(sr::SmartRobot, side::HorizonSide)
    HSR.move!(get_baserobot(sr), side)
    update_coord!(sr.coord, side)
    update_path!(sr.path, side)
    update_marker_count!(sr)
end

function move!(sr::SmartRobot, diagonal::Diagonal)
    side_tuple = associate_diagonal(diagonal)
    for side in side_tuple
        HSR.move!(get_baserobot(sr), side)
        update_coord!(sr.coord, side)
        update_path!(sr.path, side)
        update_marker_count!(sr)
    end
end


function isborder(sr::SmartRobot, diagonal::Diagonal)::Bool
    side_tuple = associate_diagonal(diagonal)
    return HSR.isborder(get_baserobot(sr), side_tuple[1]) ||
           HSR.isborder(get_baserobot(sr), side_tuple[2])
end


function clear_data!(sr::SmartRobot)
    sr.coord = Coordinates(0, 0)
    sr.path = Path([])
    sr.marker_set = MarkerSet(Set())
end