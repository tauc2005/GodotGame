extends StaticBody2D
const node_type = "generator"
##------------------------------------------------
## Элемент из которого формируются другие динамические элементы на уровне
##------------------------------------------------
# Сигнал о формировании новых элементов
signal generator_clicked (blocks)
#------------------------------------------------
#Точка формирования элементов
@onready var positionPoint = get_node("button/ColorRect/point")
# Ссылка на ноду с уровнем
@onready var node_level= self.get_parent()

# Текущий экран
var _active_screen =1
# Правила генерации
var _GRules=Dictionary()	
var _current = Dictionary()	
var _current_balls = 0
#------------------------------------------------
func serialize():
	pass

func deserialize (_data:Dictionary):

	pass


#------------------------------------------------
func set_rules(new_rules:Dictionary):
	_GRules= new_rules

## Автозапуск генератора		
var _wait_time = 1
var _current_time = 0

func _process(delta: float):
	_current_time += 1*delta
	if (_current_time>=_wait_time): 
		start()
		_current_time =0
	pass
#------------------------------------------------
# Запуск генератора
func start():
	var activeRules = _GRules[_active_screen]['rules']
	
	var _items= Array()
	for ruleName in activeRules:	
		if (check_item(ruleName,activeRules[ruleName])):
			_items.append(ruleName)
	
	var _blocks = Array()
	for _rulename in _items:
		if  _GRules[_active_screen]['max']>_current_balls:
			make_blocks(_rulename)

func check_item(ruleName,_rule):
	if !_current.has(ruleName):
			_new_rule(ruleName,_rule)
			
	var element = _current[ruleName]	
	if (!_rule['limit']==0):
		if (element['count']>_rule['limit']): # Проверка доступных элементов
			if (element['current']>=_rule['min']): # Проверка нижней границы
				if (element['current']>=_rule['max']): # Проверка верхней границы
					return false
	return true
	
func _new_rule(ruleName,_rule):
	var _item = {
		'current': _rule['current'],
		'count':0
	}
	_current_balls +=_rule['current']
	_current.merge({ruleName:_item})	
# обновление информации при уничтожении шарика	
func _on_destroyed_block(item):
	var rule_name = item.get_type()
	if (rule_name =='ball'):
		rule_name = "ball%s" % item.get_color()
	if _current.has(rule_name):
		_current_balls -= 1
		_current[rule_name]['current'] -=1
	

func make_blocks(rule_name:String):
	var _gotype = Globals.GO_TYPES_from_str(rule_name)
	var _level = 1;
	var _color:int =0
	if (rule_name.contains("ball")):
		_gotype = Globals.GO_TYPES.BALL
		_color = int(rule_name.erase(0,4))
		_current_balls +=1
	
	var blocks = make_new_block(_gotype,_level,_color)
	emit_signal("generator_clicked",[blocks])
	_current[rule_name]['current'] +=1
	_current[rule_name]['count'] +=1
	pass
	
# Создаем новый блок
func make_new_block(go_type, level=1, color=0):
	#print("(generator) -> make_new_block")
	var rand = RandomNumberGenerator.new()
	rand.randomize()
	
	var block = null
	match (go_type):
		Globals.GO_TYPES.BALL:	
			block = Globals.BallItem.instantiate()
			block.set_color (color)
			block.block_die.connect(_on_destroyed_block)
		Globals.GO_TYPES.EGG: 
			block = Globals.EggItem.instantiate()
			block.add_to_group("balls")
		Globals.GO_TYPES.STONE : 
			block = Globals.StoneItem.instantiate()
			block.set_level(level)	
		Globals.GO_TYPES.ICE : 
			block = Globals.IceItem.instantiate()
			block.set_level(level)		
	
	block.position =positionPoint.global_position
	block.position.x += rand.randi_range(0,20)
	block.position.y -= rand.randi_range(10,40)
	block.sleeping = true
	
	return block
