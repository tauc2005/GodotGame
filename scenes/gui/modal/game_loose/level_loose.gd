extends Control

signal on_window_closed()
signal on_level_complited(result)
#Возвращение в игровой процесс при покупке доп ходов
signal on_return_to_game()

@onready var modal = get_node("SizeBox/VBoxContainer/ModalWindow")

func _ready():
	modal.on_window_closed.connect(_on_window_closed)
	
func _on_window_closed():
	if Globals.DEBAG:print ("(level_loose) _on_window_closed ")
	emit_signal("on_window_closed")
	emit_signal("on_level_complited",false)
	pass
	
func _on_bg_focus_entered():
	emit_signal("on_window_closed")
	emit_signal("on_level_complited",false)
	pass # Replace with function body.	

# Завершение игры
func _on_btn_pressed():
	emit_signal("on_window_closed")
	emit_signal("on_level_complited",false)
