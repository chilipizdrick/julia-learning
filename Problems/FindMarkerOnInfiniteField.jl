include("../RobotUtils.jl")


function find_marker_on_infinite_field!(sr::SmartRobot)
    sr.path = []
    sr.x = 0
    sr.y = 0
    count = 1
    side = Ost
    is_marker = false

    while !is_marker
        is_marker = move_until_marker_straight!(sr, side, count)
        if is_marker
            break
        end
        side = rotate(side)
        is_marker = move_until_marker_straight!(sr, side, count)
        side = rotate(side)
        count += 1
    end
end

function move_until_marker_straight!(sr::SmartRobot, side::HorizonSide, steps::Integer)::Bool
    while !ismarker(sr) && steps > 0
        move!(sr, side)
        steps -= 1
        if ismarker(sr)
            return true
        end
    end
    return false
end
