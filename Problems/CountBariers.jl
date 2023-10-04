include("../RobotUtils.jl")


function count_bariers!(sr::SmartRobot)::Integer
    sr.x = 0
    sr.y = 0
    sr.path = []
    move_to_corner!(sr, WestSud)
    path = copy(sr.path)
    count = 0
    barier_side = Nord
    side = Ost
    should_stop_flag = false
    while !should_stop_flag
        (increment, should_stop_flag) = count_bariers_in_line!(sr, side, barier_side)
        count += increment
        if !should_stop_flag
            side = invert(side)
            move_around_steps!(sr, barier_side, 1)
        end
    end
    move_to_corner!(sr, WestSud)
    inv_path = invert(path)
    follow_path!(sr, inv_path)
    return count
end

@enum State Gap = 0 Barier = 1 Border = 2 

function count_bariers_in_line!(sr::SmartRobot, moving_side::HorizonSide, barier_side::HorizonSide)::Tuple
    count = 0
    if isborder(sr, barier_side)
        state = Border
    else
        state = Gap
    end
    while !isborder(sr, moving_side)
        if state == Border || state == Barier
            move!(sr, moving_side)
            if !isborder(sr, barier_side)
                state = Gap
                count += 1
            end
        else # state == Gap
            move!(sr, moving_side)
            if isborder(sr, barier_side)
                state = Barier
            end
        end
    end
    if state == Border
        should_stop_flag = true
    else
        should_stop_flag = false
    end
    return (count, should_stop_flag)
end
