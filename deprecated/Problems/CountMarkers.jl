include("../RobotUtils.jl")


function count_markers!(sr::SmartRobot)
    sr.path = []
    sr.x = 0
    sr.y = 0
    side = Ost
    should_stop = false
    move_to_corner!(sr, WestSud)
    path = copy(sr.path)
    count = Int(ismarker(sr))
    while !should_stop
        flag1 = isborder(sr, Nord)
        count += count_markers_in_line!(sr, side)
        flag2 = isborder(sr, Nord)
        if flag1 && flag2
            should_stop = true
        else
            if !isborder(sr, Nord)
                move!(sr, Nord)
            end
            side = HorizonSide(mod(Int(side) + 2, 4))
        end
    end
    move_to_corner!(sr, WestSud)
    inv_path = invert(path)
    follow_path!(sr, inv_path)
    clear_data!(sr)
    return count
end

function count_markers_in_line!(sr::SmartRobot, side::HorizonSide)::Integer
    count = 0
    if ismarker(sr)
        count += 1
    end
    while !isborder(sr, side)
        move!(sr, side)
        if ismarker(sr)
            count += 1
        end
    end
    return count
end
