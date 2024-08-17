class_name DraggableBlock extends StaticBody2D

var held := false
var movable := true
var initial_position: int

var rotate_direction = 1
const ROTATE_JIGGLE = 0.1
const ROTATE_SPEED = 0.1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var offset_rotation = randf_range(-ROTATE_JIGGLE, ROTATE_JIGGLE)
	global_rotation = offset_rotation
	if offset_rotation > 0:
		rotate_direction = -1
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
		
	# animation
	if movable:
		if rotate_direction == -1 and global_rotation <= rotate_direction * ROTATE_JIGGLE:
			rotate_direction *= -1
		elif rotate_direction == 1 and  global_rotation >= rotate_direction * ROTATE_JIGGLE:
			rotate_direction *= -1
		if initial_position == 0:
			print(global_rotation)
			print("go from", global_rotation)
			print("to", float(rotate_direction * ROTATE_JIGGLE))
			print("by pct", ROTATE_SPEED * _delta)
		global_rotation += rotate_direction * _delta * ROTATE_SPEED

func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.pressed and event.is_action("left_click"):
			Globals.block_clicked.emit(self)
		
func pick_up():
	held = true
	movable = false
	global_rotation = 0
	
func drop():
	held = false
