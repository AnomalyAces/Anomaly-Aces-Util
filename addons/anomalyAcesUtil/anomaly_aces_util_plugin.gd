@tool
extends EditorPlugin


func _enter_tree():
	# Initialization of the plugin goes here.

	#Add Autoloads
	add_autoload_singleton("AceArrayUtil", "res://addons/anomalyAcesUtil/Scripts/AceArrayUtil/AceArrayUtil.gd")
	add_autoload_singleton("AceSerialize", "res://addons/anomalyAcesUtil/Scripts/AceSerialize/AceSerialize.gd")
	add_autoload_singleton("AceStringUtil", "res://addons/anomalyAcesUtil/Scripts/AceStringUtil/AceStringUtil.gd")
	add_autoload_singleton("AceFileUtil", "res://addons/anomalyAcesUtil/Scripts/AceFileUtil/AceFileUtil.gd")
	pass


func _exit_tree():
	remove_autoload_singleton("AceArrayUtil")
	remove_autoload_singleton("AceSerialize")
	remove_autoload_singleton("AceStringUtil")
	remove_autoload_singleton("AceFileUtil")