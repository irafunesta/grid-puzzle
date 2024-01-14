extends Node2D

var isPieceHeld = false
var pieceReference

var mainGrid : Grid

@onready var label = $Label

# Called when the node enters the scene tree for the first time.
func _ready():
	print("ready")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var string = "isPieceHeld " + str(isPieceHeld)
	if pieceReference != null:
		string += "||" + pieceReference.name
	label.text = string
	pass

func setHeldPiece(piece):
	isPieceHeld = true
	if piece:
		pieceReference = piece

func dropPiece():
	isPieceHeld = false
	pieceReference = null

func registerMainGrid(grid):
	mainGrid = grid

func copyToMainGrid(piece : Grid):
	if mainGrid != null:
		#starting cell
		var cell_x = floor(piece.position.x / piece.cellWidth) 
		var cell_y = floor(piece.position.y / piece.cellHeight)
		
		var startingCell_x = (floor(mainGrid.rows / 2) + cell_x) - 1
		var startingCell_y = (floor(mainGrid.cols / 2) + cell_y) - 1
		
		print("starting cell (x:", startingCell_x, ",y:", startingCell_y,")")
		
		#Check if the piece is fully in the grid, add the size but divided by 2 cause we start from the center
		var lastCell_x = startingCell_x + floor(piece.rows / 2)
		var lastCell_y = startingCell_y + floor(piece.cols / 2)
		
		if startingCell_x < 0 or lastCell_y < 0 :
			piece.jumpToStartPosition()
			return
		
		if lastCell_x >= mainGrid.rows or lastCell_y >= mainGrid.cols :
			piece.jumpToStartPosition() 
			return
			
		var spaceIsFree = true;
			
		#Check if the space is free
		for i in range(0, piece.rows * piece.cols):
			var x = i % piece.rows
			var y = floor(i / piece.rows)
			
			var tmpY = startingCell_y + y
			var tmpX = startingCell_x + x
			
			var id = int((tmpY * mainGrid.rows) + tmpX)
			if mainGrid.getCellId(id) > -1:
				spaceIsFree = false
				
		if !spaceIsFree:
			piece.jumpToStartPosition()
			return
		
		# Can actually copy data
		for i in range(0, piece.rows * piece.cols):
			var x = i % piece.rows
			var y = floor(i / piece.rows)
			
			var tmpY = startingCell_y + y
			var tmpX = startingCell_x + x
			
			var id = int((tmpY * mainGrid.rows) + tmpX)
			
			mainGrid.setCell(id , piece.getCellValue(i), piece.pieceId)
		
		piece.jumpToStartPosition()
		pass

# int((y*width) + x)
