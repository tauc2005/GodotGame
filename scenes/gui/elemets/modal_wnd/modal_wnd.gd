extends Control
class_name ModalWindow

signal on_window_closed()

@export var Caption:String = "Заголовок" : #_set set_caption
	get: 
		return Caption
	set(value): 
		Caption= value
		$MarginContainer/NameWnd/Box/CaptionLabel.set("text",Caption)
		
@export var ShowExitButton:bool = true:
	get: 
		return $MarginContainer/BtnClose.visible
	set(value):
		$MarginContainer/BtnClose.visible = value

@export var ShowBackGround:bool = true

func _on_window_closed():
	print ("(settings) _on_window_closed ")
	emit_signal("on_window_closed")
	pass # Replace with function body.
