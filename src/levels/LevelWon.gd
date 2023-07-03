extends Node2D

class_name LevelWon

@onready var game_controller: World = $"/root/World"
@onready var score = $"VBoxContainer/score/stars"

func _ready():
	$VBoxContainer.size.x = ProjectSettings.get_setting("display/window/size/viewport_width")

func set_stars(star_count: int):
	call_deferred("_set_stars", star_count)

func _set_stars(star_count: int):
	score.set_frame(star_count)

func _notification(what):
	if what == NOTIFICATION_WM_CLOSE_REQUEST || what == NOTIFICATION_WM_GO_BACK_REQUEST: 
		game_controller.go_to_main_menu()

func _on_next_level_pressed():
	game_controller.next_level()

func _on_main_menu_pressed():
	game_controller.go_to_main_menu()

func _on_quit_pressed():
	get_tree().quit()

func _on_retry_level_pressed():
	game_controller.repeat_level()
