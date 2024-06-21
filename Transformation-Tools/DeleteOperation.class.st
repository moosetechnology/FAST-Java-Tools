"
This transformation operation is used to delete a node (and its eventual children nodes) from the source code of its parent entity.

This operation requires to be given as the `transformedNode` the node to delete, and its parent using the `parentNode:` or `anchorNode:` setter.

If the node to delete represents a full line of code (typically a statement), then the whole line, including the carriage return will be deleted.
Otherwise, the parent node will be generated after deleting the node to delete, and this code string will replace the orignal code string representing the parent node.
"
Class {
	#name : #DeleteOperation,
	#superclass : #AbstractTransformationOperation,
	#category : #'Transformation-Tools'
}

{ #category : #'applying operation' }
DeleteOperation >> buildNewNode [

	"returns the new node created using the anchor and transformed node"

	"returns nil if the whole node must be deleted, returns the transformed parent node otherwise"

	^ ({ 
		   FASTJavaClassDeclaration.
		   FASTJavaStatementBlock } includes: anchorNode parentNode class)
		  ifTrue: [ nil ]
		  ifFalse: [ 
			  | parentNode |
			  parentNode := self copyNode: anchorNode.
			  (transformedNode
				   attributeAt: #copy
				   ifAbsent: [ "sholud not happen" ]) removeAllPotentialParentNode.
			  parentNode ]
]

{ #category : #'as yet unclassified' }
DeleteOperation >> getPosForSorting [
	"returns a position in the source code string, used to sort the operation list"
	^ transformedNode startPos
]

{ #category : #accessing }
DeleteOperation >> parentNode [

	^ anchorNode
]

{ #category : #accessing }
DeleteOperation >> parentNode: anObject [

	anchorNode := anObject
]
