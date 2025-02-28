extends Node

const DEBAG = true
const DEBAG_LOCAL = true
#------------------------------------------------
# Максимально доступное кол-во жизней
const MAX_LIFES = 5
# Стоимость доп жизни
const MONEY_FOR_LIFE = 50
# Стоимость доп ходов
const MONEY_FOR_MOVES = 100
# Сколько ходов дается при покупке за деньги и рекламу
const MOVES_BY_MONEY = 5
const MOVES_BY_ADS = 3
#------------------------------------------------
# Игровые таймеры (в секундах)
const TIME_TO_NEXT_LIFE = 10 
const TIME_TO_CANBUY_MOVES_BY_MONEY = 100
const TIME_TO_CANBUY_MOVES_BY_ADS  = 100
#------------------------------------------------
#------------------------------------------------
# Адрес к бекенду
const SERVER_BACKSIDE_PATH = "https://games.redsparrow.ru/popitka/bk"
const SERVER_BACKSIDE_PATH_LOCAL = "http://localhost/godot/popitka/bk"
# Адреса загрузки уровней
const LEVELS_PATH = "https://games.redsparrow.ru/popitka/levels"
#const LEVELS_PATH_LOCAL2 = "http://localhost/godot/popitka/levels"
#const LEVELS_PATH_LOCAL3 = "res://debag/levels"

const LEVELS_PATH_LOCAL = "res://levels"
const LEVELS_PATH_LOCAL1 = "D://Kurennaya_as/Projects/godot/popits/levels"
#------------------------------------------------
#------------------------------------------------
# Карта цветов шариков
const Ball_ColorMap = {
		0:Color(1,1,1),
		1:Color(0,1,0),
		2:Color(0,0,1),
		3:Color(1,0,0),
		4:Color(1,1,0),
		}
#------------------------------------------------
# Игровые типы
#------------------------------------------------
enum GO_TYPES {BALL,BUSTER,STONE,ICE,EGG,KEY,LOCKER,CHAIN}

const GO_GROUPS_NAMES = {
	GO_TYPES.BALL: 		"balls",
	GO_TYPES.BUSTER: 	"buster",
	GO_TYPES.STONE: 	"stones",
	GO_TYPES.ICE:  		"stones",
	GO_TYPES.CHAIN: 	"chains",
	GO_TYPES.LOCKER:	"colored",
	}		

func get_group (type):
	var gr= get_tree().get_nodes_in_group(GO_GROUPS_NAMES[type])
	return gr	

func GO_TYPES_from_str(id:String):
	var res = Globals.GO_TYPES.BALL
	match  (id):
		"balls": res  = Globals.GO_TYPES.BALL	
		"buster": res  = Globals.GO_TYPES.BUSTER
		"stone": res  = Globals.GO_TYPES.STONE
		"ice"  : res  = Globals.GO_TYPES.ICE
		"egg": res  = Globals.GO_TYPES.EGG
		"key": res  = Globals.GO_TYPES.KEY
		"locker": res  = Globals.GO_TYPES.LOCKER
		"chain": res  = Globals.GO_TYPES.CHAIN
	return res

func GO_TYPES_as_str(id:int):
	var res = "ball"
	match  (id):
		Globals.GO_TYPES.BALL : res  = "balls" 
		Globals.GO_TYPES.BUSTER: res  ="buster"
		Globals.GO_TYPES.STONE: res  ="stone"
		Globals.GO_TYPES.ICE : res  = "ice"
		Globals.GO_TYPES.EGG: res  = "egg"
		Globals.GO_TYPES.KEY: res  = "key"
		Globals.GO_TYPES.LOCKER: res  = "locker"
		Globals.GO_TYPES.CHAIN: res  = "chain"

	return res		
#------------------------------------------------
#------------------------------------------------
# Правила победы
#------------------------------------------------	
enum GAME_STATUS {NONE,GAME,WIN,LOSE,TRY_AGAIN,LOSE_HAS_MOVES,LOSE_NO_MOVES} 

enum RULE_TYPE  {NONE,BALL1,BALL2,BALL3,BALL4,EGG,STONE,ICE} 
const RuleItem= preload("res://game/ruleItem.gd")

# Текстуры для правил победы
const RULE_TYPE_IMG = {
	RULE_TYPE.NONE: "",
	RULE_TYPE.BALL1: preload("res://assets/img/0.png"),
	RULE_TYPE.BALL2: preload("res://assets/img/0.png"),
	RULE_TYPE.BALL3: preload("res://assets/img/0.png"),
	RULE_TYPE.BALL4: preload("res://assets/img/0.png"),
	RULE_TYPE.EGG:  preload("res://assets/img/egg.png"),
	RULE_TYPE.ICE:  preload("res://assets/img/ice.png"),
}

func get_rule_type(rule):
	var _type = null
	match rule:
		0      : _type =  Globals.RULE_TYPE.NONE
		"ball1": _type =  Globals.RULE_TYPE.BALL1
		"ball2": _type =  Globals.RULE_TYPE.BALL2
		"ball3": _type =  Globals.RULE_TYPE.BALL3
		"ball4": _type =  Globals.RULE_TYPE.BALL4
		"egg":	 _type =  Globals.RULE_TYPE.EGG
		"stone": _type =  Globals.RULE_TYPE.STONE
		"ice": 	 _type =  Globals.RULE_TYPE.ICE
	if _type ==null:
		printerr("(global) -> get_rule_type. Type not found %s" % rule)
		return		
	return _type
#------------------------------------------------
#------------------------------------------------
# Базовые игровые элементы
#------------------------------------------------
# Статика
const WallPolyItem = preload("res://scenes/game_objects/wall/wall.tscn")
const GeneratorItem = preload("res://scenes/game_objects/generator/generator.tscn")
#const GrassItem = preload("res://scenes/game_objects/grass/grass.tscn")


# Динамика
const BallItem  = preload("res://scenes/game_objects/items/ball/ball.tscn")
const IceItem   = preload("res://scenes/game_objects/items/ice/ice.tscn")
const StoneItem = preload("res://scenes/game_objects/items/stone/stone.tscn")
const EggItem   = preload("res://scenes/game_objects/items/egg/egg.tscn")


# Птички
const BusterItem = preload("res://scenes/game_objects/items/busters/buster.tscn")
#
#const Booster_KillerItem = preload("res://scenes/game_objects/booster/killer.tscn")

# Цепь обычная
#const ChainItem = preload("res://interface/go/chain/chain.tscn")
#const ChainBlockItem = preload("res://interface/go/chain/chain_block.tscn")
#const ChainLinkItem  = preload("res://interface/go/chain/link.tscn")

# Замок и ключ
#const LockerItem = 	  preload("res://interface/go/locker/locker.tscn") 
#const LockerKeyItem = preload("res://interface/go/locker/key.tscn") 

enum DIRECTION {UP,DOWN,LEFT,RIGHT}


#------------------------------------------------
# Бустеры - усилители
const BUSTER_BIRDS_TEXTURES = {
	1: preload("res://assets/img/buster1.png"),
	2: preload("res://assets/img/buster2.png"),
	3: preload("res://assets/img/buster3.png"),
} 


#------------------------------------------------
# Текстуры для усилителей
const BOOSTER_TYPE_DATA = {
	1:{
		"img": preload("res://assets/img/booster1.png"),
		"money": 150,
		"value": 3
	},
	2:{
		"img": preload("res://assets/img/booster2.png"),
		"money": 500,
		"value": 3
	},
	3:{
		"img": preload("res://assets/img/booster3.png"),
		"money": 300,
		"value": 3
	}}
	
#------------------------------------------------

#------------------------------------------------
# Функция определения попадания элемента в заданный прямоугольник
# возвращает true если более 50% попадает 
func check_item_in_rect(item:Node,rect: Rect2)->bool:
	if item == null: return false
	var _rect = Rect2(
		snapped(rect.position.x,0.001),
		snapped(rect.position.y,0.001),
		snapped(rect.size.x,0.01),
		snapped(rect.size.y,0.01))		
	var _point = item.global_position
	# Центр попадает в прямоугольник
	if _rect.has_point(_point): 
		print ("point: ",_point, " in rect ", _rect , " - true (%s)"% item.name)
		return true
	#	if _point.x >rect.x-rect.size) and (_point.x <_center.x+w) and (_point.y >_center.y-w) and (_point.y <_center.y+w)
	print ("point: ",_point, " in rect ", _rect , " - false")
	return false
