include("../RobotUtils.jl")


function put_markers_in_corners!(sr::SmartRobot)
    sr.path = []
    sr.x = 0
    sr.y = 0
    move_to_corner!(sr, WestSud)
    path = copy(sr.path)
    for side in (Ost, Nord, West, Sud)
        move_until!(sr, side)
        putmarker!(sr)
    end
    move_to_corner!(sr, WestSud)
    inv_path = invert(path)
    follow_path!(sr, inv_path)
end
