class_name HurtBox
extends Area2D

var area_entered = false

func _ready():
# warning-ignore:return_value_discarded
	connect("area_entered", self, "_on_area_entered")

func _on_area_entered(card: HitBox):
	area_entered = true
	if card == null:
		return
	if owner.has_method("card_effect"):
		owner.card_effect(card)


func _on_area_exited():
	area_entered = false
