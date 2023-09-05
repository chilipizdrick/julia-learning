using HorizonSideRobots
include("./RobotUtils.jl")


function straight_cross!(r::Robot)
    for side in (HorizonSide(i) for i=0:3)
        move_steps!(r, inverse_side(side), mark_line!(r, side))
    end
end
