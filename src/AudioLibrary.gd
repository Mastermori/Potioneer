extends Node


const sounds : Dictionary = {}
const music : Dictionary = {}

var sfx_volume : float setget set_sfx_volume
var music_volume : float setget set_music_volume


func _ready():
	add_sound("player/dash")
	
	set_sfx_volume(1)

func add_sound(name : String, custom_path := ""):
	sounds[name] = get_audio_from_dir("sounds/" + custom_path + name)

func add_music(name : String , custom_path := ""):
	music[name] = get_audio_from_dir("music/" + custom_path + name)

func get_audio_from_dir(name : String, path := "res://assets/") -> Array:
	return get_audio_from_path(path + name + "/")

func get_audio_from_path(absolute_path : String) -> Array:
	var dir = Directory.new()
	var sounds_from_dir := []
	if dir.open(absolute_path) == OK:
		dir.list_dir_begin(true)
		var file_name = dir.get_next()
		while file_name != "":
			if not dir.current_is_dir() and (file_name.ends_with("wav.import") or file_name.ends_with("ogg.import")):
				sounds_from_dir.append(load(absolute_path + file_name.replace(".import", "")))
			file_name = dir.get_next()
		return sounds_from_dir
	else:
		print("An error occurred when trying to access the path:")
		print(absolute_path)
		return []

func play_music(name : String , index : int, pitch_scale = 1.0, volume_db = 0.0, bus = "Music") -> void:
	if not music.has(name):
		add_music(name)
		if music[name].size() < 1:
			print("Can't find music: " + str(name))
			return
	play_audio(music[name][index], self, false, pitch_scale, volume_db, bus)

func play_random_music(name : String, pitch_scale = 1.0, volume_db = 0.0, bus := "Music") -> void:
	play_music(name, randi() % music[name].size(), pitch_scale, volume_db, bus)

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

func set_sfx_volume(value : float):
	if value > 1 or value < 0:
		printerr("Sound level can't be set above 1.0 or below 0.0")
		value = clamp(value, 0, 1)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), range_lerp(value, 0, 1, -30, 0))
	sfx_volume = value

func set_music_volume(value : float):
	if value > 1 or value < 0:
		printerr("Sound level can't be set above 1.0")
		value = clamp(value, 0, 1)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), range_lerp(value, 0, 1, -30, 0))
	music_volume = value
