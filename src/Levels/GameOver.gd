extends Control

onready var Player_Stats = $PlayerStats

func _physics_process(delta):
	Player_Stats.text = str("You Defeated ", PlayerInfo.number_defeated, " Enemies")


func _on_TryAgain_pressed():
	SceneChanger.change_scene("res://src/Levels/BattleScene.tscn")


func _on_MainMenu_pressed():
	SceneChanger.change_scene("res://src/Levels/TitleScreen.tscn")
