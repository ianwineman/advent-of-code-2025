import Base: parse

input = "3-5
10-14
16-20
12-18

1
5
8
11
17
32"

function parse(T::Type{UnitRange}, str::String)::UnitRange{Int64}
	lower, upper = parse.(Int, string.(split(str, "-")))
	return lower:upper
end

function parse_input(input::String)
	range_lines, available_lines = split(input, "\n\n")
	fresh_id_ranges = parse.(UnitRange, string.(collect(split(range_lines))))
	available_ids = parse.(Int, collect(split(available_lines)))
	return fresh_id_ranges, available_ids 
end

fresh_ids, ids = parse_input(input)
sum([any(x->id in x, fresh_ids) for id in ids])
