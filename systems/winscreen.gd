extends Control

# text formatting:
# https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_format_string.html

@export var stats_label: Label
@export var score_label: Label
@export var share_text_button: Button
@export var share_text_confirmation: Panel
@export var share_image_button: Button

var max_height = 124.14451
var time_summon = 74.112
var time_scale = 15.671
var blocks_summoned = 43

var lb_alltime_pos = 14
var lb_alltime_ord = "th"
var lb_today_pos = 11
var lb_today_ord = "th"

var fading
const FADE_SPEED = 5
const FADE_WAIT = 2

var win_text = "WELL DONE
YOU WON
YOU CLIMBED %.2f m in 2 minutes
YOU SPENT %.1f SECONDS BUILDING AND %.1f SECONDS SCALING
[bar graph of building/scaling? same asset as timer]
YOU SUMMONED %d BLOCKS
"
var score_text = "SCORE SUBMITTED TO SCOREBOARD
YOU PLACED %d%s (TODAY) OR %d%s (ALL TIME)"
var share_text = "I built and climbed %.2f m in Summon & Scale
  ⬛⬛
⬛ ⬛  🏃‍♀️
⬛    ⬛⬛
I spent %.2f summoning %d blocks and %.2f climbing %.2f m
I placed %d%s (today)
"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var text_template = stats_label.text
	var text_filled = text_template % [
		max_height,
		time_summon,
		time_scale,
		blocks_summoned
	]
	stats_label.text = text_filled
	
	var score_text_template = score_label.text
	var score_text_filled = score_text_template % [
		lb_alltime_pos,
		lb_alltime_ord,
		lb_today_pos,
		lb_today_ord,
	]
	score_label.text = score_text_filled

	share_text_button.pressed.connect(self._share_text)
	
	share_image_button.pressed.connect(self._share_image)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if fading:
		share_text_confirmation.modulate.a = lerp(share_text_confirmation.modulate.a, 0.0, delta * FADE_SPEED)

func _share_text():
	var text = share_text % [
		max_height,
		time_summon,
		blocks_summoned,
		time_scale,
		max_height,
		lb_today_pos,
		lb_today_ord,
	]
	DisplayServer.clipboard_set(text)
	
	#var styleBox: StyleBoxFlat = get_theme_stylebox("panel")
	fading = 0
	share_text_confirmation.modulate.a = 1
	await get_tree().create_timer(FADE_WAIT).timeout
	fading = 1

func _share_image():
	await RenderingServer.frame_post_draw
	var image = $Camera2D.get_viewport().get_texture().get_image()
	#.save_png("user://Screenshot.png")
	
	if OS.get_name() != "HTML5" or !OS.has_feature('JavaScript'):
		return
	
	image.clear_mipmaps()
	var buffer = image.save_png_to_buffer()
	JavaScriptBridge.download_buffer(buffer, "pic.png")
