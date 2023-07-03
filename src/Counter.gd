extends Node2D

class_name Counter

var should_hide = false

@onready var singleDigit = get_node("SingleDigit")
@onready var firstDigit = get_node("FirstDigit")
@onready var secondDigit = get_node("SecondDigit")

func _ready():
	singleDigit.visible = false
	firstDigit.visible = false
	secondDigit.visible = false
	
func hide_counter():
	should_hide = true
	singleDigit.visible = false
	firstDigit.visible = false
	secondDigit.visible = false

func set_scale_counter(x, y):
	self.scale = Vector2(x, y)

func set_counter(val):
	if should_hide:
		return
	if val < 10:
		singleDigit.visible = true
		firstDigit.visible = false
		secondDigit.visible = false
		singleDigit.set_frame(val)
		return
	singleDigit.visible = false
	firstDigit.visible = true
	secondDigit.visible = true
	firstDigit.set_frame(int(val/10))
	secondDigit.set_frame(int(val % 10))
