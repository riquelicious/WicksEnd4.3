class_name CutSceneChoiceManager extends Node

var parent: CutSceneManager
var buttons: Array
var values: Array = [null, null, null, null]


func _init(parent_instance: Node) -> void:
	self.parent = parent_instance


func _ready() -> void:
	#self.buttons = parent.get_node("Control/choices_button_container").get_children()
	var container_button = parent.get_node_or_null("VBoxContainer").get_children()
	buttons.append(GestureHoldButton.new(container_button[0], GlobalControls.dialogueContols[0], button_1_pressed))
	buttons.append(GestureHoldButton.new(container_button[1], GlobalControls.dialogueContols[1], button_2_pressed))
	buttons.append(GestureHoldButton.new(container_button[2], GlobalControls.dialogueContols[2], button_3_pressed))
	buttons.append(GestureHoldButton.new(container_button[3], GlobalControls.dialogueContols[3], button_4_pressed))
	buttons[0]._ready()
	buttons[1]._ready()
	buttons[2]._ready()
	buttons[3]._ready()

func _process(delta: float) -> void:
	for button: GestureHoldButton in buttons:
		button._process(delta)

func list_choices():
	reset_buttons()
	if parent.choices_list.size() == 0: return
	var index = 0
	for choice in parent.choices_list:
		if choice != null:
			update_button_values(index, choice)
			index += 1

func update_button_values(index: int, choice: Dictionary) -> void:
	var but = buttons[index].buttonNode
	but.button_label.text = choice["text"]
	values[index] = choice["nextNode"]
	buttons[index].buttonNode.visible = true
	buttons[index].disabled = false

func reset_buttons() -> void:
	for button: GestureHoldButton in buttons:
		button.disabled = true
		button.buttonNode.visible = false


func fetch_value() -> void:
	for index in values.size():
		if values[index] != null:
			buttons[index].grab_focus()

func button_1_pressed() -> void:
	if values[0] == null: return
	parent.text_manager.change_value(values[0])


func button_2_pressed() -> void:
	if values[1] == null: return
	parent.text_manager.change_value(values[1])

func button_3_pressed() -> void:
	if values[2] == null: return
	parent.text_manager.change_value(values[2])

func button_4_pressed() -> void:
	if values[3] == null: return
	parent.text_manager.change_value(values[3])
