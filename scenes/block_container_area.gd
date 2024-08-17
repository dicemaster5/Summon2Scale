extends Area2D

@export var blocks: Array[PackedScene]
@export var positions: Array[Node2D]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in range(len(positions)):
		spawn_shape_in_position(i)

func load_shape(asset: PackedScene, shape_position: Vector2):
	var new_block = asset.instantiate()
	new_block.global_position = shape_position
	new_block.initial_position = shape_position
	
	add_sibling.call_deferred(new_block)

func spawn_shape_in_position(pos: int):
	var rand_block_id = randi_range(0,blocks.size()-1)
	var position = positions[pos]
	load_shape(blocks[rand_block_id], position.global_position)
