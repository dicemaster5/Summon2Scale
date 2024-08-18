class_name DraggableBlock extends StaticBody2D

@export var movable := true
@export var cobweb := false

var random_rotation: bool = true

var rotatioins: Array[int] = [0, 90, 180, 270]
var held := false

var initial_position: int

# rotate when in block selector
var rotate_direction = 1
const ROTATE_JIGGLE = 0.1
var ROTATE_SPEED = 0.1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if movable:
		var offset_rotation = randf_range(-ROTATE_JIGGLE, ROTATE_JIGGLE)
	
		global_rotation = offset_rotation
		if offset_rotation > 0:
			rotate_direction = -1
		ROTATE_SPEED += randf_range(-0.02, 0.02)

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
		
	# rotate blocks when in selector
	if movable:
		if rotate_direction == -1 and global_rotation <= rotate_direction * ROTATE_JIGGLE:
			rotate_direction *= -1
		elif rotate_direction == 1 and  global_rotation >= rotate_direction * ROTATE_JIGGLE:
			rotate_direction *= -1
		global_rotation += rotate_direction * _delta * ROTATE_SPEED

func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.pressed and event.is_action("left_click"):
			Globals.block_clicked.emit(self)
		
func pick_up():
	held = true
	movable = false

	#if random_rotation:
		#global_rotation_degrees = rotatioins.pick_random()

	var tween = get_tree().create_tween()
	tween.set_ease(Tween.EASE_IN)
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(self,"scale",Vector2(1.3, 1.3),0.025)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(self,"scale",Vector2(1, 1),0.1)
	tween.play()
	
func drop():
	held = false
	if cobweb:
		remove_child(get_child(1))
