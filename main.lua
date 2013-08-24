function love.load()
    xpos = 0
    move_amount = 5
    move_direction = -1
end


function love.draw()
    local y_offset = 80 -- offset from top and bottom borders
    local max_distance = 20 -- max distance from centreline at y_offset
    local seperation = 30 -- distance between points
    local waves = 6 -- amount of cycles

    local width = love.graphics.getWidth()

    for i = -seperation * waves, width + seperation * waves, seperation do
        local rads = (i / width) * math.pi
        local y = math.sin(rads * waves)
        love.graphics.point(i + xpos, y_offset + y * max_distance)
    end

    xpos = (xpos + move_amount * move_direction)
    local lim = (width / waves) * 2

    if xpos < -lim or xpos >= lim then
        xpos = 0
    end
end
