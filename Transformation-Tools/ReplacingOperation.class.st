"
This transformation operation is used to replace the source code of a node (and its eventual children nodes) using the generated source code of a new node.

This operation requires to be given as the `transformedNode` the node to use as replacement, and the original node using the `originalNode:` or `anchorNode:` setter.

The behaviour of the operation doesn't change no matter the type of nodes involved.
"
Class {
	#name : #ReplacingOperation,
	#superclass : #AbstractTransformationOperation,
	#category : #'Transformation-Tools'
}

{ #category : #'applying operation' }
ReplacingOperation >> buildNewNode [
	"returns the new node created using the anchor and transformed node"
	^ transformedNode
]

{ #category : #'as yet unclassified' }
ReplacingOperation >> getPosForSorting [
	"returns a position in the source code string, used to sort the operation list"
	^ self originalNode startPos
]

{ #category : #accessing }
ReplacingOperation >> originalNode [

	^ anchorNode
]

{ #category : #accessing }
ReplacingOperation >> originalNode: anObject [

	anchorNode := anObject
]
