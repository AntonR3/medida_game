extends Node2D

var point = Vector2(1000,1000)

func format_number_for_excel(value: float) -> String:
	return str(value).replace(".", ",")

func _ready():
	print("Name\tPoints")  # Überschrift für Excel

	# --- POLYGONE ---
	for poly in $polygons.get_children():
		if poly is Polygon2D:
			var points = []
			for point in poly.polygon:
				var global_point = poly.global_position + point
				points.append(Vector2(global_point.x, global_point.y))
			print("%s\t%s" % [poly.name, format_vector2_list(points)])

	# --- LINIEN ---
	for line in $lines.get_children():
		if line is Line2D:
			var points = []
			for point in line.points:
				var global_point = line.global_position + point
				points.append(Vector2(global_point.x, global_point.y))
			print("%s\t%s" % [line.name, format_vector2_list(points)])


func format_vector2_list(points: Array) -> String:
	var formatted = "["
	for i in range(points.size()):
		var p = points[i]
		formatted += "(%.1f, %.1f)" % [p.x, p.y]
		if i < points.size() - 1:
			formatted += ", "
	formatted += "]"
	return formatted
	
func get_distance_polygon_point(points: PackedVector2Array, point: Vector2):
	if !Geometry2D.is_point_in_polygon(point, points):
		var min_dist = INF
		var closest_point = point
		for i in range(points.size()):
			var p1 = points[i]
			var p2 = points[(i + 1) % (points.size() - 1)]
			
			var closest = Geometry2D.get_closest_point_to_segment(point, p1, p2)
			var dist = closest.distance_to(point)
			
			if dist < min_dist:
				min_dist = dist
				closest_point = closest
		return [min_dist,closest_point]
	else:
		return [0,point]

func get_distance_line_point(points: PackedVector2Array, point: Vector2):
	var min_dist = INF
	var closest_point = point
	for i in range(points.size() - 1 ):
		var p1 = points[i]
		var p2 = points[(i + 1)]
		
		var closest = Geometry2D.get_closest_point_to_segment(point, p1, p2)
		var dist = closest.distance_to(point)
		
		if dist < min_dist:
			min_dist = dist
			closest_point = closest
	return [min_dist,closest_point]
	
func parse_vector2_list(input: String) -> PackedVector2Array:
	var vectors = PackedVector2Array()
	# Entferne unnötige Zeichen und splitte an den Klammern
	var cleaned = input.replace(" ", "").replace("[", "").replace("]", "")
	var tuples = cleaned.split("),(", false)
	
	for tuple in tuples:
		# Entferne eventuelle verbleibende Klammern
		var clean_tuple = tuple.replace("(", "").replace(")", "")
		# Teile in X und Y Komponenten
		var components = clean_tuple.split(",", false)
		
		if components.size() == 2:
			var x = components[0].to_float()
			var y = components[1].to_float()
			vectors.append(Vector2(x, y))
		else:
			push_error("Ungültiges Tupel: " + tuple)
	return vectors
