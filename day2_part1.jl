import Base: parse

input = "11-22,95-115,998-1012,1188511880-1188511890,222220-222224,1698522-1698528,446443-446449,38593856-38593862,565653-565659,824824821-824824827,2121212118-2121212124"

function parse(T::Type{UnitRange}, str::String)::UnitRange{Int64}
	lower, upper = parse.(Int, string.(split(str, "-")))
	return lower:upper
end

function parse_input(input::String)::Vector{UnitRange{Int64}}
	splits = split(input, ",")
	ranges = Vector{UnitRange{Int64}}(undef, length(splits))
	for (i,range) in enumerate(splits)
		ranges[i] = parse(UnitRange, string(range))
	end
	return ranges
end

function invalid_id(id::Int64)
	l = length(string(id))
	if l % 2 == 1
		return false
	else
		l2 = Int(l/2)
		if string(id)[1:l2] == string(id)[l2+1:end]
			return true
		else
			return false
		end
	end
end

function invalid_ids(id_range::UnitRange{Int64})
	return filter(invalid_id, id_range)
end

ranges = parse_input(input)
invalidIDs = reduce(vcat, [invalid_ids(r) for r in ranges])
sum(invalidIDs)
