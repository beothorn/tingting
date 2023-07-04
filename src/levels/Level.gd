extends Node

class_name Level

@export var best_score = 10
@export var average_score = 20

@onready var game_controller: World = $"/root/World"
@onready var ball_gen: BallGenerator = $BallGenerator
@onready var background: Node2D = $Background

var try_count: int = 0

func on_ball_generation() -> void:
	try_count += 1

func _ready():
	game_controller.on_start_level(ball_gen)
	game_controller.connect("balls_died", balls_died)

func _notification(what):
	if what == NOTIFICATION_WM_GO_BACK_REQUEST: 
		game_controller.go_to_level_selection()

func _input(ev):
	if ev is InputEventKey:
		var iek: InputEventKey = ev 
		if iek.keycode == KEY_ESCAPE:
			game_controller.go_to_level_selection()

func init_level(w: World):
	print("DRAW")
	w.draw.connect(draw_line)
	#w.draw_line(Vector2(0,w.game_over_line_pos_y), Vector2(screen_width, w.game_over_line_pos_y), Color(100, 100, 100), 4)

func draw_line(w):
	var screen_width = ProjectSettings.get_setting("display/window/size/viewport_width")
	w.draw_line(Vector2(0,w.game_over_line_pos_y), Vector2(screen_width, w.game_over_line_pos_y), Color(100, 100, 100), 4)

func balls_died() -> void:
	var new_pos: Vector2 = background.position
	new_pos.y -= game_controller.float_speed
	var tween: Tween = create_tween()
	tween.tween_property(background, "position", new_pos, 0.5).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_LINEAR)
	tween.play()
