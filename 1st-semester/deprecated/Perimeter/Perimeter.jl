using HorizonSideRobots
include("../RobotUtils.jl")


function perimeter!(r::Robot)
    path = goto_corner!(r, OstNord)
    mark_outer_perimeter_from_corner!(r, get_corner(r))
    inv_path = invert_path(path)
    go_path!(r, inv_path)
end
