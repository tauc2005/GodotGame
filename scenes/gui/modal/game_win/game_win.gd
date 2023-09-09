extends Control

signal on_window_closed()

@onready var modal = get_node("SizeBox/ModalWindow")


func _ready():
	modal.on_window_closed.connect(_on_window_closed)

	
func _on_window_closed():
	if Globals.DEBAG:print ("(gamewin) _on_window_closed ")
	emit_signal("on_window_closed")
	
func _on_bg_focus_entered():
	emit_signal("on_window_closed")

func _on_btn_pressed():
	if Globals.DEBAG:print ("(gamewin) _on_btn_start_pressed ")
	emit_signal("on_window_closed")

