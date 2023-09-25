using HorizonSideRobots
include("../RobotUtils.jl")


function fill_field!(r::Robot)
    side = West
    should_stop = false
    path = goto_corner!(r, OstNord)
    while !should_stop
        mark_line_p!(r, side)
        if !isborder(r, Sud)
            move!(r, Sud)
            side = inverse_p(side)
        else
            should_stop = true
        end
    end
    goto_corner!(r, OstNord)
    inv_path = invert_path(path)
    go_path!(r, inv_path)
end
