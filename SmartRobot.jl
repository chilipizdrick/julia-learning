using HorizonSideRobots
include("Diagonal.jl")


mutable struct SmartRobot
    robot::HorizonSideRobots.Robot
    x::Int64
    y::Int64
    path::Vector{Tuple{HorizonSide,Int64}}
    marker_count::Int64
end

function SmartRobot(;animate=true, file_name=nothing, field_length=10, field_height=10)::SmartRobot
    if !isa(file_name, Nothing)
        _robot = Robot(file_name; animate=animate)
        return SmartRobot(_robot, 0, 0, [], HorizonSideRobots.ismarker(_robot))
    else
        _robot = Robot(animate=animate, field_height, field_length)
        return SmartRobot(_robot, 0, 0, [], HorizonSideRobots.ismarker(_robot))
    end
end


function move!(sr::SmartRobot, direction)
    @assert isa(direction, HorizonSide) || isa(direction, Diagonal)

    if isa(direction, HorizonSide)
        HorizonSideRobots.move!(sr.robot, direction)

        if ismarker(sr)
            sr.marker_count += 1
        end

        if direction == Ost
            sr.x += 1
        elseif direction == Nord
            sr.y += 1
        elseif direction == West
            sr.x -= 1
        else # if direction == Sud
            sr.y -= 1
        end

        if length(sr.path) > 0 && direction == last(sr.path)[1]
            sr.path[lastindex(sr.path)] = (last(sr.path)[1], last(sr.path)[2] + 1)
        else
            push!(sr.path, (direction, 1))
        end
    end

    if isa(direction, Diagonal)
        side_tuple = associate_diagonal(direction)

        HorizonSideRobots.move!(sr.robot, side_tuple[1])
        if ismarker(sr)
            sr.marker_count += 1
        end

        HorizonSideRobots.move!(sr.robot, side_tuple[2])
        if ismarker(sr)
            sr.marker_count += 1
        end

        if direction == OstNord
            sr.x += 1
            sr.y += 1
        elseif direction == NordWest
            sr.x -= 1
            sr.y += 1
        elseif direction == WestSud
            sr.x -= 1
            sr.y -= 1
        else # if direction == SudOst
            sr.x += 1
            sr.y -= 1
        end

        if length(sr.path) > 0 && side_tuple[1] == last(sr.path)[1]
            sr.path[lastindex(sr.path)] = (last(sr.path)[1], last(sr.path)[2] + 1)
            push!(sr.path, (side_tuple[2], 1))
        else
            push!(sr.path, (side_tuple[1], 1))
            push!(sr.path, (side_tuple[2], 1))
        end
    end
end

function isborder(sr::SmartRobot, direction)::Bool
    @assert isa(direction, HorizonSide) || isa(direction, Diagonal)
    if isa(direction, HorizonSide)
        return HorizonSideRobots.isborder(sr.robot, direction)
    end
    if isa(direction, Diagonal)
        side_tuple = associate_diagonal(direction)
        return HorizonSideRobots.isborder(sr.robot, side_tuple[1]) || HorizonSideRobots.isborder(sr.robot, side_tuple[2])
    end
end

function putmarker!(sr::SmartRobot)
    HorizonSideRobots.putmarker!(sr.robot)
end

function ismarker(sr::SmartRobot)::Bool
    return HorizonSideRobots.ismarker(sr.robot)
end

function temperature(sr::SmartRobot)::Integer
    return HorizonSideRobots.temperature(sr.robot)
end

function clear_data!(sr::SmartRobot)
    sr.x = 0
    sr.y = 0
    sr.path = []
    sr.marker_count = 0
end
