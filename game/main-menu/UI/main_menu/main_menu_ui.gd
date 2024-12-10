class_name MainMenuUI extends Node

var newGameNode: Control
var continueNode: Control
var quitNode: Control

var newGameButton: HoverButton
var continueButton: HoverButton
var quitButton: HoverButton


var menuSequence: MenuSequence

func _ready() -> void:
	newGameNode = get_node_or_null("MainButtonContainer/NewGameButton")
	continueNode = get_node_or_null("MainButtonContainer/ContinueButton")
	quitNode = get_node_or_null("MainButtonContainer/QuitButton")
	if get_parent() is MenuSequence:
		menuSequence = get_parent()
	assert(newGameNode != null)
	assert(continueNode != null)
	assert(quitNode != null)
	newGameButton = HoverButton.new(newGameNode, newGameFunc)
	continueButton = HoverButton.new(continueNode, continueFunc)
	quitButton = HoverButton.new(quitNode, exitGame)
	newGameButton._ready()
	continueButton._ready()
	quitButton._ready()

func _process(delta: float) -> void:
	newGameButton._process(delta)
	continueButton._process(delta)
	quitButton._process(delta)

func newGameFunc():
	if menuSequence is MenuSequence:
		menuSequence.set_menu(MenuSequence.Menu.LEVEL_SELECT)

		#newGameCallback.call()

func continueFunc():
	if menuSequence is MenuSequence:
		#TODO load game
		menuSequence.set_menu(MenuSequence.Menu.LEVEL_SELECT)

func exitGame():
	get_tree().quit()
