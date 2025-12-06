input = "123 328  51 64 
 45 64  387 23 
  6 98  215 314
*   +   *   +  "

function parse_input(input::String)
	lines = split(input, "\n")
    s = stack([collect(split(line, "")) for line in lines[1:end-1]]; dims=1)

    cols = []
    nums = []
    for i in 1:size(s)[2]
        str = join(s[:,i])
        if strip(str) == ""
            push!(cols, nums)
            nums = []
        else
            push!(nums, parse(Int, str))
        end
    end
    push!(cols, nums)

    operations = map(s -> getfield(Main,s), Symbol.(split(lines[end])))

    return cols, operations
end

number_cols, operations = parse_input(input2)
sum([reduce(operations[i], number_cols[i]) for i in 1:length(operations)])
