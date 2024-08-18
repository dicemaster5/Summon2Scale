extends CanvasLayer

@export var game_timer: GameTimer
@export var build_screen: Node2D
@export var main_menu: Control
@export var tutorial_menu: Control
@export var end_menu: Control

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Globals.gamemode_changed.connect(gamemode_check)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func gamemode_check(new_gamemode: Globals.GAMEMODE) -> void:
	match new_gamemode:
		Globals.GAMEMODE.START:
			pass
		Globals.GAMEMODE.BUILDER:
			build_screen.show()
			game_timer.show()
			game_timer.start_timer()
			pass
		Globals.GAMEMODE.PLAYER:
			build_screen.hide()
			pass
		Globals.GAMEMODE.FINISHED:
			end_menu.show()
			pass
		_:
			pass
	pass