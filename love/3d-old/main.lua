-- https://www.scratchapixel.com/lessons/3d-basic-rendering/perspective-and-orthographic-projection-matrix/building-basic-perspective-projection-matrix
-- https://stackoverflow.com/questions/28286057/trying-to-understand-the-math-behind-the-perspective-matrix-in-webgl/28301213
-- https://en.wikipedia.org/wiki/3D_projection#Orthographic_projection
-- https://www.mathway.co
-- blah this is hard...

objLoader = require("obj.lua")

-- Helper functions

function Matrix(w, h, fill)
	m = {}
	for y=1,h do
		m[y] = {}
		for x=1,w do
			m[y][x] = fill
		end
	end
	return m
end

function perspectiveMatrix(near, far, fov, aspect)
	scale = 1 / math.tan(math.pi*0.5 - 0.5*fov)
	range = 1 / (near-far)
	m = Matrix(4, 4, 0)
	m[1][1] = scale/aspect
    m[2][2] = scale
    m[3][3] = (near+far)*range
    m[4][3] = near*far*range*2; 
    m[3][4] = -1
    m[4][4] = 0 
end

function project(point, s)

	o = {}




	return o
end

-- Main functions

function love.load()

	-- Declaring variables
	player = {
		pos = {0, 0, 0}
	}

	projectionMatrix = perspectiveMatrix(0, 128, 90,
		love.graphics.getWidth()/love.graphics.getHeight())

	myObj = obj.load("spaceship.obj")

end

function love.update(dt)

end

function love.draw()

end