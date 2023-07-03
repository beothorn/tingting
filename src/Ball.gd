extends RigidBody2D

class_name Ball

@onready var game_controller: World = $"/root/World"
@onready var ball_sprite: AnimatedSprite2D = $BallSprite

var limit_height: int = 0

func _ready():
	self.body_entered.connect(collision)
	limit_height = get_viewport().get_visible_rect().size.y
	game_controller.on_ball_creation()

func collision(body: Node) ->  void:
	if(OS.has_feature("editor")):
		print("ball collision")
	if body.is_in_group("blocks"):
		var bubble: Bubble = body
		bubble.hit(self)
	
func set_ball(ball_index: int) -> void:
	call_deferred("_set_ball", ball_index)

func _set_ball(ball_index: int):
	ball_sprite.set_frame(ball_index)

func die() -> void:
	game_controller.on_ball_dead()
	queue_free()

func _physics_process(_delta):
	if self.position.y > limit_height:
		die()
