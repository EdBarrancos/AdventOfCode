#= 

Winnint values | My values

For any of my values in winning values
Start at 1 and double for each more correct

Sum all the card values

=#

#= PART 1 =#

input = "Card 1: 41 48 83 86 17 | 83 86  6 31 17  9 48 53
Card 2: 13 32 20 16 61 | 61 30 68 82 17 32 24 19
Card 3:  1 21 53 59 44 | 69 82 63 72 16 21 14  1
Card 4: 41 92 73 84 69 | 59 84 76 51 58  5 54 83
Card 5: 87 83 26 28 32 | 88 30 70 12 93 22 82 36
Card 6: 31 18 13 56 72 | 74 77 10 23 35 67 36 11"

struct Card
    winningValues::Array{Int}
    myValues::Array{Int}
end

function parse_card(card_input)
    values_only = split(card_input, ": ")[end]
    splitted_values = split(values_only, " | ")
    return Card(
        map(
            value -> parse(Int, value), 
            filter(value -> !isempty(value), split(splitted_values[begin], ' '))),
        map(
            value -> parse(Int, value), 
            filter(value -> !isempty(value), split(splitted_values[end], ' ')))
    )

end

parse_input(input) = map(parse_card, split(input, '\n'))

get_my_winning_values(card::Card) = filter(my_value -> my_value in card.winningValues, card.myValues)

get_my_winning_values(card_list::Array{Card}) = map(get_my_winning_values, card_list)

points(number_of_values::Int) = number_of_values == 0 ? 0 : 2 ^ (number_of_values - 1)

function exercise4(input)
    parsed_input = parse_input(input)
    return reduce(+, map(points, map(length, get_my_winning_values(parsed_input))))
end

exercise4(input)

#= PART 2 =#

struct CardWithID
    id::Int
    card::Card
end

struct CardResult
    id::Int
    sequence::Int
end

function parse_card(card_input, owned_cards::Dict)
    # Card 1: 41 48 83 86 17 | 83 86  6 31 17  9 48 53
    id = parse(Int, split(split(card_input, ": ")[begin], ' ')[end])
    owned_cards[id] = 1
    values_only = split(card_input, ": ")[end]
    splitted_values = split(values_only, " | ")
    return CardWithID(
        id,
        Card(
            map(
                value -> parse(Int, value), 
                filter(value -> !isempty(value), split(splitted_values[begin], ' '))),
            map(
                value -> parse(Int, value), 
                filter(value -> !isempty(value), split(splitted_values[end], ' '))))
    )
end

parse_cards(cards, owned_cards::Dict) = map(card -> parse_card(card, owned_cards), cards)

function resolve_card(card::CardWithID, answered_cards::Dict)
    answered_cards[card.id] = CardResult(card.id, length(get_my_winning_values(card.card)))
end

function apply_clones(owned_cards, source_id, number)
    for _ in 1:owned_cards[source_id]
        for x in 1:number
            owned_cards[source_id + x] += 1
        end
    end
end

function solve_exercise4(owned_cards, answered_cards)
    for pair in sort(collect(answered_cards), by=x->x[begin])
        apply_clones(owned_cards, pair[begin], pair[end].sequence)
    end
end

function exercise4(input)
    owned_cards = Dict()
    answered_cards = Dict()
    initial_cards = parse_cards(split(input, '\n'), owned_cards)
    map(card -> resolve_card(card, answered_cards), initial_cards)
    solve_exercise4(owned_cards, answered_cards)
    reduce(+, values(owned_cards))
end

exercise4(input)