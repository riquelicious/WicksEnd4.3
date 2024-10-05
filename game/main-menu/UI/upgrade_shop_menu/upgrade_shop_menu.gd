class_name UpgradeShopMenu extends Control

var UpgradeBackButton: HoverButton
var UpgradeBackNode: Control
var available_points: int
var item_price: int
var equipment_index
var temporary_stats: Dictionary = {}
var upgradeButtonManager: UpgradeShopButtonManager = UpgradeShopButtonManager.new(self)
var upgradeDisplayManager: UpgradeShopDisplayManager = UpgradeShopDisplayManager.new(self)

func _ready() -> void:
	UpgradeBackNode = get_node_or_null("ColumnContainer/shopControls/controlContainers/BackContainer/Button")
	UpgradeBackButton = HoverButton.new(UpgradeBackNode, UpgradeBackFunc)
	assert(UpgradeBackNode != null)
	initialize_temporary_stats()
	UpgradeBackButton._ready()
	upgradeButtonManager._ready()
	upgradeDisplayManager._ready()

func _process(delta: float) -> void:
	UpgradeBackButton._process(delta)
	upgradeButtonManager._process(delta)

func UpgradeBackFunc():
	pass


func initialize_temporary_stats():
	temporary_stats = Global.equipment_settings.equipments.duplicate(true)
	print(temporary_stats)


func update_on_window_change():
	pass
