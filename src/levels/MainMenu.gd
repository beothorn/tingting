extends Node2D

class_name MainMenu

@onready var game_controller: World = get_node("/root/World")

func _ready():
	$VBoxContainer.size.x = ProjectSettings.get_setting("display/window/size/viewport_width")

func _on_QuitBtn_pressed():
	get_tree().quit()

func _on_ChooseLevelBtn_pressed():
	game_controller.go_to_level_selection()
