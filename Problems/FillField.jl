include("../RobotUtils.jl")


function fill_field!(sr::SmartRobot)
    move_to_corner!(sr, WestSud)
    path = copy(sr.path)
    side = Ost
    while !isborder(sr, Nord)
        mark_line!(sr, side)
        move!(sr, Nord)
        side = invert(side)
    end
    mark_line!(sr, side)
    move_to_corner!(sr, WestSud)
    inv_path = invert(path)
    follow_path!(sr, inv_path)
    clear_data!(sr)
end
