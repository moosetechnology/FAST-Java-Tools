"
This transformation operation is a composite of operations to apply on one anchor node before regenerating it once and replace the original node.

Using the setter `operations: aCollection`, this object takes a list of `AbstractTransformationOperation` and modifies the FAST through the `transformNodeIfNeeded` method of each operation, before calling the `applyOperation` method to modify the string using the generated node transformed by each operation.

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

{ #category : #accessing }
GroupOfTransformationOperations >> addedHighlight [ 

	^ operations last addedHighlight
]

{ #category : #'applying operation' }
GroupOfTransformationOperations >> applyOperationOnSource: aCodeString withOffset: anInt [

	| currentAnchorNode |
	currentAnchorNode := operations first anchorNode.

	operations allButLast do: [ :op | 
		op anchorNode: currentAnchorNode.
		op transformNodeIfNeeded.
		currentAnchorNode := op transformedNode ].

	operations last anchorNode: currentAnchorNode.

	^ operations last
		  applyOperationOnSource: aCodeString
		  withOffset: anInt
]

{ #category : #'as yet unclassified' }
GroupOfTransformationOperations >> findNewOffsetPosWithOffsetDict: aDictionary [.
	"operations should all apply on the same node, so any operation should have a good return value"
	^ self operations first findNewOffsetPosWithOffsetDict: aDictionary 
]

{ #category : #'as yet unclassified' }
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

{ #category : #accessing }
GroupOfTransformationOperations >> removedHighlight [ 

	^ operations last removedHighlight
]
