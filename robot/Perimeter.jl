using HorizonSideRobots
include("./RobotUtils.jl")


function perimeter!(r::Robot)
    move_until_p!(r, Nord)
    
    side_tuple = (West, Sud, Ost, Nord, West)
    idx = 1
    while idx < 6
        side = side_tuple[idx]
        mark_flag = move_until_p!(r, side; marking=true)
        if mark_flag && idx < 5
            idx += 1
            side = side_tuple[idx]
            move!(r, side)
        else
            idx += 1
        end
    end
end