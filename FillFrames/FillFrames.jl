using HorizonSideRobots
include("../RobotUtils.jl")


function fill_frames!(r::Robot)
    path = goto_corner!(r, OstNord)
    mark_outer_perimeter_from_corner!(r, get_corner(r))
    scan_until_sud_border!(r, get_corner(r))
    while isborder(r, Sud)
        move!(r, Ost)
    end
    mark_inner_perimeter_from_corner!(r, OstNord)
    goto_corner!(r, OstNord)
    inv_path = invert_path(path)
    go_path!(r, inv_path)
end
