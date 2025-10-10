"
This transformation operation is used to delete a node (and its eventual children nodes) from the source code of its parent entity.

This operation requires to be given as the `anchorNode` the node to delete. The transformed node is not used by this operation.

If the node to delete represents a full line of code (typically a statement), then the whole line, including the carriage return will be deleted. To do so, `buildNewNode` will return `nil`.
Otherwise, the parent node will be copied and returned after removing the node to delete. The code string generated from this node will replace the orignal code string representing the parent node.
"
Class {
	#name : 'DeleteOperation',
	#superclass : 'AbstractTransformationOperation',
	#category : 'Transformation-Tools',
	#package : 'Transformation-Tools'
}

{ #category : 'applying operation' }
DeleteOperation >> buildNewNode [

	"returns the new node created using the anchor and transformed node"

	"returns nil if the whole node must be deleted, returns the transformed parent node otherwise"

	^ ({ 
		   FASTJavaClassDeclaration.
		   FASTJavaStatementBlock } includes: anchorNode parentNode class)
		  ifTrue: [ nil ]
		  ifFalse: [ 
			  | newNode |
			  newNode := self copyNode: anchorNode parentNode.
			  (anchorNode
				   attributeAt: #copy
				   ifAbsent: [ "sholud not happen" ]) removeAllPotentialParentNode.
			  newNode ]
]

{ #category : 'sorting' }
DeleteOperation >> getPosForSorting [
	"returns a position in the source code string, used to sort the operation list"
	^ anchorNode startPos
]

{ #category : 'accessing' }
DeleteOperation >> parentNode [

	^ anchorNode
]

{ #category : 'accessing' }
DeleteOperation >> parentNode: anObject [

	anchorNode := anObject
]
