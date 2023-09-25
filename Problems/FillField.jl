include("../RobotUtils.jl")


function fill_field!(sr::SmartRobot)
    sr.path = []
    sr.x = 0
    sr.y = 0
    move_to_corner!(r, WestSud)
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
end
