input = "[.##.] (3) (1,3) (2) (2,3) (0,2) (0,1) {3,5,4,7}
[...#.] (0,2,3,4) (2,3) (0,4) (0,1,2) (1,2,3,4) {7,5,12,7,2}
[.###.#] (0,1,2,3,4) (0,3,4) (0,1,2,4,5) (1,2) {10,11,11,5,10,5}"

struct Machine
	indicator_lights::Vector{Int64}
	num_indicator_lights::Int64
	buttons::Vector{Vector{Int64}}
end

function parse_input(input::String)::Vector{Machine}
	machine_lines = split(input, "\n")
	machines = Vector{Machine}(undef, length(machine_lines))
	for (i,machine) in enumerate(machine_lines)
		light_str, button_str = split(machine, "]")
		lights = replace(split(string(split(light_str[2:end])[1]), ""), "." => 0, "#" => 1)
		llen = length(lights)
		buttons = [parse.(Int, split(y[2:end-1], ",")) for y in  filter(x->!isempty(x), split(split(button_str, "{")[1], " "))]
		binary_buttons = Vector{Vector{Int64}}(undef, length(buttons))
		for (i,b) in enumerate(buttons)
			bb = zeros(llen)
			bb[b.+1] = ones(length(b))
			binary_buttons[i] = bb
		end
		machines[i] = Machine(lights, llen, binary_buttons)
	end
	return machines
end

"""
presses[i] is how many times the ith button of m is pressed

presses are preformed from zeros() by default unless ;lights passed
"""
function press_buttons(presses::Vector{Int64}, m::Machine; lights=zeros(Int, m.num_indicator_lights))
	for i in 1:length(presses)
		lights .+= (presses[i] .* m.buttons[i])
	end
	return lights .% 2
end

machines = parse_input(input)
min_presses = zeros(Int, length(machines))

for (i,m) in enumerate(machines) 
	# presses_and_state[1] is current state of lights, presses_and_state[2] is current presses
	presses_and_state = [(zeros(Int, m.num_indicator_lights), zeros(Int, length(m.buttons)))]

	machine_min_presses = []

	while true
		incremental_presses = collect.(vec(collect(Iterators.product([0:1 for _ in 1:length(m.buttons)]...))))
		new_presses_and_state = []

		for ps in presses_and_state
			for p in incremental_presses
				current_lights = ps[1]
				previous_presses = ps[2]
				next_presses = previous_presses .+ p
				next_state = press_buttons(next_presses, m; lights=deepcopy(current_lights))
				if next_state == m.indicator_lights
					push!(machine_min_presses, sum(next_presses))
				else
					push!(new_presses_and_state, (next_state, next_presses))
				end
			end
		end
		presses_and_state = new_presses_and_state
		if length(machine_min_presses) > 0
			break
		end
	end
	min_presses[i] = minimum(machine_min_presses)
end

sum(min_presses)
