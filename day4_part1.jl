input = "..@@.@@@@.
@@@.@.@.@@
@@@@@.@.@@
@.@@@@..@.
@@.@@@@.@@
.@@@@@@@.@
.@.@.@.@@@
@.@@@.@@@@
.@@@@@@@@.
@.@.@@@.@."

function parse_input(input::String)
	lines = split(input)
	grid = zeros(Int, length(lines)+2,length(lines[1])+2)
	for (i,line) in enumerate(lines)
		for (j,cell) in enumerate(line)
			if string(cell) == "@"
				grid[i+1, j+1] = 1
			end
		end
	end
	return grid
end

function convolution(A)
	K = ones(Int, 3, 3)
	K[2,2] = 0
	return sum(A .* K)
end

function removable(grid)
	removable_count = 0
	for i in 2:size(grid)[1]-1
		for j in 2:size(grid)[2]-1
			A = grid[i-1:i+1, j-1:j+1]
			c = convolution(A)
			if (c < 4) && (A[2, 2] == 1)
				removable_count += 1
			end
		end
	end
	return removable_count
end
	

grid = parse_input(input)
removed = removable(grid)
