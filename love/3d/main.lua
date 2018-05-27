require("obj")

function createTri(size)
	s = size/2
	return {
		verts = {
			{ 0, 0,  s},
			{-s, 0, -s},
			{ s, 0, -s},
		},
		faces = {
			{1, 2, 3}
		}
	}
end

function project(v)
	z = v[3]+5 -- near
	if (z < camera.position[3]) then
		return nil
	else 
		f = (love.graphics.getHeight()/2)/z

		return {
			love.graphics.getWidth()/2+v[1]*f,
			love.graphics.getHeight()/2+v[2]*f
		}
	end
end

-- function rotateCamera(v, r)
-- 	nv = {};
	
-- 	-- rotate in x
-- 	nv[1] = v[1]
-- 	nv[2] = math.cos(r[1])*v[2] + -math.sin(r[1])*v[3]
-- 	nv[3] = math.sin(r[1])*v[2] +  math.cos(r[1])*v[3]
-- 	v = nv
	
-- 	-- rotate in y
-- 	nv[1] =  math.cos(r[2])*v[1] + math.sin(r[2])*v[3]
-- 	nv[2] =  v[2]
-- 	nv[3] = -math.sin(r[2])*v[1] + math.cos(r[2])*v[3]
-- 	v = nv
	
-- 	-- rotate in z
-- 	nv[1] = math.cos(r[3])*v[1] + -math.sin(r[3])*v[2]
-- 	nv[2] = math.sin(r[3])*v[1] +  math.cos(r[3])*v[2]
-- 	nv[3] = v[3]
-- 	v = nv
	
-- 	return v
-- end


function rotate(p, r)
	return {
		p[1]*math.cos(r) - p[2]*math.sin(r),
		p[2]*math.cos(r) + p[1]*math.sin(r)
	}
end

function love.draw()

	for _, mesh in pairs(scene) do
		-- 3d projecting vertecies to points
		mesh.points = {}
		for i, vertex in pairs(mesh.verts) do
			v = {
				vertex[1]+camera.position[1],
				vertex[2]+camera.position[2],
				vertex[3]+camera.position[3]
			}

			yaw = rotate({v[1],v[3]}, camera.rotation[2])
			v[1] = yaw[1]
			v[3] = yaw[2]

			pitch = rotate({v[2],v[3]}, camera.rotation[1])
			v[2] = pitch[1]
			v[3] = pitch[2]

			mesh.points[i] = project(v)
			--print(mesh.points[i][1]..", "..mesh.points[i][2])
		end

		-- rendering faces
		for i, face in pairs(mesh.faces) do
			shape = {}
			for _, vertex in pairs(face) do
				if (mesh.points[vertex] ~= nil) then
					shape[#shape+1] = mesh.points[vertex][1]
					shape[#shape+1] = mesh.points[vertex][2]
				end
			end

			love.graphics.setColor(
				mesh["faceColor"][i][1],
				mesh["faceColor"][i][2],
				mesh["faceColor"][i][3], 256)
			love.graphics.polygon("fill", shape)
		end
	end

end

function love.update(dt)

	if (love.keyboard.isDown("left")) then
		camera.rotation[2] = camera.rotation[2]+camera.speed.rotation*dt end
	if (love.keyboard.isDown("right")) then
		camera.rotation[2] = camera.rotation[2]-camera.speed.rotation*dt end
	if (love.keyboard.isDown("down")) then
		camera.rotation[1] = camera.rotation[1]+camera.speed.rotation*dt end
	if (love.keyboard.isDown("up")) then
		camera.rotation[1] = camera.rotation[1]-camera.speed.rotation*dt end

	if (love.keyboard.isDown("w")) then
		camera.position[3] = camera.position[3] - camera.speed.position*dt end
	if (love.keyboard.isDown("s")) then
		camera.position[3] = camera.position[3] + camera.speed.position*dt end
	if (love.keyboard.isDown("a")) then
		camera.position[1] = camera.position[1] + camera.speed.position*dt end
	if (love.keyboard.isDown("d")) then
		camera.position[1] = camera.position[1] - camera.speed.position*dt end

end

function love.load()

	scene = {
		obj.load("kot.obj"),
	}

	-- give every mesh's face a random colour
	for _, mesh in pairs(scene) do
		mesh["faceColor"] = {}
		for i, _ in pairs(mesh["faces"]) do
			mesh["faceColor"][i] = {
				love.math.random(),
				love.math.random(),
				love.math.random()
			}
		end 
	end

	camera = {
		position = {0, 0, 0},
		rotation = {0, 0, 0},

		speed = {
			position = 12,
			rotation = 0.08
		}
	}

end