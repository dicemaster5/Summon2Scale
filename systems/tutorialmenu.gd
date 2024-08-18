extends Control

@export var button_skip: Button
@export var timer: Timer
@export var time_label: Label

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timer.timeout.connect(self._start_game)
	button_skip.pressed.connect(self._start_game)

func start_timer() -> void:
	timer.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	time_label.text = "%d s" % timer.time_left

func _start_game():
	Globals.change_gamemode(Globals.GAMEMODE.BUILDER)
	# this may be fired twice (if timer skipped)
	if timer.time_left > 0:
		timer.stop()
	# start game here (timer etc)
	visible = false
