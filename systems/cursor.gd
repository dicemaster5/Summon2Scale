extends Node2D

@export var block_container_area: Node2D
var held_block: DraggableBlock
var hover_block: DraggableBlock
@export var placed_block_container: Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Globals.block_clicked.connect(on_clicked_block)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass	

func _unhandled_input(event):
	if event is InputEventMouseButton and event.is_action("left_click"):
		if Globals.mouse_in_tower_area and held_block and !event.pressed:
			held_block.drop()
			held_block = null
			
func on_clicked_block(body: DraggableBlock) -> void:
	if held_block:
		return
	
	if body.movable:
		held_block = body
		held_block.pick_up()
		held_block.reparent(placed_block_container)
		
		await get_tree().create_timer(0.5).timeout
		block_container_area.spawn_shape_in_position(body.initial_position)
