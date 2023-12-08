input = "LR

11A = (11B, XXX)
11B = (XXX, 11Z)
11Z = (11B, XXX)
22A = (22B, XXX)
22B = (22C, 22C)
22C = (22Z, 22Z)
22Z = (22B, 22B)
XXX = (XXX, XXX)"

import Base

struct Position
    label::String
    left_label::String
    right_label::String
end

struct Result
    start::Position
    final::Position
    moves::Int
end

Base.isless(a::Result, b::Result) = a.moves < b.moves
Base.isequal(a::Result, b::Result) = a.final.label == b.final.label

function move(movement, from::Position, positions::Dict)
    if movement == 'R'
        return positions[from.right_label]
    else
        return positions[from.left_label]
    end
end

is_end_pos(pos::Position) = 'Z' in pos.label
is_begin_pos(pos::Position) = 'A' in pos.label

function parse_position(position_input)
    parsed_input = split(position_input, " = ")
    return Position(
        parsed_input[begin],
        replace(
            split(parsed_input[end], ", ")[begin], r"\(" => ""),
        replace(
            split(parsed_input[end], ", ")[end], r"\)" => "")
    )
end

function parse_positions(lines) 
   positions = Dict()
   map(
        function(line)
            pos = parse_position(line)
            positions[pos.label] = pos
        end, 
        lines)
    return positions
end

next_index(movement_size, current_index::Int) = 
    current_index == movement_size ? current_index = 1 : current_index + 1

function reach_a_destination(positions::Dict, movement, result)
    index = 1
    movement_size = length(movement)
    current_pos = result.start
    nb_moves = 0
    while(!is_end_pos(current_pos))
        current_pos = move(movement[index], current_pos, positions)
        index = next_index(movement_size, index)
        nb_moves += 1
    end

    return Result(
        result.start,
        current_pos, 
        nb_moves)
end

function exercise8(input)
    lines = split(input, '\n')
    movement = lines[begin]
    positions = parse_positions(
        filter(line -> !isempty(line), lines[2:end]))
    starting_positions = filter(is_begin_pos, collect(values(positions)))
    results = map(pos -> Result(pos, pos, 0), starting_positions)
    map!(r -> reach_a_destination(positions, movement, r), results, results)
    return lcm(map(r -> r.moves, results))
end

exercise8(input)


