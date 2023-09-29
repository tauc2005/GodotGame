extends LevelBase
#class_name Level_1

@onready var generator = get_node("World/generator")
const level_id = 1

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
# Инициализация уровня
func _ready():
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
