class_name TargetMarker
extends Sprite2D

@onready var camera := get_viewport().get_camera_3d()
@onready var marker_target : Node3D
var hide_when_behind := true

func _process(_delta):
	_mark_target()

func _mark_target():
	if marker_target:
		if not is_instance_valid(marker_target): 
			marker_target = null
			return
		var target_position_marker = marker_target
		var target_position = target_position_marker.global_transform.origin
		var onscreen_ui_marker_postion : Vector2 = camera.unproject_position(target_position)
		if hide_when_behind:
			self.visible = !camera.is_position_behind(target_position)
		self.position = onscreen_ui_marker_postion
