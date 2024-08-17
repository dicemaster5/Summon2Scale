extends CharacterBody2D

@export var walk_speed: float = 300.0
@export var run_speed: float = 500.0
@export var jump_velocity: float = -400.0

@onready var animator: AnimatedSprite2D = $AnimatedSprite2D
@onready var coyote_timer: Timer = $CoyoteTimer

var move_speed: float
var jumped: bool
var can_jump: bool

var coyote_frames = 6  # How many in-air frames to allow jumping
var coyote = false  # Track whether we're in coyote time or not
var last_floor = false  # Last frame's on-floor state

var gravity_enabled = true

func _ready() -> void:
	animator.play()

func _physics_process(delta: float) -> void:
	if Globals.we_are_in_a_menu:
		return
		
	# Add the gravity.
	if not is_on_floor() && gravity_enabled:
		velocity += get_gravity() * delta

	# Get the input direction and handle the movement/deceleration.
	var direction := Input.get_axis("move_left", "move_right")
	
	# Handle jump.
	if is_on_floor():
		can_jump = true
		coyote_timer.stop()

		if direction != 0:
			if Input.is_action_pressed("run"):
				move_speed = run_speed
				animator.play("run")
			else:
				move_speed = walk_speed
				animator.play("walk")
		else:
			animator.play("Idle")

	if Input.is_action_just_pressed("jump") and (is_on_floor() or coyote):
		velocity.y = jump_velocity
		jumped = true

	if direction:
		velocity.x = direction * move_speed
		
		# Flip character 
		if velocity.x > 0:
			animator.flip_h = false
		elif velocity.x < 0:
			animator.flip_h = true

	else:
		velocity.x = move_toward(velocity.x, 0, move_speed)

	move_and_slide()
