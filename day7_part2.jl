input = ".......S.......
...............
.......^.......
...............
......^.^......
...............
.....^.^.^.....
...............
....^.^...^....
...............
...^.^...^.^...
...............
..^...^.....^..
...............
.^.^.^.^.^...^.
..............."

struct TachyonManifold
	manifold::Matrix{String}
	beam_entrance::Tuple{Int64, Int64}
	splitters::Vector{Tuple{Int64, Int64}}
end

function parse_input(input::String)::TachyonManifold
	m  = string.(stack(split.(split(input), ""); dims=1))
	be = (1, findfirst(==("S"), m[1,:]))
	s  = [(i,j) for i in 2:size(m)[1] for j in findall(==("^"), m[i,:])]
	return TachyonManifold(m, be, s)
end

function beam_step(
		tm::TachyonManifold, 
		level_beams::Vector{Tuple{Int64, Int64, Int64}}	
	)::Vector{Tuple{Int64, Int64, Int64}}	
	next_level_beams = []

	for beam in level_beams
		if beam[1:2] .+ (1,0) in tm.splitters
			push!(next_level_beams, beam .+ (1, 1, 0))
			push!(next_level_beams, beam .+ (1,-1, 0))
		else
			push!(next_level_beams, beam .+ (1,0,0))
		end
	end
	
	unique_beams = unique(x->x[1:2], next_level_beams)
	condensed_beams = []
	for ub in unique_beams
		overlapping_beam_ids = findall(x->x[1:2]==ub[1:2], next_level_beams)
		overlapping_beams = next_level_beams[overlapping_beam_ids]
		push!(condensed_beams, (ub[1:2]..., reduce(+, [ob[3] for ob in overlapping_beams])))
	end
	return condensed_beams
end

function beam_path(tm::TachyonManifold)
	beam_path = [(tm.beam_entrance..., 1)]
	for i in 2:size(tm.manifold)[1]
		bp = beam_step(tm, beam_path)
		beam_path = bp
	end
	return sum(getindex.(beam_path, 3))
end

tm = parse_input(input)
beam_path(tm)
