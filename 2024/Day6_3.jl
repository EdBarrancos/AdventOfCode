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

# Not working, not sure why, going to sleep

mutable struct Guard
    current_position::Pair{Int,Int}
    dir::Pair{Int,Int}
end

struct Room
    visited_positions::Set{Pair{Int,Int}}
    walls::Vector{Pair{Int,Int}}
    obstacles::Set{Pair{Int,Int}}
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
    hits = Vector()
    push!(room.visited_positions, room.guard.current_position)
    while !willOutside(
        room.length,
        room.height,
        room.guard)

        current_dir = room.guard.dir
        while willCollide(room.guard, room)
            push!(hits, room.guard.current_position)
            room.guard.dir = turn(room.guard.dir)
            if current_dir == room.guard.dir
                stuck = true
                break
            end
        end

        room.guard.current_position = move(room.guard.current_position, room.guard.dir)
        push!(room.visited_positions, room.guard.current_position)
        if length(hits) > 2
            # This does not work, because Im predicting object placement without accounting for objects in the way
            first = popfirst!(hits)
            corner = Pair(
                abs(room.guard.dir[begin]) == 1 ? first[begin] : room.guard.current_position[begin],
                abs(room.guard.dir[end]) == 1 ? first[end] : room.guard.current_position[end])
            obs_pos = move(corner, room.guard.dir)

            reachable = true
            for x in obs_pos[begin]:room.guard.current_position[begin]
                for y in obs_pos[end]:room.guard.current_position[end]
                    if Pair(x, y) in room.walls
                        reachable = false
                        break
                    end
                end
                reachable ? continue : break
            end
            if reachable
                push!(room.obstacles, obs_pos)
            end
        end
        if stuck
            break
        end
    end
    return length(room.obstacles)
end


function parsePart1(input_string)
    lines = split(input_string, '\n')
    height = length(lines)
    lenght = length(lines[begin])
    room = Room(
        Set{Pair{Int,Int}}(),
        Vector{Pair{Int,Int}}(),
        Set(),
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
