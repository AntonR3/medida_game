extends Node2D

var point = Vector2(1000,1000)

func _ready() -> void:
	var polygon_points = parse_vector2_list("[(7929.0, 4151.0), (8355.0, 4160.0), (8407.0, 4079.0),
	 (8253.0, 3764.0), (8325.0, 3770.0), (8337.0, 3742.0), (8308.0, 3676.0), (8165.0, 3635.0), (8066.0, 3680.0), (7904.0, 3628.0)]")
	print(polygon_points)
	print(get_distance_polygon_point(polygon_points, point))
	var line_points = parse_vector2_list("[(7169.0, 2432.0), (7182.0, 2508.0), (7168.0, 2568.0), (7185.0, 2632.0)]")
	print(line_points)
	print(get_distance_line_point(line_points, point))

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
