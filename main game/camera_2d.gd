extends Camera2D

# Einstellungen
@export var map_sprite: TextureRect
const MIN_ZOOM: float = 0.1
const MAX_ZOOM: float = 5.0
const ZOOM_RATE: float = 10.0
const ZOOM_INCREMENT: float = 0.1

var dragging = false

var _target_zoom: float = 1.0

func _ready() -> void:
	set_physics_process(false)
	
func _physics_process(delta: float) -> void:
	zoom = lerp(zoom, _target_zoom * Vector2.ONE, ZOOM_RATE * delta)
	set_physics_process(not is_equal_approx(zoom.x, _target_zoom))


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

func zoom_in() -> void:
	_target_zoom = max(_target_zoom - ZOOM_INCREMENT, MIN_ZOOM)
	set_physics_process(true)


func zoom_out() -> void:
	_target_zoom = min(_target_zoom + ZOOM_INCREMENT, MAX_ZOOM)
	set_physics_process(true)


func focus_position(target_position: Vector2) -> void:
	var _tween = get_tree().create_tween()
	_tween.tween_property(self, "position", target_position, 0.5).set_trans(Tween.TRANS_EXPO)
	
	
func _clamp_camera_position() -> void:
	if !map_sprite || !map_sprite.texture:
		return

	var map_rect: Rect2 = map_sprite.get_global_rect()
	
	var vp_size_px: Vector2 = get_viewport_rect().size
	var view_size: Vector2 = vp_size_px * zoom
	var half: Vector2 = view_size * 0.5

	var min_x = map_rect.position.x + half.x
	var max_x = map_rect.position.x + map_rect.size.x - half.x
	var min_y = map_rect.position.y + half.y
	var max_y = map_rect.position.y + map_rect.size.y - half.y

	if max_x <= min_x: 
		min_x = map_rect.position.x + map_rect.size.x * 0.5
		max_x = min_x
	if max_y <= min_y:
		min_y = map_rect.position.y + map_rect.size.y * 0.5
		max_y = min_y
		
	position.x = clamp(global_position.x, min_x, max_x)
	position.y = clamp(global_position.y, min_y, max_y)
