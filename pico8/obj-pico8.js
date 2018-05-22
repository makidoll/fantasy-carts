let filename = "cutedragon";

var fs = require("fs");
var pico8 = filename+"={";
var obj = fs.readFileSync(filename+".obj", "utf8").split("\n");

var verts = "";
var edges = "";

for (var i=0; i<obj.length; i++) {
	let line = obj[i].split(" ");
	switch (line[0]) {
		case "v":
			verts += "{"+line[1]+","+line[2]+","+line[3]+"},";
		case "f":
			edges += "{"+ // arrays start at 1 ayy
				line[1].split("/")[0]+","+
				line[2].split("/")[0]+"},";
			edges += "{"+ // arrays start at 1 ayy
				line[2].split("/")[0]+","+
				line[3].split("/")[0]+"},";
			edges += "{"+ // arrays start at 1 ayy
				line[3].split("/")[0]+","+
				line[1].split("/")[0]+"},";
	}
}

pico8 += 
	"verts={"+verts.slice(0, -1)+"},"+
	"edges={"+edges.slice(0, -1)+"}}"

fs.writeFileSync(filename+".lua", pico8)