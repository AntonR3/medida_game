extends Control

var mouse_in = false
var is_inside_container = false
var body_ref: Node
var offset: Vector2
var initialPos: Vector2

var original_scale: Vector2
var original_position: Vector2
var original_container
var is_dragging := false

func _ready() -> void:
	original_scale = scale
	# WICHTIG: Eingabeverarbeitung aktivieren
	mouse_filter = Control.MOUSE_FILTER_STOP

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			initialPos = position
			offset = get_local_mouse_position() - position
			is_dragging = true
			z_index = 10  # Marker nach vorne bringen
			accept_event()
		else:
			is_dragging = false
			z_index = 0
			accept_event()
	
	elif event is InputEventMouseMotion and is_dragging:
		position = get_local_mouse_position() - offset
		accept_event()

func _notification(what: int) -> void:
	if what == NOTIFICATION_MOUSE_ENTER:
		mouse_in = true
		var tween = get_tree().create_tween()
		tween.tween_property(self, "scale", original_scale * 1.1, 0.2).set_trans(Tween.TRANS_SINE)
	
	elif what == NOTIFICATION_MOUSE_EXIT:
		mouse_in = false
		var tween = get_tree().create_tween()
		tween.tween_property(self, "scale", original_scale, 0.2).set_trans(Tween.TRANS_SINE)

func set_original_position(pos: Vector2) -> void:
	original_position = pos

func set_original_container(container: Control) -> void:
	original_container = container
