include("../RobotUtils.jl")


function fill_frames!(sr::SmartRobot)
    move_to_corner!(sr, WestSud)
    path = copy(sr.path)
    mark_outer_perimeter_from_corner!(sr, WestSud)
    scan_until_nord_border!(sr, WestSud)
    while isborder(sr, Nord)
        move!(sr, West)
    end
    mark_inner_perimeter_from_corner!(sr, WestSud)
    move_to_corner!(sr, WestSud)
    inv_path = invert(path)
    follow_path!(sr, inv_path)
    clear_data!(sr)
end

function scan_until_nord_border!(sr::SmartRobot, corner::Diagonal)
    @assert corner == WestSud || corner == SudOst
    if corner == WestSud
        side = Ost
    else # if corner == SudOst
        side = West
    end
    while !isborder(sr, Nord)
        if !isborder(sr, side)
            move!(sr, side)
        else
            move!(sr, Nord)
            side = invert(side)
        end
    end
end

function mark_inner_perimeter_from_corner!(sr::SmartRobot, corner::Diagonal)
    side_tuple = associate_diagonal(corner)
    side = invert(side_tuple[1])
    for _ in 0:4
        mark_until_off_wall!(sr, side)
        side = rotate(side)
    end
end

function mark_until_off_wall!(sr::SmartRobot, side::HorizonSide)
    sr.path = []
    sr.x = 0
    sr.y = 0
    move!(sr, side)
    putmarker!(sr)
    while isborder(sr, rotate(side))
        move!(sr, side)
        putmarker!(sr)
    end
end
