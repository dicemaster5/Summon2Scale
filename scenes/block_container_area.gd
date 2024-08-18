extends Node2D

@export var blocks: Array[PackedScene]
@export var positions: Array[Node2D]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in range(len(positions)):
		spawn_shape_in_position(i)

func spawn_shape_in_position(pos: int):
	var rand_block_id = randi_range(0,blocks.size()-1)
	var place_position = positions[pos]
	
	var new_block = blocks[rand_block_id].instantiate()
	new_block.global_position = place_position.global_position
	new_block.initial_position = pos
	new_block.scale = Vector2(0.1, 0.1)
	
	add_sibling.call_deferred(new_block)
	
	# "pop" in from small
	var tween = get_tree().create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_QUINT)
	tween.tween_property(new_block,"scale",Vector2(1, 1),0.15)
	tween.play()
	
