include("../RobotUtils.jl")


function stairs!(sr::SmartRobot)
    move_to_corner!(sr, WestSud)
    path = copy(sr.path)
    count = move_until!(sr, Ost)
    move_steps!(sr, West, count)
    while count >= 0
        move_steps!(sr, Ost, count)
        mark_line!(sr, West)
        if !isborder(sr, Nord)
            move!(sr, Nord)
        else
            break
        end
        count -= 1
    end
    move_to_corner!(sr, WestSud)
    inv_path = invert(path)
    follow_path!(sr, inv_path)
    clear_data!(sr)
end
