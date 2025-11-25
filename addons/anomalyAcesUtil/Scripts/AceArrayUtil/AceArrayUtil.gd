@tool
extends Node

## Find First Element of Array that meets the criteria
func findFirst( arr:Array, search_criteria: Callable) -> Variant: 
	for item in arr:
		if search_criteria.call(item):
			return item
	return null

## Add Unique item to Array - Create a Set
func addUnique(arr: Array, item: Variant) -> bool:
	if not arr.has(item):
		arr.push_back(item)
		return true
	else:
		return false
