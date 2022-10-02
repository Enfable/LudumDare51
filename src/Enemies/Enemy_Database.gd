extends Node


enum {
	Soldier, Guardsman, Priest, Wizard, Archer
	}

#name / max health / current health / damage / guard / heal
const DATA = {
	Soldier: 
		["Soldier", 20, 20, 8, 4, 0],
	Guardsman:
		["Guardsman", 30, 30, 4, 8, 0],
#	Priest:
#		["Priest", 15, 15, 4, 4, 8],
	Wizard:
		["Wizard", 10, 10, 15, 0, 0],
	Archer:
		["Archer", 15, 15, 10, 4, 0]
}

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
