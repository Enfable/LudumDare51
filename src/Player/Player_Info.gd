extends Node

#controls the weight of each card in the deck
const Deck_List = [
	"Slash", "Slash", "Slash", "Slash",
	"Guard", "Guard",
	"Inspire", 
	"Pray",
	"Quickdraw", "Quickdraw",
	"Loot", "Loot",
	"Fireball", "Fireball",
	"BeatDown", "BeatDown"
	]

const Enemy_List = [
	"Soldier", "Guardsman", "Wizard", "Archer"
]

var health = 50
const max_health = 50
var armor = 0
const max_armor = 50
var number_resets = 0
var number_defeated = 0

func _physics_process(_delta):
	if health > max_health:
		health = max_health

func take_damage(amount):
	armor -= amount
	if armor < 0:
		health += armor
		armor = 0
	if health <= 0:
		SceneChanger.change_scene("res://src/Levels/GameOver.tscn")

func heal(amount):
	health += amount

func guard(amount):
	armor += amount
	if armor > max_armor:
		armor = max_armor

func _ready():
	pass 
