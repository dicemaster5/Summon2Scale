extends Control

# text formatting:
# https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_format_string.html

@export var height_label: Label
@export var stats_label: Label
@export var score_label: Label
@export var share_text_button: BaseButton
@export var share_text_confirmation: Panel
@export var share_image_button: BaseButton
@export var file_dialog: FileDialog
@export var scoreboard: BoxContainer

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
https://jman9092.itch.io/summon-to-scale
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
	
func populate():
	height_label.text = "%.2f m" % Globals.max_height
	scoreboard.submit_score(
		Globals.username,
		Globals.max_height,
		0,
		0,
		0,
		0,
		0,
		0
	)
	pass

func _share_text():
	var text = share_text % [
		Globals.max_height,
	]
	DisplayServer.clipboard_set(text)
	
	#var styleBox: StyleBoxFlat = get_theme_stylebox("panel")
	share_text_confirmation.show()
	share_text_confirmation.modulate.a = 1
	await get_tree().create_timer(FADE_WAIT).timeout
	share_text_confirmation.modulate.a = 0
	share_text_confirmation.hide()

func _share_image():
	await RenderingServer.frame_post_draw
	var image = $Camera2D.get_viewport().get_texture().get_image()
	#.save_png("user://Screenshot.png")
	
	image.clear_mipmaps()
	if OS.get_name() == "Web" and OS.has_feature('web'):
		var buffer = image.save_png_to_buffer()
		JavaScriptBridge.eval('console.log("saving image")')
		JavaScriptBridge.download_buffer(buffer, "pic.png")
	elif OS.get_name() in ["Linux", "Windows", "macOS"]:
		file_dialog.use_native_dialog = true
		file_dialog.mode = 4
		file_dialog.connect("file_selected", _save_image_func(image))
		file_dialog.current_file = "screenshot.png"
		file_dialog.show()

func _save_image_func(image: Image):
	var _save_image = func _save_image(to: String):
		image.save_png(to)
	return _save_image
