include("./lib.jl")

function main()
    arr = randn(Float64, 5000)
    @time(my_sort(arr, bubleperm))
    @time(my_sort(arr, insertperm))
    @time(my_sort(arr, seftperm))
    @time(my_sort(arr, shellperm))
    @time(my_sort(arr, waveperm))
    @time(my_sort(arr, hoarperm))
    @time(my_sort(arr, sift_perm))
    arr = randn(Float64, 5000)
    rrr :: Array{Int} = [1, 2, 43 ,4]
    for i in eachindex(arr)
        push!(rrr, Int(ceil(arr[i] * 400)))
    end
    @time(count_sort(rrr))
end

main()