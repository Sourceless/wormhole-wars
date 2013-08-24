function love.load()

end


function love.draw()
    local y_offset = 80 -- offset from top and bottom borders
    local max_distance = 20 -- max distance from centreline at y_offset
    local seperation = 65 -- distance between points
    local waves = 6 -- amount of cycles

    local width = love.graphics.getWidth()

    for i = -seperation, width + seperation, seperation do
        local rads = (i / width) * math.pi
        local y = math.sin(rads * waves)
        love.graphics.point(i, y_offset + y * max_distance)
    end
end
