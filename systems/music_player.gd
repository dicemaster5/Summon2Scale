extends Node2D

@export var audiostreamplayer2D: AudioStreamPlayer2D
@export var audiostreamlistener2D: AudioListener2D

@export var music_list: Array[AudioStream]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	music_change(Globals.GAMEMODE.INTRO)
	Globals.gamemode_changed.connect(music_change)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func music_change(newgamemode: Globals.GAMEMODE) -> void:
	match newgamemode:
		Globals.GAMEMODE.INTRO:
			audiostreamplayer2D.stream = music_list[0]
			audiostreamplayer2D.play()
		Globals.GAMEMODE.START:
			audiostreamplayer2D.stream = music_list[1]
			audiostreamplayer2D.play()
		Globals.GAMEMODE.BUILDER:
			audiostreamplayer2D.stream = music_list[2]
			audiostreamplayer2D.play()
		Globals.GAMEMODE.PLAYER:
			pass
		Globals.GAMEMODE.FINISHED:
			audiostreamplayer2D.stream = music_list[3]
			audiostreamplayer2D.play()
		_:
			pass
	
	
