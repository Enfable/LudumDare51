extends Control


func _ready():
	MusicController.play_music()
	SceneChanger.change_scene("res://src/Levels/TitleScreen.tscn")
