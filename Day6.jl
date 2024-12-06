input_string = "....#.....
.........#
..........
..#.......
.......#..
..........
.#..^.....
........#.
#.........
......#..."

mutable struct Guard
    current_position::Pair{Int,Int}
    dir::Pair{Int,Int}
end

struct Room
    visited_positions::Set{Pair{Int,Int}}
    walls::Vector{Pair{Int,Int}}
    guard::Guard
    height::Int
    length::Int
end

function turn(dir::Pair{Int,Int})
    return Pair(-1 * dir[end], dir[begin])
end

function move(current::Pair{Int,Int}, dir::Pair{Int,Int})
    return Pair(current[begin] + dir[begin], current[end] + dir[end])
end

function willOutside(length::Int, height::Int, guard::Guard)
    pos = move(guard.current_position, guard.dir)
    return pos[begin] > length || pos[begin] < 1 || pos[end] > height || pos[end] < 1
end

function willCollide(guard::Guard, room::Room)
    return move(guard.current_position, guard.dir) in room.walls
end

function loop(room::Room)
    stuck = false

    push!(room.visited_positions, room.guard.current_position)
    while !willOutside(
        room.length,
        room.height,
        room.guard)

        current_dir = room.guard.dir
        while willCollide(room.guard, room)
            room.guard.dir = turn(room.guard.dir)
            if current_dir == room.guard.dir
                stuck = true
                break
            end
        end

        room.guard.current_position = move(room.guard.current_position, room.guard.dir)
        push!(room.visited_positions, room.guard.current_position)
        if stuck
            break
        end
    end
    return length(room.visited_positions)
end


function parsePart1(input_string)
    lines = split(input_string, '\n')
    height = length(lines)
    lenght = length(lines[begin])
    room = Room(
        Set{Pair{Int,Int}}(),
        Vector{Pair{Int,Int}}(),
        Guard(Pair(0, 0), Pair(0, 0)),
        height,
        lenght)

    for y in eachindex(lines)
        for x in eachindex(lines[y])
            if lines[y][x] == '#'
                push!(room.walls, Pair(x, y))
            elseif lines[y][x] == '^'
                room.guard.current_position = Pair(x, y)
                room.guard.dir = Pair(0, -1)
            elseif lines[y][x] == '>'
                room.guard.current_position = Pair(x, y)
                room.guard.dir = Pair(1, 0)
            elseif lines[y][x] == '<'
                room.guard.current_position = Pair(x, y)
                room.guard.dir = Pair(-1, 0)
            elseif lines[y][x] == 'v'
                room.guard.current_position = Pair(x, y)
                room.guard.dir = Pair(0, 1)
            end
        end
    end
    println(loop(room))
end

parsePart1(input_string)
