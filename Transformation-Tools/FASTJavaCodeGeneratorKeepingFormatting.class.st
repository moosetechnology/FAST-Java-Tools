Class {
	#name : #FASTJavaCodeGeneratorKeepingFormatting,
	#superclass : #Object,
	#instVars : [
		'operationList',
		'originalEntity',
		'transformedCodeString',
		'offsetDict',
		'removedHighlights',
		'addedHighlights',
		'transformedEntitiesPosition'
	],
	#category : #'Transformation-Tools'
}

{ #category : #'as yet unclassified' }
FASTJavaCodeGeneratorKeepingFormatting class >> onEntity: aFamixEntity forOperations: operationsList [

	^ self new
		  originalEntity: aFamixEntity;
		  operationList: operationsList;
		  yourself
]

{ #category : #'as yet unclassified' }
FASTJavaCodeGeneratorKeepingFormatting >> addTransformationPointerIfNeededFor: aTransformationOperation withLastOffsetValue: offsetToApply [

	| parentEntity |
	"if it's a new declaration, add it without entity"
	aTransformationOperation class = DeclarationInsertionOperation 
		ifTrue: [ 
			transformedEntitiesPosition add: (TransformationPointerWrapper new
					 newVersionStartIndex: aTransformationOperation addedHighlight x;
					 oldVersionStartIndex:
						 aTransformationOperation addedHighlight x - offsetToApply).
			^ self ].

	parentEntity := self getParentEntityFor: aTransformationOperation.

	"operations are ordered, so if the last entity with a pointer is not the parent entity, there's no pointer for it"
	(transformedEntitiesPosition isNotEmpty and: [ 
		 transformedEntitiesPosition last entity = parentEntity ]) ifTrue: [ 
		^ self ].

	transformedEntitiesPosition add: (TransformationPointerWrapper new
			 entity: parentEntity;
			 newVersionStartIndex: aTransformationOperation addedHighlight x;
			 oldVersionStartIndex: aTransformationOperation removedHighlight x)
]

{ #category : #accessing }
FASTJavaCodeGeneratorKeepingFormatting >> addedHighlights [

	^ addedHighlights
]

{ #category : #accessing }
FASTJavaCodeGeneratorKeepingFormatting >> addedHighlights: anObject [

	addedHighlights := anObject
]

{ #category : #'as yet unclassified' }
FASTJavaCodeGeneratorKeepingFormatting >> applyCodeTransformation [

	transformedCodeString := originalEntity sourceText.

	"setting original source code, used by some operations for sorting"
	operationList do: [ :o | o sourceCode: transformedCodeString ].

	"sort to simplify the calculus of offset and highlights"
	operationList sort: [ :a :b | 
		a getPosForSorting < b getPosForSorting ].

	operationList do: [ :op | 
		self applyOperation: op.
		op removedHighlight ifNotNil: [ 
			removedHighlights add: op removedHighlight ].
		op addedHighlight ifNotNil: [ 
			addedHighlights add: op addedHighlight ] ].

	^ transformedCodeString
]

{ #category : #'as yet unclassified' }
FASTJavaCodeGeneratorKeepingFormatting >> applyOperation: aTransformationOperation [

	| newOffsetPos offsetToApply oldSourceSize fast |
	newOffsetPos := aTransformationOperation 
		                findNewOffsetPosWithOffsetDict: offsetDict.
	offsetToApply := aTransformationOperation
		                 computeOffsetWithOriginalPos: newOffsetPos
		                 andOffsetDict: offsetDict.

	oldSourceSize := transformedCodeString size.

	originalEntity generateFastIfNotDoneAndBind.

	fast := originalEntity class = FamixJavaClass
		        ifTrue: [ originalEntity fastTypeDefinition ]
		        ifFalse: [ originalEntity fast ].

	transformedCodeString := aTransformationOperation
		                         applyOperationOnSource:
		                         transformedCodeString
		                         withOffset: offsetToApply.
		
	self addTransformationPointerIfNeededFor: aTransformationOperation withLastOffsetValue: offsetToApply.

	offsetDict add:
		newOffsetPos -> (transformedCodeString size - oldSourceSize)
]

{ #category : #'as yet unclassified' }
FASTJavaCodeGeneratorKeepingFormatting >> getParentEntityFor: aTransformationOperation [

	| currentNode |
	currentNode := aTransformationOperation anchorNode.

	[ 
	currentNode class = FASTJavaMethodEntity or: [ 
		currentNode class = FASTJavaClassDeclaration ] ] whileFalse: [ 
		currentNode := currentNode parentNode ].
	
	^ currentNode
]

{ #category : #initialization }
FASTJavaCodeGeneratorKeepingFormatting >> initialize [

	operationList := OrderedCollection new.
	offsetDict := OrderedDictionary new.
	removedHighlights := OrderedCollection new.
	addedHighlights := OrderedCollection new.
	transformedEntitiesPosition := OrderedCollection new
]

{ #category : #accessing }
FASTJavaCodeGeneratorKeepingFormatting >> operationList [

	^ operationList
]

{ #category : #accessing }
FASTJavaCodeGeneratorKeepingFormatting >> operationList: anObject [

	operationList := anObject
]

{ #category : #accessing }
FASTJavaCodeGeneratorKeepingFormatting >> originalEntity [

	^ originalEntity
]

{ #category : #accessing }
FASTJavaCodeGeneratorKeepingFormatting >> originalEntity: anObject [

	originalEntity := anObject
]

{ #category : #accessing }
FASTJavaCodeGeneratorKeepingFormatting >> removedHighlights [

	^ removedHighlights
]

{ #category : #accessing }
FASTJavaCodeGeneratorKeepingFormatting >> removedHighlights: anObject [

	removedHighlights := anObject
]

{ #category : #accessing }
FASTJavaCodeGeneratorKeepingFormatting >> transformedEntitiesPosition [

	^ transformedEntitiesPosition
]

{ #category : #accessing }
FASTJavaCodeGeneratorKeepingFormatting >> transformedEntitiesPosition: anObject [

	transformedEntitiesPosition := anObject
]
