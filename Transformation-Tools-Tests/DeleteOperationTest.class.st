"
A DeleteOperationTest is a test class for testing the behavior of DeleteOperation
"
Class {
	#name : #DeleteOperationTest,
	#superclass : #TestCase,
	#instVars : [
		'builder'
	],
	#category : #'Transformation-Tools-Tests'
}

{ #category : #running }
DeleteOperationTest >> setUp [
	super setUp.
	
	"Put here a common initialization logic for tests"
	builder := FASTJavaCodeGeneratorBuilder new.
]

{ #category : #test }
DeleteOperationTest >> testApplyOperation [

	| fastMethod op |
	fastMethod := builder fastMethodGetEdges.
	op := builder deleteOperation1.

	self
		assert:
		(op
			 applyOperationOnSource: builder sourceMethodGetEdges
			 withOffset: 0)
		equals: builder sourceMethodGetEdgesDeletingIf
]
