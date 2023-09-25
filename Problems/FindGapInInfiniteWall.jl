include("../RobotUtils.jl")


function find_gap_in_infinite_wall!(sr::SmartRobot)
    sr.path = []
    sr.x = 0
    sr.y = 0
    count = 1
    border_side = check_border(sr)

    if border_side == Ost || border_side == West
        side = Nord
    else # if border_side == Nord || border_side == Sud
        side = Ost
    end
    while true
        move_steps!(sr, side, count)
        if !isborder(sr, border_side)
            break
        end
        move_steps!(sr, invert(side), count)

        side = invert(side)

        move_steps!(sr, side, count)
        if !isborder(sr, border_side)
            break
        end
        move_steps!(sr, invert(side), count)

        side = invert(side)
        count += 1
    end
    move!(sr, border_side)
    move_steps!(sr, invert(side), count)
end

"""
The function returns the first found border in the order (Ost, Nord, West, Sud).
"""
function check_border(sr::SmartRobot)::HorizonSide
    for side in (Ost, Nord, West, Sud)
        if isborder(sr, side)
            return side
        end
    end
end
