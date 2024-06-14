Class {
	#name : #TransformationApplyerOnSourceAnchor,
	#superclass : #Object,
	#instVars : [
		'fileSourceText',
		'classToTransform',
		'dictEntitiesToTransform',
		'importStrings'
	],
	#category : #'Transformation-Tools'
}

{ #category : #'as yet unclassified' }
TransformationApplyerOnSourceAnchor >> adaptFilePathOfClassToTransform [

	| referenceStr |
	referenceStr := self fileNameOfClassToTransform
		                allButFirst.

	[ (referenceStr indexOf: $/) isZero ] whileFalse: [ 
		referenceStr at: (referenceStr indexOf: $/) put: $\ ].

	^ referenceStr
]

{ #category : #adding }
TransformationApplyerOnSourceAnchor >> addEntityToTransform: aFamixJavaEntity withNewSource: aString [

	aFamixJavaEntity sourceAnchor fileName
	= self fileNameOfClassToTransform ifFalse: [ 
		Exception signal:
			'Entity to transform is not located in the file of the class to transform.' ].

	dictEntitiesToTransform at: aFamixJavaEntity put: aString
]

{ #category : #'as yet unclassified' }
TransformationApplyerOnSourceAnchor >> addImportStringsIfNeeded [

	| stringToInsert insertIndex |
	importStrings ifEmpty: [ ^ self ].
	
	stringToInsert := ''.
	importStrings do: [ :is | 
		| current |
		current := is trim.
		current last = $; ifFalse: [ current := current , ';' ].
		current := current , self carriageReturn.
		stringToInsert := stringToInsert , current ].

	insertIndex := fileSourceText findString: 'import'.

	fileSourceText := String streamContents: [ :s | 
		                  s
			                  nextPutAll:
				                  (fileSourceText copyFrom: 1 to: insertIndex - 1);
			                  nextPutAll: stringToInsert;
			                  nextPutAll:
				                  (fileSourceText
					                   copyFrom: insertIndex
					                   to: fileSourceText size) ]
]

{ #category : #'as yet unclassified' }
TransformationApplyerOnSourceAnchor >> buildFileReference [

	^ (String streamContents: [ :s | 
		   s
			   nextPutAll: classToTransform mooseModel rootFolder pathString;
			   nextPutAll: self adaptFilePathOfClassToTransform;
			   yourself ]) asPath asFileReference
]

{ #category : #adding }
TransformationApplyerOnSourceAnchor >> carriageReturn [

	^ (fileSourceText includes: Character lf)
		  ifTrue: [ String crlf ]
		  ifFalse: [ String cr ]
]

{ #category : #accessing }
TransformationApplyerOnSourceAnchor >> classToTransform [

	^ classToTransform
]

{ #category : #accessing }
TransformationApplyerOnSourceAnchor >> classToTransform: anObject [

	classToTransform := anObject
]

{ #category : #'as yet unclassified' }
TransformationApplyerOnSourceAnchor >> copyOriginalFileContent [
	
	| stream content |
	stream := self buildFileReference readStream.
	content := stream upToEnd.
	stream close.
	
	fileSourceText := content
]

{ #category : #'as yet unclassified' }
TransformationApplyerOnSourceAnchor >> fileNameOfClassToTransform [

	^ classToTransform sourceAnchor fileName
]

{ #category : #accessing }
TransformationApplyerOnSourceAnchor >> importStrings [

	^ importStrings
]

{ #category : #accessing }
TransformationApplyerOnSourceAnchor >> importStrings: anObject [

	importStrings := anObject
]

{ #category : #adding }
TransformationApplyerOnSourceAnchor >> initialize [ 
		
	dictEntitiesToTransform := Dictionary new.
	importStrings := OrderedCollection new.
]

{ #category : #'as yet unclassified' }
TransformationApplyerOnSourceAnchor >> transformClass: aFamixJavaClass withNewSource: aString [

	classToTransform := aFamixJavaClass.

	self copyOriginalFileContent.
	self transformEntity: aFamixJavaClass withNewSource: aString.
	self addImportStringsIfNeeded.
	self transformSourceFile
]

{ #category : #'as yet unclassified' }
TransformationApplyerOnSourceAnchor >> transformEntity: aFamixEntity withNewSource: aString [

	fileSourceText := String streamContents: [ :s | 
		                  s
			                  nextPutAll:
				                  (fileSourceText
					                   copyFrom: 1
					                   to: aFamixEntity sourceAnchor startPos - 1);
			                  nextPutAll: aString;
			                  nextPutAll: (fileSourceText
					                   copyFrom: aFamixEntity sourceAnchor endPos + 1
					                   to: fileSourceText size);
			                  yourself ]
]

{ #category : #'as yet unclassified' }
TransformationApplyerOnSourceAnchor >> transformSourceFile [

	| stream |
	self buildFileReference delete.
	
	stream := self buildFileReference writeStream.
	stream nextPutAll: fileSourceText.
	stream close
]
