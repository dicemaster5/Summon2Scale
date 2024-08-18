extends Camera2D

@export var follow_target: Node2D
@export var follow_speed: float = 2

@export var move_speed: float = 2

var move_direction: Vector2
var dragging = false

const HEIGHT_CLAMP: Vector2 = Vector2(-10000, 20)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	match Globals.current_gamemode:
		Globals.GAMEMODE.BUILDER:
			camera_movement(delta)
		Globals.GAMEMODE.PLAYER:
			follow_tartget(delta)
		_:
			pass
	position.y = clamp(position.y, HEIGHT_CLAMP.x, HEIGHT_CLAMP.y)

func follow_tartget(delta: float) -> void:
	position = lerp(position, follow_target.global_position, follow_speed * delta)

func camera_movement(delta:float) -> void:
	move_direction.x = Input.get_axis("move_left", "move_right")
	move_direction.y = Input.get_axis("move_up", "move_down")

	position += move_direction * delta * move_speed


# camera drag
func _input(event):
	if Globals.current_gamemode != Globals.GAMEMODE.BUILDER: return
	
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT:
		if event.is_pressed():
			dragging = true
			position_smoothing_enabled = false
		else:
			dragging = false
			position_smoothing_enabled = true
	elif event is InputEventMouseMotion and dragging:
		var diff = event.screen_relative
		position = position - diff
