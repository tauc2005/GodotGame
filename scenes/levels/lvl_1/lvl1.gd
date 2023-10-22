extends LevelBase
#class_name Level_1

@onready var generator = get_node("World/generator")
const level_id = 1
# правила победы уровня
const RulesData = {
	"moves":18,
	"rules": {
		"ball1": 3,
	},
	"bonus":{ 
		"money"	:7,
		"bonus_1":0,
	},
}
# правила генерации
const GeneratorRules = {
	# экран 1
	1:{		
		"max":10, # макс кол-во шариков на экране
		"min":2, 
		"rules":{
			"ball1":{ # зеленый
				"current":0,	#текущее кол-во шариков на экране
				"min":0,		# мин  кол-во шариков на экране
				"max":0, 		# макс кол-во шариков на экране
				"limit":1,		# число за игру "limited":1		# кол-во граничено
				
				},
			"ball2":{ # Синий
				"current":0,
				"min":2,
				"max":2,
				"limit":3,
				},
			"ball3":{# красный
				"current":0,
				"min":0,
				"max":0,
				"limit":0,
				},
			"ball4":{ # желтый
				"current":0,
				"min":1,
				"max":0,
				"limit":5,
				},
			"ice":{ # лед
				"current":0,
				"min":2,
				"max":0,
				"limit":5,
				},	
			}
		}
	}


# Инициализация уровня
func _ready():
	generator.set_rules(GeneratorRules)
	generator.generator_clicked.connect(append_items)
	screens.level_moved_down_to.connect(_on_level_move_down)
	
	# Условия победы
	export_scene()
	#separator.level_move_down.connect(_on_level_move_down)


	pass # Replace with function body.
func export_scene():
	Serializer.save_level(level_id,map,RulesData,get_node("World"))

func init_rules():
	Rules.Moves= RulesData["moves"]
func _on_level_move_down():
	match screens.CurrentScreen:
		1: 
			generator.visible =false
		2: 
			generator.position.y = screens.CurrentPos +100
			generator.visible = true
	pass
