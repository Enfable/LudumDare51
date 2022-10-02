extends Control


func _on_StartGame_pressed():
	SceneChanger.change_scene("res://src/Levels/BattleScene.tscn")


func _on_Options_pressed():
	SceneChanger.change_scene("res://src/Levels/ControlsScene.tscn")
