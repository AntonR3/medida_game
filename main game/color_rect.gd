extends ColorRect

var base_color = color

func _process(delta):
	if randi() % 80 == 0:
		color.a = 0.1
	else:
		color = base_color
	
