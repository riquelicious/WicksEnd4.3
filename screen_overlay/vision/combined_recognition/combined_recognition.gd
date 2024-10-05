extends VisionTask

#hand_landmark
var htask: MediaPipeHandLandmarker
var htask_file := "res://screen_overlay/vision/hand_landmarker.task"
#gesture
var gtask: MediaPipeGestureRecognizer
var gtask_file := "res://screen_overlay/vision/gesture_recognizer.task"

#@export var idk : Node3D
@export var lbl_handedness: Label

#cache
var cached_hresult = null
var cached_gresult = null
var cached_landmark_text

func _hresult_callback(hresult: MediaPipeHandLandmarkerResult, image: MediaPipeImage, _timestamp_ms: int) -> void:
	var img := image.get_image()
	call_deferred("show_result", img, hresult, null)

func _gresult_callback(gresult: MediaPipeGestureRecognizerResult, image: MediaPipeImage, _timestamp_ms: int) -> void:
	var img := image.get_image()
	call_deferred("show_result", img, null, gresult)

func init_task() -> void:
	#hand_landmark
	var hbase_options := MediaPipeTaskBaseOptions.new()
	hbase_options.delegate = delegate
	var hfile := FileAccess.open(htask_file, FileAccess.READ)
	hbase_options.model_asset_buffer = hfile.get_buffer(hfile.get_length())
	htask = MediaPipeHandLandmarker.new()
	htask.initialize(hbase_options, running_mode)
	htask.result_callback.connect(self._hresult_callback)
	#gesture
	var gbase_options := MediaPipeTaskBaseOptions.new()
	gbase_options.delegate = delegate
	var gfile := FileAccess.open(gtask_file, FileAccess.READ)
	gbase_options.model_asset_buffer = gfile.get_buffer(gfile.get_length())
	gtask = MediaPipeGestureRecognizer.new()
	gtask.initialize(gbase_options, running_mode)
	gtask.result_callback.connect(self._gresult_callback)

func process_camera_frame(image: MediaPipeImage, timestamp_ms: int) -> void:
	htask.detect_async(image, timestamp_ms)
	gtask.recognize_async(image, timestamp_ms)

func show_result(image: Image, hresult: MediaPipeHandLandmarkerResult, gresult: MediaPipeGestureRecognizerResult) -> void:
	var _handedness_text := ""
	var gesture_text := ""
	if cached_gresult and cached_hresult:
		MousePositioning.is_hand_on_screen = cached_hresult.handedness.size() and cached_gresult.handedness.size()

	if typeof(hresult) != 0:
		cached_hresult = hresult
	if typeof(gresult) != 0:
		cached_gresult = gresult
	if cached_hresult:
		for landmarks in cached_hresult.hand_landmarks:
			draw_landmarks(image, landmarks)
		#for categories in hresult.handedness:
		for categories in cached_hresult.handedness:
			for category in categories.categories:
				_handedness_text += "%s\n" % [category.display_name]
	if cached_gresult:
		var gestures = cached_gresult.gestures
		var handedness = cached_gresult.handedness
		assert(gestures.size() == handedness.size())
		for i in range(gestures.size()):
			var gesture = gestures[i]
			var hand = handedness[i]
			var classification_gesture: MediaPipeProto = gesture.get_repeated("classification", 0)
			var classification_hand: MediaPipeProto = hand.get_repeated("classification", 0)
			var gesture_label: String = classification_gesture.get("label")
			var gesture_score: float = classification_gesture.get("score")
			var hand_label: String = classification_hand.get("label")
			var hand_score: float = classification_hand.get("score")
			if hand_label.to_lower() == 'left':
				hand_label = 'right'
			elif hand_label.to_lower() == 'right':
				hand_label = 'left'
			GlobalCursor.handedness = hand_label
			gesture_text += "%s: %.2f\n%s: %.2f\n\n" % [hand_label, hand_score, gesture_label, gesture_score]
			
			update_stored_gesture(gesture_label)
	var _lbl_text = gesture_text
	lbl_handedness.call_deferred("set_text", _lbl_text)
	update_image(image)

func update_stored_gesture(gesture: String) -> void:
	Global.gesture_settings.update_gesture(gesture)
	#Global.gesture_settings.gesture = gesture

func draw_landmarks(image: Image, landmarks: MediaPipeNormalizedLandmarks) -> void:
	var color := Color.GREEN
	var rect := Image.create(4, 4, false, image.get_format())
	rect.fill(color)
	var image_size := Vector2(image.get_size())
	var hand_coordinates := Vector2(landmarks.landmarks[6].x, landmarks.landmarks[6].y)
	for landmark in landmarks.landmarks:
		var pos := Vector2(landmark.x, landmark.y)
		image.blit_rect(rect, rect.get_used_rect(), Vector2i(image_size * pos) - rect.get_size() / 2)
	MousePositioning.detected_mouse_position = hand_coordinates
