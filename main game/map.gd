extends Control

signal marker_placed(pos: Vector2, data: Vector2)

var should_draw_line: bool = false
var line_start: Vector2
var line_end: Vector2
var line_color: Color
func _draw() -> void:
	if should_draw_line:
		draw_dashed_line(line_start, line_end, line_color, 20, 40, true, true)


func _can_drop_data(at_position, data):
	return data.item_id == "marker"

func _drop_data(at_position, data):
	var component = TextureRect.new()
	component.texture = load("res://marker.png")
	component.position = at_position - (component.texture.get_size() * Vector2(1,2))
	component.size *= 2
	add_child(component)
	emit_signal("marker_placed", at_position, data["data"])
	await get_tree().create_timer(2.0).timeout
	remove_child(component)


func drop_correct_marker(pos: Vector2):
	var component = TextureRect.new()
	component.texture = load("res://marker.png")
	component.position = pos - (component.texture.get_size() * Vector2(1,2))
	component.size *= 2
	add_child(component)
	await get_tree().create_timer(2.0).timeout
	remove_child(component)

func set_correct_pos_line(pos1: Vector2, pos2: Vector2, col: Color):
	line_start = pos1
	line_end = pos2
	line_color = col
	should_draw_line = true
	queue_redraw()
	await get_tree().create_timer(2.0).timeout
	hide_line()
	
func hide_line():
	should_draw_line = false
	queue_redraw()
