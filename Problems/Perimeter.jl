include("../RobotUtils.jl")


function perimeter!(sr::SmartRobot)
    sr.path = []
    sr.x = 0
    sr.y = 0
    move_to_corner!(sr, WestSud)
    path = copy(sr.path)
    mark_outer_perimeter_from_corner!(sr, WestSud)
    inv_path = invert(path)
    follow_path!(sr, inv_path)
end
