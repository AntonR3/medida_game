extends MarginContainer

@export var modulation := Color(1, 1, 0.5, 1):
	get:
		return modulation
	set(value):
		modulation = value
		%TextureRect.modulate = value

func _get_drag_data(_position):
	var icon = TextureRect.new()
	var preview = Control.new()
	icon.texture = %TextureRect.texture
	icon.position = icon.texture.get_size() * -0.5
	icon.modulate = modulation
	preview.add_child(icon)
	preview.z_index = 60
	set_drag_preview(preview)
	return { item_id = "marker", modulation = modulation }
	
func _can_drop_data(at_position, data):
	return data.item_id == "marker"

func _drop_data(at_position, data):
	pass

func set_text(text: String):
	$MarginContainer/VBoxContainer/Label.text = text
