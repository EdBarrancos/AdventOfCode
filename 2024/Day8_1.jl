input_string="............
........0...
.....0......
.......0....
....0.......
......A.....
............
............
........A...
.........A..
............
............"

struct Antena
    frequency::Char
    pos::Pair{Int, Int}
end

struct City
    antenas::Vector{Antena}
    height::Int
    length::Int
end

function areInSameFrequency(antena1::Antena, antena2::Antena)
    return antena1.frequency == antena2.frequency
end

function getAntinodes(antena1::Antena, antena2::Antena)
    if !areInSameFrequency(antena1, antena2)
        return []
    end

    return [
        Pair(antena1.pos[1] * 2 - antena2.pos[1], antena1.pos[2] * 2 - antena2.pos[2])
        Pair(antena2.pos[1] * 2 - antena1.pos[1], antena2.pos[2] * 2 - antena1.pos[2])]
end

function isInside(city::City, node::Pair{Int, Int})
    return node[1] >= 1 && node[2] >= 1 && node[1] <= city.length && node[2] <= city.height
end

function process_input(input_string)
    antenas = []
    splitted = split(input_string, '\n')
    map(
        y -> map(
            x -> splitted[y][x] != '.' ? push!(antenas, Antena(splitted[y][x], Pair(x, y))) : return , 
            eachindex(splitted[y])),
        eachindex(splitted))
    return City(antenas, length(splitted), length(splitted[1]))
end

function solve(city::City)
    antinodes = Set()

    for i in eachindex(city.antenas)
        for j in i+1:length(city.antenas)
            union!(antinodes, getAntinodes(city.antenas[i], city.antenas[j]))
        end
    end
    return antinodes
end

city = process_input(input_string)

anti = solve(city)
# println(anti)
filtered = filter(node -> isInside(city, node), solve(city))
println(length(filtered))
