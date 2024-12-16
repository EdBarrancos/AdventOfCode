input_string = "...s..............................................
...................w......K.......t...............
........s.........................................
.......s......w...............1...................
.........w5.......................................
.......................t.F........................
..................................................
F................................1...........d....
.........................5......................K.
............5.................R..............KZ...
....F.....q.........w..............1.....t........
............8.......I.............................
..........8.................t....................K
...........8.................5.....Z..............
.........q..............................Z...d..U..
...................Y.q...R........................
....................E.....z...............y.......
..........................................U.......
.....F.................................k........S.
............q...................d.................
.................................R................
..x....................................U.........y
.......x.........................E..M...U..d......
......z.......X............................4......
...............I....m....M......R............y....
.......z...................................k..e...
..f..z.......................................e....
...f.I..........7..u..........M................D..
.......X..I.......x.................k.............
.........X.......7....................4.......S...
....................u9...T.....3.Z....o..........6
........f.......D..3....u..................S......
...W...0.........................................D
.....................T................E.......m...
...8....Y............f........T4..................
......Y...........................................
....0.............3...............................
....................3.T.....................k.....
.......................u..............6...........
...........................6..........9........e..
..................4....7.............o..........D.
.................................M...E..o.........
...i.................O...........................Q
.....0.i.....................................m.2..
.......Y.r........7..............S..O..2.......m..
.....r......0.............O.......................
..................................Q...............
........................6................o......Q.
..W...r.................................9.........
.W.........................O........2............."

struct Antena
    frequency::Char
    pos::Pair{Int,Int}
end

struct City
    antenas::Vector{Antena}
    height::Int
    length::Int
end

function areInSameFrequency(antena1::Antena, antena2::Antena)
    return antena1.frequency == antena2.frequency
end

function getAntinodes(city::City, antena1::Antena, antena2::Antena)
    if !areInSameFrequency(antena1, antena2)
        return []
    end

    dirUp = Pair(antena1.pos[1] - antena2.pos[1], antena1.pos[2] - antena2.pos[2])
    dirDown = Pair(antena2.pos[1] - antena1.pos[1], antena2.pos[2] - antena1.pos[2])

    return vcat(
        getAntinodes(city, antena1.pos, dirDown),
        vcat(
            getAntinodes(city, antena1.pos, dirUp),
            vcat(
                getAntinodes(city, antena2.pos, dirUp),
                getAntinodes(city, antena2.pos, dirDown))))
end

function getAntinodes(city::City, starting::Pair{Int,Int}, dir::Pair{Int,Int})
    result = []
    current = Pair(starting[1] + dir[1], starting[2] + dir[2])
    while isInside(city, current)
        push!(result, current)
        current = Pair(current[1] + dir[1], current[2] + dir[2])
    end
    return result
end

function isInside(city::City, node::Pair{Int,Int})
    return node[1] >= 1 && node[2] >= 1 && node[1] <= city.length && node[2] <= city.height
end

function process_input(input_string)
    antenas = []
    splitted = split(input_string, '\n')
    map(
        y -> map(x -> splitted[y][x] != '.' && push!(antenas, Antena(splitted[y][x], Pair(x, y))),
            eachindex(splitted[y])),
        eachindex(splitted))
    return City(antenas, length(splitted), length(splitted[1]))
end

function solve(city::City)
    antinodes = Set()

    for i in eachindex(city.antenas)
        for j in i+1:length(city.antenas)
            union!(antinodes, getAntinodes(city, city.antenas[i], city.antenas[j]))
        end
    end
    return antinodes
end

function showme(city::City, filtered::Set)
    for y in 1:city.height
        for x in 1:city.length
            pos = Pair(x, y)
            antena = filter(a -> a.pos == pos, city.antenas)
            if !isempty(antena)
                print(antena[1].frequency)
                continue
            end
            if pos in filtered
                print('#')
                continue
            end
            print('.')
        end
        println()
    end
end

city = process_input(input_string)

anti = solve(city)
filtered = filter(node -> isInside(city, node), solve(city))
println(length(filtered))
showme(city, filtered)
