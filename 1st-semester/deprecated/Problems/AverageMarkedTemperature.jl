include("../RobotUtils.jl")


function average_marked_temperature!(sr::SmartRobot)::Number
    temperature_sum = 0
    marker_count = 0
    move_to_corner!(sr, WestSud)
    path = copy(sr.path)
    side = Ost
    while !isborder(sr, Nord)
        return_tuple = count_temperature!(sr, side)
        temperature_sum += return_tuple[1]
        marker_count += return_tuple[2]
        move!(sr, Nord)
        side = invert(side)
    end
    return_tuple = count_temperature!(sr, side)
    temperature_sum += return_tuple[1]
    marker_count += return_tuple[2]

    move_to_corner!(sr, WestSud)
    inv_path = invert(path)
    follow_path!(sr, inv_path)
    clear_data!(sr)

    return temperature_sum / marker_count
end

function count_temperature!(sr::SmartRobot, side::HorizonSide)
    temperature_sum = 0
    marker_count = 0
    while !isborder(sr, side)
        if ismarker(sr)
            temperature_sum += temperature(sr)
            marker_count += 1
        end
        move!(sr, side)
    end
    if ismarker(sr)
        temperature_sum += temperature(sr)
        marker_count += 1
    end
    return (temperature_sum, marker_count)
end
