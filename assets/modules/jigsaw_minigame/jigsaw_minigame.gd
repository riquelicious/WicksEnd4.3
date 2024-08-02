class_name JigsawMinigame
extends Control 

@onready var piece_1: TextureRect = $"jigsaw_container/piece #1"
@onready var piece_2: TextureRect = $"jigsaw_container/piece #2"
@onready var piece_3: TextureRect = $"jigsaw_container/piece #3"
@onready var piece_4: TextureRect = $"jigsaw_container/piece #4"

@export var piece_positions = {
	"piece #1": Vector2(0, 0),
	"piece #2": Vector2(149, 0),
	"piece #3": Vector2(0, 149),
	"piece #4": Vector2(149, 149)
}
var jigsaw_manager : JigsawManager = JigsawManager.new()
var piece_one : JigsawPieceManager = JigsawPieceManager.new()
var piece_two : JigsawPieceManager = JigsawPieceManager.new()
var piece_three : JigsawPieceManager = JigsawPieceManager.new()
var piece_four : JigsawPieceManager = JigsawPieceManager.new()
var current_piece 

func _ready() -> void:
	jigsaw_manager.initialize(self)
	piece_one.initialize(self,piece_1) 
	piece_two.initialize(self,piece_2) 
	piece_three.initialize(self,piece_3) 
	piece_four.initialize(self,piece_4) 

func _process(delta: float) -> void:
	jigsaw_manager.check_all_pieces(delta)
	piece_one.detect_drag()
	piece_two.detect_drag()
	piece_three.detect_drag()
	piece_four.detect_drag()
