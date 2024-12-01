#= 

Part 1

Find first and last digit of each line
Sum the numbers

Part 2

Digits can also be typed out (one -> 1)

=#

input = "1abc2
pqr3stu8vwx
a1b2c3d4e5f
treb7uchet"


function get_first_digit(line::SubString{String})
    for character in line
        if isdigit(character)
            return character
        end
    end
end

function get_last_digit(line::SubString{String})
    digit = '0'
    for character in line
        if isdigit(character)
            digit = character
        end
    end

    return digit
end

function find_number(line::SubString{String}) :: Int
    first_digit = get_first_digit(line)
    second_digit = get_last_digit(line)

    return parse(Int64, first_digit * second_digit)
end

function main()
    return sum(map(
        find_number,
        split(input, '\n')
    ))
end

main()