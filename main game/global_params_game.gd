extends Node

var markers

func save_markers(points: Dictionary, polygons: Dictionary, lines: Dictionary):
	var temp_markers = {}
	
	for id in points.keys():
		var temp_point = {
			"NAME": points[id]["NAME"],
			"SCORE": points[id]["SCORE"]
		}
		temp_markers.get_or_add(id, temp_point)
		
	for id in polygons.keys():
		var temp_polygon = {
			"NAME": polygons[id]["NAME"],
			"SCORE": polygons[id]["SCORE"]
		}
		temp_markers.get_or_add(id, temp_polygon)

	for id in lines.keys():
		var temp_line = {
			"NAME": lines[id]["NAME"],
			"SCORE": lines[id]["SCORE"]
		}
		temp_markers.get_or_add(id, temp_line)
	markers = temp_markers
	
func update_score(id: int, score: int):
	if markers[str(id)]["SCORE"] != null:
		if score > markers[str(id)]["SCORE"]:
			markers[str(id)]["SCORE"] = score
	else:
		markers[str(id)]["SCORE"] = score
