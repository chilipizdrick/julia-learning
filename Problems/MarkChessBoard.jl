include("../RobotUtils.jl")


function mark_chess_board!(sr::SmartRobot)
    move_to_corner!(sr, WestSud)
    path = copy(sr.path)
    moving_side = Ost
    ortogonal_side = Nord
    mark_snake_condition!(sr, moving_side, ortogonal_side, (r) -> mod(r.x + r.y, 2) == 0, (r) -> false)
    move_to_corner!(sr, WestSud)
    inv_path = invert(path)
    follow_path!(sr, inv_path)
    clear_data!(sr)
end
