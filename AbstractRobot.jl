using HorizonSideRobots
HSR = HorizonSideRobots


abstract type AbstractRobot end

get_baserobot(ar::AbstractRobot) = ar.robot

move!(ar::AbstractRobot, side) = HSR.move!(get_baserobot(ar), side::HorizonSide)
isborder(ar::AbstractRobot, side) = HSR.isborder(get_baserobot(ar), side::HorizonSide)
putmarker!(ar::AbstractRobot) = HSR.putmarker!(get_baserobot(ar))
ismarker(ar::AbstractRobot) = HSR.ismarker(get_baserobot(ar))
temperature(ar::AbstractRobot) = HSR.temperature(get_baserobot(ar))


invert(side::HorizonSide)::HorizonSide = HorizonSide(mod(Int(side) + 2, 4))

@enum Diagonal NordWest = 0 WestSud = 1 SudOst = 2 OstNord = 3
function associate_diagonal(diagonal::Diagonal)
    lookup_table = Dict(
        0 => (Nord, West),
        1 => (West, Sud),
        2 => (Sud, Ost),
        3 => (Ost, Nord)
    )
    return lookup_table[Int(diagonal)]
end

invert(diagonal::Diagonal) = Diagonal(mod(Int(diagonal) + 2, 4))


mutable struct Coordinates
    x::Int64
    y::Int64
end

Base.:(==)(a::Coordinates, b::Coordinates) = a.x == b.x && a.y == b.y
Base.:(!=)(a::Coordinates, b::Coordinates) = a.x != b.x || a.y != b.y

getcoord(ar::AbstractRobot)::Coordinates = ar.coord
function update_coord!(coord::Coordinates, side::HorizonSide)
    lookup_table = Dict(
        Nord => (0, 1),
        Sud => (0, -1),
        Ost => (1, 0),
        West => (-1, 0)
    )
    coord.x += lookup_table[side][1]
    coord.y += lookup_table[side][2]
end


mutable struct Path
    path::Vector{Tuple{HorizonSide,Int64}}
end

getpath(ar::AbstractRobot) = ar.path
function update_path!(path::Path, side::HorizonSide)
    if length(path.path) > 0 && last(path.path)[1] == side
        last_move = path.path[end]
        path.path[end] = (last_move[1], last_move[2] + 1)
    else
        push!(path.path, (side, 1))
    end
end
copy(path::Path) = Path(Base.copy(path.path))

function invert(path::Path)::Path
    inv_path = []
    for move in reverse(path.path)
        move = (invert(move[1]), move[2])
        push!(inv_path, move)
    end
    return Path(inv_path)
end


mutable struct MarkerSet
    set::Set{Tuple{Int64, Int64}}
end

get_marker_count(ar::AbstractRobot)::Integer = return length(ar.marker_set.set)
function update_marker_count!(ar::AbstractRobot)  
    if HSR.ismarker(get_baserobot(ar))
        push!(ar.marker_set.set, (ar.coord.x, ar.coord.y)) 
    end
end
