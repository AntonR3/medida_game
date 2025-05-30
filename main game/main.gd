extends Control

var markers: Dictionary
var open_markers: Array

var json_path = "res://data/medida_game_data.json"

func _ready() -> void:
	randomize()
	setup_markers_open_markers()
	print(markers)
	print(open_markers)
	fill_containers()
	
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
		print(markers[marker]["NAME"])
	
func fill_containers():
	for child in get_node("Control").get_children():
		var marker = open_markers.pick_random()
		open_markers.erase(marker)
		child.set_text(markers[marker]["NAME"])
