extends Control
class_name ModalWindow

signal on_window_closed()

@onready var GUI_caption = get_node("MarginContainer/NameWnd/Box/CaptionLabel")
@onready var GUI_btn_close = get_node("MarginContainer/BtnClose")

@export var Caption:String = "Заголовок" : #_set set_caption
	get: 
		return Caption
	set(value): 
		Caption= value
		if not GUI_caption: return
		GUI_caption.set("text",Caption)
		
@export var ShowExitButton:bool = true:
	get: 
		if not GUI_btn_close: return false 
		return GUI_btn_close.get("visible")
	set(value):
		GUI_btn_close.set("visible",value)

@export var ShowBackGround:bool = true



func _on_window_closed():
	print ("(settings) _on_window_closed ")
	emit_signal("on_window_closed")
	pass # Replace with function body.
