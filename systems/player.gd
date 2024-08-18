class_name Player extends CharacterBody2D

enum STATUSEFFECT {
	SLOW = 1,
	FAST = 2,
	SMALLJUMP = 4,
	BIGJUMP = 8
}

@export var walk_speed: float = 300.0
@export var run_speed: float = 500.0
@export var max_jump_velocity: float = -100.0
@export var jump_impede: float = -10
@export var coyote_frames: int = 30  # How many in-air frames to allow jumping

@onready var animator: AnimatedSprite2D = $AnimatedSprite2D
@onready var coyote_timer: Timer = $CoyoteTimer
@onready var collider: CollisionShape2D = $Collider
@onready var areachecker: Area2D = $AreaChecker

@export var height_label: Label

var gravity_value: float = ProjectSettings.get_setting("physics/2d/default_gravity")
var player_gravity: Vector2
var move_speed: float
var jumped: bool
var can_jump: bool
var can_move: bool = true
var jump_force: float
var holding_jump: bool
var status_effects: int = 0

var coyote := false  # Track whether we're in coyote time or not
var last_floor := false  # Last frame's on-floor state
var gravity_enabled := true

# LEDGE GRABBING
const DEBUG = false
# top ray
var ledge_grab_top_from = Vector2(0,-15)
var ledge_grab_top_to = Vector2(13,-15)
# bottom ray
var ledge_grab_bottom_from = Vector2(0,-5)
var ledge_grab_bottom_to = Vector2(13,-5)
# ray from top to bottom
var ledge_grab_floor_from = Vector2(0, 0)
var ledge_grab_floor_to = Vector2(0, 10)
var facing_direction = Vector2(1,1) # 1 right, -1 left
# climbing
var climbing: bool = false
var climb_to: Vector2
const CLIMB_SPEED = 60
# debug visuals
@export var ledge_grab_debug_node: Node2D
var topline: Line2D
var bottomline: Line2D
var label: Label
var upline: Line2D
var point: Line2D

var current_height: float
var start_height_offset: float
const METER_SCALE: int = 15 # Player collider height divided by 2

# Redorded data
var max_height_reached: float = 0
var jump_counter: int = 0
var time_spent_scaling: float = 0

func _ready() -> void:
	height_label.text = "%.2f m" %[max_height_reached]
	animator.play()
	coyote_timer.wait_time = coyote_frames / 60.0
	calculate_speed(walk_speed)
	start_height_offset = global_position.y
	
	if DEBUG:
		topline = ledge_grab_debug_node.get_child(0)
		bottomline = ledge_grab_debug_node.get_child(1)
		label = ledge_grab_debug_node.get_child(2)
		upline = ledge_grab_debug_node.get_child(3)
		point = ledge_grab_debug_node.get_child(4)

func _process(_delta: float) -> void:
	height_calculation()

func height_calculation() -> void:
	current_height = (-global_position.y - -start_height_offset) / METER_SCALE
	if current_height >  max_height_reached:
		max_height_reached = current_height
		height_label.text = "%.2f m" %[max_height_reached]
		Globals.max_height = max_height_reached

		Globals.new_height_reached.emit()

func _physics_process(delta: float) -> void:
	if Globals.current_gamemode == Globals.GAMEMODE.BUILDER:
		animator.play("summon")
	if Globals.current_gamemode != Globals.GAMEMODE.PLAYER: return
	
	if climbing:
		animator.play("grab")
		global_position = global_position.move_toward(
			climb_to,
			delta * CLIMB_SPEED
		)
		var overlaps = areachecker.get_overlapping_bodies()
		if overlaps.size() > 0:
			climbing = false

		if global_position == climb_to:
			climbing = false
		else:
			return
		
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
				calculate_speed(run_speed)
				animator.play("run")
			else:
				calculate_speed(walk_speed)
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
			facing_direction = Vector2(1, 1)
		elif velocity.x < 0:
			animator.flip_h = true
			facing_direction = Vector2(-1, 1)
	else:
		velocity.x = move_toward(velocity.x, 0, move_speed)

	climbing = check_and_grab()
	
	last_floor = is_on_floor()
	move_and_slide()

func _on_coyote_timer_timeout() -> void:
	coyote = false

func check_and_grab() -> bool:
	# wall grab
	var space_state = get_world_2d().direct_space_state
	var fd = facing_direction
	# debug lines
	if DEBUG: topline.points[0] = fd * ledge_grab_top_from
	if DEBUG: 	topline.points[1] = fd * ledge_grab_top_to
	if DEBUG: bottomline.points[0] = fd * ledge_grab_bottom_from
	if DEBUG: bottomline.points[1] = fd * ledge_grab_bottom_to
	if DEBUG: upline.default_color = "#ff0000"
	
	# top ray
	var querytop = PhysicsRayQueryParameters2D.create(
		position + fd * ledge_grab_top_from,
		position + fd * ledge_grab_top_to
	)
	var resulttop = space_state.intersect_ray(querytop)
	if len(resulttop) > 1:
		if DEBUG: topline.default_color = "#ffffff"
	else:
		if DEBUG: topline.default_color = "#00ff00"
	# bottom ray
	var querybottom = PhysicsRayQueryParameters2D.create(
		position + fd * ledge_grab_bottom_from,
		position + fd * ledge_grab_bottom_to
	)
	var resultbottom = space_state.intersect_ray(querybottom)
	if len(resultbottom) > 1:
		if DEBUG: bottomline.default_color = "#ffffff"
	else:
		if DEBUG: bottomline.default_color = "#ff00ff"
	
	# if NOT(bottom hits and top doesn't)
	if not (len(resulttop) == 0 and len(resultbottom) > 0):
		if DEBUG: label.text = "no grab"
		return false
		
	# ray cast from x where wall is, and from y between the raycasts
	var from_x = to_local(Vector2(resultbottom.position.x, 0)).x
	var from_y = ledge_grab_top_to.y
	var to_x = to_local(Vector2(resultbottom.position.x, 0)).x
	var to_y = ledge_grab_bottom_to.y
	var from = Vector2(from_x, from_y)
	var to = Vector2(to_x, to_y)
	# debug line
	if DEBUG: upline.points[0] = from
	if DEBUG: upline.points[1] = to
	# ray cast!
	var queryfloor = PhysicsRayQueryParameters2D.create(
		position + from,
		position + to
	)
	var resultfloor = space_state.intersect_ray(queryfloor)
	# debug line
	# if we do not hit (the floor)
	if len(resultfloor) == 0:
		if DEBUG: label.text = "no grab"
		return false
	if DEBUG: point.points[0] = to_local(resultfloor.position) + + Vector2(0,2)
	if DEBUG: point.points[1] = to_local(resultfloor.position) + Vector2(0,-2)
		
	
	if DEBUG: upline.default_color = "#ffffff"
	#var colliding = get_last_slide_collision()
	var check_holding
	if facing_direction.x == 1: check_holding = "move_right"
	else: check_holding = "move_left"
	var pushing_against = Input.is_action_pressed(check_holding)
	if not pushing_against or is_on_floor():
		if DEBUG: label.text = "no grab"
		return false
		
	# can we fit?
	var climb_to_local = to_local(resultfloor.position) + fd * Vector2(12,-1)
	areachecker.position = climb_to_local + Vector2(0, -15) # as player is shifted up by 15 px
	var overlaps = areachecker.get_overlapping_bodies()
	if len(overlaps) > 0:
		if DEBUG: label.text = "no grab"
		return false
	
	
	# grab !!!
	if DEBUG: label.text = "grab"
	# set climb_to
	climb_to = resultfloor.position + fd * Vector2(10,0)
	velocity = Vector2.ZERO
	return true
	
func check_status_effect(status: STATUSEFFECT):
	var current_value = status_effects
	var bits = [0, 0, 0, 0, 0, 0, 0, 0]
	var bit = 7
	while current_value > 0:
		bits[bit] = (current_value % 2)
		current_value /= 2
		bit -= 1
	
	if bits[8 - status] == 1:
		return true
	else:
		return false

func calculate_speed(speed: float):
	move_speed = speed
	if check_status_effect(STATUSEFFECT.SLOW):
		move_speed -= 190
	if check_status_effect(STATUSEFFECT.FAST):
		move_speed += 200
