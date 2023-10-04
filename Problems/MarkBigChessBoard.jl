include("../RobotUtils.jl")


function mark_big_chess_board!(sr::SmartRobot, scale::Integer)
    sr.path = []
    move_to_corner!(sr, WestSud)
    sr.x = 0
    sr.y = 0
    path = copy(sr.path)
    mark_condition = begin
        robot_instance -> mod(robot_instance.x, scale * 2) < scale && 
        mod(robot_instance.y, scale * 2) < scale || 
        !(mod(robot_instance.x, scale * 2) < scale || 
        mod(robot_instance.y, scale * 2) < scale)
    end
    mark_snake_condition!(sr, mark_condition)
    move_to_corner!(sr, WestSud)
    inv_path = invert(path)
    follow_path!(sr, inv_path)
end
