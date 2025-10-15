"
This transformation operation is used to insert a node (and its eventual children nodes) into the given anchor node.

This operation requires to be given as the `transformedNode` the node to insert, and its parent using the `parentNode:` or `anchorNode:` setter.
The selector used to insert the `transformedNode` to the `anchorNode` must also be specified as a symbol (check `FASTJavaCodeGeneratorBuilder` `>> insertionOperation1`).

This operation must be used for node insertions that will only modify one (already existing) line of code. For example, adding a variable to be used as a parameter in a method invocation (as shown in the test in `InsertionOperationTest`).
"
Class {
	#name : 'InsertionOperation',
	#superclass : 'AbstractTransformationOperation',
	#instVars : [
		'selector'
	],
	#category : 'Transformation-Tools',
	#package : 'Transformation-Tools'
}

{ #category : 'applying operation' }
InsertionOperation >> buildNewNode [
	"returns the new node created using the anchor and transformed node"
	| parentCopy |
	parentCopy := self copyNode: self parentNode.

	parentCopy perform: selector withArguments: { transformedNode }.
	
	^ parentCopy.
]

{ #category : 'sorting' }
InsertionOperation >> getPosForSorting [

	"returns a position in the source code string, used to sort the operation list"

	^ self parentNode class = FASTJavaStatementBlock
		  ifTrue: [ self parentNode endPos ]
		  ifFalse: [ self parentNode startPos ]
]

{ #category : 'accessing' }
InsertionOperation >> nodeToInsert [

	^ transformedNode 
]

{ #category : 'accessing' }
InsertionOperation >> nodeToInsert: anObject [

	transformedNode := anObject
]

{ #category : 'accessing' }
InsertionOperation >> parentNode [

	^ anchorNode
]

{ #category : 'accessing' }
InsertionOperation >> parentNode: anObject [

	anchorNode := anObject
]

{ #category : 'accessing' }
InsertionOperation >> selector [

	^ selector
]

{ #category : 'accessing' }
InsertionOperation >> selector: anObject [

	selector := anObject
]
