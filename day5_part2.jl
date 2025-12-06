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
	range_lines = split(input, "\n\n")[1]
	fresh_id_ranges = parse.(UnitRange, string.(collect(split(range_lines))))
	return fresh_id_ranges
end

fresh_ids = parse_input(input)

range_starts = sort(first.(fresh_ids))
range_ends   = sort(last.(fresh_ids))

zippered_ranges = zeros(Int, length(fresh_ids)*2)
for i in 0:length(fresh_ids)-1
	zippered_ranges[2*i+1] = range_starts[i+1]
	zippered_ranges[2*i+2] = range_ends[i+1]
end

condensed_ranges = []
i = 1
while true
	if i == length(zippered_ranges)
		push!(condensed_ranges, zippered_ranges[i])
		break
	end
	if zippered_ranges[i] < zippered_ranges[i+1]
		push!(condensed_ranges, zippered_ranges[i])
		global i += 1
	else
		global i += 2
	end
end

condensed_ranges = [condensed_ranges[i]:condensed_ranges[i+1] for i in 1:2:length(condensed_ranges)-1]
singles = first.(filter(x->length(x)==1, fresh_ids))
missed_singles = if length(singles) > 0 sum([any(x->single in x, condensed_ranges) for single in singles]) else 0 end

sum(length.(condensed_ranges)) + missed_singles
