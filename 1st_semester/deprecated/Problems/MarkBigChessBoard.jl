include("../RobotUtils.jl")


function mark_big_chess_board!(sr::SmartRobot, scale::Integer)
    move_to_corner!(sr, WestSud)
    sr.x = 0
    sr.y = 0
    path = copy(sr.path)
    moving_side = Ost
    ortogonal_side = Nord
    mark_condition = begin
        r -> mod(r.x, scale * 2) < scale && 
        mod(r.y, scale * 2) < scale || 
        !(mod(r.x, scale * 2) < scale || 
        mod(r.y, scale * 2) < scale)
    end

    mark_snake_condition!(sr, moving_side, ortogonal_side, mark_condition, (r) -> false)
    move_to_corner!(sr, WestSud)
    inv_path = invert(path)
    follow_path!(sr, inv_path)
    clear_data!(sr)
end
