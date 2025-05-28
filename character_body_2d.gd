extends CharacterBody2D

func _on_mouse_entered() -> void:
	scale *= 11/10


func _on_mouse_exited() -> void:
	scale *= 10/11
