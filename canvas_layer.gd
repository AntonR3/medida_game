extends CanvasLayer

const MarkerScene = preload("res://newmarker2.tscn")

func _ready() -> void:
	layer = 1
	create_markers()
	
func create_markers() -> void:
	var screensizex = get_viewport().size.x
	var screensizey = get_viewport().size.y
	var width = get_viewport().size.x * 0.4
	var height = get_viewport().size.y * 0.2
	
	for i in 4:
		var container = Control.new()  # Container als Control-Node
		var rect = ColorRect.new()
		var marker = MarkerScene.instantiate()
		
		# Container konfigurieren

		container.custom_minimum_size = Vector2(width, height)
		container.size = Vector2(width, height)
		container.mouse_filter = Control.MOUSE_FILTER_PASS
		
		# ColorRect konfigurieren
		rect.size = Vector2(width, height)
		rect.color = Color(0.2, 0.2, 0.2, 0.7)
		
		# Marker konfigurieren
		marker.position = Vector2(width/2, height/2)  # Zentriert
		
		# Signale verbinden
		rect.connect("mouse_entered", _on_rect_mouse_entered.bind(rect))
		rect.connect("mouse_exited", _on_rect_mouse_exited.bind(rect))
		
		match i:
			0: # Oben
				container.rotation_degrees = 180
				container.position = Vector2(screensizex/2 + width/2, height + 5)
			1: # Unten
				container.position = Vector2(screensizex/2 - width/2, screensizey - height - 5)
			2: # Rechts
				container.rotation_degrees = 270
				container.position = Vector2(screensizex - height - 5, screensizey/2 + width/2)
			3: # Links
				container.rotation_degrees = 90
				container.position = Vector2(height + 5, screensizey/2- width/2)
		
		# Nodes hinzufügen
		container.add_child(rect)
		container.add_child(marker)
		add_child(container)
		
		# Originalposition im Container speichern
		marker.set_original_container(container)
		marker.set_original_position(marker.position)

func _on_rect_mouse_entered(rect: ColorRect) -> void:
	rect.color = Color(0.3, 0.3, 0.3, 0.7)

func _on_rect_mouse_exited(rect: ColorRect) -> void:
	rect.color = Color(0.2, 0.2, 0.2, 0.7)
