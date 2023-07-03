extends Sprite

class_name ChooseLevel

@onready var game_controller: World = $"/root/World/GameController"

func _ready():
	game_controller.go_to_level(0)
