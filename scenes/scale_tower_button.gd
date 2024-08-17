extends Button

@export var buildscreen: Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pressed.connect(change_to_playmode)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func change_to_playmode() -> void:
	buildscreen.visible = false
	self.visible = false
	Globals.change_gamemode(Globals.GAMEMODE.PLAYER)
