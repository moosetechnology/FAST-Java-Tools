"
An InsertionOperationTest is a test class for testing the behavior of InsertionOperation
"
Class {
	#name : #InsertionOperationTest,
	#superclass : #TestCase,
	#instVars : [
		'builder'
	],
	#category : #'Transformation-Tools-Tests'
}

{ #category : #running }
InsertionOperationTest >> setUp [
	super setUp.
	
	"Put here a common initialization logic for tests"
	builder := FASTJavaCodeGeneratorBuilder new.
]

{ #category : #test }
InsertionOperationTest >> testApplyOperation [

	| fastMethod op |
	fastMethod := builder fastMethodTestMethod.
	op := builder insertionOperation1.

	self
		assert: (op
				 applyOperationOnSource: builder sourceMethodTestMethod
				 withOffset: 0)
		equals: builder sourceMethodTestMethodWithCatColor
]
