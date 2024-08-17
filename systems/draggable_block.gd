class_name DraggableBlock extends StaticBody2D

var held := false
var movable := true
var initial_position: int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if held:
		global_position = get_global_mouse_position()
		if Globals.mouse_in_tower_area:
			modulate.a = 1.0
		elif not Globals.mouse_in_tower_area:
			modulate.a = 0.5
	else:
		modulate.a = 1.0

func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.pressed and event.is_action("left_click"):
			Globals.block_clicked.emit(self)
		
func pick_up():
	held = true
	
func drop():
	held = false
	movable = false
