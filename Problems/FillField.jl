include("../RobotUtils.jl")


function fill_field!(sr::SmartRobot)
    move_to_corner!(sr, WestSud)
    path = copy(sr.path)
    mark_snake_condition!(sr, Ost, Nord, (r) -> true, (r) -> false)
    move_to_corner!(sr, WestSud)
    inv_path = invert(path)
    follow_path!(sr, inv_path)
    clear_data!(sr)
end
