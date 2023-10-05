include("../RobotUtils.jl")


function four_points!(sr::SmartRobot)
    move_to_corner!(sr, WestSud)
    path = copy(sr.path)
    for side in (Ost, Nord, West, Sud)
        mark_line_condition!(sr, side, robot_instance -> robot_instance.x == 0 || robot_instance.y == 0)
    end
    move_to_corner!(sr, WestSud)
    inv_path = invert(path)
    follow_path!(sr, inv_path)
    clear_data!(sr)
end
