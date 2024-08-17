class_name DraggableBlock extends StaticBody2D

var held := false
var movable := true
var mouseHover := false
var initial_position: Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.pressed and event.is_action("left_click"):
			Globals.block_clicked.emit(self)
		
func pick_up():
	held = true
	
func drop():
	held = false

func _mouse_enter() -> void:
	mouseHover = true

func _mouse_exit() -> void:
	mouseHover = false
