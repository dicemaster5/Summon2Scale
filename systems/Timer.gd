
extends Control
@export var timer: Timer
@export var label: Label
@export var watch_hand: Control

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
 

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:

	print(timer.time_left)
	var minutes = int(timer.time_left/60)
	var seconds = int(timer.time_left-(minutes*60))
	var centiseconds = 100*timer.time_left-((minutes*60)*100)-(seconds*100)
	
	if minutes < 2:
		label.font_color = ff0000
	
	
	label.text = "%02d:%02d:%02d" % [minutes, seconds, centiseconds] 
	
	watch_hand.rotation_degrees = -360 * timer.time_left/timer.wait_time
	
	

	
func start_timer() -> void:
	timer.start()
