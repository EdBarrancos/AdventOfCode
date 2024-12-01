input = "-L|F7
7S-7|
L|7||
-L-J|
L|-JF"

#= 

 1
2.3
 4

=#
struct Tube
    representation::Char
    connections::Vector{Int}
end

mutable struct MazePosition
    distance
    tube::Tube
end


dot = Tube('.', [])
l = Tube('L', [1, 3])
vertical = Tube('|', [1, 4])
horizontal = Tube('-', [2, 3])
j = Tube('J', [1, 2])
seven = Tube('7', [2, 4])
f = Tube('F', [3, 4])
start = Tube('S', [1, 2, 3, 4])

options = [dot, l, vertical, horizontal, j, seven, f, start]

function parse_input(input)
    lines = split(input, '\n')
    maze_of_tubes = map(
        line -> map(
            character -> filter(option -> option.representation == character, options)[begin], 
            collect(line)),
        lines
    )
    maze = map(tubes -> map(tube -> MazePosition(Inf, tube), tubes), maze_of_tubes)
    return reduce(hcat, maze)
end

find_first_in_maze(tube::Tube, maze::Matrix{MazePosition}) = findfirst(pos -> pos.tube == tube, maze)
set_distance(new_distance::Int, index::CartesianIndex, maze::Matrix{MazePosition}) = getindex(maze, index).distance = new_distance


function get_adjacent(
        target::CartesianIndex, 
        from::CartesianIndex, 
        directions,
        width::Int,
        height::Int)
    adjacent = []
    for dir in directions
        if dir == 1
            push!(adjacent, CartesianIndex(target[1], target[2] - 1))
        elseif dir == 2
            push!(adjacent, CartesianIndex(target[1] - 1, target[2]))
        elseif dir == 3
            push!(adjacent, CartesianIndex(target[1] + 1, target[2]))
        elseif dir == 4
            push!(adjacent, CartesianIndex(target[1], target[2] + 1))
        end
    end

    adjacent = filter(!=(from), adjacent)
    adjacent = filter(index -> index[1] >= 1 && index[1] <= width, adjacent)
    adjacent = filter(index -> index[2] >= 1 && index[2] <= height, adjacent)
    return adjacent
end

function travel(stack, start_index::CartesianIndex, from::CartesianIndex, visited,  maze::Matrix{MazePosition})
    if isempty(stack)
        return
    end
    current = popfirst!(stack)

    adjacents = get_adjacent(current, from, maze[current].tube.connections, size(maze, 1), size(maze, 2))
    adjacents = filter(adjacent -> !(adjacent in visited), adjacents)
    adjacents = filter(adjacent -> !(adjacent in stack), adjacents)
    map(adjacent -> push!(stack, adjacent), adjacents)
    return travel(stack, start_index, current, push!(visited, current), maze)
end

function map_maze(start_index::CartesianIndex, maze::Matrix{MazePosition})
    move_stack = []
    adjacent_to_start = get_adjacent(start_index, start_index, maze[start_index].tube.connections, size(maze, 1), size(maze, 2))
    map(adjacent -> push!(move_stack, adjacent), adjacent_to_start)
    travel(move_stack, start_index, start_index, [start_index], maze)
    return maze
end

function exercise10(input)
    maze = parse_input(input)
    start_index = find_first_in_maze(start, maze)
    set_distance(0, start_index, maze)
    return map_maze(start_index, maze)
end

a = exercise10(input)

length(a)
ndims(a)
size(a, 2)