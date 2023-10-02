include("../RobotUtils.jl")


function four_points!(sr::SmartRobot)
    sr.x = 0
    sr.y = 0
    sr.path = []
    move_to_corner!(sr, WestSud)
    path = copy(sr.path)
    for side in (Ost, Nord, West, Sud)
        mark_line_condition!(sr, side, condition)
    end
    move_to_corner!(sr, WestSud)
    inv_path = invert(path)
    follow_path!(sr, inv_path)
end

function condition(sr::SmartRobot)
    return sr.x == 0 || sr.y == 0
end
