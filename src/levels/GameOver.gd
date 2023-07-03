extends Node2D

class_name GameOver

@onready var game_controller = get_node("/root/World")

func _notification(what):
	if what == NOTIFICATION_WM_CLOSE_REQUEST || what == NOTIFICATION_WM_GO_BACK_REQUEST: 
		game_controller.go_to_main_menu()

func _on_try_again_pressed():
	game_controller.repeat_level()

func _on_main_menu_pressed():
	game_controller.go_to_main_menu()

func _on_quit_pressed():
	get_tree().quit()
