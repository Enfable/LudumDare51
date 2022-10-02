extends Node


enum {
	Slash, Guard, Inspire, Quickdraw, Loot, QuickManuvers, BeatDown, Pray, Fireball, KnifeThrow
}
# dodge reduces damage taken by half
# boost increases damage dealt per card by 3

# name / description / damage / block / heal / dodge time /
# boost time / draw number /discard number / damage AOE
const DATA = {
	Slash:
		["Slash", "Deal 10 Damage", 10,0,0,0,0,0,0,0],
	
	Guard:
		["Guard", "Gain 10 Block", 0,10,0,0,0,0,0,0],
	
	Inspire:
		["Inspire", "Gain Boost And Gain Dodge", 0,0,0,1,1,0,0,0],
	
	Quickdraw:
		["Quickdraw", "Deal 3 Damage Draw 1 Card", 3,0,0,0,0,1,0,0],
	
	Loot:
		["Loot", "Discard A Random Card Then Draw 3 Cards",0,0,0,0,0,3,1,0],
	
	QuickManuvers:
		["Quick Manuvers", " Deal 3 Damage And Gain Dodge", 3,0,0,1,0,0,0,0],
	
	BeatDown:
		["Beat Down", "Deal 3 Damage And Gain Boost", 3,0,0,0,1,0,0,0],
	
	Pray:
		["Pray", "Heal 8 Health", 0,0,8,0,0,0,0,0],
	
	Fireball:
		["Fireball", "Deal 8 Damage To All Enemies", 0,0,0,0,0,0,0,8],
	
	KnifeThrow:
		["Knife Throw", "Deal 1 Damage To All Enemies Then Draw A Card", 0,0,0,0,0,1,0,1]
}
