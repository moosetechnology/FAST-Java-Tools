"
This transformation operation is used to replace a node (and its eventual children nodes) for a new node (and its eventual children nodes).

This operation requires to be given as the `transformedNode` the node to use as replacement, and the original node using the `originalNode:` or `anchorNode:` setter.

The behaviour of the operation doesn't change no matter the type of nodes involved.
"
Class {
	#name : 'ReplacingOperation',
	#superclass : 'AbstractTransformationOperation',
	#category : 'Transformation-Tools',
	#package : 'Transformation-Tools'
}

{ #category : 'applying operation' }
ReplacingOperation >> buildNewNode [
	"returns the new node created using the anchor and transformed node"
	^ transformedNode
]

{ #category : 'sorting' }
ReplacingOperation >> getPosForSorting [
	"returns a position in the source code string, used to sort the operation list"
	^ self originalNode startPos
]

{ #category : 'accessing' }
ReplacingOperation >> originalNode [

	^ anchorNode
]

{ #category : 'accessing' }
ReplacingOperation >> originalNode: anObject [

	anchorNode := anObject
]
