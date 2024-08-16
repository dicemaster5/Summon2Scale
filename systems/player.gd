extends CharacterBody2D


@export var walk_speed: float = 300.0
@export var run_speed: float = 500.0
@export var jump_velocity: float = -400.0

var move_speed: float

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if is_on_floor():
		if Input.is_action_just_pressed("jump"):
			velocity.y = jump_velocity
		if Input.is_action_pressed("run"):
			move_speed = run_speed
		else:
			move_speed = walk_speed

	# Get the input direction and handle the movement/deceleration.
	var direction := Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * move_speed
	else:
		velocity.x = move_toward(velocity.x, 0, move_speed)

	move_and_slide()
