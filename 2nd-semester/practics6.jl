include("./lib.jl")

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