using Test
using HorizonSideRobots.SituationDatas
include.(filter(contains(r".jl$"), readdir("Problems/"; join=true)))

global ANIMATE_FLAG = true
global COMPARE_SIT_FILES_FLAG = false

@testset "straight_cross" begin
    for case in 1:length(readdir("test_cases/straight_cross"))
        input_file_path = "test_cases/straight_cross/case$case/input.sit"
        output_file_path = "test_cases/straight_cross/case$case/output.sit"
        sr = SmartRobot(;file_name=input_file_path, animate=ANIMATE_FLAG)
        straight_cross!(sr)
        HorizonSideRobots.SituationDatas.save(sr.robot.situation, "test.sit")
        if COMPARE_SIT_FILES_FLAG
            @test open(io -> read(io, String), "test.sit") == open(io -> read(io, String), output_file_path)
        end
    end
end

@testset "perimeter" begin
    for case in 1:length(readdir("test_cases/perimeter"))
        input_file_path = "test_cases/perimeter/case$case/input.sit"
        output_file_path = "test_cases/perimeter/case$case/output.sit"
        sr = SmartRobot(;file_name=input_file_path, animate=ANIMATE_FLAG)
        perimeter!(sr)
        HorizonSideRobots.SituationDatas.save(sr.robot.situation, "test.sit")
        if COMPARE_SIT_FILES_FLAG
            @test open(io -> read(io, String), "test.sit") == open(io -> read(io, String), output_file_path)
        end
    end
end

@testset "fill_field" begin
    for case in 1:length(readdir("test_cases/fill_field"))
        input_file_path = "test_cases/fill_field/case$case/input.sit"
        output_file_path = "test_cases/fill_field/case$case/output.sit"
        sr = SmartRobot(;file_name=input_file_path, animate=ANIMATE_FLAG)
        fill_field!(sr)
        HorizonSideRobots.SituationDatas.save(sr.robot.situation, "test.sit")
        if COMPARE_SIT_FILES_FLAG
            @test open(io -> read(io, String), "test.sit") == open(io -> read(io, String), output_file_path)
        end
    end
end

@testset "diagonal_cross" begin
    for case in 1:length(readdir("test_cases/diagonal_cross"))
        input_file_path = "test_cases/diagonal_cross/case$case/input.sit"
        output_file_path = "test_cases/diagonal_cross/case$case/output.sit"
        sr = SmartRobot(;file_name=input_file_path, animate=ANIMATE_FLAG)
        diagonal_cross!(sr)
        HorizonSideRobots.SituationDatas.save(sr.robot.situation, "test.sit")
        if COMPARE_SIT_FILES_FLAG
            @test open(io -> read(io, String), "test.sit") == open(io -> read(io, String), output_file_path)
        end
    end
end

@testset "fill_frames" begin
    for case in 1:length(readdir("test_cases/fill_frames"))
        input_file_path = "test_cases/fill_frames/case$case/input.sit"
        output_file_path = "test_cases/fill_frames/case$case/output.sit"
        sr = SmartRobot(;file_name=input_file_path, animate=ANIMATE_FLAG)
        fill_frames!(sr)
        HorizonSideRobots.SituationDatas.save(sr.robot.situation, "test.sit")
        if COMPARE_SIT_FILES_FLAG
            @test open(io -> read(io, String), "test.sit") == open(io -> read(io, String), output_file_path)
        end
    end
end

@testset "four_points" begin
    for case in 1:length(readdir("test_cases/four_points"))
        input_file_path = "test_cases/four_points/case$case/input.sit"
        output_file_path = "test_cases/four_points/case$case/output.sit"
        sr = SmartRobot(;file_name=input_file_path, animate=ANIMATE_FLAG)
        four_points!(sr)
        HorizonSideRobots.SituationDatas.save(sr.robot.situation, "test.sit")
        if COMPARE_SIT_FILES_FLAG
            @test open(io -> read(io, String), "test.sit") == open(io -> read(io, String), output_file_path)
        end
    end
end

@testset "find_gap_in_infinite_wall" begin
    for case in 1:length(readdir("test_cases/find_gap_in_infinite_wall"))
        input_file_path = "test_cases/find_gap_in_infinite_wall/case$case/input.sit"
        output_file_path = "test_cases/find_gap_in_infinite_wall/case$case/output.sit"
        sr = SmartRobot(;file_name=input_file_path, animate=ANIMATE_FLAG)
        find_gap_in_infinite_wall!(sr)
        HorizonSideRobots.SituationDatas.save(sr.robot.situation, "test.sit")
        if COMPARE_SIT_FILES_FLAG
            @test open(io -> read(io, String), "test.sit") == open(io -> read(io, String), output_file_path)
        end
    end
end

@testset "find_marker_on_infinite_field" begin
    for case in 1:length(readdir("test_cases/find_marker_on_infinite_field"))
        input_file_path = "test_cases/find_marker_on_infinite_field/case$case/input.sit"
        output_file_path = "test_cases/find_marker_on_infinite_field/case$case/output.sit"
        sr = SmartRobot(;file_name=input_file_path, animate=ANIMATE_FLAG)
        find_marker_on_infinite_field!(sr)
        HorizonSideRobots.SituationDatas.save(sr.robot.situation, "test.sit")
        if COMPARE_SIT_FILES_FLAG
            @test open(io -> read(io, String), "test.sit") == open(io -> read(io, String), output_file_path)
        end
    end
end

@testset "mark_chess_board" begin
    for case in 1:length(readdir("test_cases/mark_chess_board"))
        input_file_path = "test_cases/mark_chess_board/case$case/input.sit"
        output_file_path = "test_cases/mark_chess_board/case$case/output.sit"
        sr = SmartRobot(;file_name=input_file_path, animate=ANIMATE_FLAG)
        mark_chess_board!(sr)
        HorizonSideRobots.SituationDatas.save(sr.robot.situation, "test.sit")
        if COMPARE_SIT_FILES_FLAG
            @test open(io -> read(io, String), "test.sit") == open(io -> read(io, String), output_file_path)
        end
    end
end

@testset "mark_big_chess_board" begin
    for case in 1:length(readdir("test_cases/mark_big_chess_board"))
        input_file_path = "test_cases/mark_big_chess_board/case$case/input.sit"
        output_file_path = "test_cases/mark_big_chess_board/case$case/output.sit"
        sr = SmartRobot(;file_name=input_file_path, animate=ANIMATE_FLAG)
        mark_big_chess_board!(sr, case)
        HorizonSideRobots.SituationDatas.save(sr.robot.situation, "test.sit")
        if COMPARE_SIT_FILES_FLAG
            @test open(io -> read(io, String), "test.sit") == open(io -> read(io, String), output_file_path)
        end
    end
end

@testset "count_bariers" begin
    for case in 1:length(readdir("test_cases/count_bariers"))
        input_file_path = "test_cases/count_bariers/case$case/input.sit"
        output_file_path = "test_cases/count_bariers/case$case/output.sit"
        sr = SmartRobot(;file_name=input_file_path, animate=ANIMATE_FLAG)
        @test count_bariers!(sr) == 20
        HorizonSideRobots.SituationDatas.save(sr.robot.situation, "test.sit")
        if COMPARE_SIT_FILES_FLAG
            @test open(io -> read(io, String), "test.sit") == open(io -> read(io, String), output_file_path)
        end
    end
end

@testset "count_bariers_one_gap" begin
    for case in 1:length(readdir("test_cases/count_bariers_one_gap"))
        input_file_path = "test_cases/count_bariers_one_gap/case$case/input.sit"
        output_file_path = "test_cases/count_bariers_one_gap/case$case/output.sit"
        sr = SmartRobot(;file_name=input_file_path, animate=ANIMATE_FLAG)
        @test count_bariers_one_gap!(sr) == 12
        HorizonSideRobots.SituationDatas.save(sr.robot.situation, "test.sit")
        if COMPARE_SIT_FILES_FLAG
            @test open(io -> read(io, String), "test.sit") == open(io -> read(io, String), output_file_path)
        end
    end
end

@testset "average_marked_temperature" begin
    for case in 1:length(readdir("test_cases/average_marked_temperature"))
        input_file_path = "test_cases/average_marked_temperature/case$case/input.sit"
        output_file_path = "test_cases/average_marked_temperature/case$case/output.sit"
        sr = SmartRobot(;file_name=input_file_path, animate=ANIMATE_FLAG)
        @test average_marked_temperature!(sr) == 55.57142857142857
        HorizonSideRobots.SituationDatas.save(sr.robot.situation, "test.sit")
        if COMPARE_SIT_FILES_FLAG
            @test open(io -> read(io, String), "test.sit") == open(io -> read(io, String), output_file_path)
        end
    end
end

@testset "count_markers" begin
    for case in 1:length(readdir("test_cases/count_markers"))
        input_file_path = "test_cases/count_markers/case$case/input.sit"
        output_file_path = "test_cases/count_markers/case$case/output.sit"
        sr = SmartRobot(;file_name=input_file_path, animate=ANIMATE_FLAG)
        @test count_markers!(sr) == 19
        HorizonSideRobots.SituationDatas.save(sr.robot.situation, "test.sit")
        if COMPARE_SIT_FILES_FLAG
            @test open(io -> read(io, String), "test.sit") == open(io -> read(io, String), output_file_path)
        end
    end
end

@testset "stairs" begin
    for case in 1:length(readdir("test_cases/stairs"))
        input_file_path = "test_cases/stairs/case$case/input.sit"
        output_file_path = "test_cases/stairs/case$case/output.sit"
        sr = SmartRobot(;file_name=input_file_path, animate=ANIMATE_FLAG)
        stairs!(sr)
        HorizonSideRobots.SituationDatas.save(sr.robot.situation, "test.sit")
        if COMPARE_SIT_FILES_FLAG
            @test open(io -> read(io, String), "test.sit") == open(io -> read(io, String), output_file_path)
        end
    end
end

@testset "put_markers_in_corners" begin
    for case in 1:length(readdir("test_cases/put_markers_in_corners"))
        input_file_path = "test_cases/put_markers_in_corners/case$case/input.sit"
        output_file_path = "test_cases/put_markers_in_corners/case$case/output.sit"
        sr = SmartRobot(;file_name=input_file_path, animate=ANIMATE_FLAG)
        put_markers_in_corners!(sr)
        HorizonSideRobots.SituationDatas.save(sr.robot.situation, "test.sit")
        if COMPARE_SIT_FILES_FLAG
            @test open(io -> read(io, String), "test.sit") == open(io -> read(io, String), output_file_path)
        end
    end
end
