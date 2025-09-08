@tool
extends Node

const CLASS_RESOURCE: String = "CLASS_RESOURCE"

var json: JSON = JSON.new()
var data: Variant;

class DeserializeResult:
	var data: Variant
	var error: Error
	
	

func serialize(obj: Object) -> String:
	var dict: Dictionary = {}

	if obj.get_script() != null:
		var cls_properties: Array[Dictionary] = obj.get_script().get_script_property_list()
		var properties: Array[String] = _prop_list_to_string_list(cls_properties)
		
		#Add Class Resource to object - contains script of classes (built-in and custom)
		var base_script: Dictionary = cls_properties[0]
		if base_script.hint_string != null && base_script.hint_string != "":
			dict[CLASS_RESOURCE] = "Resource(\"%s\")" % base_script.hint_string
		
		for prop in properties:
			var pval = obj.get(prop)
			#Don't serialize empty properties
			if(pval == null || (typeof(pval) == TYPE_STRING && pval == "" )):
				continue
			var value = (
				JSON.parse_string(serialize(pval)) if (typeof(pval) == TYPE_OBJECT && !pval is Texture2D)
				else var_to_str(pval) if ![TYPE_STRING,TYPE_INT,TYPE_FLOAT].has(typeof(pval))
				else pval
			)
			dict[prop] = value
		return JSON.stringify(dict, "\t",false)
	else:
		return var_to_str(obj) if ![TYPE_STRING,TYPE_INT,TYPE_FLOAT].has(typeof(obj)) else str(obj)
	
func deserialize(jsonInput:Dictionary, cls:Resource) -> Error:
	var res: DeserializeResult = _deserialize_obj(jsonInput, cls)
	data = res.data
	return res.error

	
func _prop_list_to_string_list(cls_properties: Array[Dictionary]):
	var properties: Array[String] 
	properties.assign(cls_properties.map(
		func(prop) -> String: return prop.name 
	))
	return properties

func _deserialize_obj(jsonInput:Dictionary, cls:Resource) -> DeserializeResult:
	var res:DeserializeResult = DeserializeResult.new()
	
	var obj:Object = cls.new()
	var cls_properties: Array[Dictionary] = obj.get_script().get_script_property_list()
	var properties: Array[String] = _prop_list_to_string_list(cls_properties)
	
	for key in jsonInput.keys():
		if key in properties:
			var value = jsonInput.get(key)
			if typeof(value) == TYPE_STRING:
				if str_to_var(value) != null:
					print("key: %s str_to_value: %s" % [key,str_to_var(value)])
					obj.set(key, str_to_var(value))
				else:
					obj.set(key, value)
			elif typeof(value) == TYPE_DICTIONARY:
				var internal_res: DeserializeResult = _deserialize_obj(value, str_to_var(value.get(CLASS_RESOURCE)))
				obj.set(key, internal_res.data)
			else:
				obj.set(key, value)
		elif key == CLASS_RESOURCE:
			#found added property CLASS_RESOURCE from serialize. Continue
			continue
		else:
			push_error("Key %s is not included in %s" % [key, cls.resource_path])
			res.data = null
			res.error = FAILED
			return res
	
	res.data = obj
	res.error = OK
	return res
