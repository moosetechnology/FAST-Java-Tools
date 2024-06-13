"
A DeclarationInsertionOperationTest is a test class for testing the behavior of DeclarationInsertionOperation
"
Class {
	#name : #DeclarationInsertionOperationTest,
	#superclass : #TestCase,
	#instVars : [
		'builder'
	],
	#category : #'Transformation-Tools-Tests'
}

{ #category : #running }
DeclarationInsertionOperationTest >> setUp [

	super setUp.

	"Put here a common initialization logic for tests"
	builder := FASTJavaCodeGeneratorBuilder new
]

{ #category : #tests }
DeclarationInsertionOperationTest >> testApplyOperation [

	| fast op |
	fast := builder fastClassWithTestMethod.
	op := builder declarationInsertionOperation1.
	
	self
		assert: (op
				 applyOperationOnSource: builder sourceClassWithTestMethod
				 withOffset: 0)
		equals: builder sourceClassWithTestMethodAndConstructorBefore.
		
	fast := builder fastClassWithTestMethod.
	op := builder declarationInsertionOperation2.
	
	self
		assert: (op
				 applyOperationOnSource: builder sourceClassWithTestMethod
				 withOffset: 0)
		equals: builder sourceClassWithTestMethodAndConstructorAfter.
]
