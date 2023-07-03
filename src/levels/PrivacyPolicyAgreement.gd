extends Node2D

@onready var play_game_button = $"VBoxContainer/play"
@onready var main_level: PackedScene = preload("res://world.tscn")

var policy_version = 1.0

var privacy_policy_file: String = "user://accepted_policy.save"

func _ready():
	if FileAccess.file_exists(privacy_policy_file):
		var file = FileAccess.open(privacy_policy_file, FileAccess.READ)
		var currentVersion: float = file.get_float()
		if currentVersion == policy_version: 
			call_deferred("_on_play_pressed")
	
	$VBoxContainer.size.x = ProjectSettings.get_setting("display/window/size/viewport_width")

func _on_PrivacyAgreement_pressed():
	OS.shell_open(($VBoxContainer/PrivacyAgreement as LinkButton).uri)

func _on_play_pressed():
	var file = FileAccess.open(privacy_policy_file, FileAccess.WRITE)
	file.store_float(policy_version)
	
	var root = get_tree().get_root()
	# Remove the current level
	var level = get_node("/root/PrivacyPolicy")
	root.remove_child(level)
	level.call_deferred("free")
	
	# Add the next level
	var next_level = main_level.instantiate()
	root.add_child(next_level)
