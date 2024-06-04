using HorizonSideRobots
include("../RobotUtils.jl")


function average_marked_temperature!(r::Robot)
    temperature_sum = 0
    marker_count = 0
    path = goto_corner!(r, OstNord)
    side = West
    while !isborder(r, Sud)
        return_tuple = count_temperature!(r, side)
        temperature_sum += return_tuple[1]
        marker_count += return_tuple[2]
        move!(r, Sud)
        side = inverse_p(side)
    end
    return_tuple = count_temperature!(r, side)
    temperature_sum += return_tuple[1]
    marker_count += return_tuple[2]   

    goto_corner!(r, OstNord)
    inv_path = invert_path(path)
    go_path!(r, inv_path)

    return temperature_sum / marker_count
end

function count_temperature!(r::Robot, side::HorizonSide)
    temperature_sum = 0
    marker_count = 0
    while !isborder(r, side)
        if ismarker(r)
            temperature_sum += temperature(r)
            marker_count += 1
        end
        move!(r, side)
    end
    if ismarker(r)
        temperature_sum += temperature(r)
        marker_count += 1
    end
    return (temperature_sum, marker_count)
end
