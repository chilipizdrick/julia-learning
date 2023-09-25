include("../RobotUtils.jl")


function diagonal_cross!(sr::SmartRobot)
    sr.path = []
    sr.x = 0
    sr.y = 0
    for diagonal in (Diagonal(i) for i=0:3)
        move_steps!(sr, invert(diagonal), mark_line!(sr, diagonal))  
    end
end
