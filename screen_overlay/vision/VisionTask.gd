class_name VisionTask
extends Control

#var main_scene := preload("res://Main.tscn")
var running_mode := MediaPipeTask.RUNNING_MODE_IMAGE
var delegate := MediaPipeTaskBaseOptions.DELEGATE_CPU
var camera_helper := MediaPipeCameraHelper.new()

#* @onready var image_view: TextureRect = $Image
#* @onready var video_player: VideoStreamPlayer = $Video
#* @onready var permission_dialog: AcceptDialog = $PermissionDialog
@export var image_view: TextureRect
@export var permission_dialog: AcceptDialog
@export var vision_task := true

func _ready():
	if !vision_task: return
	_open_camera()
	camera_helper.permission_result.connect(self._permission_result)
	camera_helper.new_frame.connect(self._camera_frame)
	if OS.get_name() == "Android":
		var gpu_resources := MediaPipeGPUResources.new()
		camera_helper.set_gpu_resources(gpu_resources)
	init_task()

func _open_camera() -> void:
	if camera_helper.permission_granted():
		start_camera()
	else:
		camera_helper.request_permission()

func _permission_result(granted: bool) -> void:
	if granted:
		start_camera()
	else:
		permission_dialog.popup_centered()

func _camera_frame(image: MediaPipeImage) -> void:
	if not running_mode == MediaPipeTask.RUNNING_MODE_LIVE_STREAM:
		running_mode = MediaPipeTask.RUNNING_MODE_LIVE_STREAM
		init_task()
	if delegate == MediaPipeTaskBaseOptions.DELEGATE_CPU and image.is_gpu_image():
		image.convert_to_cpu()
	process_camera_frame(image, Time.get_ticks_msec())

func init_task() -> void:
	pass

func process_image_frame(_image: Image) -> void:
	pass

func process_video_frame(_image: Image, _timestamp_ms: int) -> void:
	pass

func process_camera_frame(_image: MediaPipeImage, _timestamp_ms: int) -> void:
	pass

func update_image(image: Image) -> void:
	if Vector2i(image_view.texture.get_size()) == image.get_size():
		image_view.texture.call_deferred("update", image)
	else:
		image_view.texture.call_deferred("set_image", image)

func start_camera() -> void:
	reset()
	camera_helper.set_mirrored(true)
	camera_helper.start(MediaPipeCameraHelper.FACING_FRONT, Vector2(640, 480))

func reset() -> void:
	camera_helper.close()
