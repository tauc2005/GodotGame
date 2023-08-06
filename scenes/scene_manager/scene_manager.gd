extends CanvasLayer
class_name SceneManager
## Класс SceneManager занимается отображением окон приложении

# Сигнал на запуск игры
signal on_game_start()
signal on_game_end()

# GUI
@onready var ui_mainMenu = get_node("GUI/MainMenu")
@onready var ui_gameMenu = get_node("GUI/GameMenu")
@onready var wnd_settings = get_node("GUI/Modals/Settings")
@onready var wnd_before_game = get_node("GUI/Modals/BeforeGame")

# Called when the node enters the scene tree for the first time.
func _ready():
	#Связываем сигналы
	ui_mainMenu.on_show_gui_window.connect(show_window)
	ui_gameMenu.on_show_gui_window.connect(show_window)
	
	#закрытие модальных окон
	wnd_settings.on_window_closed.connect(hide_window.bind("settings"))
	wnd_before_game.on_window_closed.connect(hide_window.bind("before_game"))
	
	# Запуск игры
	wnd_before_game.on_game_start.connect(_on_game_start)
	pass # Replace with function body.


#------------------------------------------------
# Навигация между окнами
#------------------------------------------------
func show_window(wnd_name:String):
	print ("(SceneManager)   -> show_window("+wnd_name+")")
	match wnd_name:
		"": printerr("(SceneManager)   -> show_window - empty param! ")
		"main": show_main()
		"game": show_game()
		# Модальные окна
		"settings":    wnd_settings.visible = true
		"before_game": wnd_before_game.visible = true
	pass
	
func hide_window(wnd_name:String):
	print ("(SceneManager)   -> hide_window("+wnd_name+")")
	match wnd_name:
		"": printerr("(SceneManager)   -> show_window - empty param! ")
		"main": show_main()
		"game": show_game()
		"settings":  wnd_settings.visible = false
		"before_game": wnd_before_game.visible = false
	pass	
#------------------------------------------------
func show_main():
	ui_mainMenu.visible = true
	ui_gameMenu.visible = false
	_on_game_ended()
	pass
	
func show_game():
	ui_mainMenu.visible = false
	ui_gameMenu.visible = true
	pass
#------------------------------------------------
# Запуск игры
func _on_game_start():
	if Globals.DEBAG:print ("(SceneManager)   -> _on_game_start")
	emit_signal("on_game_start")

func _on_game_ended():
	emit_signal("on_game_end")
