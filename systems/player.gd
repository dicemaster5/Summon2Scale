extends CharacterBody2D

@export var walk_speed: float = 300.0
@export var run_speed: float = 500.0
@export var max_jump_velocity: float = -100.0
@export var jump_impede: float = -10
@export var coyote_frames: int = 30  # How many in-air frames to allow jumping

@onready var animator: AnimatedSprite2D = $AnimatedSprite2D
@onready var coyote_timer: Timer = $CoyoteTimer

@export var height_label: Label

var gravity_value: float = ProjectSettings.get_setting("physics/2d/default_gravity")
var player_gravity: Vector2
var move_speed: float
var jumped: bool
var can_jump: bool
var can_move: bool = true
var jump_force: float
var holding_jump: bool

var coyote := false  # Track whether we're in coyote time or not
var last_floor := false  # Last frame's on-floor state
var gravity_enabled := true

var current_height: float
var start_height_offset: float
const METER_SCALE: int = 15 # Player collider height divided by 2

# Redorded data
var max_height_reached: float = 0
var jump_counter: int = 0
var time_spent_scaling: float = 0

func _ready() -> void:
	animator.play()
	coyote_timer.wait_time = coyote_frames / 60.0
	move_speed = walk_speed
	start_height_offset = global_position.y

func _process(_delta: float) -> void:
	height_calculation()

func height_calculation() -> void:
	current_height = (-global_position.y - -start_height_offset) / METER_SCALE
	if current_height >  max_height_reached:
		max_height_reached = current_height
		print("max!!!! - ",max_height_reached)
		height_label.text = "%.2f - meters" %[max_height_reached]

func _physics_process(delta: float) -> void:
	if Globals.current_gamemode != Globals.GAMEMODE.PLAYER: return
		
	# Add the gravity.
	if not is_on_floor() && gravity_enabled:
		player_gravity = get_gravity()
		velocity += player_gravity * delta

	# Get the input direction and handle the movement/deceleration.
	var direction := Input.get_axis("move_left", "move_right")
	
	# Player crouch!
	if is_on_floor() && Input.is_action_pressed("move_down"):
		animator.play("crouch")
		return

	# movement and stuff
	if is_on_floor():
		jumped = false
		if direction != 0 && can_move:
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
	
	# Variable jumping.
	if Input.is_action_just_pressed("jump") and (is_on_floor() or coyote):
		velocity.y = max_jump_velocity
		jumped = true
		holding_jump = true
		jump_counter += 1

	if Input.is_action_just_released("jump"):  
		holding_jump = false
  
	if holding_jump and velocity.y <= jump_impede:  
		velocity.y -= -jump_impede

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
