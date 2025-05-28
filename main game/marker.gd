extends CharacterBody2D

var original_scale: Vector2
var original_position: Vector2

var original_container: StaticBody2D

var draggingDistance
var dir
var dragging
var newPosition = Vector2()

var mouse_in = false
var inside_container = false

func _ready():
	original_scale = scale
	original_container = get_parent() as StaticBody2D
	pass
	
	
func _input(event):
	if event is InputEventMouseButton:
		if event.is_pressed() && mouse_in:
			draggingDistance = position.distance_to(get_global_mouse_position())
			dir = (get_global_mouse_position() - position).normalized()
			dragging = true
			newPosition = get_global_mouse_position() - draggingDistance * dir
			get_viewport().set_input_as_handled()
		else:
			dragging = false
			
	elif event is InputEventMouseMotion:
		if dragging:
			newPosition = get_global_mouse_position() - draggingDistance * dir
			get_viewport().set_input_as_handled()

func _physics_process(delta):
	if dragging:
		velocity = (newPosition - position) * Vector2(30, 30)
		move_and_slide()
		
func _on_mouse_entered():
	mouse_in = true
	var tween = get_tree().create_tween()
	tween.tween_property(self, "scale", original_scale * 1.1, 0.2).set_trans(Tween.TRANS_SINE)

func _on_mouse_exited():
	mouse_in = false
	var tween = get_tree().create_tween()
	tween.tween_property(self, "scale", original_scale, 0.2).set_trans(Tween.TRANS_SINE)
	
func set_original_position(pos: Vector2) -> void:
	position = pos
	original_position = pos
