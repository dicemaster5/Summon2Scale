extends Node2D

@export var block_container_area: Area2D
var held_block: DraggableBlock
var hover_block: DraggableBlock

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Globals.block_clicked.connect(on_clicked_block)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	global_position = get_global_mouse_position()
	

func _unhandled_input(event):
	if event is InputEventMouseButton and event.is_action("left_click"):
		if Globals.mouse_in_tower_area and held_block and !event.pressed:
			held_block.drop()
			held_block = null
			
func on_clicked_block(body: DraggableBlock) -> void:
	if held_block:
		return
		
	held_block = body
	held_block.pick_up()
	
	await get_tree().create_timer(0.5).timeout
	block_container_area.spawn_shape_in_position(body.initial_position)
