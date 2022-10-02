extends Sprite

var Enemy_Name = "Soldier"

onready var Enemy_Database = preload("res://src/Enemies/Enemy_Database.gd")
onready var Enemy_Info = Enemy_Database.DATA[Enemy_Database.get(Enemy_Name)]
onready var Enemy_Art = str("res://src/Art/EnemyArt/",Enemy_Info[0],".png")
onready var healthlabel = $Health
onready var shieldlabel = $Shield
onready var actionlabel = $Action

onready var max_health = Enemy_Info[1] + PlayerInfo.number_resets
onready var health = max_health
var armor = 0
var max_armor = max_health

var rng = RandomNumberGenerator.new()
var action = ""

func _ready():
	texture = load(Enemy_Art)

#name / max health / current health / damage / guard / heal
func next_action():
	var action_select = rng.randi() % 5
	match action_select:
		0:
			action = "damage"
		1:
			action = "guard"
		2:
			action = "guard"
		3:
			action = "idle"
		4:
			action = "damage"

func do_action():
	match action:
		"damage":
			PlayerInfo.take_damage(Enemy_Info[3])
		"guard":
			armor += Enemy_Info[4]
		"heal":
			health += Enemy_Info[5]
		"idle":
			pass

func take_damage(amount):
	armor -= amount
	if armor < 0:
		health += armor
		armor = 0

func _physics_process(_delta):
	healthlabel.text = str(health)
	shieldlabel.text = str(armor)
	actionlabel.text = str(action)
	if health >= max_health:
		health = max_health
	
	if health <= 0:
		PlayerInfo.number_defeated += 1
		queue_free()
