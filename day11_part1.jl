input = "aaa: you hhh
you: bbb ccc
bbb: ddd eee
ccc: ddd eee fff
ddd: ggg
eee: out
fff: out
ggg: out
hhh: ccc fff iii
iii: out"

struct Device
	name::String
	outputs::Vector{String}
end

function parse_input(input::String)::Vector{Device}
	device_lines = split(input, "\n")
	devices = Vector{Device}(undef, length(device_lines))
	for (i,device) in enumerate(device_lines)
		name, output_line = string.(split(device, ":"))
		outputs = string.(split(output_line[2:end], " "))
		devices[i] = Device(name, outputs)
	end
	return devices
end

function all_paths(from::String, to::String, d::Vector{Device})
	start = findfirst(x->x.name == from, devices)
	path_ends = [d[start]]
	path_terminations = 0

	while true
		new_ends = []
		for pe in path_ends
			for output in pe.outputs
				if output == to
					path_terminations += 1
				end
				ids = findall(x->x.name == output, d)
				for id in ids
					push!(new_ends, d[id])
				end
			end
		end
		if length(new_ends) == 0
			break
		else
			path_ends = new_ends
		end
	end

	return path_terminations
end

devices = parse_input(input)
all_paths("you", "out", devices)
