extends Node

var markers: Dictionary
var open_markers: Array


func setup(dict: Dictionary):
		markers = dict
		for marker in markers:
			open_markers.append(marker)
	
func parse_marker_data_from_json(id, json_data: Dictionary):
	pass
