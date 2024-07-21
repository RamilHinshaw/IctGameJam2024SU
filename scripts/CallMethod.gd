extends Node

@export  var nodePath:NodePath
@export  var methodName:String

@export  var call_function:bool



func testPrint():
	print("Hello World From Test!!")

func _ready():
	if not call_function:return 
	
	var node:Node = get_node(nodePath)
	if methodName != null and node.has_method(methodName):
		node.call(methodName)
