class_name DraggableBlock extends StaticBody2D

var held := false
var movable := true
var mouseHover := false
var initial_position: int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if held:
		global_transform.origin = get_global_mouse_position()

func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.pressed and event.is_action("left_click"):
			Globals.block_clicked.emit(self)
		
func pick_up():
	held = true
	
func drop():
	held = false
	movable = false

func _mouse_enter() -> void:
	mouseHover = true

func _mouse_exit() -> void:
	mouseHover = false
