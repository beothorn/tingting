extends Node2D

@onready var play_game_button = $"VBoxContainer/play"
@onready var main_level: PackedScene = preload("res://world.tscn")

func _ready():
	if FileAccess.file_exists("user://savegame.save"):
		var file = FileAccess.open("user://savegame.save", FileAccess.READ)
		var currentVersion = file.get_var()
		var last_version_with_privacy_policy_changes = 0.003
		if currentVersion >= last_version_with_privacy_policy_changes: 
			call_deferred("_on_play_pressed")
	
	$VBoxContainer.size.x = ProjectSettings.get_setting("display/window/size/viewport_width")

func _on_PrivacyAgreement_pressed():
	OS.shell_open("http://godotengine.org")

func _on_play_pressed():
	var root = get_tree().get_root()
	# Remove the current level
	var level = get_node("/root/PrivacyPolicy")
	root.remove_child(level)
	level.call_deferred("free")
	
	# Add the next level
	var next_level = main_level.instantiate()
	root.add_child(next_level)
