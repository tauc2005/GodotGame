extends Control

signal on_window_closed()
signal on_game_start()

@onready var modal = get_node("SizeBox/ModalWindow")

@export var Level:int = 0 : #_set set_caption
	get: 
		return Level
	set(value): 
		Level= value
		$SizeBox/ModalWindow.set("Caption","Уровень %d"% Level)

func _ready():
	modal.on_window_closed.connect(_on_window_closed)
	pass
	
func _on_window_closed():
	if Globals.DEBAG:print ("(gamebefore) _on_window_closed ")
	emit_signal("on_window_closed")
	pass
	
func _on_bg_focus_entered():
	emit_signal("on_window_closed")
	pass # Replace with function body.	

func _on_btn_start_pressed():
	if Globals.DEBAG:print ("(gamebefore) _on_btn_start_pressed ")
	emit_signal("on_window_closed")
	emit_signal("on_game_start")
	pass # Replace with function body.
