extends RigidBody2D
class_name BallItem 

const node_type = "ball"
signal block_clicked(block)

@export var color: int = 1 # setget set_color, get_color
@export var level:int =1

var need_to_delete= false
var delete = false


func _ready():
	add_to_group(Globals.GO_GROUPS_NAMES[Globals.GO_TYPES.BALL])
	pass # Replace with function body.

# На шарик нажали 
func _on_ball_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		emit_signal("block_clicked",self) 
		print("block_clicked",self)
	pass # Replace with function body.

func destroy():
	_level_down()
	if level==0:
		queue_free()
#------------------------------------------------
# Получение типа
func get_type()-> String:
	return node_type		
#------------------------------------------------	
# ЦВЕТ
#------------------------------------------------
#Получение цвета
func get_color ():
	return color
	
# Изменение цвета окраски кнопки
func set_color(new_color:int)->void:
	color = new_color
	$Sprite.set_modulate(Globals.Ball_ColorMap[color])
	pass
#------------------------------------------------	
# Сложность
#------------------------------------------------
func set_level(value):
	level = value	

func _level_down():
	level -=1	
#------------------------------------------------	
#------------------------------------------------	
# ПОЗИЦИЯ
#------------------------------------------------	
#------------------------------------------------
func check_inside(pos)->bool:
	var size = 25
	if pos.x >position.x - size and pos.x<position.x+size and pos.y >position.y - size and pos.y<position.y+size:
		return true
	return false	
#------------------------------------------------
# Соседи
#------------------------------------------------
func get_collision():
	var tmp =  get_colliding_bodies().duplicate()
	return tmp
#------------------------------------------------
