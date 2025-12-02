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
		nums = mod.(collect(d.num:-1:(d.num-r.turns)), 100)
		d.num = last(nums)
		return count(x->x==0, nums[2:end])
	else # right
		nums = mod.(collect(d.num:1:(d.num+r.turns)), 100)
		d.num = last(nums)
		return count(x->x==0, nums[2:end])
	end
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
zero_count = sum([turn_dial!(dial,rotation) for rotation in rotations])
