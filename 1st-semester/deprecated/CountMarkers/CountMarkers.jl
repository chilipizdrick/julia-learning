using HorizonSideRobots
include("../RobotUtils.jl")


function count_markers!(r)
    side = West
    should_stop = false
    path = goto_corner!(r, OstNord)
    count = Int(move_until_p!(r, Ost))
    while !should_stop
        flag1 = isborder(r, Sud)
        count += count_markers_in_line_p!(r, side)
        flag2 = isborder(r, Sud)
        if flag1 && flag2
            should_stop = true
        else
            if !isborder(r, Sud)
                move!(r, Sud)
            end
            side = HorizonSide(mod(Int(side) + 2, 4))
        end
    end
    goto_corner!(r, OstNord)
    inv_path = invert_path(path)
    go_path!(r, inv_path)
    println(count)
end
