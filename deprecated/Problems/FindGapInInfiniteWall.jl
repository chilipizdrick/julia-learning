include("../RobotUtils.jl")


function find_gap_in_infinite_wall!(sr::SmartRobot)
    border_side = check_border(sr)
    if border_side == Ost || border_side == West
        side = Nord
    else # if border_side == Nord || border_side == Sud
        side = Ost
    end
    mark_shutle_condition!(sr, side, (r) -> false, (r) -> !isborder(r, border_side))
    move!(sr, border_side)
    path = copy(sr.path)
    inv_path = invert(path)
    move_steps!(sr, inv_path[2][1], div(inv_path[2][2], 2))
    clear_data!(sr)
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
