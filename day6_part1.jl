input = "123 328  51 64 
 45 64  387 23 
  6 98  215 314
*   +   *   +  "

function parse_input(input::String)
	lines = split(input, "\n")
	operations = map(s -> getfield(Main,s), Symbol.(split(lines[end])))
	numbers = [parse.(Int, split(line)) for line in lines[1:end-1]]
	return stack(numbers; dims=1), operations
end

numbers, operations = parse_input(input)
sum([reduce(operations[i], numbers[:,i]) for i in 1:length(operations)])
