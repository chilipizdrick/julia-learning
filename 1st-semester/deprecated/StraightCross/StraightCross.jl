using HorizonSideRobots
include("../RobotUtils.jl")


function straight_cross!(r::Robot)
    for side in (HorizonSide(i) for i=0:3)
        move_steps_p!(r, inverse_p(side), mark_line_p!(r, side))
    end
end
