extends StaticBody2D

class_name Bubble

var small_size: float = 64.0
var normal_size: float = 96.0
var big_size: float = 144.0
var giant_size: float = 216.0
var enormous_size: float = 324.0
var actual_size: float = 0.0

enum BUBBLE_SIZE{
	small,
	normal,
	big,
	giant,
	enormous
}

enum BUBBLE_CONTENT{
	extra_ball,
	blue_ball,
	green_ball,
	red_ball,
	purple_ball
}

@export var size: BUBBLE_SIZE = BUBBLE_SIZE.normal
@export var content_type: BUBBLE_CONTENT = BUBBLE_CONTENT.blue_ball
@export var hit_count: int = 9
@export var retrieve_content = false
@export var show_counter = true

@onready var bubble: AnimatedSprite2D = $Bubble
@onready var content: Node2D = $Content
@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var counter: Counter = $Counter

@onready var game_controller: World = $"/root/World"
@onready var bubble_burst_animation: PackedScene = preload("res://game_animations/bubble_burst.tscn")

func _ready():
	content.visible = true
	var shape: CircleShape2D = CircleShape2D.new()
	if size == BUBBLE_SIZE.small:
		bubble.set_frame(0)
		shape.radius = 29.5
		actual_size = small_size
		counter.set_scale_counter(0.1, 0.1)
		content.scale = Vector2(0.1, 0.1)
	if size == BUBBLE_SIZE.normal:
		bubble.set_frame(1)
		shape.radius = 42.5
		actual_size = normal_size
		counter.set_scale_counter(0.25, 0.25)
		content.scale = Vector2(0.2, 0.2)
	if size == BUBBLE_SIZE.big:
		bubble.set_frame(2)
		shape.radius = 64
		actual_size = big_size
		counter.set_scale_counter(0.3, 0.3)
		content.scale = Vector2(0.3, 0.3)
	if size == BUBBLE_SIZE.giant:
		bubble.set_frame(3)
		shape.radius = 96.5
		actual_size = giant_size
		counter.set_scale_counter(0.5, 0.5)
		content.scale = Vector2(0.5, 0.5)
	if size == BUBBLE_SIZE.enormous:
		bubble.set_frame(4)
		shape.radius = 142.5
		actual_size = enormous_size
		counter.set_scale_counter(0.8, 0.8)
		content.scale = Vector2(0.8, 0.8)
	collision_shape.shape = shape
	
	if content_type == BUBBLE_CONTENT.extra_ball:
		content.set_frame(0)
	if content_type == BUBBLE_CONTENT.blue_ball:
		content.set_frame(1)
	if content_type == BUBBLE_CONTENT.green_ball:
		content.set_frame(2)
	if content_type == BUBBLE_CONTENT.red_ball:
		content.set_frame(3)
	if content_type == BUBBLE_CONTENT.purple_ball:
		content.set_frame(4)
	
	game_controller.balls_died.connect(balls_died)
	self.scale = Vector2(0.0, 0.0)
	var tween: Tween = create_tween()
	tween.tween_property(self, "scale", Vector2(1.0,1.0), 0.5).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_LINEAR)
	tween.play()
	self.add_to_group("blocks")
	counter.set_counter(hit_count)
	if !show_counter:
		counter.hide_counter()
	
func _physics_process(_delta):
	if self.position.y < game_controller.game_over_line_pos_y:
		game_controller.on_bubble_above_line()
		queue_free()

func balls_died() -> void:
	var new_pos: Vector2 = self.position
	new_pos.y -= game_controller.float_speed
	var tween: Tween = create_tween()
	tween.tween_property(self, "position", new_pos, 0.5).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_LINEAR)
	tween.play()
	
func hit(_ball: Ball) -> void:
	if(OS.has_feature("editor")):
		print("bubble hit ball called")
	hit_count -= 1
	if hit_count > 0:
		counter.set_counter(hit_count)
		return
	var bba: BubbleBurst = bubble_burst_animation.instantiate()
	get_tree().get_root().add_child(bba)
	bba.animate_on(self.position, actual_size)
	if content_type == BUBBLE_CONTENT.extra_ball:
		game_controller.extra_ball()
	if retrieve_content:
		counter.queue_free()
		collision_shape.queue_free()
		_move_contents_from_to(content.position, game_controller.get_ball_generator().position - self.position)
	else:
		queue_free()
	bubble.visible = false
	
func _move_contents_from_to(start: Vector2, end: Vector2) -> void:
	var time = 0.5
	
	content.position = start
	content.modulate = Color(1, 1, 1, 1)
	var pos_tween: Tween = create_tween()
	pos_tween.tween_property(content, "position", end, time).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
	var modulate_tween: Tween = create_tween()
	modulate_tween.tween_property(content, "modulate", Color(1, 1, 1, 0.7), time).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_QUINT)
	var scale_tween: Tween = create_tween()
	scale_tween.tween_property(content, "scale", Vector2(content.scale.x/3,content.scale.y/3), time).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_QUINT)
	
	pos_tween.tween_callback(queue_free)
	pos_tween.play()
	modulate_tween.play()
	scale_tween.play()
