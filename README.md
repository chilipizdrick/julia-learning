# julia-learning
## **Очень важно, сначала прочтите, как запускать решения!**

Все задачи, касающиеся [HorizonSideRobots.jl](https://github.com/Vibof/HorizonSideRobots.jl) могут быть найдены в папке *Problems*.
Устаревшие решения могут быть найдены в папке *deprecated*.

### Запуск решений
Решения используют обертку [*SmartRobot*](https://github.com/chilipizdrick/julia-learning/blob/master/SmartRobot.jl) над стандартным *Robot*

```julia
include("include_all.jl")
# or possibly
# include("Problems/FillField.jl")
r = SmartRobot()
fill_field!(r)
```
