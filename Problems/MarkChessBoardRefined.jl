include("../RobotUtils.jl")


function mark_chess_board_refined!(sr::SmartRobot)
    sr.x = 0
    sr.y = 0
    sr.path = []
    move_to_corner!(sr, WestSud)
    path = copy(sr.path)
    mark_snake_condition!(sr, robot_instance -> mod(robot_instance.x + robot_instance.y, 2) == 0)
    move_to_corner!(sr, WestSud)
    inv_path = invert(path)
    follow_path!(sr, inv_path)
end
