input_string = "47|53
97|13
97|61
97|47
75|29
61|13
75|53
29|13
97|29
53|29
61|53
97|53
61|29
47|13
75|47
97|75
47|61
75|61
47|29
75|13
53|13

75,47,61,53,29
97,61,53,29,13
75,29,13
75,97,47,61,53
61,13,29
97,13,75,29,47"

function isOrderOrdered(order, rules)
    past = []
    for x in order
        antecedants = filter(n -> n in order, get(rules, x, []))
        if !all(map(n -> n in past, antecedants))
            return false
        end
        push!(past, x)
    end
    return true
end

function orderAnOrder(order, rules)
    orderedOrder = []
    for x in order
        if x in orderedOrder
            continue
        end
        antecedants = filter(n -> n in order, get(rules, x, []))
        fucked = filter(n -> !(n in orderedOrder), antecedants)
        if isempty(fucked)
            continue
        end
        orderedOrder = vcat(orderedOrder, fucked)
        push!(orderedOrder, x)
    end
    return orderedOrder
end

function processOrder(order, rules)
    past = []
    for x in order
        antecedants = filter(n -> n in order, get(rules, x, []))
        if !all(map(n -> n in past, antecedants))
            return 0
        end
        push!(past, x)
    end
    return order[div(end, 2)+1]
end

function processAllOrders(allOrders, rules)
    total = 0
    for order in allOrders
        if isOrderOrdered(order, rules)
            continue
        end
        while !isOrderOrdered(order, rules)
            order = orderAnOrder(order, rules)
        end
        total += order[div(end, 2)+1]
    end
    return total
end

function parsePart1(input_string)
    splitted = split(input_string, "\n\n")
    rules = splitted[1]
    to_update = map(line -> map(nbr -> parse(Int, nbr), split(line, ',')), split(splitted[2], '\n'))
    constructed_rules = Dict()
    map(line -> begin
            nbr1 = parse(Int, split(line, '|')[1])
            nbr2 = parse(Int, split(line, '|')[2])
            constructed_rules[nbr2] = push!(get(constructed_rules, nbr2, []), nbr1)
        end,
        split(rules, '\n'))
    println(processAllOrders(to_update, constructed_rules))
end

parsePart1(input_string)


