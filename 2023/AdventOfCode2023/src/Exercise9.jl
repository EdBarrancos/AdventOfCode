input = "0 3 6 9 12 15
1 3 6 10 15 21
10 13 16 21 30 45"

parse_line(line) = map(nbr -> parse(Int, nbr), split(line, ' '))

is_zero(line::Vector{Int}) = all(map(x -> x == 0, line))

function process_line(line::Vector{Int})
    computed_lines = get_computed_lines(line)
    return foldr(-, map(cmpt_line -> first(cmpt_line), computed_lines))
end

function get_computed_lines(line::Vector{Int})
    computed_lines = [line]
    while (!is_zero(last(computed_lines)))
        push!(computed_lines, process(last(computed_lines)))
    end
    return computed_lines
end

function process(line::Vector{Int})
    return [line[i+1] - line[i] for i in eachindex(line) if i < length(line)]
end

function exercise9(input)
    lines = map(parse_line,split(input, '\n'))
    return reduce(+, map(process_line, lines))
end

exercise9(input)