extends VBoxContainer

@export var scoreboardentry_scene: PackedScene
@export var scoreboardentry_vbox: VBoxContainer
@export var http_request_scores: HTTPRequest
@export var status_label: Label
@export var button_time_daily: Button
@export var button_time_weekly: Button
@export var button_time_alltime: Button
@export var http_request_submit: HTTPRequest

var current_board = "daily" # "daily" or "weekly" or "alltime"

signal submit_score_start
signal submit_score_fail
signal submit_score_success

var test_label

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	button_time_daily.pressed.connect(_fetch_things("daily"))
	button_time_weekly.pressed.connect(_fetch_things("weekly"))
	button_time_alltime.pressed.connect(_fetch_things("alltime"))
	refresh_leadereboard()	
	
	if OS.is_debug_build():
		$"test button".visible = true
		$"test button".pressed.connect(submit_fake_score)
		test_label = $"test label"
		test_label.visible = true
		test_label.text = "nothing happening"
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func refresh_leadereboard():
	_fetch_things(current_board).call()

func _fetch_things(timeframe: String) -> Callable:
	var _fetch_timeframe = func():
		print("[%s] starting request" % Time.get_datetime_string_from_system())
		current_board = timeframe
		
		for i in range(0, scoreboardentry_vbox.get_child_count()):
			scoreboardentry_vbox.get_child(i).queue_free()
		status_label.text = "loading..."
		status_label.visible = true
		http_request_scores.request_completed.connect(_fetch_completed)
		
		var error = http_request_scores.request(
			"https://summon2scale.alifeee.co.uk/scoreboard/top?total=10&timeframe=%s" % timeframe
		)
		if error != OK:
			status_label.text = "something went wrong :("
	return _fetch_timeframe

func _fetch_completed(result, response_code, headers, body):
	print("[%s] fetch completed" % Time.get_datetime_string_from_system())
	#await get_tree().create_timer(2).timeout
	var json = JSON.new()
	json.parse(body.get_string_from_utf8())
	var response = json.get_data()
	print("scoreboard response:", response)
	if response == null:
		status_label.text = "could not load scoreboard..."
		return
	
	var scores = response.get("scores")
	if scores == null:
		status_label.text = "could not load scoreboard..."
		return

	for score in scores:
		var name: String = score["name"]
		var max_height: float = score["max_height"]
		print("%s got %s" % [name, max_height])
		var scoreboardentry: ScoreboardEntry = scoreboardentry_scene.instantiate()
		scoreboardentry.username = name
		scoreboardentry.score = "%.2f" % max_height
		scoreboardentry_vbox.add_child(scoreboardentry)
	
	status_label.visible = false

func submit_score(
	name: String,
	max_height: float,
	time_total_s: float,
	time_building_s: float,
	time_scaling_s: float,
	blocks_placed: int,
	jumps: int,
	distance_fallen: float,
):
	print("[%s] starting score submit" % Time.get_datetime_string_from_system())
	submit_score_start.emit()
	test_label.text = "starting submit"
	
	var now = Time.get_datetime_string_from_unix_time(Time.get_unix_time_from_system())
	
	var data = {
		"timestamp": now,
		"name": name,
		"max_height": max_height,
		"time_total_s": time_total_s,
		"time_building_s": time_building_s,
		"time_scaling_s": time_scaling_s,
		"blocks_placed": blocks_placed,
		"jumps": jumps,
		"distance_fallen": distance_fallen
	}
	var json = JSON.stringify(data)
	
	http_request_submit.request_completed.connect(_submit_score_completed)
	
	var error = http_request_submit.request(
			"https://summon2scale.alifeee.co.uk/score/new",
			[
				"Content-Type: application/json"
			],
			HTTPClient.METHOD_POST,
			json
		)
	if error != OK:
		submit_score_fail.emit("failed to make HTTP request")
		test_label.text = "failed to make HTTP request"
	

func _submit_score_completed(result, response_code, headers, body):
	print("[%s] submit completed" % Time.get_datetime_string_from_system())
	
	var json_response = JSON.new()
	json_response.parse(body.get_string_from_utf8())
	var response = json_response.get_data()
	print("scoreboard response:", response)
	if response == null:
		submit_score_fail.emit("failed to parse submit score result")
		test_label.text = "failed to parse submit score result"
		return
	
	var success = response["success"]
	if success != true:
		submit_score_fail.emit("failed to submit score")
		test_label.text = "failed to submit score"
	var id = response["id"]
	
	submit_score_success.emit("success", id)
	test_label.text = "added score with id %s" % id
	
	refresh_leadereboard()

func submit_fake_score():
	var random = RandomNumberGenerator.new()
	var num = randi() % 50
	submit_score(
		"alifeee %s" % num,
		114.7,
		120.0,
		100.1,
		19.9,
		59,
		83,
		35.6,
	)
