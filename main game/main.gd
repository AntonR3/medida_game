extends Control

#signals used
signal game_end

#variables for game logic
var score: int
var counter: int

#Dictionaries for Markers
var points: Dictionary
var polygons: Dictionary
var lines: Dictionary

#Arrays for not answered Markers
var open_points: Array
var open_polygons: Array
var open_lines: Array

#json paths for parsing
var json_path_points = "res://data/medida_game_data_points.json"
var json_path_polygons = "res://data/medida_game_data_polygons.json"
var json_path_lines = "res://data/medida_game_data_lines.json"

func _ready() -> void:
	initial_setup()
	
func initial_setup():
	randomize()
	setup_markers_open_markers()
	initial_fill_containers()
	$Score_Popup.hide()
	
	score = 0
	$Score_Tracker.text = str(score)
	
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
	
func initial_fill_containers():
	for child in get_node("Control").get_children():
		fill_container(child)

func _on_marker_placed(pos: Vector2, data: Vector2) -> void:
	counter += 1
	print(counter)
	var container_id = int(data.x)
	var marker_id = int(data.y)
	
	var correct_tuple
	
	var correct_pos
	var dist
	
	if marker_id <= 3:
		correct_pos = Vector2(points[str(marker_id)]["POSITION_X"], points[str(marker_id)]["POSITION_Y"])
		dist = int(pos.distance_to(correct_pos))
		$SubViewPortContainer/SubViewPort/map.drop_correct_marker(correct_pos)
		$SubViewPortContainer/SubViewPort/map.draw_correction_line(pos, correct_pos)
	elif marker_id == 4:
		var polygon_points = parse_vector2_list(polygons[str(marker_id)]["POINTS"])
		correct_tuple = get_distance_polygon_point(polygon_points, pos)
		correct_pos = correct_tuple[1]
		dist = int(correct_tuple[0])
		$SubViewPortContainer/SubViewPort/map.draw_correct_polygon(polygon_points)
		$SubViewPortContainer/SubViewPort/map.draw_correction_line(pos, correct_pos)
	elif marker_id == 5:
		var line_points = parse_vector2_list(lines[str(marker_id)]["POINTS"])
		correct_tuple = get_distance_line_point(line_points, pos)
		correct_pos = correct_tuple[1]
		dist = int(correct_tuple[0])
		$SubViewPortContainer/SubViewPort/map.draw_correct_line(line_points)
		$SubViewPortContainer/SubViewPort/map.draw_correction_line(pos, correct_pos)
	else:
		push_error("marker not found in dictionaries")
	var score_update = calc_score(dist)
	set_pop_up_score(str(score_update))
	
	fill_container(get_node("Control").get_container(container_id))
	
	if counter == 10:
		emit_signal("game_end")

func set_pop_up_score(update: String):
	$Score_Popup.show()
	var text
	if counter == 10:
		text = "neue Punkte: " + update +"!" + "\n" + "Spiel wird beendet!"
	else:
		text = "neue Punkte: " + update +"!"
	$Score_Popup.text = text
	$Node/Label_Timer.start()

func calc_score(dist: float) -> int:
	if dist <= 100:
		score += 10
		$Score_Tracker.text = str(score)
		return 10
	elif dist > 300:
		$Score_Tracker.text = str(score)
		return 0
	else:
		score += int(floor((300-dist)/20))
		$Score_Tracker.text = str(score)
		return int(floor((300-dist)/20))



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



func fill_container(container: MarginContainer):
	var retry = true
	while retry == true:
		var number = randi_range(1,3)

		match number:
			1:
				if open_points.is_empty():
					retry = true
				else:
					retry = false
					var point = open_points.pick_random()
					open_points.erase(point)
					container.set_text(points[point]["NAME"], int(point))
			2:
				if open_polygons.is_empty():
					retry = true
				else:
					retry = false
					var polygon = open_polygons.pick_random()
					open_polygons.erase(polygon)
					container.set_text(polygons[polygon]["NAME"], int(polygon))
			3:
				if open_lines.is_empty():
					retry = true
				else:
					retry = false
					var line = open_lines.pick_random()
					open_lines.erase(line)
					container.set_text(lines[line]["NAME"], int(line))
			_:
				print("something went wrong")
				push_error("wrong number has been generated randomly (not 1-3)")
		if open_points.is_empty() && open_polygons.is_empty() && open_lines.is_empty():
			print("No more markers left :(")
			retry = false

func _on_label_timer_timeout() -> void:
	$Score_Popup.hide()

func _on_game_end() -> void:
	#add logic for the end of the game
	#maybe make a scene where 
	await get_tree().create_timer(2.0).timeout
	get_tree().quit(0)
