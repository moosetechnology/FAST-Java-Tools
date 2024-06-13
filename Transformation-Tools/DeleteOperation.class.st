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
DeleteOperation >> applyOperation [

	removedHighlight := transformedNode startPos @ transformedNode endPos.

	^ (self checkIfWholeLineMustBeRemovedInSourceCode: sourceCode)
		  ifTrue: [ 
		  self removeLineInSourceCode: sourceCode withOffset: offsetToApply ]
		  ifFalse: [ 
			  self
				  transformAndReplaceParentNodeInSourceWithOffset: offsetToApply ]
]

{ #category : #'as yet unclassified' }
DeleteOperation >> checkIfWholeLineMustBeRemovedInSourceCode: sourceCode [

	| beforeIndex afterIndex |
	beforeIndex := transformedNode startPos - 1.
	[ 
	{ 
		Character cr.
		Character lf } includes: (sourceCode at: beforeIndex) ] whileFalse: [ 
		({ 
			 Character space.
			 Character tab } includes: (sourceCode at: beforeIndex))
			ifTrue: [ beforeIndex := beforeIndex - 1 ]
			ifFalse: [ ^ false ] ].

	afterIndex := transformedNode endPos + 1.
	[ (sourceCode at: afterIndex) = Character cr ] whileFalse: [ 
		({ 
			 Character space.
			 Character tab.
			 $; } includes: (sourceCode at: afterIndex))
			ifTrue: [ afterIndex := afterIndex + 1 ]
			ifFalse: [ ^ false ] ].
	
	^ true
]

{ #category : #'as yet unclassified' }
DeleteOperation >> findNewOffsetPosWithOffsetDict: aDictionary [

	^ self parentNode class = FASTJavaStatementBlock
		  ifTrue: [
			"if the parent is a statement block, then the whole statement will be removed" 
			  self
				  computeOffsetWithOriginalPos: transformedNode startPos
				  andOffsetDict: aDictionary ]
		  ifFalse: [ 
			"otherwise, the parent node will be transformed"
			  self
				  computeOffsetWithOriginalPos: self parentNode startPos
				  andOffsetDict: aDictionary ]
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

{ #category : #'applying operation' }
DeleteOperation >> removeLineInSourceCode: sourceCode withOffset: anInt [

	| beforeIndex afterIndex |
	beforeIndex := transformedNode startPos - 1.
	[ (sourceCode at: beforeIndex) = Character cr ] whileFalse: [ 
		beforeIndex := beforeIndex - 1 ].

	afterIndex := transformedNode endPos + 1.
	[ (sourceCode at: afterIndex) = Character cr ] whileFalse: [ 
		afterIndex := afterIndex + 1 ].

	^ '' join: { 
			  (sourceCode copyFrom: 1 to: beforeIndex - 1).
			  (sourceCode copyFrom: afterIndex to: sourceCode size) }
]

{ #category : #'applying operation' }
DeleteOperation >> transformAndReplaceParentNodeInSourceWithOffset: offset [

	| codeBeforeNode codeAfterNode |
	codeBeforeNode := sourceCode
		                  copyFrom: 1
		                  to: self parentNode startPos + offset - 1.
	codeAfterNode := sourceCode
		                 copyFrom: self parentNode endPos + offset + 1
		                 to: sourceCode size.

	^ '' join: { 
			  codeBeforeNode.
			  self generateNode: self parentNode.
			  codeAfterNode }
]

{ #category : #'applying operation' }
DeleteOperation >> transformNodeIfNeeded [

	(self checkIfWholeLineMustBeRemovedInSourceCode: sourceCode) 
		ifFalse: [ 
			"removing the node from its parent" 
			transformedNode removeAllPotentialParentNode ]
]
