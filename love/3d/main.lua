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


function project(v, p) -- vertex, projection
	v = {
		v[1]*p[1] +  v[2]*p[2] +  v[3]*p[3] +  1*p[4], -- v[4]
		v[1]*p[5] +  v[2]*p[6] +  v[3]*p[7] +  1*p[8], 
		v[1]*p[9] + v[2]*p[10] + v[3]*p[11] + 1*p[12],
		-- 4th value?? 
	}

	return {
		love.graphics.getWidth()/2 + v[1]*camera.scale,
		love.graphics.getHeight()/2 + v[3]*camera.scale,
	}
end

function orthographic(w, h, n, f)
	return {
		2/w, 0, 0, -1,
		0, 2/h, 0, -1,
		0, 0, 2/(f-n), -((f+n)/(f-n)),
		0, 0, 0, 1
	}
end

function orthoTest(v)
	return {
		love.graphics.getWidth()/2 + v[1]*camera.scale,
		love.graphics.getHeight()/2 + v[3]*camera.scale,
	}
end

function rotateCamera(v, r)
	nv = {};
	
	-- rotate in x
	nv[1] = v[1]
	nv[2] = math.cos(r[1])*v[2] + -math.sin(r[1])*v[3]
	nv[3] = math.sin(r[1])*v[2] +  math.cos(r[1])*v[3]
	v = nv
	
	-- rotate in y
	nv[1] =  math.cos(r[2])*v[1] + math.sin(r[2])*v[3]
	nv[2] =  v[2]
	nv[3] = -math.sin(r[2])*v[1] + math.cos(r[2])*v[3]
	v = nv
	
	-- rotate in z
	nv[1] = math.cos(r[3])*v[1] + -math.sin(r[3])*v[2]
	nv[2] = math.sin(r[3])*v[1] +  math.cos(r[3])*v[2]
	nv[3] = v[3]
	v = nv
	
	return v
end

function love.draw()

	for _, mesh in pairs(scene) do
		-- 3d projecting vertecies to points
		mesh.points = {}
		for i, vertex in pairs(mesh.verts) do
			mesh.points[i] = 
				orthoTest(
					rotateCamera(vertex, camera.rotation),
					camera.projection
				)
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

function love.update()

	if (love.keyboard.isDown("left")) then
		camera.rotation[3] = camera.rotation[3]+camera.speed.rotation end
	if (love.keyboard.isDown("right")) then
		camera.rotation[3] = camera.rotation[3]-camera.speed.rotation end
	if (love.keyboard.isDown("down")) then
		camera.rotation[1] = camera.rotation[1]+camera.speed.rotation end
	if (love.keyboard.isDown("up")) then
		camera.rotation[1] = camera.rotation[1]-camera.speed.rotation end

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
		projection = orthographic(
			love.graphics.getWidth(),
			love.graphics.getHeight(),
			0, 32
		),

		scale = 128,
		position = {0, 0, 0},
		rotation = {1.2, 0, 0},

		speed = {
			rotation = 0.08
		}
	}

end