extends Sprite2D

class_name BallGenerator

@onready var game_controller: World = $"/root/World"

@onready var ball: PackedScene = preload("res://Ball.tscn")
@onready var counter: Counter = get_node("Counter")

@export var ball_index: int = 1
@export var ball_qnt: int = 1

var timescale_set_radius = 200
var max_timescale: float = 2.0

enum GEN_STATE{
	idle,
	aiming,
	generating_balls,
	waiting_balls
}
var state: GEN_STATE = GEN_STATE.idle

var setting_balls_timescale: bool = false

var delta_since_last_gen: float = 0
var gen_interval: float = 0.2
var gen_count: int = 0

var time_passed: int = 0
var half_screen: int = 0

var is_pressed: bool = false
var last_mouse_pos_x: int = 0
var start_touch_x: int = 0

func _ready():
	set_process_input(true)
	self.position = Vector2(55, 55)
	self.scale = Vector2(0, 0)
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2(1.0,1.0), 1.5).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_LINEAR)
	tween.play()
	half_screen = ProjectSettings.get_setting("display/window/size/width") / 2 
	counter.set_counter(ball_qnt)
	counter.set_scale_counter(0.2, 0.2)
	game_controller.update_ball_count.connect(update_counter)
	game_controller.balls_died.connect(balls_died)

func _input(event):
	if event is InputEventMouseButton:
		is_pressed = event.pressed
		if game_controller.can_create_balls():
			if is_pressed:
				_set_state(GEN_STATE.aiming)
				self.position.x = event.position.x
			else: #on release touch
				Engine.time_scale = 1
				if state != GEN_STATE.waiting_balls && !setting_balls_timescale:
					var time = 0.2
					var tween = create_tween()
					tween.tween_property(self, "position:x", event.position.x, time).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_LINEAR)
					tween.tween_callback(start_gen)
					tween.play()
					_set_state(GEN_STATE.waiting_balls)
				#update()
				setting_balls_timescale = false
		else:
			if is_pressed:
				start_touch_x = event.position.x
			else: #on release touch
				Engine.time_scale = 1
				setting_balls_timescale = false
				_set_state(GEN_STATE.waiting_balls)
	if event is InputEventMouseMotion:
		last_mouse_pos_x = event.position.x
		if game_controller.can_create_balls() && is_pressed && !setting_balls_timescale:
			self.position.x = event.position.x
		else:
			if is_pressed:
				setting_balls_timescale = true
				var diff: float = event.position.x - start_touch_x
				if diff > 0:
					if diff < timescale_set_radius:
						Engine.time_scale = (diff/(timescale_set_radius/2.0)) +1
					else:
						Engine.time_scale = max_timescale
				else:
					if diff > -timescale_set_radius:
						Engine.time_scale = (diff/timescale_set_radius) +1
					else:
						Engine.time_scale = 0.01

func balls_died():
	if !is_pressed:
		_set_state(GEN_STATE.idle)

func update_counter():
	counter.set_counter(game_controller.ball_gen_count)

func start_gen():
	get_parent().on_ball_generation()
	delta_since_last_gen = 0
	_set_state(GEN_STATE.generating_balls)
	ball_qnt = game_controller.ball_gen_count
	gen_count = 0

func _set_state(new_state):
	state = new_state

func _draw():
	if game_controller.can_create_balls() && is_pressed && !setting_balls_timescale:
		draw_line(Vector2(self.offset.x, self.offset.y), Vector2(self.offset.x, 5000), Color(100, 100, 100), 4)

func _process(delta):
	if game_controller.can_create_balls():
		time_passed = time_passed + delta
	if state == GEN_STATE.generating_balls:
		delta_since_last_gen = delta_since_last_gen + delta
		if delta_since_last_gen > gen_interval && gen_count < ball_qnt:
			delta_since_last_gen = delta_since_last_gen - gen_interval
			var new_ball: Ball = ball.instantiate()
			new_ball.set_ball(ball_index)
			new_ball.position = self.position
			$"/root/World/current_level".add_child(new_ball)
			gen_count = gen_count + 1
