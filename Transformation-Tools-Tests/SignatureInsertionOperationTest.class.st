"
A SignatureInsertionOperationTest is a test class for testing the behavior of SignatureInsertionOperation
"
Class {
	#name : #SignatureInsertionOperationTest,
	#superclass : #TestCase,
	#instVars : [
		'builder'
	],
	#category : #'Transformation-Tools-Tests'
}

{ #category : #running }
SignatureInsertionOperationTest >> setUp [
	super setUp.
	
	"Put here a common initialization logic for tests"
	builder := FASTJavaCodeGeneratorBuilder new.
]

{ #category : #test }
SignatureInsertionOperationTest >> testApplyOperation [

	| fast op |
	fast := builder fastMethodTestMethod.
	op := builder signatureInsertionOperation1.
	
	self
		assert: (op
				 applyOperationOnSource: builder sourceMethodTestMethod
				 withOffset: 0)
		equals: builder sourceMethodTestMethodWithException.
		
	fast := builder fastClassWithTestMethod.
	op := builder signatureInsertionOperation2.
	
	self
		assert: (op
				 applyOperationOnSource: builder sourceClassWithTestMethod
				 withOffset: 0)
		equals: builder sourceClassWithTestMethodAndSuperclass.
]
