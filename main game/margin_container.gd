extends MarginContainer

@export var number: int
var marker_id: int

func _get_drag_data(_position):
	var icon = TextureRect.new()
	var preview = Control.new()
	var data = Vector2(number, marker_id)
	icon.texture = %TextureRect.texture
	icon.position = icon.texture.get_size() * Vector2(-0.5,-1)
	preview.add_child(icon)
	preview.scale = Vector2.ONE * 0.05
	preview.z_index = 60
	set_drag_preview(preview)
	return { item_id = "marker", data = data }
	
func _can_drop_data(at_position, data):
	return data.item_id == "marker"

func _drop_data(at_position, data):
	pass

func set_text(text: String, id: int):
	marker_id = id
	$MarginContainer/VBoxContainer/Label.text = text

func get_number():
	return number
