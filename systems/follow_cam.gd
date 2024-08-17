extends Camera2D

@export var follow_target: Node2D
@export var follow_speed: float = 2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position = lerp(position, follow_target.global_position, follow_speed * delta)
	position.y = clamp(position.y, -10000, 20)
