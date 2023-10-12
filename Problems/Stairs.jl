include("../RobotUtils.jl")


function stairs!(sr::SmartRobot)
    move_to_corner!(sr, WestSud)
    path = copy(sr.path)
    clear_data!(sr)
    count = move_until!(sr, Ost)
    move_until!(sr, West)
    mark_snake_condition!(sr, Ost, Nord, (r) -> r.x + r.y <= count, (r) -> false)
    move_to_corner!(sr, WestSud)
    inv_path = invert(path)
    follow_path!(sr, inv_path)
    clear_data!(sr)
end
