extends Camera2D

@export var follow_target: Node2D
@export var follow_speed: float = 2

@export var move_speed: float = 2


var move_direction: Vector2

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

func follow_tartget(delta: float) -> void:
	position = lerp(position, follow_target.global_position, follow_speed * delta)
	position.y = clamp(position.y, -10000, 20)

func camera_movement(delta:float) -> void:
	move_direction.x = Input.get_axis("move_left", "move_right")
	move_direction.y = Input.get_axis("move_up", "move_down")

	position += move_direction * delta * move_speed