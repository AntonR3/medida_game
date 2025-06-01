extends Camera2D

# Einstellungen
@export var map_sprite: TextureRect
const MIN_ZOOM: float = 1.0
const MAX_ZOOM: float = 5.0
const ZOOM_RATE: float = 10.0
const ZOOM_INCREMENT: float = 0.1

var dragging = false

var _target_zoom: float = 1.0

func _ready() -> void:
	zoom = Vector2(1,1)
	set_physics_process(false)
	set_limit(1, 0)
	set_limit(3, 1550)
	set_limit(0, 0)
	set_limit(2, 2325)
	
func _physics_process(delta: float) -> void:
	zoom = lerp(zoom, _target_zoom * Vector2.ONE, ZOOM_RATE * delta)
	set_physics_process(not is_equal_approx(zoom.x, _target_zoom))
	_clamp_camera_position()


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == 5:
			zoom_in()
		if event.button_index == 4:
			zoom_out()
		if event.double_click:
			focus_position(get_global_mouse_position())
		if event.button_index == 1:
			dragging = event.pressed
	elif event is InputEventMouseMotion && dragging:
		position -= event.relative / zoom
		_clamp_camera_position()
		
func zoom_in() -> void:
	_target_zoom = max(_target_zoom - ZOOM_INCREMENT, MIN_ZOOM)
	set_physics_process(true)


func zoom_out() -> void:
	_target_zoom = min(_target_zoom + ZOOM_INCREMENT, MAX_ZOOM)
	set_physics_process(true)


func focus_position(target_position: Vector2) -> void:
	var _tween = get_tree().create_tween()
	_tween.tween_property(self, "position", target_position, 0.5).set_trans(Tween.TRANS_EXPO)
	_clamp_camera_position()
	
	
func _clamp_camera_position() -> void:
	if !map_sprite || !map_sprite.texture:
		return

	position.x = clamp(global_position.x, 576 / zoom.x, 1749 * zoom.x)
	position.y = clamp(global_position.y, 324 / zoom.y, 1126 * zoom.y)
