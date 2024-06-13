"
A ReplacingOperationTest is a test class for testing the behavior of ReplacingOperation
"
Class {
	#name : #ReplacingOperationTest,
	#superclass : #TestCase,
	#instVars : [
		'builder'
	],
	#category : #'Transformation-Tools-Tests'
}

{ #category : #running }
ReplacingOperationTest >> setUp [
	super setUp.
	
	"Put here a common initialization logic for tests"
	builder := FASTJavaCodeGeneratorBuilder new.
]

{ #category : #test }
ReplacingOperationTest >> testApplyOperation [

	| fastMethod op |
	fastMethod := builder fastMethodGetEdges.
	op := builder replacingOperation1.
	
	self
		assert: (op
				 applyOperationOnSource: builder sourceMethodGetEdges
				 withOffset: 0)
		equals: builder sourceMethodGetEdgesReplacingSuperNode
]
