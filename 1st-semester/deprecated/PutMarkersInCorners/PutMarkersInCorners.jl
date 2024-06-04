using HorizonSideRobots
include("../RobotUtils.jl")


function put_markers_in_corners!(r::Robot)
    path = goto_corner!(r, OstNord)
    putmarker!(r)
    for corner in (NordWest, WestSud, SudOst)
        goto_corner!(r, corner)
        putmarker!(r)
    end
    goto_corner!(r, OstNord)
    inv_path = invert_path(path)
    go_path!(r, inv_path)
end
