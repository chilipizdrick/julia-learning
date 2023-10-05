include("../RobotUtils.jl")


function straight_cross!(sr::SmartRobot)
    for side in (HorizonSide(i) for i=0:3)
        move_steps!(sr, invert(side), mark_line!(sr, side))  
    end
    clear_data!(sr)
end
