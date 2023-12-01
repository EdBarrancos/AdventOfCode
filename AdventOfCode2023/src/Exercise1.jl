#= 

Callibration Document -> Lines of text
Each line used to contain specific calibration value -> What we are looking for

We need to find the first and last digit to form a two digit number

What is the sum of all callibration number

=#

input = "two1nine
eightwothree
abcone2threexyz
xtwone3four
4nineeightseven2
zoneight234
7pqrstsixteen"

function is_number(line, target_index, number_string, number_return)
    if length(line) < target_index + length(number_string) - 1
        return missing
    end

    if line[target_index:target_index + length(number_string) - 1] == number_string
        return number_return
    end
    return missing
end

function process(line, target_index::Int)
    if isnumeric(line[target_index])
        return line[target_index]
    end

    one =   is_number(line, target_index, "one",    "1")
    two =   is_number(line, target_index, "two",    "2")
    three = is_number(line, target_index, "three",  "3")
    four =  is_number(line, target_index, "four",   "4")
    five =  is_number(line, target_index, "five",   "5")
    six =   is_number(line, target_index, "six",    "6")
    seven = is_number(line, target_index, "seven",  "7")
    eight = is_number(line, target_index, "eight",  "8")
    nine =  is_number(line, target_index, "nine",   "9")

    target = filter(
        number -> !ismissing(number), 
        [one, two, three, four, five, six, seven, eight, nine])
    
    if isempty(target)
        return missing
    end

    return target[begin]
end


function process_line(line)
    numbers_only = []
    for i in 1:length(line)
        push!(numbers_only, process(line, i))
    end
    filter!(number -> !ismissing(number), numbers_only)
    return parse(Int, numbers_only[begin] * numbers_only[end])
end

function exercise1(input::String)
    parsed_input = split(input, "\n")
    numbers = map(process_line, parsed_input)
    return reduce(+, numbers)
end

exercise1(input)
