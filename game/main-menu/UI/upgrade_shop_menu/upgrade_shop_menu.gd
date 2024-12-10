class_name UpgradeShopMenu extends Control

var available_points: float
var item_price: float
var equipment_index
var temporary_stats: Dictionary = {}
var upgradeButtonManager: UpgradeShopButtonManager = UpgradeShopButtonManager.new(self)
var upgradeDisplayManager: UpgradeShopDisplayManager = UpgradeShopDisplayManager.new(self)
var backButton: HoverButton
var backButtonNode: Control

var menuSequence: MenuSequence

func _ready() -> void:
	backButtonNode = get_node_or_null("ColumnContainer/shopControls/controlContainers/BackContainer/Button")
	assert(backButtonNode != null)
	backButton = HoverButton.new(backButtonNode, backFunc)
	if get_parent() is MenuSequence:
		menuSequence = get_parent()
	backButton._ready()
	initialize_temporary_stats()
	upgradeButtonManager._ready()
	upgradeDisplayManager._ready()

func _process(delta: float) -> void:
	upgradeButtonManager._process(delta)
	upgradeDisplayManager._process(delta)
	backButton._process(delta)


func update_dictionary_stats(increment: int):
	var equipment = temporary_stats.keys()[equipment_index]
	temporary_stats[equipment]["level"] += increment

func initialize_temporary_stats():
	temporary_stats = Global.equipment_settings.equipments.duplicate(true)


func backFunc():
	if menuSequence is MenuSequence:
		menuSequence.set_menu(MenuSequence.Menu.LEVEL_SELECT)
