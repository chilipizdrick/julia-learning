using HorizonSideRobots
include("../AbstractRobot.jl")

mutable struct Coordinates
    x::Int64
    y::Int64
end

mutable struct MazeRobot <: AbstractRobot
    robot::HorizonSideRobots.Robot
    coord::Coordinates
end


Base.:(==)(a::Coordinates, b::Coordinates) = a.x == b.x && a.y == b.y

function MazeRobot(; animate=true, file_name=nothing, field_length=10, field_height=10)::MazeRobot
    if !isnothing(file_name)
        _robot = Robot(file_name; animate=animate)
        return MazeRobot(_robot, Coordinates(0, 0))
    else
        _robot = Robot(animate=animate, field_height, field_length)
        return MazeRobot(_robot, Coordinates(0, 0))
    end
end

function getcoord(mr::MazeRobot)::Coordinates
    return mr.coord
end

function update_coord!(coord::Coordinates, side::HorizonSide)
    delta = Dict(Nord => (0, 1), Sud => (0, -1), Ost => (1, 0), West => (-1, 0))
    coord.x += delta[side][1]
    coord.y += delta[side][2]
end

function move!(mr::MazeRobot, side::HorizonSide)
    HorizonSideRobots.move!(mr.robot, side)
    update_coord!(getcoord(mr), side)
    println(getcoord(mr))
end

function putmarker!(mr::MazeRobot)
    HorizonSideRobots.putmarker!(mr.robot)
end
