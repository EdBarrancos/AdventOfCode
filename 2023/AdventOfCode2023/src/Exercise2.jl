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


function is_set_of_cubes_valid(number, color)
    return number <= get_max_of_type(color)
end

function process_set_of_cubes(set_of_cubes)
    parsed_set = split(set_of_cubes, ' ')
    return is_set_of_cubes_valid(parse(Int, parsed_set[2]), parsed_set[end])
end

function process_round(round)
    parsed_sets = split(round, ',')
    processed_sets = map(process_set_of_cubes, parsed_sets)
    return all(processed_sets)
end

function is_game_possible(game)
    rounds = split(game, ';')
    possible_rounds = map(process_round, rounds)
    # true -> valid
    return all(possible_rounds)
end

function process_game(game)
    parsed_game = split(game, ':')
    game_id = parse(Int, split(parsed_game[begin], ' ')[end])
    return is_game_possible(parsed_game[end]) ? game_id : 0
end

function exercise2(input::String)
    parsed_input = split(input, "\n")
    result = map(process_game, parsed_input)
    return reduce(+, result)
end

exercise2(input)