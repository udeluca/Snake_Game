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
    return not grid[col + 1][row + 1]
end

-- Check if the cell is the destination
function AI:is_destination(row, col, dest)
    return row == dest[1] and col == dest[2]
end

-- Calculate the heuristic value of a cell (using Manhantan distance as h)
function AI:h_value(row, col, dest)
    return math.abs(row - dest[1]) + math.abs(col - dest[2])
end

-- Build an occupancy grid
function AI:build_occupancy(bodyGrid)
    local grid = {}
    for x = 0, self.Col - 1 do
        grid[x + 1] = {}
        for y = 0, self.Row - 1 do
            grid[x + 1][y + 1] = false
        end
    end

    for i = 1, #bodyGrid do
        local x = bodyGrid[i].gridX
        local y = bodyGrid[i].gridY
        grid[x + 1][y + 1] = true
    end

    return grid
end

function AI:simulate_step(player, nextCell, object)

    local willEat = (nextCell[1] == object.posGridY and nextCell[2] == object.posGridX)

    if willEat then
        player:grow(object)
    end

    player:updateCells()
    local newVT  = player:updateVacateTime()

    return newVT
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
function AI:a_star_search(grid, src, dest, vacate_time)

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

            local arrival = q["g"] + 1
            local vt = math.huge
            if self:is_valid(neighbor["row"], neighbor["col"]) and not (vacate_time[neighbor["col"] + 1][neighbor["row"] + 1] == nil) then
                vt = vacate_time[neighbor["col"] + 1][neighbor["row"] + 1]
            end
            -- Checking if the neighbor is valid and not blocked
            if self:is_valid(neighbor["row"], neighbor["col"]) and (self:is_not_blocked(grid, neighbor["row"], neighbor["col"]) or arrival >= vt) then

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
                    neighbor["g"] = arrival
                    neighbor["h"] = self:h_value(neighbor["row"], neighbor["col"], dest)
                    neighbor["f"] = neighbor["g"] + neighbor["h"]

                    -- Checking if same cell (position) is already in the open list with a lower f value
                    -- If yes, swap values in case the already existing value is bigger
                    if not (unexploredCells[neighborKey] == nil) and neighbor["f"] < unexploredCells[neighborKey]["f"] then
                        unexploredCells[neighborKey] = neighbor
                        allCells[neighborKey] = neighbor
                    end

                    -- Checking if same cell (position) is already in the closed list list with a lower f value
                    -- If yes, add new values to open list in case the already existing value is bigger and remove that value from closed list
                    if not (exploredCells[neighborKey] == nil) and neighbor["f"] < exploredCells[neighborKey]["f"] then
                        exploredCells[neighborKey] = nil
                        unexploredCells[neighborKey] = neighbor
                        allCells[neighborKey] = neighbor
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
            break
        end

        -- Adding cell to the already explored list
        exploredCells[qKey] = q
        allCells[qKey] = q

        -- If unexplored list is empty (explored all possible cells), break the while loop
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

