extends PanelContainer

@export var sfx_audio_name: String = ""
@export var mus_audio_name: String = ""
@onready var sfxplayer = $MarginContainer/VBoxContainer/SFX
@onready var musicplayer = $MarginContainer/VBoxContainer/Music
@onready var GameSlider = $MarginContainer/VBoxContainer/GameSlider
@onready var MusicSlider = $MarginContainer/VBoxContainer/MusicSlider

func _on_game_slider_value_changed(value):
	var audio_index = AudioServer.get_bus_index(sfx_audio_name)
	if value > GameSlider.min_value:
		var volume_db = linear_to_db(value)
		AudioServer.set_bus_mute(audio_index, false)
		AudioServer.set_bus_volume_db(audio_index, volume_db)
	else:
		AudioServer.set_bus_mute(audio_index, true)
	sfxplayer.play()


func _on_music_slider_value_changed(value):
	var audio_index = AudioServer.get_bus_index(mus_audio_name)
	if value > MusicSlider.min_value:
		var volume_db = linear_to_db(value)
		AudioServer.set_bus_mute(audio_index, false)
		AudioServer.set_bus_volume_db(audio_index, volume_db)
	else:
		AudioServer.set_bus_mute(audio_index, true)
	musicplayer.play()
