extends Control
	
func _on_start_button_pressed() -> void:
	$AnimationPlayer.play("fade_transition")
	await $AnimationPlayer.animation_finished
	get_tree().change_scene_to_file("res://intro_anim/intro.tscn")


func _on_exit_button_pressed() -> void:
	get_tree().quit()
