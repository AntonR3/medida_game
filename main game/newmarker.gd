extends Control

var mouse_in = false
var is_inside_container = false
var body_ref: Node
var offset: Vector2
var initialPos: Vector2

var original_scale: Vector2
var original_position: Vector2
var original_container

func _ready() -> void:
	original_scale = scale
	mouse_filter = Control.MOUSE_FILTER_PASS

func _process(delta: float) -> void:
	if mouse_in:
		if Input.is_action_just_pressed("click"):
			initialPos = global_position
			offset = get_global_mouse_position() - global_position
			Global.is_dragging = true
		if Input.is_action_pressed("click"):
			global_position = get_global_mouse_position() - offset
		elif Input.is_action_just_released("click"):
			Global.is_dragging = false
			var tween = get_tree().create_tween()
			if is_inside_container:
				tween.tween_property(self,"position", original_position, 0.2).set_ease(Tween.EASE_OUT)
			else:
				pass
		get_viewport().set_input_as_handled()

func _on_area_2d_mouse_entered() -> void:
	mouse_in = true
	var tween = get_tree().create_tween()
	tween.tween_property(self, "scale", original_scale * 1.1, 0.2).set_trans(Tween.TRANS_SINE)


func _on_area_2d_mouse_exited() -> void:
	mouse_in = false
	var tween = get_tree().create_tween()
	tween.tween_property(self, "scale", original_scale, 0.2).set_trans(Tween.TRANS_SINE)


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("dropable"):
		is_inside_container = true
		body.modulate = Color(0.3,0.3,0.3,0.2)
		body_ref = body


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("dropable"):
		is_inside_container = false
		body.modulate = Color(0.2,0.2,0.2,0.2)

func set_original_position(pos: Vector2) -> void:
	original_position = pos

func set_original_container(container: Control) -> void:
	original_container = container
