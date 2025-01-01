extends Node

var testVector:Vector2 = Vector2.ZERO
var runOnce:bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	testVector = Vector2(1,1)
	return
	#pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(!runOnce):
		testVector += Vector2(2,-1);
		runOnce = true;
	
	if(testVector == Vector2(3,0)):
		print("duh");
	
