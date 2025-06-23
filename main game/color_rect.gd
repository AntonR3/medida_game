extends ColorRect

func _process(delta):
	if randi() % 80 == 0:
		var tween = get_tree().create_tween()
		tween.tween_property(self, "modulate", Color("bdffff"), 0.2)
	else:
		modulate = Color(1,1,1,1)
	
