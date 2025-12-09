input = "7,1
11,1
11,7
9,7
9,5
2,5
2,3
7,3"

function parse_input(input::String)
	map(
		x -> parse.(Int, string.(x)), 
		split.(split(input), ",")
	)
end

corners = parse_input(input)
areas = [length(range(c1[1],c2[1])) * length(range(c1[2],c2[2])) for c1 in corners for c2 in corners]
maximum(areas)
