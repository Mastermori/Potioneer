extends Node

enum Mood {
	PEACEFUL,
	SUSPENSEFUL,
	EXCITING,
}

var music := {}

var current_mood = Mood.SUSPENSEFUL setget set_mood
var current_track : Track

var crossfade_duration := 3

onready var timer := Timer.new()
onready var tween := Tween.new()

class Track:
	var player : AudioStreamPlayer
	var is_loopable := false
	var ended := false
	var loop_counter := 0
	var _loops : Array
	var _start : AudioStream
	var _end : AudioStream
	var _full : AudioStream
	
	func play():
		ended = false
		loop_counter = 0
		if not is_loopable:
			if not player:
				player = Music.create_audio_player(_full)
		else:
			player = Music.create_audio_player(_start)
			print(player)
		print("Crated player")
		player.play()
	
	func loop():
		var new_player = Music.create_audio_player(_loops[randi() % _loops.size()])
		Music.transition(player, new_player, .1)
		player = new_player
		loop_counter += 1
	
	func end():
		if ended:
			return
		if is_loopable:
			var new_player = Music.create_audio_player(_end)
			Music.transition(player, new_player, .1)
			player = new_player
		else:
			# to be added (fade out when ending full track)
			return
		ended = true
	
	func get_current_time_left() -> float:
		return player.stream.get_length() - player.get_playback_position()
	
	func _init(path_to_dir : String, name : String, can_loop := true):
		is_loopable = can_loop
#		print("Creating track from: " + path_to_dir + " with name: " + name)
		if not can_loop:
			if path_to_dir.replace(".wav.import", "").replace(".ogg.import", "").ends_with("full"):
				_full = load(path_to_dir.replace(".import", ""))
			else:
				printerr("The file given to the track is not a valid full track file: ")
				print(path_to_dir)
		else:
			var dir : Directory = Directory.new()
			if dir.open(path_to_dir) == OK:
				dir.list_dir_begin(true)
				var file_name = dir.get_next()
				while file_name != "":
					if dir.current_is_dir() and file_name == "loops":
						_loops = AudioLib.get_audio_from_path(path_to_dir)
					elif not dir.current_is_dir() and (file_name.ends_with("wav.import") or file_name.ends_with("ogg.import")):
						var audio_type = file_name.replace(name + "_", "").replace(".wav.import", "").replace(".ogg.import", "")
						if audio_type == "start":
							_start = load(path_to_dir + file_name.replace(".import", ""))
						elif audio_type == "end":
							_end = load(path_to_dir + file_name.replace(".import", ""))
					file_name = dir.get_next()
			else:
				print("An error occurred when trying to access the path to this track:")
				print(path_to_dir)

func _ready():
	timer.one_shot = true
	timer.connect("timeout", self, "play_next_part")
	add_child(timer)
	tween.connect("tween_completed", self, "transition_finished")
	add_child(tween)
	for mood in Mood.values():
		var mood_name = Mood.keys()[mood].to_lower()
		var dir : Directory = Directory.new()
		var mood_path = "res://assets/music/" + mood_name + "/"
		if dir.open(mood_path) == OK:
			music[mood] = []
			dir.list_dir_begin(true)
			var dir_name = dir.get_next()
			while dir_name != "":
				var can_loop : bool
				if dir.current_is_dir():
					can_loop = true
				elif not dir.current_is_dir() and (dir_name.ends_with(".wav.import") or dir_name.ends_with(".ogg.import")) and dir_name.replace(".wav.import", "").replace(".ogg.import", "").ends_with("full"):
					can_loop = false
				else:
					dir_name = dir.get_next()
					continue
				music[mood].append(Track.new(mood_path + dir_name, dir_name, can_loop))
				dir_name = dir.get_next()
	start()

func set_mood(mood : int):
	current_mood = mood

func start():
#	start_next_track(false)
	print(music)
	for mood in music:
		for track in music[mood]:
			print(track._full)
	
	next_track()

func play_next_part():
	if current_track.is_loopable:
		if current_track.ended:
			next_track()
		else:
			var change_track : bool = randf() < (current_track.loop_counter - 1) * .1
			if change_track:
				current_track.end()
				timer.start(current_track.get_current_time_left() / 2)
			else:
				current_track.loop()
				timer.start(current_track.get_current_time_left() - crossfade_duration)
	else:
		next_track()

func next_track():
	var new_track := get_random_track()
	if current_track:
		transition(current_track.player, new_track.player, current_track.get_current_time_left())
	new_track.play()
	current_track = new_track
	if current_track.is_loopable:
		timer.start(current_track.get_current_time_left() - .1)
	else:
		timer.start(current_track.get_current_time_left() - crossfade_duration)

func get_random_track() -> Track:
	var possibilities : Array = music[current_mood].duplicate()
	if possibilities.size() > 1 and possibilities.has(current_track):
		possibilities.erase(current_track)
	return possibilities[randi() % possibilities.size()]

func transition(from : AudioStreamPlayer, to : AudioStreamPlayer, duration : float):
	print("Transition duration: " + str(duration))
	tween.interpolate_property(from, "volume_db", from.volume_db, -80, duration)
	tween.interpolate_property(to, "volume_db", -40, 0, duration)
	tween.start()

func transition_finished(_object, _key):
	pass

func create_audio_player(audio : AudioStream, volume_db := 0.0, pitch_scale := 1.0, bus := "Music") -> AudioStreamPlayer:
	var audio_stream_player : AudioStreamPlayer = AudioStreamPlayer.new()
	add_child(audio_stream_player)
	audio_stream_player.bus = bus
	audio_stream_player.stream = audio
	audio_stream_player.volume_db = volume_db
	if pitch_scale <= 0:
		pitch_scale = 0.001
	audio_stream_player.pitch_scale = pitch_scale
	audio_stream_player.connect("finished", audio_stream_player, "queue_free")
	return audio_stream_player

#func load_music_from_dir(name : String, extra_path := "", music_path := "res://assets/music/") -> Dictionary:
#	var dir = Directory.new()
#	var sounds_from_dir := {}
#	var path = music_path + extra_path + name + "/"
#	print("looking for: " + path)
#	if dir.open(path) == OK:
#		dir.list_dir_begin(true)
#		var file_name = dir.get_next()
#		while file_name != "":
#			if not dir.current_is_dir() and (file_name.ends_with("wav.import") or file_name.ends_with("ogg.import")):
#				var audio_type = file_name.replace(name + "_", "").replace(".wav.import", "").replace(".ogg.import", "")
#				print(audio_type)
#				if not audio_type in ["start", "end"]:
#					continue
#				sounds_from_dir[audio_type] = load(path + file_name.replace(".import", ""))
#			elif dir.current_is_dir() and file_name == "loops":
#				sounds_from_dir["loops"] = AudioLib.get_audio_from_dir("loops", music_path + extra_path + name)
#			file_name = dir.get_next()
#		return sounds_from_dir
#	else:
#		print("An error occurred when trying to access the path:")
#		print(path)
#		return {}
