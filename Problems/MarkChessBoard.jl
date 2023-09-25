include("../RobotUtils.jl")


function mark_chess_board!(sr::SmartRobot)
    sr.path = []
    sr.x = 0
    sr.y = 0
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