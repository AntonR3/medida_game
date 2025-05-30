extends Control

signal marker_placed(pos: Vector2, data: Vector2)

func _can_drop_data(at_position, data):
	return data.item_id == "marker"

func _drop_data(at_position, data):
	print("data in map:", data["data"])
	var component = TextureRect.new()
	component.texture = load("res://marker.png")
	component.position = at_position - (component.texture.get_size() * Vector2(1,2))
	component.size *= 2
	add_child(component)
	emit_signal("marker_placed", at_position, data["data"])
