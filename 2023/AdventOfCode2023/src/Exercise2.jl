#= 

Cubes - green, red, blue

With each game, a few sets are revealed and then put back before removing another set
Which game is possible

Sum of the ids
=#

input = "Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green
Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue
Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red
Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red
Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green"

#= PART 1  =#

red_cubes = 12
green_cubes = 13
blue_cubes = 14

function get_max_of_type(color)
    if color == "red"
        return red_cubes
    elseif color == "green"
        return green_cubes
    else
        return blue_cubes
    end
end

is_set_of_cubes_valid(number, color) = number <= get_max_of_type(color)

function process_set_of_cubes_p1(set_of_cubes)
    parsed_set = split(set_of_cubes, ' ')
    return is_set_of_cubes_valid(parse(Int, parsed_set[2]), parsed_set[end])
end

function process_round_p1(round)
    parsed_sets = split(round, ',')
    processed_sets = map(process_set_of_cubes_p1, parsed_sets)
    return all(processed_sets)
end

function is_game_possible(game)
    rounds = split(game, ';')
    possible_rounds = map(process_round_p1, rounds)
    # true -> valid
    return all(possible_rounds)
end

function process_game_p1(game)
    parsed_game = split(game, ':')
    game_id = parse(Int, split(parsed_game[begin], ' ')[end])
    return is_game_possible(parsed_game[end]) ? game_id : 0
end

function exercise2_part1(input::String)
    parsed_input = split(input, "\n")
    result = map(process_game_p1, parsed_input)
    return reduce(+, result)
end

exercise2_part1(input)

#= PART 2 =#

struct PossibleBagValues
    red
    blue
    green
end

function update_minimum(number, color, current::PossibleBagValues)
    if color == "red" && number > current.red
        return PossibleBagValues(number, current.blue, current.green)
    elseif color == "green" && number > current.green
        return PossibleBagValues(current.red, current.blue, number)
    elseif color == "blue" && number > current.blue
        return PossibleBagValues(current.red, number, current.green)
    else
        return current
    end
end

function process_set_of_cubes_p2(set_of_cubes, current::PossibleBagValues)
    parsed_set = split(set_of_cubes, ' ')
    return update_minimum(parse(Int, parsed_set[2]), parsed_set[end], current)
end

function process_round_p2(round, minimum::PossibleBagValues)
    parsed_sets = split(round, ',')
    for parsed_set in parsed_sets
        minimum = process_set_of_cubes_p2(parsed_set, minimum)
    end
    return minimum
end

function minimums_for_game(game)
    minimum = PossibleBagValues(0, 0, 0)
    rounds = split(game, ';')
    for round in rounds
        minimum = process_round_p2(round, minimum)
    end
    return minimum
end

function process_game(game)
    parsed_game = split(game, ':')
    possibleValues = minimums_for_game(parsed_game[end])
    return possibleValues.red * possibleValues.green * possibleValues.blue
end

function exercise2_p2(input::String)
    parsed_input = split(input, "\n")
    result = map(process_game, parsed_input)
    return reduce(+, result)
end

exercise2_p2(input)