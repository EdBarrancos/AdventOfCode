input_string = "190: 10 19
3267: 81 40 27
83: 17 5
156: 15 6
7290: 6 8 6 15
161011: 16 10 13
192: 17 8 14
21037: 9 7 18 13
292: 11 6 16 20"

function process(result::Int, current::Int, leftOver::Vector{Int})
    if isempty(leftOver)
        if result == current
            return true
        end
        return false
    end
    next = leftOver[1]
    return process(result, current * next, leftOver[2:end]) ||
           process(result, current + next, leftOver[2:end]) ||
           process(result, parse(Int, string(current) * string(next)), leftOver[2:end])
end

function isPossible(result::Int, args::Vector{Int})
    first = popfirst!(args)
    calibrated = process(result, first, args)
    return calibrated ? result : 0
end

function parseInput(input_string)
    equations = map(
        line -> begin
            eq_splitted = split(line, ':')
            return Pair(
                parse(Int, eq_splitted[1]),
                map(
                    nbr -> parse(Int, nbr),
                    filter(n -> !isempty(n), split(eq_splitted[2], ' '))))
        end,
        split(input_string, '\n'))
    return equations
end

function solve(equations)
    return foldr(+, map(eq -> isPossible(eq[1], eq[2]), equations))
end

println(solve(parseInput(input_string)))
