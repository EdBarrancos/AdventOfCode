input_string = raw"xmul(2,4)&mul[3,7]!^don't()_mul(5,5)+mul(32,64](mul(11,8)undo()?mul(8,5))"

regex = r"mul\(\d+,\d+\)"
function solveP1(input_string)
    total = 0
    for x in eachmatch(regex, input_string)
        codes = split(x.match, ',')
        total += parse(Int, codes[1][5:end]) * parse(Int, codes[2][1:end-1])
    end
    println(total)
end


function solveP2(input_string)
    regex_p2 = r"mul\(\d+,\d+\)|do\(\)|don\'t\(\)"
    doit = true
    total = 0
    for x in eachmatch(regex_p2, input_string)
        if x.match[1:3] == "do("
            doit = true
        elseif x.match[1:3] == "don"
            doit = false
        elseif doit
            codes = split(x.match, ',')
            total += parse(Int, codes[1][5:end]) * parse(Int, codes[2][1:end-1])
        end
    end
    println(total)
end

solveP2(input_string)
