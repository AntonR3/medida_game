extends Control
	
func _ready() -> void:
	$AnimationPlayer.play("background")
	$VBoxContainer/Collectibles.show()
	$Panel.hide()
	
func _on_start_button_pressed() -> void:
	$AnimationPlayer.play("fade_transition")
	await $AnimationPlayer.animation_finished
	get_tree().change_scene_to_file("res://intro_anim/intro.tscn")


func _on_exit_button_pressed() -> void:
	get_tree().quit()

func show_collectibles():
	$Panel.show()
	var container = $Panel/ScrollContainer/VBoxContainer
	
	for child in container.get_children():
		container.remove_child(child)
	if GlobalParamsGame.markers == null:
		var margin = MarginContainer.new()
		margin.add_theme_constant_override("margin_left", 10)
		margin.add_theme_constant_override("margin_right", 10)
		margin.add_theme_constant_override("margin_top", 10)
		margin.add_theme_constant_override("margin_bottom", 10)
		var text = Label.new()
		text.text = "Noch ist nichts hier..."
		text.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		text.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		margin.add_child(text)
		container.add_child(margin)
	
	else:
		for id in GlobalParamsGame.markers:
			var name = GlobalParamsGame.markers[str(id)]["NAME"]
			var score = GlobalParamsGame.markers[str(id)]["SCORE"]
			
			if score != null:
			
				var item = MarginContainer.new()
				item.add_theme_constant_override("margin_left", 10)
				item.add_theme_constant_override("margin_right", 10)
				item.add_theme_constant_override("margin_top", 5)
				item.add_theme_constant_override("margin_bottom", 5)

				var hbox = HBoxContainer.new()
				
				var label_name = Label.new()
				label_name.text = str(name)
				label_name.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT

				var label_score = ProgressBar.new()
				label_score.min_value = 0
				label_score.max_value = 10
				label_score.value = score
				label_score.fill_mode = 0
				label_score.custom_minimum_size.x = 150
				
				hbox.add_child(label_name)
				hbox.add_child(label_score)
				item.add_child(hbox)
				container.add_child(item)


func _on_collectibles_pressed() -> void:
	show_collectibles()


func _on_exit_collectibles_pressed() -> void:
	$Panel.hide()
