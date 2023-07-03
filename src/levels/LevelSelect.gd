extends Node2D

@onready var game_controller = get_node("/root/World")
@onready var button_icon = preload("res://Bubble/giant_bubble.png")
@onready var button_icon_disabled = preload("res://Bubble/giant_bubble_disabled.png")
@export var levels_per_row = 4

func _ready():
	set_process_input(true) 
	var level_count: int = game_controller.level_count()
	
	var vBox: VBoxContainer  = VBoxContainer.new()
	vBox.theme = preload("res://theme/general_theme.tres")
	vBox.set_position(Vector2(70, 120))
	vBox.set_size(Vector2(button_icon.get_width() * levels_per_row , button_icon.get_height() * (level_count/float(levels_per_row)) ))
	var currentHBox
	
	add_child(vBox)
	
	var title: Label = Label.new()
	title.text = "Select Level"
	title.size_flags_horizontal = Control.SIZE_EXPAND | Control.SIZE_FILL
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	vBox.add_child(title)
	
	for i in level_count:
		if i % levels_per_row == 0:
			currentHBox = HBoxContainer.new()
			currentHBox.size_flags_horizontal = Control.SIZE_EXPAND | Control.SIZE_FILL
			currentHBox.size_flags_vertical = Control.SIZE_EXPAND | Control.SIZE_FILL
			vBox.add_child(currentHBox)
		var button = TextureButton.new()
		button.texture_normal = button_icon
		button.texture_disabled = button_icon_disabled
		
		button.size_flags_horizontal = Control.SIZE_EXPAND | Control.SIZE_FILL
		button.size_flags_vertical = Control.SIZE_EXPAND | Control.SIZE_FILL
		
		button.disabled = game_controller.is_level_locked(i)
		
		var label: Label = Label.new()
		label.text = str(i+1)
		label.set_size(Vector2(button_icon.get_width(), button_icon.get_height()))
		label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		button.add_child(label)
		
		currentHBox.add_child(button)
		button.pressed.connect(_on_level_pressed.bind(i))

func _notification(what):
	if what == NOTIFICATION_WM_GO_BACK_REQUEST: 
		game_controller.go_to_main_menu()

func _input(ev):
	if ev is InputEventKey and ev.scancode == KEY_ESCAPE:
		game_controller.go_to_main_menu()

func _on_level_pressed(level):
	game_controller.go_to_level(level)
