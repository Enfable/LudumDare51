extends Node2D


const Card_Base = preload("res://src/Cards/CardBase.tscn")
const Enemy_Base = preload("res://src/Enemies/EnemyBase.tscn")

onready var Deck_Size = PlayerInfo.Deck_List.size()
onready var enemy_size = PlayerInfo.Enemy_List.size()
onready var x_viewport = OS.window_size.x
onready var y_viewport = OS.window_size.y
onready var hand = $HandCards
onready var MainTimer = $MainTimer
onready var inspire_timer = $InpireTimer
onready var dodge_timer = $DodgeTimer
onready var enemies = $Enemies
onready var SFX = $SoundFX
onready var Hand_Size = hand.get_children().size()

var rng = RandomNumberGenerator.new()
var card_selected = []
var enemy_selected = []
var x_card_position 
onready var y_card_position = y_viewport - 32 - 192
onready var enemy_position_start = Vector2(x_viewport - 128, y_viewport * 0.5)
var old_hand_size
var number_resets = 0
var card_drag = false

func _ready():
	rng.randomize()
	MainTimer.start()
	PlayerInfo.health = PlayerInfo.max_health
	PlayerInfo.armor = 0
	PlayerInfo.number_defeated = 0
	PlayerInfo.number_resets = 0

func _physics_process(_delta):
	$Time.text = str(floor(MainTimer.time_left) + 1)
#	$Player/Label.text = str("Health ",PlayerInfo.health, " Armor ", PlayerInfo.armor,
#	 " Boost ", int(inspire_timer.time_left), " dodge ", int(dodge_timer.time_left))
	
	$Player/Health.text = str(PlayerInfo.health)
	$Player/Armor.text = str(PlayerInfo.armor)
	$Player/Boost.text = str("Boost ", int(inspire_timer.time_left))
	$Player/Dodge.text = str("Dodge ", int(dodge_timer.time_left))
	
	old_hand_size = Hand_Size
	
	Hand_Size = hand.get_children().size()
	x_card_position = x_viewport - 64
	
	enemy_position()
	
	if Hand_Size != old_hand_size:
		card_position()
	
	if MainTimer.is_stopped():
		timer_reset()
	card_position()
	enemy_position()

func timer_reset():
	if Deck_Size > 0 && Hand_Size < 6:
		draw_card()
	#need to force hand size and position to update in middle of this function
	Hand_Size = hand.get_children().size()
	card_position()
	if Deck_Size > 0 && Hand_Size < 6:
		draw_card()
		Hand_Size = hand.get_children().size()
	card_position()
	if Deck_Size > 0 && Hand_Size < 6:
		draw_card()
		Hand_Size = hand.get_children().size()
	enemy_action()
	if enemies.get_children().size() < 4:
		summon_enemy()
	MainTimer.start()
	PlayerInfo.number_resets += 1


# calculates where the enemies should be positioned
func enemy_position():
	var enemy_pos = enemies.get_children()
	var rightmost_enemy = x_viewport - 128
	var y_enemy = y_viewport * 0.5
	var spacing = 128+32
	var t =+ 5 * get_physics_process_delta_time()
	if enemy_pos.size() == 0:
		pass
	elif enemy_pos.size() == 1:
		enemy_pos[0].position = enemy_pos[0].position.linear_interpolate(Vector2(rightmost_enemy, y_enemy),t)
	elif enemy_pos.size() == 2:
		enemy_pos[0].position = enemy_pos[0].position.linear_interpolate(Vector2(rightmost_enemy-spacing, y_enemy),t)
		enemy_pos[1].position = enemy_pos[1].position.linear_interpolate(Vector2(rightmost_enemy, y_enemy),t)
	elif enemy_pos.size() == 3:
		enemy_pos[0].position = enemy_pos[0].position.linear_interpolate(Vector2(rightmost_enemy-spacing*2, y_enemy),t)
		enemy_pos[1].position = enemy_pos[1].position.linear_interpolate(Vector2(rightmost_enemy-spacing, y_enemy),t)
		enemy_pos[2].position = enemy_pos[2].position.linear_interpolate(Vector2(rightmost_enemy, y_enemy),t)
	elif enemy_pos.size() == 4:
		enemy_pos[0].position = enemy_pos[0].position.linear_interpolate(Vector2(rightmost_enemy-spacing*3, y_enemy),t)
		enemy_pos[1].position = enemy_pos[1].position.linear_interpolate(Vector2(rightmost_enemy-spacing*2, y_enemy),t)
		enemy_pos[2].position = enemy_pos[2].position.linear_interpolate(Vector2(rightmost_enemy-spacing, y_enemy),t)
		enemy_pos[3].position = enemy_pos[3].position.linear_interpolate(Vector2(rightmost_enemy, y_enemy),t)


# calculates where cards should go when there is a change in the hand size
func card_position():
	#calculate the leftmost card
	var leftmost_card = (x_viewport * 0.5) - (64 + (80 * (Hand_Size-1)))
	var hand_array = hand.get_children()
	var t =+ 5 * get_physics_process_delta_time()
	#position each card in the array
	if hand_array.size() == 0:
		pass
	elif hand_array.size() == 1:
		hand_array[0].rect_position = hand_array[0].rect_position.linear_interpolate(Vector2(leftmost_card, y_card_position),t)
	
	elif hand_array.size() == 2:
		hand_array[0].rect_position = hand_array[0].rect_position.linear_interpolate(Vector2(leftmost_card + 160 *0, y_card_position),t)
		hand_array[1].rect_position = hand_array[1].rect_position.linear_interpolate(Vector2(leftmost_card + 160 *1, y_card_position),t)
	
	elif hand.get_children().size() == 3:
		hand_array[0].rect_position = hand_array[0].rect_position.linear_interpolate(Vector2(leftmost_card + 160 *0, y_card_position),t)
		hand_array[1].rect_position = hand_array[1].rect_position.linear_interpolate(Vector2(leftmost_card + 160 *1, y_card_position),t)
		hand_array[2].rect_position = hand_array[2].rect_position.linear_interpolate(Vector2(leftmost_card + 160 *2, y_card_position),t)
	
	elif hand.get_children().size() == 4:
		hand_array[0].rect_position = hand_array[0].rect_position.linear_interpolate(Vector2(leftmost_card + 160 *0, y_card_position),t)
		hand_array[1].rect_position = hand_array[1].rect_position.linear_interpolate(Vector2(leftmost_card + 160 *1, y_card_position),t)
		hand_array[2].rect_position = hand_array[2].rect_position.linear_interpolate(Vector2(leftmost_card + 160 *2, y_card_position),t)
		hand_array[3].rect_position = hand_array[3].rect_position.linear_interpolate(Vector2(leftmost_card + 160 *3, y_card_position),t)
	
	elif hand.get_children().size() == 5:
		hand_array[0].rect_position = hand_array[0].rect_position.linear_interpolate(Vector2(leftmost_card + 160 *0, y_card_position),t)
		hand_array[1].rect_position = hand_array[1].rect_position.linear_interpolate(Vector2(leftmost_card + 160 *1, y_card_position),t)
		hand_array[2].rect_position = hand_array[2].rect_position.linear_interpolate(Vector2(leftmost_card + 160 *2, y_card_position),t)
		hand_array[3].rect_position = hand_array[3].rect_position.linear_interpolate(Vector2(leftmost_card + 160 *3, y_card_position),t)
		hand_array[4].rect_position = hand_array[4].rect_position.linear_interpolate(Vector2(leftmost_card + 160 *4, y_card_position),t)
	
	elif hand.get_children().size() == 6:
		hand_array[0].rect_position = hand_array[0].rect_position.linear_interpolate(Vector2(leftmost_card + 160 *0, y_card_position),t)
		hand_array[1].rect_position = hand_array[1].rect_position.linear_interpolate(Vector2(leftmost_card + 160 *1, y_card_position),t)
		hand_array[2].rect_position = hand_array[2].rect_position.linear_interpolate(Vector2(leftmost_card + 160 *2, y_card_position),t)
		hand_array[3].rect_position = hand_array[3].rect_position.linear_interpolate(Vector2(leftmost_card + 160 *3, y_card_position),t)
		hand_array[4].rect_position = hand_array[4].rect_position.linear_interpolate(Vector2(leftmost_card + 160 *4, y_card_position),t)
		hand_array[5].rect_position = hand_array[5].rect_position.linear_interpolate(Vector2(leftmost_card + 160 *5, y_card_position),t)
	else:
		print("error too many cards in hand")


#draws a card and puts it into the players hand
func draw_card():
	PlayerInfo.Deck_List.shuffle()
	var new_card = Card_Base.instance()
	card_selected = rng.randi() % Deck_Size
	new_card.Card_Name = PlayerInfo.Deck_List[card_selected]
	new_card.rect_position = Vector2(x_card_position, y_card_position)
	hand.add_child(new_card)

#discards a card into the disard pile
func discard_card():
	var dead_card = Card_Base.instance()
	card_selected = rng.randi() % Hand_Size
	dead_card.Card_Name = hand.get_children()[card_selected]
	hand.get_children()[card_selected].queue_free()


func enemy_action():
	for enemy in enemies.get_children():
		enemy.do_action()
		enemy.next_action()

func summon_enemy():
	PlayerInfo.Enemy_List.shuffle()
	var new_enemy = Enemy_Base.instance()
	enemy_selected = rng.randi() % 4
	new_enemy.Enemy_Name = PlayerInfo.Enemy_List[enemy_selected]
	new_enemy.position = enemy_position_start + Vector2(128,0)
	new_enemy.next_action()
	enemies.add_child(new_enemy)

# name / description / damage / block / heal / dodge bool 
# boost bool / draw number /discard number
func card_effect(card):
	var drag_card_data = card.get_parent()
	damage(int(str(drag_card_data.Card_Info[2])))
	block(int(str(drag_card_data.Card_Info[3])))
	heal(int(str(drag_card_data.Card_Info[4])))
	dodge(int(str(drag_card_data.Card_Info[5])))
	boost(int(str(drag_card_data.Card_Info[6])))
	discard(int(str(drag_card_data.Card_Info[8])))
	drawcard(int(str(drag_card_data.Card_Info[7])))
	damageAOE(int(str(drag_card_data.Card_Info[9])))
	var Card_Sound = str("res://src/Sound/",drag_card_data.Card_Info[0],".wav")
	SFX.stream = load(Card_Sound)
	SFX.play()
	drag_card_data.queue_free()
	

func damage(amount):
	if amount == 0:
		return
	if !inspire_timer.is_stopped():
		amount += 3
	if enemies.get_children().size() == 0:
		return
	enemies.get_children()[0].take_damage(amount)

func block(amount):
	PlayerInfo.guard(amount)

func heal(amount):
	PlayerInfo.heal(amount)

func dodge(value):
	if value == 1:
		if dodge_timer.is_stopped():
			dodge_timer.start()
		else:
			dodge_timer.stop()
			dodge_timer.start()

func boost(value):
	if value == 1:
		if inspire_timer.is_stopped():
			inspire_timer.start()
		else:
			inspire_timer.stop()
			inspire_timer.start()

func drawcard(amount):
	var i = 0
	while i < amount:
		if Deck_Size > 0 && Hand_Size < 6:
			draw_card()
		#need to force hand size and position to update in middle of this function
		Hand_Size = hand.get_children().size()
		card_position()
		i += 1

func discard(amount):
	var i = 0
	while i < amount:
		if Hand_Size > 0:
			discard_card()
		#need to force hand size and position to update in middle of this function
		Hand_Size = hand.get_children().size()
		card_position()
		i += 1

func damageAOE(amount):
	if amount == 0:
		return
	if !inspire_timer.is_stopped():
		amount += 3
	if enemies.get_children().size() == 0:
		return
	for enemy in enemies.get_children():
		enemy.health -= amount
