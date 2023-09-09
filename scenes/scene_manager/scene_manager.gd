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
@onready var wnd_game_loose = get_node("GUI/Modals/LevelLoose")
@onready var wnd_game_win= get_node("GUI/Modals/GameWin")

#Счетчик окон при поражении
var _cnt_show_buy_moves :int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	#Связываем сигналы
	ui_mainMenu.on_show_gui_window.connect(show_window)
	ui_gameMenu.on_show_gui_window.connect(show_window)

	#закрытие модальных окон
	wnd_settings.on_window_closed.connect(hide_window.bind("settings"))
	wnd_before_game.on_window_closed.connect(hide_window.bind("before_game"))
	wnd_game_loose.on_window_closed.connect (hide_window.bind("game_loose"))
	wnd_game_win.on_window_closed.connect   (hide_window.bind("game_win"))
	
	# Запуск игры
	wnd_before_game.on_game_start.connect(_on_game_start)
	
	# Завершение уровня
	Rules.on_level_complited.connect(_on_level_complited)	
	#wnd_game_win.on_game_complite.connect (_on_game_complite)
	wnd_game_loose.on_level_complited.connect(_on_level_complited)

	# Возврат в игру
	wnd_game_loose.on_return_to_game.connect (hide_window.bind("game_loose"))
#------------------------------------------------
## Навигация между окнами
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
		"game_loose" : wnd_game_loose.visible = true
		"game_win"	 : wnd_game_win.visible = true
	pass
	
func hide_window(wnd_name:String):
	print ("(SceneManager)   -> hide_window("+wnd_name+")")
	match wnd_name:
		"": printerr("(SceneManager)   -> show_window - empty param! ")
		"main": show_main()
		"game": show_game()
		"settings":  wnd_settings.visible = false
		"before_game": wnd_before_game.visible = false
		"game_loose" : wnd_game_loose.visible = false
		"game_win"	 : 
			wnd_game_win.visible = false
			show_main()
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
#------------------------------------------------
func _on_game_start():
	if Globals.DEBAG:print ("(SceneManager)   -> _on_game_start")
	emit_signal("on_game_start")

func _on_game_ended():
	emit_signal("on_game_end")
#------------------------------------------------

#------------------------------------------------
## Изменение игровых данных
#------------------------------------------------
## Изменениие данных игрока
func player_changed(type:String,value:int):
	if Globals.DEBAG:print ("(SceneManager)   player_changed ->%s (%d)" % [type,value])
	match type:
		"Lives": ui_mainMenu.update(type,value)
		"Money": ui_mainMenu.update(type,value)
		"Level": wnd_before_game.Level = value
#------------------------------------------------
# Изменились данные игры
func level_data_changed():
	if Globals.DEBAG:print ("(SceneManager)   level_data_changed ")
	pass
#------------------------------------------------
# Показ окна в зависимости от наличия денег, просмотренной рекламы	
func _on_level_complited(result:bool):
	if Globals.DEBAG: 
		print ("(SceneManager) -> _on_level_complited %s" % result) 
	if result: # Уровень пройден
		show_window("game_win")
		_cnt_show_buy_moves = 0
	else: # проигрыш
		match _cnt_show_buy_moves:
			0: # Возможность получить 5 ходов за 100 монет
				show_window("game_loose")
				_cnt_show_buy_moves +=1
			1 :	
				show_main()
				_cnt_show_buy_moves=0

