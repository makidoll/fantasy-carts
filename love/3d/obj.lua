obj = {}

function splitGmatch(str, pattern)
	table = {}
	for value in string.gmatch(str, pattern) do
		table[#table+1] = value
	end
	return table
end

function obj.load(filename)
	mesh = {verts={},faces={}}

	data = love.filesystem.read(filename)
	for line in string.gmatch(data, "[^\r\n]+") do
		args = splitGmatch(line, "%S+")
		if (args[1] == "v") then
			mesh["verts"][#mesh["verts"]+1] = {
				tonumber(args[2]),
				tonumber(args[3]),
				tonumber(args[4]),
			}
		elseif (args[1] == "f") then
			face = {}
			for index=2,#args do
				face[#face+1] = tonumber(
					splitGmatch(args[index], "(%d+)/")[1]
				)
			end
			mesh["faces"][#mesh["faces"]+1] = face
		end
	end

	return mesh
end