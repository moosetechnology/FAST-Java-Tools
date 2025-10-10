"
This transformation operation is used to insert a node (and its eventual children nodes) as a new statement in the source code of the entity.
This allows to add new statements before or after the anchor node, using the identation of the anchor node for a seamless insertion.

This operation requires to be given as the `transformedNode` the node to insert, and the node to use as insertion location through the `anchorNode:` setter.

This operation also has an `insertBefore` instance variable, by default set to false. By default, the statement will be inserted after the anchor statement, setting `insertBefore` to true will insert the statement before the anchor node.

An example of use is shown in the test in the method `applyStatementInsertionOperationTest` of class `FASTJavaCodeGeneratorKeepingFormattingTest`.
"
Class {
	#name : 'StatementInsertionOperation',
	#superclass : 'InsertionOperation',
	#instVars : [
		'insertBefore'
	],
	#category : 'Transformation-Tools',
	#package : 'Transformation-Tools'
}

{ #category : 'applying operation' }
StatementInsertionOperation >> buildNewNode [
	"returns the new node created using the anchor and transformed node"
	^ transformedNode
]

{ #category : 'sorting' }
StatementInsertionOperation >> getPosForSorting [

	"returns a position in the source code string, used to sort the operation list"

	"returns one before or after a startPos to be sorted before or after potential operations on the anchor node"
	"that small offset should be enough"
	^ insertBefore
		ifTrue: [ anchorNode startPos - 1 ]
		ifFalse: [ anchorNode endPos + 1 ]
]

{ #category : 'initialization' }
StatementInsertionOperation >> initialize [ 

	super initialize.
	
	insertBefore := false
]

{ #category : 'accessing' }
StatementInsertionOperation >> insertBefore [

	^ insertBefore
]

{ #category : 'accessing' }
StatementInsertionOperation >> insertBefore: aBoolean [

	insertBefore := aBoolean
]
