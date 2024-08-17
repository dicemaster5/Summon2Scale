extends Node

var isMouseOnBlock = false
var isMoving = false
var blockCursor = load("res://assets/cursors/block.png")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("loaded")
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if isMoving:
		self.position = get_viewport().get_mouse_position()

func _input(event: InputEvent) -> void:
	if  event.is_action_pressed("left_click") and isMouseOnBlock:
		isMoving = true
		
	if  event.is_action_released("left_click") and isMoving:
		isMoving = false

func _on_mouse_entered() -> void:
	isMouseOnBlock = true
	
func _on_mouse_exited() -> void:
	isMouseOnBlock = false
