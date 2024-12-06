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

Room(room::Room, new_wall) = Room(
    room.visited_positions,
    vcat(room.walls, [new_wall]),
    Guard(room.guard.current_position, room.guard.dir),
    room.height,
    room.length)

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
    loop_tracking = Set()

    push!(room.visited_positions, room.guard.current_position)
    push!(loop_tracking, Pair(room.guard.current_position, room.guard.dir))
    while !willOutside(
        room.length,
        room.height,
        room.guard)

        current_dir = room.guard.dir
        while willCollide(room.guard, room)
            room.guard.dir = turn(room.guard.dir)
            if current_dir == room.guard.dir
                return true
            end
        end

        room.guard.current_position = move(room.guard.current_position, room.guard.dir)
        push!(room.visited_positions, room.guard.current_position)
        mov = Pair(room.guard.current_position, room.guard.dir)
        if mov in loop_tracking
            return true
        end

        push!(loop_tracking, mov)
    end
    return false
end


function parsePart2(input_string)
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

    # HAMMER TIME
    total = 0
    for y in eachindex(lines)
        for x in eachindex(lines[y])
            if Pair(x, y) in room.walls
                continue
            end
            total += loop(Room(room, Pair(x, y))) ? 1 : 0
        end
    end
    println(total)
end

parsePart2(input_string)
