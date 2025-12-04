struct BoundedRange
    lower::Int
    upper::Int
end

size(range::BoundedRange)::Int = range.upper - range.lower + 1
get(range::BoundedRange, index::Int)::Int = index + range.lower

wrap(range::BoundedRange, value::Int)::Int = get(range, mod(value + size(range), size(range)))

struct Dial
    mark::Int
    range::BoundedRange
end

setMark(dial::Dial, mark::Int)::Dial = Dial(mark, dial.range)

rotate_dial(dial::Dial, amount::Int)::Dial = setMark(dial, wrap(dial.range, dial.mark + amount))

getAmount(dir::Char, value::Int)::Int = dir == 'R' ? value : value * -1

getAmount(line::AbstractString)::Int = getAmount(line[begin], parse(Int, line[2:end]))

input = "L68
L30
R48
L5
R60
L55
L1
L99
R14
L82"

function main(in::String)
    count = 0
    dial = Dial(50, BoundedRange(0, 99))
    map(
        line -> begin
            amount = getAmount(line)
            dial = rotate_dial(dial, amount)
            if dial.mark == 0
                count += 1
            end
        end,
        split(in, '\n'))
    println(count)
end

main(input)

