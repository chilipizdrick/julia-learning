# THIS SOLUTION IS DEPRECATED


include("../RobotUtils.jl")


function mark_chess_board_deprecated!(sr::SmartRobot)
    move_to_corner!(sr, WestSud)
    path = copy(sr.path)
    side = Ost
    while !isborder(sr, Nord)
        mark_chess_line!(sr, side)
        move!(sr, Nord)
        side = invert(side)
    end
    mark_chess_line!(sr, side)
    move_to_corner!(sr, WestSud)
    inv_path = invert(path)
    follow_path!(sr, inv_path)
    clear_data!(sr)
end

function mark_chess_line!(sr::SmartRobot, side)
    if mod(sr.x + sr.y, 2) == 0
        putmarker!(sr)
    end
    while !isborder(sr, side)
        move!(sr, side)
        if mod(sr.x + sr.y, 2) == 0
            putmarker!(sr)
        end
    end
end
