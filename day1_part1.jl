input = "L68
L30
R48
L5
R60
L55
L1
L99
R14
L82"

mutable struct Dial
	num::Int # num ∈ [0,99]
end

@enum Direction left right

struct Rotation
	dir::Direction
	turns::Int
end

function turn_dial!(d::Dial, r::Rotation)
	if r.dir == left
		d.num = mod(d.num - r.turns, 100)
	else # right
		d.num = mod(d.num + r.turns, 100)
	end
	return nothing
end

function parse_input(input::String)::Vector{Rotation}
	lines = split(input)
	rotations = Vector{Rotation}(undef, length(lines))
	for (i,line) in enumerate(lines)
		dir = ifelse(line[1] == 'L', left, right)
		turns = parse(Int, line[2:end])
		rotations[i] = Rotation(dir, turns)
	end
	return rotations
end

rotations = parse_input(input)
dial = Dial(50)
zero_count = 0

for rotation in rotations
	turn_dial!(dial,rotation)
	if dial.num == 0
		global zero_count += 1
	end
end
zero_count
