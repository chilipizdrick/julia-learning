using HorizonSideRobots
include("./RobotUtils.jl")
include("./Perimeter.jl")


function fill_field!(r::Robot)
    while !check_markers!(r)
        perimeter!(r)
        move!(r, Sud)
        move!(r, West)
        if ismarker(r)
            move!(r, Ost)
        end
    end
end