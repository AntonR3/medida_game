extends Node

var json_path = "res://data/medida_game_data.json"

func load_json_data_from_path(path: String):
	var file_string = FileAccess.get_file_as_string(path)
	var json_data
	if  file_string != null:
		json_data = JSON.parse_string(file_string)
	else:
		push_warning("load_json_data_from_path; failed get_file_as_string for path: ", path)
		
	if json_data == null:
		push_error("load_json_data_from_path failed to parse file data to JSON for: ", path)
		
	return json_data
