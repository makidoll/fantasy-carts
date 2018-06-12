require("obj")

function translate(v1, v2)
	return {
		v1[1]+v2[1],
		v1[2]+v2[2],
		v1[3]+v2[3],
	}
end

function rotate(v, yaw, pitch)
	local v = {
		v[1]*math.cos(yaw) - v[3]*math.sin(yaw),
		v[2],
		v[3]*math.cos(yaw) + v[1]*math.sin(yaw)
	}

	return {
		v[1],
		v[2]*math.cos(pitch) - v[3]*math.sin(pitch),
		v[3]*math.cos(pitch) + v[2]*math.sin(pitch)
	}
end

function moveCamera(zx, speed) -- z or x
	if (zx == 1) then
		game.pos[1] = game.pos[1]-math.cos(game.rot[1]+math.pi/2)*speed
		game.pos[3] = game.pos[3]+math.sin(game.rot[1]+math.pi/2)*speed
	else end
end

function projectCamera(v, pos, rot)
	local v = rotate(
		translate(v, {pos[1], -pos[2], pos[3]}),
		rot[1], rot[2] 
	)

	local w = love.graphics.getWidth()
	local h = love.graphics.getHeight()
	local z = (h/2)/v[3]
	if (v[3]>0) then return nil end

	return {
		w/2 - (v[1]*z),
		h - (h/2 - (v[2]*z))
	}
end

function drawScene(scene, pos, rot)
	for _,obj in ipairs(scene) do
		
		-- project verts to points
		local points = {}
		local depth = {}

		for vI,v in ipairs(obj.verts) do
			points[vI] = projectCamera(v, pos, rot)

			table.insert(depth, math.sqrt( -- calc depth
				math.pow(obj.verts[vI][1]+pos[1], 2) +
				math.pow(obj.verts[vI][2]+pos[2], 2) +
				math.pow(obj.verts[vI][3]+pos[3], 2)
			))
		end

		-- make polygons and sort
		local polygons = {}
		for _,f in ipairs(obj.faces) do
			-- f = {vertex index, ...}
			local polygon = {}
			local z = 0

			for _,vI in ipairs(f) do -- each vertex index
				if (points[vI+0] == nil) then goto continue end
				z = z + depth[vI+0]
				table.insert(polygon, points[vI+0][1])
				table.insert(polygon, points[vI+0][2])
			end
			z = z/#f

			for i=1,#polygons do
				if (z > polygons[i][1]) then
					table.insert(polygons, i, {z, polygon})
					goto continue
				end
			end
			
			table.insert(polygons, {z, polygon})
			::continue::
		end

		-- draw them!
		for _,p in ipairs(polygons) do
			local c = 1-p[1]*0.03
			love.graphics.setColor(c,c,c, 1)
			love.graphics.polygon("fill", p[2])
		end

	end
end

function love.draw()

	drawScene(game.scene, {
		game.pos[1]+game.cam[1],
		game.pos[2]+game.cam[2],
		game.pos[3]+game.cam[3],
	}, game.rot)

	drawScene(game.kart, game.cam, {0,game.rot[2]})

	if (game.debug) then
		verts = 0
		faces = 0
		for i=1,#game.scene do
			verts = verts + #game.scene[i].verts
			faces = faces + #game.scene[i].faces
		end

		love.graphics.print(
			"position "..game.pos[1]..","..game.pos[2]..","..game.pos[3].."\n"..
			"rotation "..game.rot[1]..","..game.rot[2].."\n"..
			verts.." verticies\n"..
			faces.." faces",
		0, 0)
	end
end

function love.update(dt)
	if (love.keyboard.isDown("w")) then moveCamera(1, game.speed.pos*dt) end
	if (love.keyboard.isDown("s")) then moveCamera(1, -game.speed.pos*dt) end
	if (love.keyboard.isDown("a")) then game.rot[1] = game.rot[1]+game.speed.rot*dt end
	if (love.keyboard.isDown("d")) then game.rot[1] = game.rot[1]-game.speed.rot*dt end
end

function love.load()
	
	game = {
		debug = true,

		cam = {0,2,-2.5},
		pos = {13.5,0,0},
		rot = {0,0.4},
		speed = {
			pos = 8,
			rot = 4
		},

		scene = {obj.load("obj/track2.obj")},
		kart = {obj.load("obj/kart.obj")}
	}

end