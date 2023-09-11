using HorizonSideRobots
include("RobotUtils.jl")


function count_markers!(r)
    side = West
    should_stop = false
    move_until_p!(r, Nord)
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
    println(count)
end
