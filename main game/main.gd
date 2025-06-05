extends Control

var points: Dictionary
var polygons: Dictionary
var lines: Dictionary

var open_points: Array
var open_polygons: Array
var open_lines: Array

var json_path_points = "res://data/medida_game_data_points.json"
var json_path_polygons = "res://data/medida_game_data_polygons.json"
var json_path_lines = "res://data/medida_game_data_lines.json"

func _ready() -> void:
	initial_setup()
	
func initial_setup():
	randomize()
	setup_markers_open_markers()
	fill_containers()
	$Score.hide()
	
func setup_markers_open_markers():
	var points_string = FileAccess.get_file_as_string(json_path_points)
	var polygons_string = FileAccess.get_file_as_string(json_path_polygons)
	var lines_string = FileAccess.get_file_as_string(json_path_lines)
	
	var points_json
	var polygons_json
	var lines_json
	
	if  points_string != null && polygons_string != null && lines_string != null:
		points_json = JSON.parse_string(points_string)
		polygons_json = JSON.parse_string(polygons_string)
		lines_json = JSON.parse_string(lines_string)
	else:
		push_warning("load_json_data_from_path; failed get_file_as_string for a path")
		
	if points_json == null || polygons_json == null || lines_json == null:
		push_error("load_json_data_from_path failed to parse file data to JSON")
		
	points = points_json
	polygons = polygons_json
	lines = lines_json
	
	for point in points:
		open_points.append(point)
	for polygon in polygons:
		open_polygons.append(polygon)
	for line in lines:
		open_lines.append(line)
	
func fill_containers():
	for child in get_node("Control").get_children():
		var number = randi_range(1,3)
		match number:
			1:
				var point = open_points.pick_random()
				open_points.erase(point)
				child.set_text(points[point]["NAME"], int(point))
				print(points[point]["NAME"])
				print("of points")
			2:
				var polygon = open_polygons.pick_random()
				#open_polygons.erase(polygon)
				child.set_text(polygons[polygon]["NAME"], int(polygon))
				print(polygons[polygon]["NAME"])
				print("of polygons")
			3:
				var line = open_lines.pick_random()
				#open_lines.erase(line)
				child.set_text(lines[line]["NAME"], int(line))
				print(lines[line]["NAME"])
				print("of lines")
			_:
				print("something went wrong")
				push_error("wrong number has been generated randomly (not 1-3)")

func _on_marker_placed(pos: Vector2, data: Vector2) -> void:
	var container_id = int(data.x)
	var marker_id = int(data.y)
	
	var correct_tuple
	
	var correct_pos
	var dist
	
	if marker_id <= 3:
		correct_pos = Vector2(points[str(marker_id)]["POSITION_X"], points[str(marker_id)]["POSITION_Y"])
		dist = int(pos.distance_to(correct_pos))
	elif marker_id == 4:
		correct_tuple = get_distance_polygon_point(parse_vector2_list(polygons[str(marker_id)]["POINTS"]), pos)
		correct_pos = correct_tuple[1]
		dist = int(correct_tuple[0])
	elif marker_id == 5:
		correct_tuple = get_distance_line_point(parse_vector2_list(lines[str(marker_id)]["POINTS"]), pos)
		correct_pos = correct_tuple[1]
		dist = int(correct_tuple[0])
	else:
		push_error("marker not found in dictionaries")
	set_dist_score(str(dist))
	$SubViewPortContainer/SubViewPort/map.drop_correct_marker(correct_pos)
	$SubViewPortContainer/SubViewPort/map.set_correct_pos_line(pos, correct_pos, Color.CRIMSON)

func set_dist_score(dist: String):
	$Score.show()
	var text = "Distanz: " + dist + "Pixel"
	$Score.text = text
	$Node/resetscoretext.start()

func _on_resetscoretext_timeout() -> void:
	$Score.hide()







func get_distance_polygon_point(points: PackedVector2Array, point: Vector2):
	if !Geometry2D.is_point_in_polygon(point, points):
		var min_dist = INF
		var closest_point = point
		for i in range(points.size()):
			var p1 = points[i]
			var p2 = points[(i + 1) % (points.size() - 1)]
			
			var closest = Geometry2D.get_closest_point_to_segment(point, p1, p2)
			var dist = closest.distance_to(point)
			
			if dist < min_dist:
				min_dist = dist
				closest_point = closest
		return [min_dist,closest_point]
	else:
		return [0,point]

func get_distance_line_point(points: PackedVector2Array, point: Vector2):
	var min_dist = INF
	var closest_point = point
	for i in range(points.size() - 1 ):
		var p1 = points[i]
		var p2 = points[(i + 1)]
		
		var closest = Geometry2D.get_closest_point_to_segment(point, p1, p2)
		var dist = closest.distance_to(point)
		
		if dist < min_dist:
			min_dist = dist
			closest_point = closest
	return [min_dist,closest_point]
	
func parse_vector2_list(input: String) -> PackedVector2Array:
	var vectors = PackedVector2Array()
	# Entferne unnötige Zeichen und splitte an den Klammern
	var cleaned = input.replace(" ", "").replace("[", "").replace("]", "")
	var tuples = cleaned.split("),(", false)
	
	for tuple in tuples:
		# Entferne eventuelle verbleibende Klammern
		var clean_tuple = tuple.replace("(", "").replace(")", "")
		# Teile in X und Y Komponenten
		var components = clean_tuple.split(",", false)
		
		if components.size() == 2:
			var x = components[0].to_float()
			var y = components[1].to_float()
			vectors.append(Vector2(x, y))
		else:
			push_error("Ungültiges Tupel: " + tuple)
	return vectors
