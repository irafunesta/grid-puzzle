extends Node2D
class_name SimpleCell

@export var width = 32
@export var height = 32

var active = false;
var gridId = 0
var isMouseEntered = false;

var activeColor : Color = Color.WHITE
var unactiveColor : Color = Color.GRAY

@onready var label = $Label
@onready var cellRect = $ColorRect2
# Called when the node enters the scene tree for the first time.
func _ready():
	label.text = str(gridId)
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	match (active):
		true:
			cellRect.color = activeColor
		false:
			cellRect.color = unactiveColor
	pass
	
func setId(id):
	gridId = id
	label.text = str(gridId)

func setActive(value):
	active = value
	

#the cell will work dragging pieces on it, so the click is not necessary
func _input(event):
	if event is InputEventKey:
		if event.pressed and event.keycode == KEY_ESCAPE:
			print("esc on cell ", gridId)
	if event is InputEventMouseButton:
		#1 is left mouse
		if event.pressed and event.button_index == 1 and isMouseEntered:
			print("left click on cell ", gridId)
#			setActive(!active)
	


func _on_area_2d_mouse_entered():
	isMouseEntered = true
	pass # Replace with function body.


func _on_area_2d_mouse_exited():
	isMouseEntered = false
	pass # Replace with function body.


