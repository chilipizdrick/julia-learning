using HorizonSideRobots
include("../RobotUtils.jl")


function find_marker_on_infinite_field!(r::Robot)
    count = 1
    side = Ost
    is_marker = false

    while !is_marker
        is_marker = move_until_marker_straight!(r, side, count)
        if is_marker
            break
        end
        side = rotate_p(side)
        is_marker = move_until_marker_straight!(r, side, count)
        side = rotate_p(side)
        count += 1
    end
end
