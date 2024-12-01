function maskify(cc)
    number_of_hashes = length(cc) >= 4 ? length(cc) - 4 : 0
    reduce(*, fill('#', number_of_hashes)) * cc[number_of_hashes + 1:end]
end

maskify("123456")