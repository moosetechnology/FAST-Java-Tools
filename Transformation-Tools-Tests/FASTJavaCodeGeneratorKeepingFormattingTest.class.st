"
A FASTJavaCodeGeneratorKeepingFormattingTest is a test class for testing the behavior of FASTJavaCodeGeneratorKeepingFormatting
"
Class {
	#name : #FASTJavaCodeGeneratorKeepingFormattingTest,
	#superclass : #TestCase,
	#instVars : [
		'builder'
	],
	#category : #'Transformation-Tools-Tests'
}

{ #category : #test }
FASTJavaCodeGeneratorKeepingFormattingTest >> applyDeclarationInsertionOperationTest [

	| fast op tool |
	fast := builder fastClassWithTestMethod.
	op := builder declarationInsertionOperation1.
	tool := builder
		        codeGeneratorFor: builder sourceClassWithTestMethod
		        withOps: (OrderedCollection new
				         add: op;
				         yourself).

	self
		assert: tool applyCodeTransformation
		equals: builder sourceClassWithTestMethodAndConstructorBefore.

	fast := builder fastClassWithTestMethod.
	op := builder declarationInsertionOperation2.
	tool := builder
		        codeGeneratorFor: builder sourceClassWithTestMethod
		        withOps: (OrderedCollection new
				         add: op;
				         yourself).

	self
		assert: tool applyCodeTransformation
		equals: builder sourceClassWithTestMethodAndConstructorAfter
]

{ #category : #'as yet unclassified' }
FASTJavaCodeGeneratorKeepingFormattingTest >> applyGroupTransformationOperation [

	| fast op op1 op2 list tool |
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

	tool := builder
		        codeGeneratorFor: builder sourceClassWithTestMethod
		        withOps: (OrderedCollection new
				         add: op;
				         yourself).

	self
		assert: tool applyCodeTransformation
		equals: builder sourceClassWithTestMethodAndSuperclassAndInterface
]

{ #category : #test }
FASTJavaCodeGeneratorKeepingFormattingTest >> applyReplacingOperationTest [

	| fastMethod op tool |
	fastMethod := builder fastMethodGetEdges.
	op := builder replacingOperation1.
	tool := builder
		        codeGeneratorFor: builder sourceMethodGetEdges
		        withOps: (OrderedCollection new
				         add: op;
				         yourself).
	
	self
		assert: tool applyCodeTransformation
		equals: builder sourceMethodGetEdgesReplacingSuperNode
]

{ #category : #test }
FASTJavaCodeGeneratorKeepingFormattingTest >> applySimpleInsertionOperationTest [

	| fastMethod op tool |
	fastMethod := builder fastMethodTestMethod.
	op := builder insertionOperation1.
	tool := builder
		        codeGeneratorFor: builder sourceMethodTestMethod
		        withOps: (OrderedCollection new
				         add: op;
				         yourself).

	self
		assert: tool applyCodeTransformation
		equals: builder sourceMethodTestMethodWithCatColor
]

{ #category : #test }
FASTJavaCodeGeneratorKeepingFormattingTest >> applySimpleSignatureInsertionOperation [

	| fast op tool |
	fast := builder fastMethodTestMethod.
	op := builder signatureInsertionOperation1.
	tool := builder
		        codeGeneratorFor: builder sourceMethodTestMethod
		        withOps: (OrderedCollection new
				         add: op;
				         yourself).

	self
		assert: tool applyCodeTransformation
		equals: builder sourceMethodTestMethodWithException.

	fast := builder fastClassWithTestMethod.
	op := builder signatureInsertionOperation2.
		tool := builder
		        codeGeneratorFor: builder sourceClassWithTestMethod 
		        withOps: (OrderedCollection new
				         add: op;
				         yourself).

	self
		assert: tool applyCodeTransformation
		equals: builder sourceClassWithTestMethodAndSuperclass
]

{ #category : #test }
FASTJavaCodeGeneratorKeepingFormattingTest >> applyStatementInsertionOperationTest [

	| fast op tool |
	fast := builder fastMethodTestMethod.
	op := builder statementInsertionOperation1.
	tool := builder
		        codeGeneratorFor: builder sourceMethodTestMethod 
		        withOps: (OrderedCollection new
				         add: op;
				         yourself).
	
	self
		assert: tool applyCodeTransformation
		equals: builder sourceMethodTestMethodWithCatMeows.
		
	fast := builder fastMethodTestMethod.
	op := builder statementInsertionOperation2.
	tool := builder
		        codeGeneratorFor: builder sourceMethodTestMethod 
		        withOps: (OrderedCollection new
				         add: op;
				         yourself).
	
	self
		assert: tool applyCodeTransformation 
		equals: builder sourceMethodTestMethodWithCatMeowsBeforeTable.
]

{ #category : #running }
FASTJavaCodeGeneratorKeepingFormattingTest >> setUp [
	super setUp.
	
	"Put here a common initialization logic for tests"
	builder := FASTJavaCodeGeneratorBuilder new.
]

{ #category : #test }
FASTJavaCodeGeneratorKeepingFormattingTest >> testApplyDeleteOperation [

	| fastMethod op tool |
	fastMethod := builder fastMethodGetEdges.
	op := builder deleteOperation1.
	tool := builder
		        codeGeneratorFor: builder sourceMethodGetEdges
		        withOps: (OrderedCollection new
				         add: op;
				         yourself).

	self
		assert: tool applyCodeTransformation
		equals: builder sourceMethodGetEdgesDeletingIf
]

{ #category : #test }
FASTJavaCodeGeneratorKeepingFormattingTest >> testApplyReplacingOperation [

	self applySimpleInsertionOperationTest.
	self applyReplacingOperationTest
]

{ #category : #test }
FASTJavaCodeGeneratorKeepingFormattingTest >> testApplySignatureInsertionOperation [

	self applySimpleSignatureInsertionOperation.
	self applyGroupTransformationOperation
]

{ #category : #test }
FASTJavaCodeGeneratorKeepingFormattingTest >> testApplyStatementOrDeclarationInsertionOperation [

	self applyStatementInsertionOperationTest.
	self applyDeclarationInsertionOperationTest
]
