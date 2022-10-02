extends MarginContainer

var Card_Name = "Slash"

onready var Card_Database = preload("res://src/Cards/Card_Database.gd")
onready var Card_Info = Card_Database.DATA[Card_Database.get(Card_Name)]
onready var Card_Art = str("res://src/Art/CardArt/",Card_Info[0],".png")

onready var Card_Name_Label = $VBoxContainer/NameBar/CardNameBox/CardName
onready var Card_Text_Label = $VBoxContainer/TextBar/MarginContainer2/CardText
onready var Card_Size = rect_size

enum {
	InHand,
	InPlay,
	FocusInHand
}

var state = InHand

func _ready():
	if $CardArt.texture == null:
		$CardArt.texture = load("res://src/Art/CardArt/CardCanvase.png")
	
	$CardArt.texture = load(Card_Art)
	$CardArt.scale = Vector2(2,2)
	
	
	Card_Name_Label.text = str(Card_Info[0])
	
	Card_Text_Label.text = str(Card_Info[1])


func _physics_process(_delta):
	match state:
		InHand:
			pass
		
		InPlay:
			pass
		
		FocusInHand:
			if Input.is_action_pressed("left_click"):
				rect_position = get_global_mouse_position() - Card_Size * 0.5


func _on_CardBase_mouse_entered():
	state = FocusInHand


func _on_CardBase_mouse_exited():
	state = InHand
