using HorizonSideRobots
include("../RobotUtils.jl")


function find_gap_in_infinite_wall!(r::Robot)
    count = 1
    border_side = check_border(r)

    if border_side == Ost || border_side == West
        side = Nord
    else # if border_side == Nord || border_side == Sud
        side = Ost
    end
    while true
        move_steps_p!(r, side, count)
        if !isborder(r, border_side)
            break
        end
        move_steps_p!(r, inverse_p(side), count)

        side = inverse_p(side)

        move_steps_p!(r, side, count)
        if !isborder(r, border_side)
            break
        end
        move_steps_p!(r, inverse_p(side), count)

        side = inverse_p(side)
        count += 1
    end
    move!(r, border_side)
    move_steps_p!(r, inverse_p(side), count)
end
