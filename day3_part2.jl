input = "987654321111111
811111111111119
234234234234278
818181911112111"

function parse_input(input::String)::Vector{Vector{Int64}}
	lines = split(input)
	banks = Vector{Vector{Int64}}(undef, length(lines))
	for (i,bank) in enumerate(lines)
		banks[i] = parse.(Int, split(bank, ""))
	end
	return banks
end

function maximum_joltage(bank::Vector{Int64})
	digits = zeros(Int, 12)
	j = 1
	for (i, joltage) in enumerate(bank)
		if joltage ≥ maximum(bank[i:(end-12+j)])
			digits[j] = joltage
			j += 1
			if j == 13
				break
			end
		end
	end
	return [10^i for i in 11:-1:0]' * digits
end

banks = parse_input(input)
joltages = [maximum_joltage(b) for b in banks]
sum(joltages)
