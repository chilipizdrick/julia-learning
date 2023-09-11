using HorizonSideRobots
include("./RobotUtils.jl")


function diagonal_cross!(r::Robot)
    for diagonal in (Diagonal(i) for i = 0:3)
        move_steps_p!(r, inverse_p(diagonal), mark_line_p!(r, diagonal))
    end
end
