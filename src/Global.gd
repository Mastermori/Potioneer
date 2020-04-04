extends Node


const sounds : Dictionary = {}
const music : Dictionary = {}

var sound_level : float setget set_sound_level


func _ready():
	add_sound("dash")

func add_sound(name : String, custom_path := ""):
	sounds[name] = get_audio_from_dir("sounds/" + custom_path + name)

func add_music(name : String , custom_path := ""):
	music[name] = get_audio_from_dir("music/" + custom_path + name)

func get_audio_from_dir(name : String, path := "res://assets/") -> Array:
	var dir = Directory.new()
	var sounds_from_dir := []
	path = path + name + "/"
	if dir.open(path) == OK:
		dir.list_dir_begin(true)
		var file_name = dir.get_next()
		while file_name != "":
			if not dir.current_is_dir() and (file_name.ends_with("wav.import") or file_name.ends_with("ogg.import")):
				sounds_from_dir.append(load(path + file_name.replace(".import", "")))
			file_name = dir.get_next()
		return sounds_from_dir
	else:
		print("An error occurred when trying to access the path.")
		return []

func play_music(name : String , index : int, parent : Node, is_positional := false, pitch_scale = 1.0, volume_db = 0.0, bus = "Music") -> void:
	if not music.has(name):
		add_music(name)
		if music[name].size() < 1:
			print("Can't find music: " + str(name))
			return
	play_audio(music[name][index], parent, is_positional, pitch_scale, volume_db, bus)

func play_random_music(name : String, parent : Node, is_positional := false, pitch_scale = 1.0, volume_db = 0.0, bus := "Music") -> void:
	play_music(name, randi() % music[name].size(), parent, is_positional, pitch_scale, volume_db, bus)

func play_sound(name : String, index : int, parent : Node, is_positional := false, pitch_scale = 1.0, volume_db = 0.0, bus = "SFX") -> void:
	if not sounds.has(name):
		add_sound(name)
		if sounds[name].size() < 1:
			print("Can't find sound: " + str(name))
			return
	play_audio(sounds[name][index], parent, is_positional, pitch_scale, volume_db, bus)

func play_random_sound(name : String, parent : Node, is_positional := false, pitch_scale = 1.0, volume_db = 0.0, bus := "SFX") -> void:
	play_sound(name, randi() % sounds[name].size(), parent, is_positional, pitch_scale, volume_db, bus)

func play_audio(audio : AudioStream, parent : Node, is_positional := false, pitch_scale = 1.0, volume_db = 0.0, bus = "Master") -> void:
	var audio_stream_player : Node
	if is_positional:
		audio_stream_player = AudioStreamPlayer2D.new()
	else:
		audio_stream_player = AudioStreamPlayer.new()
	parent.add_child(audio_stream_player)
	audio_stream_player.bus = bus
	audio_stream_player.stream = audio
	audio_stream_player.volume_db = volume_db
	if pitch_scale <= 0:
		pitch_scale = 0.001
	audio_stream_player.pitch_scale = pitch_scale
	audio_stream_player.play()
	audio_stream_player.connect("finished", audio_stream_player, "queue_free")

func set_sound_level(value : float):
	if value > 1:
		printerr("Sound level can't be set above 1.0")
		value = 1
	sound_level = value
