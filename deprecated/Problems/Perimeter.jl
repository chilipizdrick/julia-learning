include("../RobotUtils.jl")


function perimeter!(sr::SmartRobot)
    move_to_corner!(sr, WestSud)
    path = copy(sr.path)
    mark_outer_perimeter_from_corner!(sr, WestSud)
    inv_path = invert(path)
    follow_path!(sr, inv_path)
    clear_data!(sr)
end
