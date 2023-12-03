#= 

Any number adjacent to a symbol, even diagonally is a "part number"
"." are not symbols

Sum all the part numbers

=#

#= Part 1 =#

input = "467..114..
...*......
..35..633.
......#...
617*......
.....+.58.
..592.....
......755.
...$.*....
.664.598.."

struct Index
    x
    y
end

# If I find a symbol search for numbers near
function is_index_valid(height::Int, width::Int, index::Index)
    return  index.x >= 1 && index.y >= 1 && index.x <= width && index.y <= height 
end

is_symbol(char) = !isnumeric(char) && char != '.'
is_symbol(input, index::Index) = 
    is_index_valid(length(input), length(input[begin]), index)  && is_symbol(input[index.y][index.x])
is_symbol(input, list_of_indexes::Array{Index}) = any(map(index -> is_symbol(input, index), list_of_indexes))

function is_number_part_of_engine(input, start_index::Index, number_of_digit::Int)
    # Up and down
    for i in 0:number_of_digit
        if is_symbol(input, Index(start_index.x + i, start_index.y - 1))
            return true
        elseif is_symbol(input, Index(start_index.x + i, start_index.y + 1))
            return true
        end
    end

    # Left and diagonals
    if is_symbol(
        input, 
        [
            Index(start_index.x - 1, start_index.y),
            Index(start_index.x - 1, start_index.y + 1),
            Index(start_index.x - 1, start_index.y - 1)
        ]
    )
        return true
    end

    # right and diagonals
    if is_symbol(
        input, 
        [
            Index(start_index.x + number_of_digit, start_index.y),
            Index(start_index.x + number_of_digit, start_index.y + 1),
            Index(start_index.x + number_of_digit, start_index.y - 1)
        ]
    )
        return true
    end

    return false
end

function get_number_size(input, start_index::Index)
    current_x = start_index.x
    while(
        is_index_valid(
            length(input), 
            length(input[begin]), 
            Index(current_x, start_index.y)) &&
        isnumeric(input[start_index.y][current_x]))
    
        current_x += 1
    end

    return current_x - start_index.x
end

function exercise3(input::String)
    parsed_input = split(input, '\n')

    engine = 0

    for y in 1:length(parsed_input)
        target_x = 1
        while (target_x <= length(parsed_input[begin]))
            if (!isnumeric(parsed_input[y][target_x]))
                target_x += 1
                continue
            end
            
            starting_index = Index(target_x, y)
            number_size = get_number_size(parsed_input, starting_index)
            println("number size: ", number_size)
            if (is_number_part_of_engine(parsed_input, starting_index, number_size))
                number_string = reduce(*, parsed_input[y][target_x:target_x + number_size - 1])
                engine += parse(Int, number_string)
            end

            target_x += number_size
        end
    end

    return engine
end

exercise3(input)

#=  Part 2 =#

is_gear_symbol(char) = char == '*'

is_number(char) = isnumeric(char)
is_number(input, index::Index) = 
    is_index_valid(length(input), length(input[begin]), index)  && is_number(input[index.y][index.x])
is_number(input, list_of_indexes::Array{Index}) = 
    any(map(index -> is_number(input, index), list_of_indexes))

get_index_if_number(input, index::Index) = is_number(input, index) ? index : missing
get_index_if_number(input, indexes::Array{Index}) = 
    filter(index -> !ismissing(index), map(index -> get_index_if_number(input, index), indexes))

get_surrounding_number_indexes(input, symbol_index::Index) =
    get_index_if_number(
        input,
        [
            Index(symbol_index.x - 1, symbol_index.y),
            Index(symbol_index.x - 1, symbol_index.y + 1),
            Index(symbol_index.x - 1, symbol_index.y - 1),
            Index(symbol_index.x + 1, symbol_index.y),
            Index(symbol_index.x + 1, symbol_index.y + 1),
            Index(symbol_index.x + 1, symbol_index.y - 1),
            Index(symbol_index.x, symbol_index.y + 1),
            Index(symbol_index.x, symbol_index.y - 1)
        ])

function do_indexes_belong_to_same_number(input, index1::Index, index2::Index)
    if (index1.y != index2.y)
        return false
    end

    if (index1.x == index2.x)
        return true
    end

    from = index1.x > index2.x ? index2.x : index1.x
    to = index1.x > index2.x ? index1.x : index2.x

    for i in from:to
        if (!is_number(input, Index(i, index1.y)))
            return false
        end
    end

    return true
end

function get_number(input, number_index::Index)
    min_x = number_index.x
    max_x = number_index.x

    while(
        is_index_valid(
            length(input),
            length(input[begin]),
            Index(min_x, number_index.y)
        ) &&
        is_number(input, Index(min_x, number_index.y)))
    
        min_x -= 1
    end

    while(
        is_index_valid(
            length(input),
            length(input[begin]),
            Index(max_x, number_index.y)
        ) &&
        is_number(input, Index(max_x, number_index.y)))
        
        max_x += 1
    end

    min_x += 1 # to go back to a valid position
    max_x -= 1

    return parse(Int, reduce(*, input[number_index.y][min_x:max_x]))
end

function process_gear_symbol(input, index::Index)
    number_indexes = get_surrounding_number_indexes(input, index)
    unique_numbers = [number_indexes[begin]]
    for index in number_indexes
        repeated = map(stored_index -> do_indexes_belong_to_same_number(input, index, stored_index), unique_numbers)
        if (any(repeated))
            continue
        end

        push!(unique_numbers, index)
    end

    if length(unique_numbers) < 2
        return 0
    end

    numbers = map(index -> get_number(input, index), unique_numbers)
    reduce(*, numbers)
end

function exercise3(input::String)
    parsed_input = split(input, '\n')

    gear = 0

    for y in 1:length(parsed_input)
        for x in 1:length(parsed_input[begin])
            if is_gear_symbol(parsed_input[y][x])
                gear += process_gear_symbol(parsed_input, Index(x, y))
            end
        end
    end

    return gear
end

exercise3(input)
