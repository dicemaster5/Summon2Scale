extends CharacterBody2D

@export var walk_speed: float = 300.0
@export var run_speed: float = 500.0
@export var max_jump_velocity: float = 400.0
@export var coyote_frames: int = 30  # How many in-air frames to allow jumping

@onready var animator: AnimatedSprite2D = $AnimatedSprite2D
@onready var coyote_timer: Timer = $CoyoteTimer
@onready var jump_timer: Timer = $JumpTimer


var move_speed: float
var jumped: bool
var can_jump: bool
var jump_force: float

var coyote = false  # Track whether we're in coyote time or not
var last_floor = false  # Last frame's on-floor state
var gravity_enabled = true

func _ready() -> void:
	animator.play()
	coyote_timer.wait_time = coyote_frames / 60.0
	print(coyote_timer.wait_time)

func _physics_process(delta: float) -> void:
	if Globals.we_are_in_a_menu:
		return
		
	# Add the gravity.
	if not is_on_floor() && gravity_enabled:
		velocity += get_gravity() * delta

	# Get the input direction and handle the movement/deceleration.
	var direction := Input.get_axis("move_left", "move_right")
	
	if is_on_floor():
		jumped = false
		if direction != 0:
			if Input.is_action_pressed("run"):
				move_speed = run_speed
				animator.play("run")
			else:
				move_speed = walk_speed
				animator.play("walk")
		else:
			animator.play("Idle")
	else: # Falling.
		if velocity.y > 0:
			animator.play("falling")
		elif velocity.y < 0:
			animator.play("jump")

	# Start coyote time.
	if !is_on_floor() and last_floor and !jumped:
		coyote = true
		coyote_timer.start()

	# Jump
	if Input.is_action_just_pressed("jump") and (is_on_floor() or coyote):
		velocity.y = -max_jump_velocity
		jumped = true
		coyote = false
		coyote_timer.stop()

	if direction:
		velocity.x = direction * move_speed
		# Flip character 
		if velocity.x > 0:
			animator.flip_h = false
		elif velocity.x < 0:
			animator.flip_h = true
	else:
		velocity.x = move_toward(velocity.x, 0, move_speed)
	
	last_floor = is_on_floor()
	move_and_slide()

func _on_coyote_timer_timeout() -> void:
	coyote = false
