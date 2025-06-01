extends Control

var markers: Dictionary
var open_markers: Array

var json_path = "res://data/medida_game_data.json"

func _ready() -> void:
	randomize()
	setup_markers_open_markers()
	fill_containers()
	$Score.hide()
	
func setup_markers_open_markers():
	var file_string = FileAccess.get_file_as_string(json_path)
	var json_data
	if  file_string != null:
		json_data = JSON.parse_string(file_string)
	else:
		push_warning("load_json_data_from_path; failed get_file_as_string for path: ", json_path)
		
	if json_data == null:
		push_error("load_json_data_from_path failed to parse file data to JSON for: ", json_path)
		
	markers = json_data
	for marker in markers:
		open_markers.append(marker)
	
func fill_containers():
	for child in get_node("Control").get_children():
		var marker = open_markers.pick_random()
		open_markers.erase(marker)
		child.set_text(markers[marker]["NAME"], int(marker))


func _on_marker_placed(pos: Vector2, data: Vector2) -> void:
	var container_id = int(data.x)
	var marker_id = int(data.y)
	var correct_pos = Vector2(markers[str(marker_id)]["POSITION_X"], markers[str(marker_id)]["POSITION_Y"])
	var dist = int(pos.distance_to(correct_pos))
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
