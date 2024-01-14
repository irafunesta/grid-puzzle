extends Node2D
class_name Grid

@export var rows = 3;
@export var cols = 3;
@export var canMove = false;
@export var values : Array[bool]
@export var pieceId = -1;

@export  var scene : PackedScene

var grid = Array()

var shape : RectangleShape2D
var collisionNode : CollisionShape2D
var underMouse = false
var held = false;
var pieceOnGrid = false;
var startingPosition : Vector2

var cellWidth = 0
var cellHeight : float = 0

@onready var cellObj = scene;
@onready var area : Area2D = $Area2D

# Called when the node enters the scene tree for the first time.
func _ready():
	
	startingPosition = position
	
	collisionNode = CollisionShape2D.new()
	shape = RectangleShape2D.new()
		
	collisionNode.shape = shape
	collisionNode.debug_color = Color.BROWN
	
	#TODO change this to main or not
	if not canMove:
		Global.registerMainGrid(self)
	
	for i in range(0, rows*cols):
		var instance = cellObj.instantiate()
		var cell : SimpleCell = instance as SimpleCell
		add_child(cell)
		
		var x = i % rows
		var y = floor(i / rows)
		cellHeight = cell.height
		cellWidth = cell.width
		
		var halfPoint = ((cell.width * rows) / 2) - (cell.width / 2)
		
		cell.position = Vector2((x * cell.width) - halfPoint, (y * cell.height) - halfPoint)
		cell.setId(pieceId)
		
		if canMove and values.size() > 0:
			if values[i] != null:
				cell.setActive(values[i])
		
		grid.append(cell)
	
	shape.size = Vector2(cellWidth * rows, cellHeight * rows)
		
	area.add_child(collisionNode)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not Engine.is_editor_hint():
		if held :
			var mousPos = get_global_mouse_position()
			global_transform.origin = mousPos
			
			if pieceOnGrid:
				#TODO use the position of the main grid
				
				var diff = Vector2.ZERO - position
				var split_y = int(diff.y) % int(cellHeight)
				var split_x = int(diff.x) % int(cellWidth)
#				global_transform.origin = Vector2(global_transform.origin.x - split_x, global_transform.origin.y - split_y)
				var xGrid = floor(mousPos.x / cellWidth) * cellWidth
				var yGrid = floor(mousPos.y / cellHeight) * cellHeight
				global_transform.origin = Vector2(xGrid, yGrid)
			
		if Global.isPieceHeld == true :
			queue_redraw()

func _input(event):
	if not Engine.is_editor_hint():
		if event is InputEventMouseButton:
			#1 is left mouse
			if event.pressed and event.button_index == MOUSE_BUTTON_LEFT and underMouse and canMove:
				print("hold grid")
				held = true
				Global.setHeldPiece(self)
			else:
				if held and underMouse:
					held = false
					Global.dropPiece()
					if pieceOnGrid :
						#Copy the cells on the main grid
						Global.copyToMainGrid(self)
					else:
						jumpToStartPosition()

func jumpToStartPosition():
	global_transform.origin = startingPosition

func setCell(id, value , pieceId):
	if grid[id] != null and pieceId != null:
		grid[id].active = value
		grid[id].setId(pieceId)

func getCellId(id):
	if id != null:
		return grid[id].gridId

func getCellValue(id):
	if grid[id] != null:
		return grid[id].active
#func idToMapCoord(id, width : int, height : f32) -> (x, y : f32) {
#	x = f32(id % width)
#	y = math.floor(f32(id) / f32(width))
#	return x, y
#}
#
#mapCoordToId :: proc(x, y : f32, width : f32, height : f32) -> int {
#	id := int((y*width) + x)
#	return id
#}
func _draw():
	# Your draw commands here
	var diff
	if Global.pieceReference != null and canMove == false:
		diff = position - Global.pieceReference.position
	if diff != null :
		draw_line(position, position - diff, Color.DEEP_PINK, 2)
		var split_y = int(diff.y) % int(cellHeight)
		var split_x = int(diff.x) % int(cellWidth)
		draw_line(position, Vector2(position.x - split_x, position.y - split_y), Color.RED, 2)
		
	pass

func _on_area_2d_mouse_entered():
	print("mouse on grid")
	underMouse = true
	pass # Replace with function body.


func _on_area_2d_mouse_exited():
	print("mouse leves grid")
	underMouse = false
	pass # Replace with function body.

func _on_area_2d_area_entered(area):
	var parent = area.get_parent()
	if parent != null:
		print("Area entered ", parent.name)
		# Snap to the grid, the movalble grid can snap to the fixed one
		if canMove == false:
			if parent is Grid and parent.held:
				parent.pieceOnGrid = true
				pass
	pass # Replace with function body.


func _on_area_2d_area_exited(area):
	var parent = area.get_parent()
	if parent != null:
		print("Area exited ", parent.name)
		# Snap to the grid, the movalble grid can snap to the fixed one
		if canMove == false:
			if parent is Grid and parent.held:
				parent.pieceOnGrid = false
				pass
	pass # Replace with function body.
