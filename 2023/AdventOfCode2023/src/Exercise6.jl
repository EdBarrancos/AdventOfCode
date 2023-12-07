#= 

for each milisecond holding -> 1 more milimeter per second

Nunca desceleras

=#


input = "Time:      7  15   30
Distance:  9  40  200"

struct Race
    time
    distance
end

function get_list_of_numbers_in_line(line)
    numbers_only = split(line, ": ")[end]
    a =  filter(n -> !isspace(n), numbers_only)
    println(a)
    return a
end

map_numbers_to_int(array_of_numbers) = map(number -> parse(Int, number), array_of_numbers)

function parse_input(input)
    lines = split(input, '\n')
    time = parse(Int, get_list_of_numbers_in_line(lines[begin]))
    distance = parse(Int, get_list_of_numbers_in_line(lines[end]))
    return map(x -> Race(x[end], distance[x[begin]]), enumerate(time))
end

function is_winnable_with_charging_time(charging_time::Int, race::Race)
    left_over_time = race.time - charging_time
    return left_over_time * charging_time > race.distance
end

function number_of_winnable_configs(race::Race)
    max_time = race.time
    winnable_points = filter(point -> is_winnable_with_charging_time(point, race), 0:max_time)
    return length(winnable_points)
end

function exercise6(input)
    races = parse_input(input)
    println(races)
    reduce(*, map(number_of_winnable_configs, races))
end

exercise6(input)

div(15, 2)