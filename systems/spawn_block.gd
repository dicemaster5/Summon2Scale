extends Node

@export var block_scene: PackedScene
@export var briefcase:Node2D
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_pressed() -> void:
	var new_block = block_scene.instantiate()
	new_block.position = Vector2(100,100)
	add_sibling(new_block)
