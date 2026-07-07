--[[
The Snake AI uses A* as its primary pathfinding algorithm but validates each food path before committing to it. It simulates the board after following the path and eating, then performs a second A* search to verify the head can still reach the tail, falling back to tail-chasing if the food path is unsafe. If no A* path exists (for tail or food), it safely selects the best legal adjacent move instead of failing (using a flood-fill algorithm). The flood-fill algorithm evaluates the amount of reachable free space for each candidate move, helping the AI avoid paths that would trap it in small enclosed regions. These heuristic safeguards significantly reduce self-trapping while keeping A* as the core decision-making algorithm.
]]

AI = Class{}

function AI:init()
    self.Row = BOARD_DIMENSIONS
    self.Col = BOARD_DIMENSIONS
end

-- Check if cell is within the grid
function AI:is_valid(row, col)
    return (row >= 0) and (row < self.Row) and (col >= 0) and (col < self.Col)
end

-- Check if the cell is unblocked
function AI:is_not_blocked(grid, row, col)
    return grid[col + 1][row + 1] == false
end

-- Check if the cell is the destination
function AI:is_destination(row, col, dest)
    return row == dest[1] and col == dest[2]
end

-- Calculate the heuristic value of a cell (using Manhantan distance as h)
function AI:h_value(row, col, dest)
    return math.abs(row - dest[1]) + math.abs(col - dest[2])
end

-- Trace the path from source to destination
function AI:track_path(set_of_cells, dest)
    local path = {}

    local row = dest[1]
    local col = dest[2]

    -- Trace the path from destination to source using parent cells
    --[[ The idea here is that since the parent of the source cell is the 
    source cell itself, when I reach the source, it's parent will pount to the 
    source cell coordinates (i,j) itself and then break the loop ]]
    local key = string.format("(%i, %i)", row, col)
    while not (set_of_cells[key]["parents"][1] == row and set_of_cells[key]["parents"][2] == col) do
        local parentI = set_of_cells[key]["parents"][1]
        local parentJ = set_of_cells[key]["parents"][2]

        table.insert(path, {row, col})

        local temp_row = parentI
        local temp_col = parentJ

        row = temp_row
        col = temp_col

        key = string.format("(%i, %i)", row, col)
    end

    -- Adding the source cell to the path
    local source_cell = {row, col}
    table.insert(path, source_cell)

    -- Reverse the path to get the path from source to destination and printing it
    local real_path = {}
    for k = #path, 1, -1 do
        table.insert(real_path, path[k])
    end
    
    return real_path
end

-- Implementing the A* search algorithm
function AI:a_star_search(grid, src, dest)
    -- Initiating open list (list that holds all unexplored cells) - Data Structure used: Map
    local unexploredCells = {}
    -- Initiating closed list (list that holds explored cells) - Data Structure used: Map
    local exploredCells = {}
    -- Initiating parents list (so it holds the parents of all cells)
    local allCells = {}

    local path = nil

    -- Adding cell details to the open list
    local s = string.format("(%i, %i)", src[1], src[2])
    unexploredCells[s] = { row = src[1], col = src[2], f = 0, g = 0, h = 0, parents = {src[1], src[2]}}

    allCells[s] = { row = src[1], col = src[2], f = 0, g = 0, h = 0, parents = {src[1], src[2]}}

    local Flag = true
    while Flag do
        -- Getting cell with lowest f value
        local lowest_f = math.huge
        local q = nil
        local qKey = nil
        for k, node in pairs(unexploredCells) do
            if lowest_f > node["f"] then
                lowest_f = node["f"]
                q = node
                qKey = k
            end
        end

        -- Removing q from the open list
        unexploredCells[qKey] = nil

        -- Found destination flag
        local found_dest = false

        -- Looking at the cell with lowest f neighbors (4 in total: up, down, left, right)
        for k = 1, 4 do
            local di, dj = 0, 0
            -- Right neighbor
            if k == 1 then
                dj = 1
            -- Left neighbor
            elseif k == 2 then
                dj = -1
            -- Bottom neighbor
            elseif k == 3 then
                di = 1
            -- Top neighbor
            elseif k == 4 then
                di = -1
            end

            -- Creating neighbor
            local neighborCol = q["col"] + dj
            local neighborRow = q["row"] + di
            local neighborKey = string.format("(%i, %i)", neighborRow, neighborCol)
            local neighbor = { row = neighborRow, col = neighborCol, f = 0, g = 0, h = 0, parents = {q["row"], q["col"]}}

            -- Checking if the neighbor is valid and not blocked
            if self:is_valid(neighbor["row"], neighbor["col"]) and self:is_not_blocked(grid, neighbor["row"], neighbor["col"]) then

                -- If is the destination, stop search
                if self:is_destination(neighbor["row"], neighbor["col"], dest) then
                    -- Setting neighbor parents
                    neighbor["parents"] = {q["row"], q["col"]}
                    allCells[neighborKey] = neighbor

                    -- Printing path
                    path = self:track_path(allCells, dest)
                    found_dest = true
                    break
                else
                    -- Compute g, h,and f values
                    neighbor["g"] = q["g"] + 1
                    neighbor["h"] = self:h_value(neighbor["row"], neighbor["col"], dest)
                    neighbor["f"] = neighbor["g"] + neighbor["h"]

                    --local insertFlag = true
                    -- Checking if same cell (position) is already in the open list with a lower f value
                    -- If yes, swap values in case the already existing value is bigger
                    if not (unexploredCells[neighborKey] == nil) and neighbor["f"] < unexploredCells[neighborKey]["f"] then
                        unexploredCells[neighborKey] = neighbor
                        allCells[neighborKey] = neighbor
                        --insertFlag = false
                    end

                    -- Checking if same cell (position) is already in the closed list list with a lower f value
                    -- If yes, add new values to open list in case the already existing value is bigger and remove that value from closed list
                    if not (exploredCells[neighborKey] == nil) and neighbor["f"] < exploredCells[neighborKey]["f"] then
                        exploredCells[neighborKey] = nil
                        unexploredCells[neighborKey] = neighbor
                        allCells[neighborKey] = neighbor
                        --insertFlag = false
                    end

                    -- Adding neighbor to the open list in case it is in neither of the lists
                    if unexploredCells[neighborKey] == nil and exploredCells[neighborKey] == nil then
                        unexploredCells[neighborKey] = neighbor
                        allCells[neighborKey] = neighbor
                    end
                end
            end
        end

        -- If destination is reached, stop search
        if found_dest then
            print("Destination Reached")
            break
        end

        -- Adding cell to the already explored list
        exploredCells[qKey] = q
        allCells[qKey] = q

        Flag = false
        for k, node in pairs(unexploredCells) do
            if not (node == nil) then
                Flag = true
                break
            end
        end
    end

    return path
end

-- Plan a path to the food using A* search and simulate the snake's movement along that path
function AI:plan_path(body, segments, food)
    local head = segments[1]
    local foodPath = self:a_star_search(body, head, food)

    if not (foodPath == nil) then
        local simulatedSegments = self:simulate_after_path(segments, foodPath)
        local newHead = simulatedSegments[1]
        local newTail = simulatedSegments[#simulatedSegments]

        -- Simulating new grid + freeing the new tail cell to check if the path is safe (if the snake can reach its own tail after eating the food)
        local simulatedGrid = self:segments_to_grid(simulatedSegments)
        local freedGrid = self:grid_with_cell_freed(simulatedGrid, newTail)

        -- If safe, accept it
        if not (self:a_star_search(freedGrid, newHead, newTail) == nil) then
            return foodPath 
        end
    end

    -- Fall back to tail chasing if food path is not safe
    local tail = segments[#segments]
    local freedRealGrid = self:grid_with_cell_freed(body, tail)
    local tailPath = self:a_star_search(freedRealGrid, head, tail)
    if not (tailPath == nil) then
        return tailPath
    end

    -- Fall back to safest adjacent move if tail path is not safe
    local safeMove = self:safest_adjacent_move(body, head, tail)
    if not (safeMove == nil) then
        return {head, safeMove} 
    end

    -- If nothing works, return nil (no path found)
    return nil  
end

-- Simulate the snake's movement along the given path and return the resulting segments
function AI:simulate_after_path(segments, path)
    local current_segments = segments
    for i = 2, #path do
        local newHead = {path[i][1], path[i][2]}
        local isLastStep = false
        if (i == #path) then
            isLastStep = true
        end
        local newSegments = {newHead}
        for k = 1, #current_segments do
            table.insert(newSegments, current_segments[k])
        end
        if not isLastStep then
            -- drop added tail; no growth this step
            table.remove(newSegments)
        end
        current_segments = newSegments
    end
    return current_segments
end

-- Setting the grid representation of the snake's segments (head + body parts) in a grid (occupied or not)
function AI:segments_to_grid(segments)
    local grid = {}
    -- Setting up the grid with all cells unblocked (false)
    for col = 0, BOARD_DIMENSIONS - 1 do
        table.insert(grid, {})
        for row = 0, BOARD_DIMENSIONS - 1 do
            table.insert(grid[col + 1], false)
        end
    end
     -- Setting the cells occupied by the snake's segments as blocked (true)
    for k = 1, #segments do
        local seg = segments[k]
        grid[seg[2] + 1][seg[1] + 1] = true
    end

    return grid
end

-- Free a specific cell in the grid representation of the snake's segments (head + body parts)
function AI:grid_with_cell_freed(grid, cell)
    local new_grid = {}
    for col = 0, BOARD_DIMENSIONS - 1 do
        table.insert(new_grid, {})
        for row = 0, BOARD_DIMENSIONS - 1 do
            if row == cell[1] and col == cell[2] then
                table.insert(new_grid[col + 1], false)
            else
                table.insert(new_grid[col + 1], grid[col + 1][row + 1])
            end
        end
    end
    return new_grid
end

-- Find the safest adjacent move for the snake
function AI:safest_adjacent_move(grid, head, tail)
    local candidates = {}
    local directions = {{0,1},{0,-1},{1,0},{-1,0}}
    for index, value in ipairs(directions) do
        local r, c = head[1] + value[1], head[2] + value[2]
        if self:is_valid(r, c) and self:is_not_blocked(grid, r, c) then
            table.insert(candidates, {r, c})
        end
    end

    -- If no candidates are available, return nil
    if #candidates == 0 then 
        return nil 
    end

    -- Score candidates, return the best one
    local bestCandidate = nil
    local bestSpace = -1
    local bestDist = math.huge
    for index, value in ipairs(candidates) do
        local space = self:flood_fill_count(grid, value)
        local dist = self:h_value(value[1], value[2], tail)
        if space > bestSpace or (space == bestSpace and dist < bestDist) then
            bestCandidate = value
            bestSpace = space
            bestDist = dist
        end
    end
    return bestCandidate
end

-- Count the number of reachable cells from a starting cell using flood fill algorithm
function AI:flood_fill_count(grid, start)
    local visited = {}
    local key = string.format("(%i, %i)", start[1], start[2])
    visited[key] = true
    local stack = {start}
    local count = 1
    local directions = {{0,1},{0,-1},{1,0},{-1,0}}

    while #stack > 0 do
        local cell = table.remove(stack)
        for index, value in ipairs(directions) do
            local r, c = cell[1] + value[1], cell[2] + value[2]
            local k = string.format("(%i, %i)", r, c)
            if self:is_valid(r, c) and self:is_not_blocked(grid, r, c) and not visited[k] then
                visited[k] = true
                count = count + 1
                table.insert(stack, {r, c})
            end
        end
    end
    return count
end
