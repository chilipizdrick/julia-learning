using HorizonSideRobots
include("Diagonal.jl")


mutable struct SmartRobot
    robot::HorizonSideRobots.Robot
    x::Int64
    y::Int64
    path::Vector{Tuple{HorizonSide,Int64}}
end

function SmartRobot(; field_length=10, field_height=10)::SmartRobot
    return SmartRobot(Robot(animate=true, field_height, field_length), 0, 0, [])
end


function move!(sr::SmartRobot, direction)
    @assert isa(direction, HorizonSide) || isa(direction, Diagonal)

    if isa(direction, HorizonSide)
        HorizonSideRobots.move!(sr.robot, direction)

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
        HorizonSideRobots.move!(sr.robot, side_tuple[2])

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
