struct X end
struct M end
struct A end

function found(::X, map, current_pos::Pair{Int,Int}, dir::Pair{Int,Int})::Bool
    search_in = Pair(current_pos[1] + dir[1], current_pos[2] + dir[2])
    if length(map) < search_in[1] || search_in[1] < 1 || search_in[2] < 1 || length(map[1]) < search_in[2]
        return false
    end
    if map[search_in[1]][search_in[2]] == 'M'
        return found(M(), map, search_in, dir)
    end
    return false
end
function found(::M, map, current_pos::Pair{Int,Int}, dir::Pair{Int,Int})::Bool
    search_in = Pair(current_pos[1] + dir[1], current_pos[2] + dir[2])
    if length(map) < search_in[1] || search_in[1] < 1 || search_in[2] < 1 || length(map[1]) < search_in[2]
        return false
    end
    if map[search_in[1]][search_in[2]] == 'A'
        return found(A(), map, search_in, dir)
    end
    return false
end
function found(::A, map, current_pos::Pair{Int,Int}, dir::Pair{Int,Int})::Bool
    search_in = Pair(current_pos[1] + dir[1], current_pos[2] + dir[2])
    if length(map) < search_in[1] || search_in[1] < 1 || search_in[2] < 1 || length(map[1]) < search_in[2]
        return false
    end
    if map[search_in[1]][search_in[2]] == 'S'
        return true
    end
    return false
end

input_string = "MMMSXXMASM
MSAMXMSMSA
AMXSXMAAMM
MSAMASMSMX
XMASAMXAMM
XXAMMXXAMA
SMSMSASXSS
SAXAMASAAA
MAMMMXMMMM
MXMXAXMASX"

function part1(input_string)
    map = split(input_string, '\n')
    total = 0
    for x in eachindex(map)
        for y in eachindex(map[1])
            if map[x][y] == 'X'
                total += found(X(), map, Pair(x, y), Pair(1, 0)) ? 1 : 0
                total += found(X(), map, Pair(x, y), Pair(0, 1)) ? 1 : 0
                total += found(X(), map, Pair(x, y), Pair(1, 1)) ? 1 : 0
                total += found(X(), map, Pair(x, y), Pair(-1, 0)) ? 1 : 0
                total += found(X(), map, Pair(x, y), Pair(0, -1)) ? 1 : 0
                total += found(X(), map, Pair(x, y), Pair(-1, -1)) ? 1 : 0
                total += found(X(), map, Pair(x, y), Pair(1, -1)) ? 1 : 0
                total += found(X(), map, Pair(x, y), Pair(-1, 1)) ? 1 : 0
            end
        end
    end
    println(total)
end

part1(input_string)
