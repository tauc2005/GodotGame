extends Node



# Called when the node enters the scene tree for the first time.
@onready var GUI = get_node("SceneManager")
@onready var Game = get_node("Game")


func _ready():
	if Globals.DEBAG: print ("(main)   -> _ready ")
	GUI.on_game_start.connect(_on_game_start)
	GUI.on_game_end.connect(_on_game_end)
	
	# GUI  и данные игрока
	Player.on_player_data_changed.connect(GUI.player_changed)
	
	Loader.load_userdata()

	pass
	

#------------------------------------------------
# СТАРТ ИГРЫ	
#------------------------------------------------
func _on_game_start():
	if Globals.DEBAG: print ("(main)   -> _on_game_start ")
	Game.startGame()
	#Отображение игрового интерфейса
	GUI.show_game()

func _on_game_end():
	if Globals.DEBAG: print ("(main)   -> _on_game_end ")
	Game.exitGame()

# Таймер жизни сделал расчет
func _on_lifeTimer_finnished():
	Player.Lives +=1 

