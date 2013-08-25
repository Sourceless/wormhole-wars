function generate_point(i, n, xvar, yvar, yoff)
    local p = {}
    local centre = love.graphics.getHeight() / 2
    p.x = (i / n) * love.graphics.getWidth()
    if mode == "safe" then
        p.y = centre - yoff
    else
        p.y = centre - yoff / 1.5
    end
    p.xcycle = math.random()
    p.ycycle = math.random()

    p.dx = math.sin(p.xcycle * math.pi) * xvar
    p.dy = math.cos(p.ycycle * math.pi) * yvar
    if mode == "panic" then
        p.dx = p.dx * 2
        p.dy = p.dy * 5
    end

    if mode == "safe" then
        p.xcycle_speed = math.random(100, 500)
        p.ycycle_speed = math.random(100, 500)
    else
        p.xcycle_speed = math.random(10, 50)
        p.ycycle_speed = math.random(10, 50)
    end

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

    for i = -1, num_points + num_points / 5 do -- add extra points so rendering/
                                               -- scrolling doesn't look bad
        wall[i+2] = generate_point(i, num_points, xvar, yvar, yoff)
    end

    return wall
end

function wall_update(wall, wall_offset)
    local wall_updated = {}
    for i,p in pairs(wall) do
        wall_updated[i] = point_update(p)
    end

    if wall_updated[3].x < 0 then 
        table.remove(wall_updated, 1)
        table.insert(wall_updated,
                     generate_point(num_points + 10,
                                    num_points,
                                    x_variation,
                                    y_variation,
                                    wall_offset))
    end

    return wall_updated
end

function wall_draw(wall, before, after)
    local polyline = before -- start at top left coordinate

    for i, p in ipairs(wall) do
        table.insert(polyline, p.x + p.dx)
        table.insert(polyline, p.y + p.dy)
    end

    for i, c in ipairs(after) do
        table.insert(polyline, c)
    end

    love.graphics.polygon("fill", polyline)
end


function wall_move(wall, amount)
    for i, p in ipairs(wall) do
        p.x = p.x + amount
    end
end


function ship_draw(ship)
    shape = {}

    for i, c in ipairs(ship.shape) do
        if i % 2 == 1 then
            table.insert(shape, c + ship.x)
        else
            table.insert(shape, c + ship.y)
        end
    end

    love.graphics.polygon("fill", shape)
end


function love.load()
    x_variation = 10
    y_variation = 20
    y_dist = 200
    num_points = 40
    movespeed = 15
    safe_time = 10
    panic_time = 10
    mode = "safe"

    love.graphics.setBackgroundColor(255, 255, 255)
    love.graphics.setLineStyle("smooth")

    wall_top = wall_generate(num_points, x_variation, y_variation, y_dist)
    wall_bottom = wall_generate(num_points, x_variation, y_variation,
                                love.graphics.getHeight() - y_dist)

    player = {x = 0.1 * love.graphics.getWidth(),
              y = 0.5 * love.graphics.getHeight(),
              shape = {0, -8, 0, 8, 25, 0}}

    t_start = os.time()
end
    

function love.draw()
    local height = love.graphics.getHeight()
    local width = love.graphics.getWidth()
    
    cur_time = os.difftime(t_start, os.time())
    tick = (cur_time) % (safe_time + panic_time)
    if tick < panic_time and mode == "safe" then
        mode = "panic"
    elseif tick >= panic_time and mode =="panic" then
        mode = "safe"
    end

    bg = 75

    love.graphics.setColor(bg, bg, bg)

    wall_draw(wall_top, {0, 0}, {width, 0, 0, 0})
    wall_draw(wall_bottom, {0, height}, {width, height, 0, height})

    wall_move(wall_top, -movespeed)
    wall_move(wall_bottom, -movespeed)

    wall_top = wall_update(wall_top, y_dist)
    wall_bottom = wall_update(wall_bottom, -y_dist)


    love.graphics.setColor(40, 40, 40)
    ship_draw(player)
end


function love.keypressed()
end
