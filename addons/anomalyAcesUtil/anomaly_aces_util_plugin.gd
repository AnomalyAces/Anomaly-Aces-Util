@tool
extends EditorPlugin


func _enter_tree():
	# Initialization of the plugin goes here.

	#Add Autoloads
	add_autoload_singleton("AceArrayUtil", "res://addons/anomalyAcesUtil/Scripts/AceArrayUtil/AceArrayUtil.gd")
	add_autoload_singleton("SerializeUtil", "res://addons/anomalyAcesUtil/Scripts/Serialize/SerializeUtil.gd")
	pass


func _exit_tree():
	remove_autoload_singleton("AceArrayUtil")
	remove_autoload_singleton("SerializeUtil")
