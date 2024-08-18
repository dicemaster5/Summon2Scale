
class_name GameTimer extends Control
@export var timer: Timer
@export var label: Label
@export var watch_hand: Control

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timer.timeout.connect(end_game)
	pass # Replace with function body.
 

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:

	if timer.is_stopped(): return

	var minutes = int(timer.time_left/60)
	var seconds = int(timer.time_left-(minutes*60))
	var centiseconds = 100*timer.time_left-((minutes*60)*100)-(seconds*100)
	
	# if minutes < 1:
	# 	label.add_theme_color_override("font_color", Color(1,0,0))
	# else:
	# 	label.add_theme_color_override("font_color", Color(1,1,1))

	
	label.text = "%02d:%02d:%02d" % [minutes, seconds, centiseconds] 
	
	watch_hand.rotation_degrees = -360 * timer.time_left/timer.wait_time
	
func end_game() -> void:
	Globals.change_gamemode(Globals.GAMEMODE.FINISHED)

func start_timer() -> void:
	timer.start()
