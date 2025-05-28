extends Camera2D

# Einstellungen
@export var map_sprite: Sprite2D  # Weise dein Sprite2D hier im Editor zu!
var zoom_speed := 0.1
var min_zoom := 0.5
var max_zoom := 10.0
var zoom_level := 1.0
var drag_sensitivity := 1.0

# Touch/Drag-Variablen
var touch_points := {}
var previous_pinch_distance := 0.0
var is_dragging := false

func _ready() -> void:
	zoom = Vector2.ONE * zoom_level

func _input(event: InputEvent) -> void:
	_handle_mouse(event)
	#_handle_touch(event)

func _handle_mouse(event: InputEvent) -> void:
	# Mausrad-Zoom
	if event is InputEventMouseButton:
		match event.button_index:
			4:
				_zoom(1)
			5:
				_zoom(-1)
			1:
				is_dragging = event.pressed

	# Maus-Drag
	elif event is InputEventMouseMotion and is_dragging:
		position -= event.relative * drag_sensitivity / zoom_level
		_clamp_camera_position()

#func _handle_touch(event: InputEvent) -> void:
	## Touch-Punkte verfolgen
	#if event is InputEventScreenTouch:
		#if event.pressed:
			#touch_points[event.index] = event.position
		#else:
			#touch_points.erase(event.index)
		#previous_pinch_distance = 0.0
#
	## Touch-Drag und Pinch-Zoom
	#elif event is InputEventScreenDrag:
		#touch_points[event.index] = event.position
		#
		## Ein-Finger-Drag
		#if touch_points.size() == 1:
			#position -= event.relative * drag_sensitivity / zoom_level
			#_clamp_camera_position()
		#
		## Zwei-Finger-Pinch-Zoom
		#elif touch_points.size() == 2:
			#var points := touch_points.values()
			#var current_distance := points[0].distance_to(points[1])
			#if previous_pinch_distance != 0.0:
				#_zoom((current_distance - previous_pinch_distance) * 0.01)
			#previous_pinch_distance = current_distance

func _zoom(direction: float) -> void:
	# Zoom-Level anpassen
	zoom_level = clamp(zoom_level + direction * zoom_speed, min_zoom, max_zoom)
	zoom = Vector2.ONE * zoom_level
	_clamp_camera_position()  # Position nach Zoom neu begrenzen

func _clamp_camera_position() -> void:
	if !map_sprite || !map_sprite.texture:
		return

	# Berechne die Begrenzungen des Sprites
	var sprite_global_pos = map_sprite.global_position
	var sprite_size = map_sprite.texture.get_size() * map_sprite.scale
	var sprite_rect = Rect2(
		sprite_global_pos - sprite_size / 2,  # Sprite-Links-Oben
		sprite_size                            # Sprite-Größe
	)

	# Sichtbare Bereichsgrenzen der Kamera (abhängig vom Zoom)
	var viewport_size = get_viewport_rect().size
	var visible_half_size = viewport_size / (2 * zoom)

	# Min/Max-Position der Kamera (Mitte darf nicht über den Rand hinaus)
	var min_x = sprite_rect.position.x + visible_half_size.x
	var max_x = sprite_rect.end.x - visible_half_size.x
	var min_y = sprite_rect.position.y + visible_half_size.y
	var max_y = sprite_rect.end.y - visible_half_size.y

	# Clamp-Kamera-Position
	position.x = clamp(position.x, min_x, max_x)
	position.y = clamp(position.y, min_y, max_y)
