include("../RobotUtils.jl")


function find_marker_on_infinite_field!(sr::SmartRobot)
    mark_spiral_condition!(sr, Ost, (r) -> false, (r) -> ismarker(r))
    clear_data!(sr)
end
