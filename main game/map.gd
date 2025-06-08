extends Control

signal marker_placed(pos: Vector2, data: Vector2)

var should_draw_correction_line: bool = false
var correction_line_start: Vector2
var correction_line_end: Vector2

var should_draw_polygon = false
var polygon_points: PackedVector2Array

var should_draw_line
var line_points: PackedVector2Array


func _draw() -> void:
	if should_draw_correction_line:
		draw_dashed_line(correction_line_start, correction_line_end, Color.CRIMSON, 20, 40, true, true)
	if should_draw_polygon:
		draw_colored_polygon(polygon_points, Color.LIGHT_BLUE)
	if should_draw_line:
		draw_polyline(line_points, Color.LIGHT_BLUE, 15, true)


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

func draw_correction_line(pos1: Vector2, pos2: Vector2):
	correction_line_start = pos1
	correction_line_end = pos2
	should_draw_correction_line = true
	queue_redraw()
	await get_tree().create_timer(2.0).timeout
	hide_correction_line()


func hide_correction_line():
	should_draw_correction_line = false
	queue_redraw()

func draw_correct_polygon(points: PackedVector2Array):
	polygon_points = points
	should_draw_polygon = true
	queue_redraw()
	await get_tree().create_timer(2.0).timeout
	hide_correct_polygon()
	
func hide_correct_polygon():
	should_draw_polygon = false
	queue_redraw()

func draw_correct_line(points: PackedVector2Array):
	line_points = points
	should_draw_line = true
	queue_redraw()
	await get_tree().create_timer(2.0).timeout
	hide_correct_line()
	
func hide_correct_line():
	should_draw_line = false
	queue_redraw()
