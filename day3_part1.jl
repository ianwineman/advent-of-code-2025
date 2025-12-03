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

function maxiumum_joltage(bank::Vector{Int64})
	x, i = findmax(bank[1:end-1])
	y, _ = findmax(bank[i+1:end])
	return 10 * x + y
end

banks = parse_input(input)
joltages = [maxiumum_joltage(b) for b in banks]
sum(joltages)
