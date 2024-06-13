"
A GroupOfTransformationOperationsTest is a test class for testing the behavior of GroupOfTransformationOperations
"
Class {
	#name : #GroupOfTransformationOperationsTest,
	#superclass : #TestCase,
	#instVars : [
		'builder'
	],
	#category : #'Transformation-Tools-Tests'
}

{ #category : #running }
GroupOfTransformationOperationsTest >> setUp [
	super setUp.
	
	"Put here a common initialization logic for tests"
	builder := FASTJavaCodeGeneratorBuilder new.
]

{ #category : #test }
GroupOfTransformationOperationsTest >> testApplyOperationOnSourceWithOffset [

	| fast op op1 op2 list |
	fast := builder fastClassWithTestMethod.
	op1 := builder signatureInsertionOperation2.
	op2 := builder signatureInsertionOperation3.
	list := OrderedCollection new
		        add: op1;
		        add: op2;
		        yourself.

	op := GroupOfTransformationOperations new
		      operations: list;
		      yourself.

	self
		assert: (op
				 applyOperationOnSource: builder sourceClassWithTestMethod
				 withOffset: 0)
		equals: builder sourceClassWithTestMethodAndSuperclassAndInterface
]
