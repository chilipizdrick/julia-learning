using HorizonSideRobots
include("../RobotUtils.jl")


function stairs!(r::Robot)
    goto_corner!(r, WestSud)
    count = count_steps_until_border!(r, Ost)
    while count >= 0
        move_steps_p!(r, Ost, count)
        mark_line_p!(r, West)
        if !isborder(r, Nord)
            move!(r, Nord)
        else
            break
        end
        count -= 1
    end
end
