function generate_point(i, n, xvar, yvar, yoff)
    local p = {}
    p.x = (i / n) * love.graphics.getWidth()
    p.y = yoff
    p.xcycle = math.random()
    p.ycycle = math.random()
    p.dx = math.sin(p.xcycle * math.pi) * xvar
    p.dy = math.cos(p.ycycle * math.pi) * yvar
    p.xcycle_speed = math.random(50, 200)
    p.ycycle_speed = math.random(50, 200)

    return p
end

function point_update(p)
    p.xcycle = p.xcycle + 1.0 / p.xcycle_speed
    p.ycycle = p.ycycle + 1.0 / p.ycycle_speed
    
    if p.xcycle > 1.0 then
        p.xcycle = p.xcycle - 1.0
    end
    if p.ycycle > 1.0 then
        p.ycycle = p.ycycle - 1.0
    end

    p.dx = math.sin(p.xcycle * math.pi * 2) * x_variation
    p.dy = math.cos(p.ycycle * math.pi * 2) * y_variation

    return p
end

function wall_generate(num_points, xvar, yvar, yoff)
    local wall = {}

    for i = -1, num_points + 1 do
        wall[i] = generate_point(i, num_points, xvar, yvar, yoff)
    end

    return wall
end

function wall_update(wall)
    local wall_updated = {}
    for i,p in pairs(wall) do
        wall_updated[i] = point_update(p)
    end

    return wall_updated
end

function wall_draw(wall)
    local polyline = {}


    for i, p in ipairs(wall) do
        love.graphics.point(p.x + p.dx,
                            p.y + p.dy)

        table.insert(polyline, p.x + p.dx)
        table.insert(polyline, p.y + p.dy)
    end

    love.graphics.line(polyline)
end


function love.load()
    x_variation = 40
    y_variation = 30
    local y_dist = 100
    local num_points = 6

    wall_top = wall_generate(num_points, x_variation, y_variation, y_dist)
    wall_bottom = wall_generate(num_points, x_variation, y_variation,
                                love.graphics.getHeight() - y_dist)

    love.graphics.setPoint(1, "rough")
end


function love.draw()
    wall_draw(wall_top)
    wall_draw(wall_bottom)

    wall_update(wall_top)
    wall_update(wall_bottom)
end


