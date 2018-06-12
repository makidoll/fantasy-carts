obj = {}

function split(str, sep)
	local arr = {""}
	local arrI = 1

	for i=1,#str do
		local chr = str:sub(i,i)

		if (chr==sep) then
			arrI = arrI+1
			arr[arrI] = ""
		else
			arr[arrI] = arr[arrI]..chr
		end
	end

	return arr
end

function obj.load(filename)
	local mesh, err = love.filesystem.read(filename)
	if (mesh==nil) then print(err) end

	local verts = {}
	local faces = {}

	-- each line
	mesh = split(mesh, "\n")
	for i=1,#mesh do
		local args = split(mesh[i], " ")

		if (args[1] == "v") then -- vertex
			table.insert(verts, {
				args[2], args[3], args[4]
			})
		elseif (args[1] == "f") then -- face
			face = {}
			for j=2,#args do
				table.insert(face, args[j])
			end
			table.insert(faces, face)
		end
	end

	-- for i=1,#verts do
	-- 	print(i..": "..verts[i][1]..","..verts[i][2]..","..verts[i][3])
	-- end

	-- local out = ""
	-- for i=1,#faces do
	-- 	local text = "f:"
	-- 	for j=1,#faces[i] do
	-- 		print(faces[i][j])
	-- 		text = text..faces[i][j]..","
	-- 	end
	-- 	out = out..text.."\n"
	-- end
	-- print(out)

	return {verts=verts,faces=faces}
end