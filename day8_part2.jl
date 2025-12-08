using LinearAlgebra

input = "162,817,812
57,618,57
906,360,560
592,479,940
352,342,300
466,668,158
542,29,236
431,825,988
739,650,466
52,470,668
216,146,977
819,987,18
117,168,530
805,96,715
346,949,466
970,615,88
941,993,340
862,61,35
984,92,344
425,690,689"

function parse_input(input::String)::Vector{Vector{Int64}}
	map(
		x -> parse.(Int, string.(x)), 
		split.(split(input), ",")
	)
end

function euclidean_distance(x,y)
	return sqrt(sum((x - y).^2)) 
end

function distance_matrix(points::Vector{Vector{Int64}})::Matrix{Float64}
	dm = zeros(length(points), length(points))
	for (i,point) in enumerate(points)
		dm[:, i] = [euclidean_distance(point, x) for x in points]
	end
	return Matrix(LowerTriangular(dm))
end

function iteratively_connect_boxes_into_circuit(distance_matrix::Matrix{Float64}) 
	dm = distance_matrix

	# let argmin() find non-zero elements by removing 0s
	dm = dm + Matrix(UpperTriangular(zeros(size(dm)...) .+ maximum(dm)))

	connected_pairs = []
	argmins = []
	while true
		am = Tuple(argmin(dm))
		push!(argmins, am)
		push!(connected_pairs, am)
		dm[am...] = maximum(dm)

		circuits = [[b] for b in unique(vcat(first.(connected_pairs), last.(connected_pairs)))]
		for (x,y) in connected_pairs
			i = findfirst(z->x in z, circuits)
			j = findfirst(z->y in z, circuits)		
			if i != j
				circuits[i] = vcat(circuits[i], circuits[j])
				deleteat!(circuits, j)
			end
		end

		if length(circuits) == 1 && length(circuits[1]) == size(dm)[1]
			return argmins[end]
		end
	end
end

junction_boxes = parse_input(input)
dm = distance_matrix(junction_boxes)
i, j = iteratively_connect_boxes_into_circuit(dm)
junction_boxes[i][1] * junction_boxes[j][1]
