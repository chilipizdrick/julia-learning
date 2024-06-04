struct Vector2D{T<:Real} <: FieldVector{2,T}
    x::T
    y::T
end

Base.:(==)(a::Vector2D{T}, b::Vector2D{T}) where {T} = (a.x == b.x && a.y == b.y)
Base.:(!=)(a::Vector2D{T}, b::Vector2D{T}) where {T} = !(a == b)

Base.:(+)(a::Vector2D{T}, b::Vector2D{T}) where {T} = Vector2D{T}(Tuple(a) .+ Tuple(b))
Base.:(-)(a::Vector2D{T}, b::Vector2D{T}) where {T} = Vector2D{T}(Tuple(a) .- Tuple(b))
Base.:(*)(a::T, v::Vector2D{T}) where {T} = Vector2D{T}(a .* Tuple(v))
LinearAlgebra.norm(v::Vector2D) = norm(Tuple(v))
LinearAlgebra.dot(a::Vector2D{T}, b::Vector2D{T}) where {T} = dot(Tuple(a), Tuple(b))
cos(a::Vector2D{T}, b::Vector2D{T}) where {T} = dot(a, b) / norm(a) / norm(b)
xdot(a::Vector2D{T}, b::Vector2D{T}) where {T} = a.x * b.y - a.y * b.x
sin(a::Vector2D{T}, b::Vector2D{T}) where {T} = xdot(a, b) / norm(a) / norm(b)
angle(a::Vector2D{T}, b::Vector2D{T}) where {T} = atan(sin(a, b), cos(a, b))
angle_(a::Vector2D{T}, b::Vector2D{T}) where {T} = acos(cos(a, b))
sign(a::Vector2D{T}, b::Vector2D{T}) where {T} = sign(sin(a, b))

struct Segment2D{T<:Real}
    A::Vector2D{T}
    B::Vector2D{T}
end

vec(s::Segment2D{T}) where {T} = Vector2D{T}((s.B - s.A)...)

function is_one_side_1(P::Vector2D{T}, Q::Vector2D{T}, s::Segment2D{T}) where {T}
    l = s.B - s.A
    return sin(l, P - s.A) * sin(l, Q - s.A) > 0
end

function is_one_area(f::Function, P::Vector2D{T}, Q::Vector2D{T}) where {T}
    return f(P...) * f(Q...) > 0
end

function is_one_side_2(P::Vector2D{T}, Q::Vector2D{T}, s::Segment2D{T}) where {T}
    f(x, y) = (x - s.A.x) * (s.B.y - s.A.y) - (y - s.A.y) * (s.B.x - s.A.x)
    return is_one_area(f, P, Q)
end

function construct_polygon(point_set::Vector{Vector2D{T}}) where {T}
    res = Vector{Segment2D{T}}()
    curr_point = point_set[1]
    for i in 2:length(point_set)
        curr_segment = Segment2D{T}(curr_point, point_set[i])
        push!(res, curr_segment)
        curr_point = point_set[i]
        if i == length(point_set)
            push!(res, Segment2D{T}(last(point_set), first(point_set)))
        end
    end
    return res
end

function is_convex(vec_polygon::Vector{Vector2D{T}}) where {T}
    polygon = construct_polygon(vec_polygon)
    curr_vector = vec(polygon[1])
    for i in 2:length(polygon)
        ang = angle(curr_vector, vec(polygon[i]))
        if ang < 0
            return false
        end
        curr_vector = vec(polygon[i])
    end
    return true
end

function is_inside(vec_polygon::Vector{Vector2D{T}}, point::Vector2D{T}) where {T}
    polygon = construct_polygon(vec_polygon)
    ang_sum = zero(T)
    for i in eachindex(polygon)
        ang_sum += angle(polygon[i].A - point, polygon[i].B - point)
    end
    if abs(ang_sum) < pi
        return false
    end
    return true
end

function jarvis_algorithm(points::Vector{Vector2D{T}}) where {T}
    if length(points) < 3
        throw(ErrorException("3 and more points are supported"))
    end
    res = Vector{Vector2D{T}}()
    availible_points = deepcopy(points)
    curr_direction = Vector2D{T}(one(T), zero(T))
    origin = availible_points[findmin(p -> p.y, availible_points)[2]]
    curr_point = availible_points[findmin(p -> p.y, availible_points)[2]]
    push!(res, curr_point)
    temp_points = filter(p -> p != curr_point, availible_points)
    next_point = temp_points[findmin(p -> angle(curr_direction, p - curr_point), temp_points)[2]]
    filter!(p -> p != next_point, availible_points)
    push!(res, next_point)
    curr_direction = next_point - curr_point
    curr_point = next_point
    while length(availible_points) > 0 && curr_point != origin
        next_point = availible_points[findmin(p -> angle(curr_direction, p - curr_point), availible_points)[2]]
        filter!(p -> p != next_point, availible_points)
        if next_point != origin
            push!(res, next_point)
        end
        curr_direction = next_point - curr_point
        curr_point = next_point
    end
    return res
end

function rotate(a::Vector2D{T}, b::Vector2D{T}, c::Vector2D{T}) where {T}
    return (b.x - a.x) * (c.y - b.y) - (b.y - a.y) * (c.x - b.x)
end

function graham_algorithm(points::Vector{Vector2D{T}}) where {T}
    if length(points) < 3
        throw(ErrorException("3 and more points are supported"))
    end
    res = Vector{Vector2D{T}}()
    origin = points[findmin(p -> p.y, points)[2]]
    sorted_points = sort(filter(p -> p != origin, points), by=p -> angle(Vector2D{T}(one(T), zero(T)), p - origin))
    push!(res, origin)
    push!(res, sorted_points[1])
    for i in 2:length(sorted_points)
        p1 = res[length(res)-1]
        p2 = sorted_points[i]
        p3 = last(res)
        if rotate(p1, p2, p3) > zero(T)
            pop!(res)
        end
        push!(res, p2)
    end
    return res
end

function trapezoid_area(points::Vector{Vector2D{T}}) where {T}
    res = zero(T)
    prev_p = points[1]
    for i in 2:length(points)
        next_p = points[i]
        res += (prev_p.y + next_p.y) * (next_p.x - prev_p.x) / 2
        prev_p = next_p
    end
    next_p = points[1]
    res += (prev_p.y + next_p.y) * (next_p.x - prev_p.x) / 2
    return -res
end

function triangle_area(points::Vector{Vector2D{T}}) where {T}
    res = zero(T)
    prev_p = points[1]
    for i in 2:length(points)
        next_p = points[i]
        res += xdot(prev_p, next_p)
        prev_p = next_p
    end
    next_p = points[1]
    res += xdot(prev_p, next_p)
    return res / 2
end

approx_eq(x, a) = abs(x - a) < eps(x)

function intersection(s1::Segment2D{T}, s2::Segment2D{T}) where {T}
    if approx_eq(abs(angle(vec(s1), vec(s2))), 0.0) ||
       approx_eq(abs(angle(vec(s1), vec(s2))), pi)
        return nothing
    end
    x1, x2, x3, x4, y1, y2, y3, y4 =
        s1.A.x, s1.B.x, s2.A.x, s2.B.x, s1.A.y, s1.B.y, s2.A.y, s2.B.y
    numerator = x1 * x3 * (y2 - y4) + x1 * x4 * (y3 - y2) + x2 * x3 * (y4 - y1) + x2 * x4 * (y1 - y3)
    denominator = (x1 - x2) * (y3 - y4) + x3 * (y2 - y1) + x4 * (y1 - y2)
    sol = numerator / denominator
    if min(s1.A.x, s1.B.x) <= sol <= max(s1.A.x, s1.B.x) &&
       min(s2.A.x, s2.B.x) <= sol <= max(s2.A.x, s2.B.x)
        y = x -> (x - s1.A.x) * (s1.B.y - s1.A.y) / (s1.B.x - s1.A.x) + s1.A.y
        return Vector2D{T}(sol, y(sol))
    end
    return nothing
end

function main()
    P = Vector2D{Float64}(3.0, -2.0)
    Q = Vector2D{Float64}(-1.0, 4.0)
    A = Vector2D{Float64}(0.0, 0.0)
    B = Vector2D{Float64}(1.0, 1.0)
    s = Segment2D{Float64}(A, B)
    square = map(x -> Vector2D{Float64}(x...), [[0, 0], [1, 0], [1, 1], [0, 1]])
    not_square = map(x -> Vector2D{Float64}(x...), [[0, 0], [1, 0], [0.5, 0.5], [1, 1], [0, 1]])
    rhombus = map(x -> Vector2D{Float64}(x...), [[0, 0], [1, 1], [0, 2], [-1, 1]])

    # 1
    println(is_one_side_1(P, Q, s))
    println(is_one_side_2(P, Q, s))
    println()

    # 2
    println(is_convex(square))
    println(is_convex(not_square))
    println()

    # 3
    println(is_inside(not_square, Vector2D{Float64}(0.25, 0.25)))
    println(is_inside(not_square, Vector2D{Float64}(0.25, -0.25)))
    println()

    # 4
    println(jarvis_algorithm(rhombus))
    println(jarvis_algorithm(not_square))
    println()

    # 5
    println(graham_algorithm(rhombus))
    println(graham_algorithm(not_square))
    println()

    # 6 
    println(trapezoid_area(rhombus))
    println(trapezoid_area(not_square))
    println()

    # 7
    println(triangle_area(rhombus))
    println(triangle_area(not_square))
    println()

    # 8
    AB = Segment2D{Float64}(Vector2D{Float64}(0, 0), Vector2D{Float64}(1, 1))
    CD = Segment2D{Float64}(Vector2D{Float64}(0, 1), Vector2D{Float64}(1, 0))
    println(intersection(AB, CD))
    AB = Segment2D{Float64}(Vector2D{Float64}(-5, 0), Vector2D{Float64}(25, 20))
    CD = Segment2D{Float64}(Vector2D{Float64}(0, 15), Vector2D{Float64}(15, -10))
    println(intersection(AB, CD))
    AB = Segment2D{Float64}(Vector2D{Float64}(5, 0), Vector2D{Float64}(20, 10))
    CD = Segment2D{Float64}(Vector2D{Float64}(10, 10), Vector2D{Float64}(15, 0))
    println(intersection(AB, CD))
    println()
end

main()