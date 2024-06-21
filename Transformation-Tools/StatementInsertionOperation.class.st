Class {
	#name : #StatementInsertionOperation,
	#superclass : #InsertionOperation,
	#instVars : [
		'insertBefore'
	],
	#category : #'Transformation-Tools'
}

{ #category : #'applying operation' }
StatementInsertionOperation >> buildNewNode [
	"returns the new node created using the anchor and transformed node"
	^ transformedNode
]

{ #category : #'as yet unclassified' }
StatementInsertionOperation >> getPosForSorting [

	"returns a position in the source code string, used to sort the operation list"

	"returns one before or after a startPos to be sorted before or after potential operations on the anchor node"
	"that small offset should be enough"
	^ insertBefore
		ifTrue: [ anchorNode startPos - 1 ]
		ifFalse: [ anchorNode endPos + 1 ]
]

{ #category : #initialization }
StatementInsertionOperation >> initialize [ 

	super initialize.
	
	insertBefore := false
]

{ #category : #accessing }
StatementInsertionOperation >> insertBefore [

	^ insertBefore
]

{ #category : #accessing }
StatementInsertionOperation >> insertBefore: aBoolean [

	insertBefore := aBoolean
]
