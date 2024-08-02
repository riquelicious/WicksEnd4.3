extends Fire_Instance

func _ready():
	positions = {
	"TOP" 		:	Vector3(0,0.8,0),
	"BOTTOM" 	:	Vector3(0,-0.8,0),
	"LEFT"		:	Vector3(0,0,0.8),
	"RIGHT"		:	Vector3(0,0,-0.8),
	"FRONT"		:	Vector3(0.8,0,0),
	"BACK"		:	Vector3(-0.8,0,0)
	}
	super()
