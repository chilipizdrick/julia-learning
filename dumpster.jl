include("MazeRobot.jl")


function calculate_shape_area!(mr::MazeRobot, border_side::HorizonSide)::Integer
    upper_borders = Dict{Integer => Integer}()
    lower_borders = Dict{Integer => Integer}()
    starting_coord = getcoord(mr)
    while cur_coord != starting_coord
        # logic to make robot move and count borders
        update_borders(mr, upper_borders, lower_borders)
    end
end

function traverse_perimeter!(ar::AbstractRobot)

end
