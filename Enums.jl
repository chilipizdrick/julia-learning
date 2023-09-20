using HorizonSideRobots


@enum Diagonal NordWest = 0 WestSud = 1 SudOst = 2 OstNord = 3

function associate_diagonal(diagonal::Diagonal)
    if Int(diagonal) === 0
        return (Nord, West)
    elseif Int(diagonal) === 1
        return (West, Sud)
    elseif Int(diagonal) === 2
        return (Sud, Ost)
    else # Int(diagonal) === 3
        return (Ost, Nord)
    end
end
