extends Node2D

class_name World

signal balls_died
signal change_level
signal update_ball_count

var ball_generator: BallGenerator
var screen_width: int = 0 
var balls_count: int = 0
@export var current_level: int = 0
@export var ball_gen_count: int = 1
@export var float_speed: float = 128
@export var game_over_line_pos_y: int = 100

var save_game_file: String = "user://save_game.save"

var levels: Array[PackedScene] = [ preload("res://levels/GameLevels/HelloWorld.tscn"),
	preload("res://levels/GameLevels/HelloWorld2.tscn"),
	preload("res://levels/GameLevels/HelloWorld3.tscn"),
	preload("res://levels/GameLevels/HelloWorld4.tscn"),
	preload("res://levels/GameLevels/LevelWalls.tscn"),
	preload("res://levels/GameLevels/DebugLevel.tscn")
]

var level_enabled: int = 0

var main_menu: PackedScene = preload("res://levels/MainMenu.tscn")
var game_over: PackedScene = preload("res://levels/GameOver.tscn")
var level_select: PackedScene = preload("res://levels/LevelSelect.tscn")
var level_won: PackedScene = preload("res://levels/LevelWon.tscn")

var previous_level: Node

func _ready():
	load_game()
	save_game()
	set_process(true)
	screen_width = ProjectSettings.get_setting("display/window/size/viewport_width")
	_go_to_level(main_menu)

func level_count() -> int:
	return levels.size()

func is_level_locked(level_index) -> bool:
	return level_index > level_enabled

func on_ball_creation():
	balls_count += 1

func can_create_balls() -> bool:
	return balls_count <= 0

func on_ball_dead() -> void:
	if(OS.has_feature("editor")):
		print("on_ball_dead called")
	var block_count: int = get_tree().get_nodes_in_group("blocks").size()
	balls_count -= 1
	if balls_count <= 0:
		emit_signal("balls_died")
		if block_count == 0:
			var best = previous_level.best_score
			var average_score = previous_level.average_score
			var try_count = previous_level.try_count
			unlock_next_level()
			var level_won_instance = _go_to_level(level_won)
			level_won_instance.set_stars(1)
			if(try_count <= average_score):
				level_won_instance.set_stars(2)
			if(try_count <= best):
				level_won_instance.set_stars(3)

func unlock_next_level() -> void:
	var next_level_index = (current_level + 1) % levels.size()
	level_enabled = next_level_index
	save_game()

func save_game():
	var file = FileAccess.open(save_game_file, FileAccess.WRITE)
	file.store_32(level_enabled)

func load_game():
	if FileAccess.file_exists(save_game_file):
		var file = FileAccess.open(save_game_file, FileAccess.READ)
		level_enabled = file.get_32()

func go_to_level(level: int) -> void:
	balls_count = 0
	emit_signal("change_level")
	var new_level = levels[level]
	current_level = level
	_go_to_level(new_level)

func _go_to_level(new_level: PackedScene):
	if previous_level:
		previous_level.queue_free()
	previous_level = new_level.instantiate()
	call_deferred("open_level", previous_level)
	return previous_level

func go_to_level_selection() -> void:
	if(OS.has_feature("editor")):
		print("go_to_level_selection called")
	_go_to_level(level_select)

func go_to_main_menu() -> void:
	if(OS.has_feature("editor")):
		print("go_to_main_menu called")
	_go_to_level(main_menu)

func next_level() -> void:
	if(OS.has_feature("editor")):
		print("next_level called")
	var next_level_index = (current_level + 1) % levels.size()
	go_to_level(next_level_index)

func repeat_level() -> void:
	if(OS.has_feature("editor")):
		print("repeat_level called")
	go_to_level(current_level)

func extra_ball() -> void:
	if(OS.has_feature("editor")):
		print("extra_ball called")
	ball_gen_count += 1
	emit_signal("update_ball_count")

func on_start_level(ball_gen: BallGenerator) -> void:
	ball_gen_count = 1
	ball_generator = ball_gen
	emit_signal("update_ball_count")

func open_level(level: Node) -> void:
	add_child(level)
	if(level is Level):
		level.init_level(self)

func get_ball_generator() -> BallGenerator:
	return ball_generator

func on_bubble_above_line() -> void:
	if(OS.has_feature("editor")):
		print("_go_to_level called")
	_go_to_level(game_over)
