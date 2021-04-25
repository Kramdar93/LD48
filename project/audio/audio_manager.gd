extends Node

export (Array, AudioStreamSample) var sfx = []

export (Array, AudioStreamSample) var music = []

var music_player
var sfx_player
var amb_player
var alarm_player


# Called when the node enters the scene tree for the first time.
func _ready():
	music_player = get_node("musicPlayer")
	sfx_player = get_node("sfxPlayer")
	amb_player = get_node("ambientPlayer")
	alarm_player = get_node("alarmPlayer")
	
func _process(delta):
	if !music_player.playing and music_player.stream == music[1]:
		music_player.stream = music[2]
		music_player.play()

func play_sfx(type):
	if type == "cancel":
		sfx_player.stop()
		sfx_player.stream = sfx[2]
		sfx_player.play()
	elif type == "get":
		sfx_player.stop()
		sfx_player.stream = sfx[3]
		sfx_player.play()
	elif type == "place":
		sfx_player.stop()
		sfx_player.stream = sfx[4]
		sfx_player.play()
	elif type == "sensor":
		sfx_player.stop()
		sfx_player.stream = sfx[5]
		sfx_player.play()
	elif type == "bad":
		sfx_player.stop()
		sfx_player.stream = sfx[1]
		sfx_player.play()
	
func play_music(type):
	if type == "idle":
		music_player.stop()
		music_player.stream = music[1]
		music_player.play()
	elif type == "interlude":
		music_player.stop()
		music_player.stream = music[3]
		music_player.play()
		
func start_ambience():
	amb_player.stream = music[0]
	amb_player.play()
	
func start_alarm():
	if !alarm_player.playing:
		alarm_player.stream = sfx[0]
		alarm_player.play()
		
func stop_alarm():
	if alarm_player.playing:
		alarm_player.stop()
