class_name UpgradeShop
extends Control

var shop_button_texture: ShopButtonTextureManager = ShopButtonTextureManager.new()
var shop_icon_manager: ShopIconManager = ShopIconManager.new()
var shop_description_manager: ShopDescriptionManager = ShopDescriptionManager.new()
var shop_manager: ShopManager = ShopManager.new()

signal button_activated

func _ready() -> void:
	shop_button_texture.initialize(self)
	shop_icon_manager.initialize(self)
	shop_description_manager.initialize(self)
	shop_manager.initialize(self)

func _process(delta: float) -> void:
	shop_button_texture.move_background(delta)
	shop_button_texture.detect_gesture()
	shop_description_manager.update_text()
	shop_description_manager.update_points(delta)
