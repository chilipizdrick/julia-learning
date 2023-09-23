using HorizonSideRobots
include("../RobotUtils.jl")


function mark_chess_board!(r::Robot)
    path = goto_corner!(r, OstNord)
    if mod(length(path), 2) == 0
        marker_flag = true
    else
        marker_flag = false
    end
    side = West

    while !isborder(r, Sud)
        mark_dotted_line!(r, side, marker_flag=marker_flag)
        if ismarker(r)
            marker_flag = false
        else
            marker_flag = true
        end
        side = inverse_p(side)
        move!(r, Sud)
    end
    mark_dotted_line!(r, side, marker_flag=marker_flag)

    goto_corner!(r, OstNord)
    inv_path = invert_path(path)
    go_path!(r, inv_path)
end
