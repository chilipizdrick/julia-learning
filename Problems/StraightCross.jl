include("../RobotUtils.jl")


function straight_cross!(sr::SmartRobot)
    sr.path = []
    sr.x = 0
    sr.y = 0
    for side in (HorizonSide(i) for i=0:3)
        move_steps!(sr, invert(side), mark_line!(sr, side))  
    end
end
