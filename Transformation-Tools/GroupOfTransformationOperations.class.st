"
This transformation operation is a composite of operations to apply on one anchor node before regenerating it once and replace the original node.

Using the setter `operations: aCollection`, this object takes a list of `AbstractTransformationOperation` and modifies the FAST through the `buildNewNode` method of each operation, before returning the result of the final call. By setting the `anchorNode` of the next operation with the result of the previous `buildNewNode` result, this composite ensures that the transformation to apply on the same anchor node do not overwrite previous ones.

This group is only necessary for insertions, as a delete or replacement operation would be overwritten by the next one. Also, the `anchorNode` must be the same for every operation to ensure the correct behaviour of the chain of operations.
"
Class {
	#name : #GroupOfTransformationOperations,
	#superclass : #AbstractTransformationOperation,
	#instVars : [
		'operations'
	],
	#category : #'Transformation-Tools'
}

{ #category : #'applying operation' }
GroupOfTransformationOperations >> buildNewNode [

	"returns the new node created using the anchor and transformed node"

	| currentAnchorNode |
	currentAnchorNode := operations first anchorNode.
	
	"setting original anchor node just in case"
	self anchorNode: currentAnchorNode. 

	operations allButLast do: [ :op | 
		op anchorNode: currentAnchorNode.
		currentAnchorNode := op buildNewNode ].

	operations last anchorNode: currentAnchorNode.

	^ operations last buildNewNode
]

{ #category : #sorting }
GroupOfTransformationOperations >> getPosForSorting [
	"returns a position in the source code string, used to sort the operation list"
	"operations should all apply on the same node, so any operation should have a good return value"
	^ self operations first getPosForSorting
]

{ #category : #accessing }
GroupOfTransformationOperations >> operations [

	^ operations
]

{ #category : #accessing }
GroupOfTransformationOperations >> operations: aCollection [

	operations := aCollection
]
