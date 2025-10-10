"
A TransformationApplyerOnSourceAnchorTest is a test class for testing the behavior of TransformationApplyerOnSourceAnchor
"
Class {
	#name : 'TransformationApplyerOnSourceAnchorTest',
	#superclass : 'TestCase',
	#instVars : [
		'builder',
		'transformationTool'
	],
	#category : 'Transformation-Tools-Tests',
	#package : 'Transformation-Tools-Tests'
}

{ #category : 'asserting' }
TransformationApplyerOnSourceAnchorTest >> assertEntity: anEntity movedWithOffset: anOffset original: originalText [

	self assert: anEntity sourceText equals: originalText.
]

{ #category : 'asserting' }
TransformationApplyerOnSourceAnchorTest >> assertEntitySourceText: anEntity equalsOriginal: originalText [

	self assert: anEntity sourceText equals: originalText.
]

{ #category : 'running' }
TransformationApplyerOnSourceAnchorTest >> setUp [
	super setUp.

	"Put here a common initialization logic for tests"
	builder := TransformationApplyerOnSourceAnchorTestBuilder new.
	transformationTool := TransformationApplyerOnSourceAnchor new
]

{ #category : 'test' }
TransformationApplyerOnSourceAnchorTest >> testAddImportStringsIfNeeded [

	"testing in a file without any imports"
	transformationTool entityToTransform: builder testClass.
	transformationTool importStrings: builder importsToAddFirst.
	transformationTool copyOriginalFileContent.
	transformationTool addImportStringsIfNeeded.
	
	self assert: transformationTool fileSourceText equals: builder classTextWithFirstImports.
	
	"testing in the file, now with imports"
	transformationTool importStrings: builder importsToAddSecond.
	transformationTool addImportStringsIfNeeded.
	
	self assert: transformationTool fileSourceText equals: builder classTextWithAllImports.
]

{ #category : 'test' }
TransformationApplyerOnSourceAnchorTest >> testCopyOriginalFileContent [

	transformationTool entityToTransform: builder testClass.
	transformationTool copyOriginalFileContent.
	
	self assert: transformationTool fileSourceText equals: builder classText
]

{ #category : 'test' }
TransformationApplyerOnSourceAnchorTest >> testFindAndUpdatePosOfNextEntitiesInFile [

	| fileContent stream |
	stream := builder fileReference readStream.
	fileContent := stream upToEnd.
	stream close.

	builder fileReference delete.

	"modify source"
	fileContent := String streamContents: [ :s |
		               s
			               nextPutAll: (fileContent copyFrom: 1 to: 179);
			               nextPutAll: String crlf;
			               nextPutAll: String crlf;
			               nextPutAll: (fileContent copyFrom: 180 to: 347) ].
	
	stream := builder fileReference writeStream.
	stream nextPutAll: fileContent.
	stream close.
	
	transformationTool entityToTransform: builder testClass. 
	transformationTool transformedEntityEndPos: 179.
	transformationTool offset: 4.
	
	transformationTool findAndUpdatePosOfNextEntitiesInFile.
	
	"before file edit"
	self
		assertEntitySourceText: builder incrementMethod
		equalsOriginal: builder incrementSource.
	self
		assertEntitySourceText: builder firstConstructor
		equalsOriginal: builder firstConstructorSource.
	"after file edit"
	self
		assertEntitySourceText: builder secondConstructor
		equalsOriginal: builder secondConstructorSource.
	self
		assertEntitySourceText: builder printMethod
		equalsOriginal: builder printSource
	
]

{ #category : 'test' }
TransformationApplyerOnSourceAnchorTest >> testFindRootClass [

	transformationTool entityToTransform: builder testClass.
	self assert: transformationTool findRootClass equals: builder testClass.

	transformationTool entityToTransform: builder incrementMethod.
	self assert: transformationTool findRootClass equals: builder testClass.
]

{ #category : 'test' }
TransformationApplyerOnSourceAnchorTest >> testTransformClassWithNewSource [

	transformationTool transformClass: builder testClass withNewSource: builder classTextWithNewMethod.
	
	self assert: builder testClass sourceText equals: builder classTextWithNewMethod. 
]

{ #category : 'test' }
TransformationApplyerOnSourceAnchorTest >> testTransformMethodWithNewSource [

	transformationTool
		transformMethod: builder incrementMethod
		withNewSource: builder incrementNewSource.

	self
		assert: builder incrementMethod sourceText
		equals: builder incrementNewSource.
	self
		assertEntitySourceText: builder firstConstructor
		equalsOriginal: builder firstConstructorSource.
	self
		assertEntitySourceText: builder secondConstructor
		equalsOriginal: builder secondConstructorSource.
	self
		assertEntitySourceText: builder printMethod
		equalsOriginal: builder printSource
]
