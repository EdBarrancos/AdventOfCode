#= 

Callibration Document -> Lines of text
Each line used to contain specific calibration value -> What we are looking for

We need to find the first and last digit to form a two digit number

What is the sum of all callibration number

=#

input = "1abc2
pqr3stu8vwx
a1b2c3d4e5f
treb7uchet"


function process_line(line)
    numbers_only = filter(isnumeric, line)
    return parse(Int, numbers_only[begin] * numbers_only[end])
end

function exercise1(input::String)
    parsed_input = split(input, "\n")
    numbers = map(process_line, parsed_input)
    return reduce(+, numbers)
end

exercise1(input)

