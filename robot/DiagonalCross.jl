using HorizonSideRobots
include("./RobotUtils.jl")


function diagonal_cross!(r::Robot)
    for diagonal in (Diagonal(i) for i = 0:3)
        move_steps_diagonal!(r, inverse_diagonal(diagonal), mark_line_diagonal!(r, direction))
    end
end
