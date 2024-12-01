function compareLists(list_1, list_2)
    result = 0
    for i in eachindex(list_1)
        result += reduce(-, sort([list_1[i], list_2[i]], rev=true))
    end
    println(result)
end

function comparePart2(list, dict)
    result = 0
    for n in list
        result += n * get(dict, n, 0)
    end
    return result
end

input_string = "3   4
4   3
2   5
1   3
3   9
3   3"

function readInputPart1(input_string)
    list_1 = []
    list_2 = []
    map(line -> begin
            nbrs = split(line, ' ')
            push!(list_1, parse(Int, nbrs[begin]))
            push!(list_2, parse(Int, nbrs[end]))
        end,
        split(input_string, '\n'))
    return (sort(list_1), sort(list_2))
end

function readInputPart2(input_string)
    list = []
    dict = Dict()
    map(line -> begin
            nbrs = split(line, ' ')
            push!(list, parse(Int, nbrs[begin]))
            second_nbr = parse(Int, nbrs[end])
            dict[second_nbr] = get(dict, second_nbr, 0) + 1
        end,
        split(input_string, '\n'))
    return (list, dict)
end

input_parsed = readInputPart2(input_string)
println(comparePart2(input_parsed[begin], input_parsed[end]))
