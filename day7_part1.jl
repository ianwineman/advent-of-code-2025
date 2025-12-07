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
		level_beams::Vector{Tuple{Int64, Int64}}	
	)::Tuple{Vector{Tuple{Int64, Int64}}, Int64}
	next_level_beams = []
	beam_splits = 0

	for beam in level_beams
		if beam .+ (1,0) in tm.splitters
			beam_splits += 1
			push!(next_level_beams, beam .+ (1, 1))
			push!(next_level_beams, beam .+ (1,-1))
		else
			push!(next_level_beams, beam .+ (1,0))
		end
	end
	
	return collect(Set(next_level_beams)), beam_splits
end

function beam_path(tm::TachyonManifold)
	beam_splits = 0
	beam_path = [tm.beam_entrance]
	for i in 2:size(tm.manifold)[1]
		bp, bs = beam_step(tm, beam_path)
		beam_path = bp
		beam_splits += bs
	end
	return beam_splits
end

tm = parse_input(input)
beam_path(tm)
