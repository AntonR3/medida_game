extends Camera2D

var boundary = Rect2(0,0,1250,1750)

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
		var new_position = position - event.relative / zoom
		if new_position.x < limit_left || new_position.y > limit_right || new_position.y < limit_top || new_position.y > limit_bottom:
			pass
		else:
			position = new_position
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
	
	var viewport_rect = get_viewport_rect()
	var camera_size = viewport_rect.size / zoom
	var half_cam = camera_size * 0.5
	var minpos = boundary.position + half_cam
	var maxpos = boundary.position + boundary.size - half_cam
	position.x = clamp(position.x, minpos.x, maxpos.x)
	position.y = clamp(position.y, minpos.y, maxpos.y)
