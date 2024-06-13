"
A StatementInsertionOperationTest is a test class for testing the behavior of StatementInsertionOperation
"
Class {
	#name : #StatementInsertionOperationTest,
	#superclass : #TestCase,
	#instVars : [
		'builder'
	],
	#category : #'Transformation-Tools-Tests'
}

{ #category : #running }
StatementInsertionOperationTest >> setUp [
	super setUp.
	
	"Put here a common initialization logic for tests"
	builder := FASTJavaCodeGeneratorBuilder new.
]

{ #category : #test }
StatementInsertionOperationTest >> testApplyOperation [

	| fast op |
	fast := builder fastMethodTestMethod.
	op := builder statementInsertionOperation1.
	
	self
		assert: (op
				 applyOperationOnSource: builder sourceMethodTestMethod
				 withOffset: 0)
		equals: builder sourceMethodTestMethodWithCatMeows.
]
