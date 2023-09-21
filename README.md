# julia-learning
### A repository intended for studying julia and top-down programming approach in university.

All problems regarding [HorizonSideRobots.jl](https://github.com/Vibof/HorizonSideRobots.jl) can be found in the corresponding folders.

### Running solutions
This can be easily done via including the cumulative file *include_all.jl* while being in the Julia REPL prompt

```julia
include("include_all.jl")
```

or by including solutions one-by-one

```julia
include("FillField/FillField.jl")
```

then creating a HorizonSideRobots *Robot* instance

```julia
r = Robot(animate=true)
```

and then running the desired solution (e.g. FillField)

```julia
fill_field!(r)
```
