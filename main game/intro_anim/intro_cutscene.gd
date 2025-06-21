extends Node

@onready var main_animation_player = $AnimationPlayer
@onready var alien_animation_player = $AlienAnimationPlayer
@onready var transition_animation_player = $TransitionAnimationPlayer
@onready var tutorial_animation_player = $TutorialAnimationPlayer

var chapter_animations = ["Chapter_01", "Chapter_02", "Chapter_03"]
var current_chapter_index = 0
var dialogue_started = false
var can_skip = true

func _ready():
	main_animation_player.connect("animation_finished", _on_main_animation_finished)
	alien_animation_player.connect("animation_finished", _on_alien_animation_finished)
	start_intro_sequence()
	
func _input(event: InputEvent):
	if can_skip and (event is InputEventKey || event is InputEventMouseButton):
		if event.is_pressed():
			advance_chapter()
	
func start_intro_sequence():
	if current_chapter_index < chapter_animations.size():
		var anim_name = chapter_animations[current_chapter_index]
		main_animation_player.play(anim_name)
		transition_animation_player.play("fade_out")
		await transition_animation_player.animation_finished
		# Starte alien_idle in Chapter_03
		if current_chapter_index == 2:
			if dialogue_started == false:
				can_skip = false
				DialogueManager.show_dialogue_balloon_scene("res://intro_anim/balloon.tscn", load("res://intro_anim/alien_intro.dialogue"), "start")
				dialogue_started = true
			alien_animation_player.play("alien_idle")
			
func _on_main_animation_finished(anim_name):
	main_animation_player.pause()
	transition_animation_player.play("fade_in")
	await transition_animation_player.animation_finished
	if anim_name == chapter_animations[current_chapter_index]:
		if current_chapter_index < chapter_animations.size()-1:
			current_chapter_index += 1
			start_intro_sequence()
		
func advance_chapter():
	if current_chapter_index < chapter_animations.size()-1:
		main_animation_player.stop()
		_on_main_animation_finished(chapter_animations[current_chapter_index])

func trigger_alien_talking():
	alien_animation_player.stop()
	alien_animation_player.play("alien_talking")
	
func start_tutorial_animation():
	tutorial_animation_player.play("pin_tutorial_start")
	
func stop_tutorial_animation():
	tutorial_animation_player.play("pin_tutorial_end")

func _on_alien_animation_finished(anim_name):
	if anim_name == "alien_talking":
		alien_animation_player.play("alien_idle")
		
func start_game():
	transition_animation_player.play("fade_in")
	await transition_animation_player.animation_finished
	get_tree().change_scene_to_file("res://main.tscn")
