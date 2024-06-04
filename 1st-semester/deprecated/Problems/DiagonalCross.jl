include("../RobotUtils.jl")


function diagonal_cross!(sr::SmartRobot)
    for diagonal in (Diagonal(i) for i=0:3)
        move_steps!(sr, invert(diagonal), mark_line!(sr, diagonal))  
    end
    clear_data!(sr)
end
