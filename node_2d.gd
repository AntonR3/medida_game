extends Node2D

# Preload the Marker scene
const MarkerScene = preload("res://marker.tscn")

var canvaslayer: CanvasLayer

func _ready():
	#create_edge_containers()
	#spawn_initial_markers()
	pass

func create_edge_containers():
	var screen_size = get_viewport_rect().size
	var vert_size = Vector2(screen_size.x * 0.1, screen_size.y * 0.6)
	var hor_size = Vector2(vert_size.y, vert_size.x)
	
	# Container für alle Ränder
	var edge_container = CanvasLayer.new()
	add_child(edge_container)
	
	# Erstelle 4 Container an den Bildschirmrändern
	var edges = {
		"left": ColorRect.new(),
		"right": ColorRect.new(),
		"top": ColorRect.new(),
		"bottom": ColorRect.new()
	}
	
	for edge in edges.values():
		edge.color = Color(0.2, 0.2, 0.2, 0.7)  # Dunkle Transparente Farbe
	
	# Positionierung
	edges["left"].position = Vector2(5, screen_size.y/2 - vert_size.y/2)
	edges["left"].size = vert_size
	edges["right"].position = Vector2(screen_size.x - vert_size.x - 5, screen_size.y/2 - vert_size.y/2)
	edges["right"].size = vert_size
	edges["top"].position = Vector2(screen_size.x/2 - hor_size.x/2, 5)
	edges["top"].size = hor_size
	edges["bottom"].position = Vector2(screen_size.x/2 - hor_size.x/2, screen_size.y - hor_size.y - 5)
	edges["bottom"].size = hor_size
	
	for edge in edges.values():
		edge_container.add_child(edge)
	canvaslayer = edge_container

func spawn_initial_markers():
	# Hole alle Edge-Container
	var containers = canvaslayer.get_children()
	
	for container in containers:
		if container.size.x > container.size.y:
			var spacing = container.size.x / 4
			for i in range (1,4,1):
				var new_marker = MarkerScene.instantiate()
				container.add_child(new_marker)
				new_marker.set_original_position(Vector2(i * spacing, container.size.y/2))
		else:
			var spacing = container.size.y / 4
			for i in range (1,4,1):
				var new_marker = MarkerScene.instantiate()
				container.add_child(new_marker)
				new_marker.set_original_position(Vector2(container.size.x/2, i * spacing))
