extends Control
class_name ModalWindow

signal on_window_closed()

@export var Caption:String = "Заголовок" #_set set_caption
@export var ShowExitButton:bool = true
@export var ShowBackGround:bool = true

@onready var ui_caption = get_node("MarginContainer/NameWnd/Box/CaptionLabel")

func _on_window_closed():
	print ("(settings) _on_window_closed ")
	emit_signal("on_window_closed")
	pass # Replace with function body.


func set_caption():
	if not ui_caption == null:
		ui_caption.set("text", Caption)
	pass

func update():
	set_caption()
	

func _ready():
	update()
	pass # Replace with function body.
