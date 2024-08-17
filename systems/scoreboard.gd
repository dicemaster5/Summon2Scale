extends VBoxContainer

@export var scoreboardentry_scene: PackedScene
@export var scoreboardentry_vbox: VBoxContainer
@export var http_request_scores: HTTPRequest
@export var status_label: Label
@export var button_time_daily: Button
@export var button_time_weekly: Button
@export var button_time_alltime: Button

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	button_time_daily.pressed.connect(_fetch_things("daily"))
	button_time_weekly.pressed.connect(_fetch_things("weekly"))
	button_time_alltime.pressed.connect(_fetch_things("alltime"))
	_fetch_things("alltime").call()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _fetch_things(timeframe: String) -> Callable:
	var _fetch_timeframe = func():
		print("[%s] starting request" % Time.get_datetime_string_from_system())
		
		for i in range(0, scoreboardentry_vbox.get_child_count()):
			scoreboardentry_vbox.get_child(i).queue_free()
		status_label.text = "loading..."
		status_label.visible = true
		http_request_scores.request_completed.connect(_fetch_completed)
		
		var error = http_request_scores.request(
			"https://summon2scale.alifeee.co.uk/scoreboard/top?total=10&timeframe=%s" % timeframe
		)
		if error != OK:
			status_label.text = "oh no"
	return _fetch_timeframe

func _fetch_completed(result, response_code, headers, body):
	print("[%s] fetch completed" % Time.get_datetime_string_from_system())
	#await get_tree().create_timer(2).timeout
	var json = JSON.new()
	json.parse(body.get_string_from_utf8())
	var response = json.get_data()
	print(response)
	
	var scores = response["scores"]

	for score in scores:
		var name: String = score["name"]
		var max_height: float = score["max_height"]
		print("%s got %s" % [name, max_height])
		var scoreboardentry: ScoreboardEntry = scoreboardentry_scene.instantiate()
		scoreboardentry.username = name
		scoreboardentry.score = "%.2f" % max_height
		scoreboardentry_vbox.add_child(scoreboardentry)
	
	status_label.visible = false
