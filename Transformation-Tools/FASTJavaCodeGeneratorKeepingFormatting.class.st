"
I receive a collection of transformation operations and the source code of an entity to apply the transformations on this source code.
These operations do not modify the FAST of the entities that are transformed, but use the information within those nodes (most notably, their `startPos` and `endPos` attribute), in order to properly transform the code as necessary.

This way of transforming the code allows us to maintain the ""aspect"" of the code, namely the indentation, comments and empty lines, which would be lost if we were to regenerate the code of the entire FAST tree.

The operations must use anchor nodes that are found at their `startPos` and `endPos` in the given source code for the transformation to be successful.

The easiest way to instantiate this class is by using the class method `onSourceCode: aString forOperations: operationsList`.
After that, using the method `applyCodeTransformation` will process and apply every given transformation operation before returning the fully transformed source code.

Once a transformation is completed, the tool has additional data available through several accessors :
- `addedHighlights` : Contains a collection of `Point` instances, with the start position of a transformed portion of code in `x` and the end position in `y`. This allows to highlight every modification in the transformed code string, using the `TransformationEditor` modal window.
- `removedHighlights` : Contains a collection of `Point` instances, with the start position of a transformed portion of code in `x` and the end position in `y`. This allows to highlight every modification in the original code string, using the `TransformationEditor` modal window.
- `transformedEntitiesPosition` : Contains a collection of `TransformationPointerWrapper`, with an index for the original code string and an index for the transformed code string, as well as the pointed FAST entity. This allows to easily jump from transformed method to transformed method inside a transfored class, using the `TransformationEditor` modal window.
"
Class {
	#name : #FASTJavaCodeGeneratorKeepingFormatting,
	#superclass : #Object,
	#instVars : [
		'operationList',
		'offsetToApply',
		'removedHighlights',
		'addedHighlights',
		'transformedEntitiesPosition',
		'sourceCode',
		'currentOperation'
	],
	#category : #'Transformation-Tools'
}

{ #category : #'as yet unclassified' }
FASTJavaCodeGeneratorKeepingFormatting class >> onSourceCode: aString forOperations: operationsList [

	^ self new
		  sourceCode: aString;
		  operationList: operationsList;
		  yourself
]

{ #category : #'setting pointer' }
FASTJavaCodeGeneratorKeepingFormatting >> addTransformationPointerIfNeeded [

	| parentEntity |
	"if it's a new declaration, add it without entity"
	currentOperation class = DeclarationInsertionOperation 
		ifTrue: [ 
			transformedEntitiesPosition add: (TransformationPointerWrapper new
					 newVersionStartIndex: addedHighlights last x;
					 oldVersionStartIndex:
						 addedHighlights last x - offsetToApply).
			^ self ].

	parentEntity := self getParentEntityFor: currentOperation.

	"operations are ordered, so if the last entity with a pointer is not the parent entity, there's no pointer for it"
	(transformedEntitiesPosition isNotEmpty and: [ 
		 transformedEntitiesPosition last entity = parentEntity ]) ifTrue: [ 
		^ self ].

	transformedEntitiesPosition add: (TransformationPointerWrapper new
			 entity: parentEntity;
			 newVersionStartIndex: parentEntity startPos + offsetToApply;
			 oldVersionStartIndex: parentEntity startPos)
]

{ #category : #accessing }
FASTJavaCodeGeneratorKeepingFormatting >> addedHighlights [

	^ addedHighlights
]

{ #category : #execute }
FASTJavaCodeGeneratorKeepingFormatting >> applyCodeTransformation [

	"sort to simplify the calculus of offset and highlights"
	operationList sort: [ :a :b | 
		a getPosForSorting < b getPosForSorting ].

	operationList do: [ :op | 
		self processOperation: op ].

	^ sourceCode
]

{ #category : #'applying operation' }
FASTJavaCodeGeneratorKeepingFormatting >> applyDeleteOperation [

	| lineBeginIndex nextLineBeginIndex |
	lineBeginIndex := self findIndexOfLineBegginingFrom:
		                  currentOperation anchorNode startPos
		                  + offsetToApply.

	nextLineBeginIndex := self findIndexOfStartOfNextLineFrom:
		                      currentOperation anchorNode endPos
		                      + offsetToApply.

	sourceCode := String streamContents: [ :s | 
		              s
			              nextPutAll:
				              (sourceCode copyFrom: 1 to: lineBeginIndex - 1);
			              nextPutAll:
				              (sourceCode
					               copyFrom: nextLineBeginIndex
					               to: sourceCode size);
			              yourself ].

	"no new string added, so only a removed highlight"
	self newRemovedHighlightOnAnchor
]

{ #category : #'applying operation' }
FASTJavaCodeGeneratorKeepingFormatting >> applyReplacingOperation [

	| anchorNode newNodeCode codeBeforeNode codeAfterNode |
	newNodeCode := self generateNode: currentOperation buildNewNode.
	anchorNode := currentOperation anchorNode.

	codeBeforeNode := sourceCode
		                  copyFrom: 1
		                  to: anchorNode startPos + offsetToApply - 1.
	codeAfterNode := sourceCode
		                 copyFrom: anchorNode endPos + offsetToApply + 1
		                 to: sourceCode size.

	sourceCode := String streamContents: [ :s | 
		              s
			              nextPutAll: codeBeforeNode;
			              nextPutAll: newNodeCode;
			              nextPutAll: codeAfterNode;
			              yourself ].

	self newRemovedHighlightOnAnchor.
	self
		newAddedHighlightApplyingOffsetStart: anchorNode startPos
		end: anchorNode startPos + newNodeCode size
]

{ #category : #'applying operation' }
FASTJavaCodeGeneratorKeepingFormatting >> applySignatureInsertionOperation [

	| generatedSignature anchorNode searchedCharacter indexOfSearchedCharacter |
	generatedSignature := self generateAndCleanSignatureForNode:
		                      currentOperation buildNewNode.
	anchorNode := currentOperation anchorNode.

	searchedCharacter := self getClosingSignatureCharacterOfAnchorNode.
	indexOfSearchedCharacter := sourceCode
		                            indexOf: searchedCharacter
		                            startingAt:
		                            anchorNode startPos + offsetToApply.

	sourceCode := String streamContents: [ :s | 
		              s
			              nextPutAll:
				              (sourceCode
					               copyFrom: 1
					               to: anchorNode startPos + offsetToApply - 1);
			              nextPutAll: generatedSignature;
			              nextPutAll:
				              (sourceCode
					               copyFrom: indexOfSearchedCharacter
					               to: sourceCode size);
			              yourself ].

	self
		newRemovedHighlightStart: anchorNode startPos
		end: indexOfSearchedCharacter - offsetToApply.
	self
		newAddedHighlightApplyingOffsetStart: anchorNode startPos
		end: anchorNode startPos + generatedSignature size
]

{ #category : #'applying operation' }
FASTJavaCodeGeneratorKeepingFormatting >> applyStatementOrDeclarationInsertionOperation [

	| insertIndex oldSourceSize |
	oldSourceSize := sourceCode size.

	insertIndex := currentOperation insertBefore
		               ifTrue: [ 
			               self findIndexOfLineBegginingFrom:
				               currentOperation anchorNode startPos
				               + offsetToApply ]
		               ifFalse: [ 
			               self findIndexOfStartOfNextLineFrom:
				               currentOperation anchorNode endPos + offsetToApply ].

	self
		insertNewNodeString:
		(self generateNodeToInsert: currentOperation buildNewNode)
		at: insertIndex.

	self
		newAddedHighlightStart: insertIndex
		end: insertIndex + sourceCode size - oldSourceSize
]

{ #category : #parsing }
FASTJavaCodeGeneratorKeepingFormatting >> findIndexOfLineBegginingFrom: anIndex [

	| index |
	index := anIndex - 1.

	"searching for the previous line delimitor, ending if something other than a delimitor is found"
	[ 
	(sourceCode at: index) = Character lf or: [ 
		(sourceCode at: index) = Character cr or: [ 
			(sourceCode at: index) isSeparator not ] ] ] whileFalse: [ 
		index := index - 1 ].

	"returning the index after the cr or crlf to get the start of the new line"
	^ index + 1
]

{ #category : #parsing }
FASTJavaCodeGeneratorKeepingFormatting >> findIndexOfStartOfNextLineFrom: anIndex [

	| index |
	index := anIndex + 1.

	"stop when finding a cr character or something that is not a delimitor"
	[ 
	(sourceCode at: index) = Character cr or: [ 
		(sourceCode at: index) isSeparator not ] ] whileFalse: [ 
		index := index + 1 ].

	"to get the start of the next line, get one character after cr or crlf (or a character that is not a delimitor)"
	index := (sourceCode at: index + 1) = Character lf
		         ifTrue: [ index + 2 ]
		         ifFalse: [ index + 1 ].

	^ index
]

{ #category : #'string generation' }
FASTJavaCodeGeneratorKeepingFormatting >> generateAndCleanForInsertedNode: aFASTNode [

	| newCodeString indentOfAnchorDeclaration joinString |
	newCodeString := (self generateNode: aFASTNode) trim.

	"if the node to insert has several lines (new method declaration for example), add the indent to each line but the first"
	currentOperation class = DeclarationInsertionOperation ifTrue: [ 
		indentOfAnchorDeclaration := self getIndentFromAnchorStatement.
		"making sure to keep the same type of end of line"
		joinString := self lineDelimetersUsedInSourceCode.

		"adding the same indent to the whole declaration"
		newCodeString := joinString join:
			                 (newCodeString lines collect: [ :l | 
				                  indentOfAnchorDeclaration , l ]) ].

	^ newCodeString
]

{ #category : #'string generation' }
FASTJavaCodeGeneratorKeepingFormatting >> generateAndCleanSignatureForNode: aFASTNode [

	| generatedSignature anchorNode |
	generatedSignature := self generateNode: aFASTNode.
	anchorNode := currentOperation anchorNode.

	anchorNode class = FASTJavaMethodEntity ifTrue: [ 
		"removing the cr and semi colon on the generated signature"
		generatedSignature := (generatedSignature allButLast: 2)
		                      , String space ].

	"copying only the signature for a class declaration, so everything before the opening bracket"
	anchorNode class = FASTJavaClassDeclaration ifTrue: [ 
		generatedSignature := generatedSignature
			                      copyFrom: 1
			                      to: (generatedSignature indexOf: ${) - 1 ].

	^ generatedSignature
]

{ #category : #'string generation' }
FASTJavaCodeGeneratorKeepingFormatting >> generateCurrentTransformedNode [

	^ self generateNode: currentOperation transformedNode
]

{ #category : #'string generation' }
FASTJavaCodeGeneratorKeepingFormatting >> generateNode: aFASTJavaNode [

	^ FASTJavaExportVisitor new export: aFASTJavaNode
]

{ #category : #'string generation' }
FASTJavaCodeGeneratorKeepingFormatting >> generateNodeToInsert: aFASTNode [

	^ String streamContents: [ :s | 
		  s
			  nextPutAll: self insertedStringPrefix;
			  nextPutAll: (self generateAndCleanForInsertedNode: aFASTNode);
			  nextPutAll: self insertedStringSuffix;
			  yourself ]
]

{ #category : #parsing }
FASTJavaCodeGeneratorKeepingFormatting >> getClosingSignatureCharacterOfAnchorNode [

	"if the signature to transform is a method declared in an interface or is abstract"
	(currentOperation anchorNode class = FASTJavaMethodEntity and: [ 
		 currentOperation anchorNode statementBlock isNil ]) ifTrue: [ ^ $; ].

	"every other method or class"
	^ ${
]

{ #category : #parsing }
FASTJavaCodeGeneratorKeepingFormatting >> getIndentFromAnchorStatement [

	^ sourceCode
		  copyFrom: (self findIndexOfLineBegginingFrom:
				   currentOperation anchorNode startPos + offsetToApply)
		  to: currentOperation anchorNode startPos + offsetToApply - 1
]

{ #category : #'lookup elements' }
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
	removedHighlights := OrderedCollection new.
	addedHighlights := OrderedCollection new.
	transformedEntitiesPosition := OrderedCollection new.
	offsetToApply := 0
]

{ #category : #'string generation' }
FASTJavaCodeGeneratorKeepingFormatting >> insertNewNodeString: newCodeString at: anIndex [

	sourceCode := String streamContents: [ :s | 
		              s
			              nextPutAll: (sourceCode copyFrom: 1 to: anIndex - 1);
			              nextPutAll: newCodeString;
			              nextPutAll:
				              (sourceCode copyFrom: anIndex to: sourceCode size);
			              yourself ]
]

{ #category : #'string generation' }
FASTJavaCodeGeneratorKeepingFormatting >> insertedStringPrefix [

	^ String streamContents: [ :s | 
		  currentOperation class = DeclarationInsertionOperation
			  ifTrue: [ 
				  currentOperation insertBefore ifFalse: [ 
					"if the new node is inserted after the anchor statement, add an additional line delimitor in the suffix"
					  s nextPutAll: self lineDelimetersUsedInSourceCode ] ]
				"only add the indent for a statement insertion"
			  ifFalse: [ s nextPutAll: self getIndentFromAnchorStatement ] ]
]

{ #category : #'string generation' }
FASTJavaCodeGeneratorKeepingFormatting >> insertedStringSuffix [

	^ String streamContents: [ :s | 
		  s nextPutAll: self lineDelimetersUsedInSourceCode.
		  "if the new node is inserted before the anchor statement, adding another line delimitor in the suffix"
		  (currentOperation class = DeclarationInsertionOperation and: [ 
			   currentOperation insertBefore ]) ifTrue: [ 
			  s nextPutAll: self lineDelimetersUsedInSourceCode ] ]
]

{ #category : #'string generation' }
FASTJavaCodeGeneratorKeepingFormatting >> lineDelimetersUsedInSourceCode [

	^ (sourceCode includes: Character lf)
		  ifTrue: [ String crlf ]
		  ifFalse: [ String cr ]
]

{ #category : #highlighting }
FASTJavaCodeGeneratorKeepingFormatting >> newAddedHighlightApplyingOffsetStart: startIndex end: endIndex [

	self
		newHighlightInCollection: addedHighlights
		start: startIndex + offsetToApply
		end: endIndex + offsetToApply
]

{ #category : #highlighting }
FASTJavaCodeGeneratorKeepingFormatting >> newAddedHighlightStart: startIndex end: endIndex [

	self
		newHighlightInCollection: addedHighlights
		start: startIndex
		end: endIndex
]

{ #category : #highlighting }
FASTJavaCodeGeneratorKeepingFormatting >> newHighlightInCollection: aCollection start: startIndex end: endIndex [

	aCollection add: startIndex @ endIndex
]

{ #category : #highlighting }
FASTJavaCodeGeneratorKeepingFormatting >> newRemovedHighlightOnAnchor [

	self
		newRemovedHighlightStart: currentOperation anchorNode startPos
		end: currentOperation anchorNode endPos
]

{ #category : #highlighting }
FASTJavaCodeGeneratorKeepingFormatting >> newRemovedHighlightStart: startIndex end: endIndex [

	self
		newHighlightInCollection: removedHighlights
		start: startIndex
		end: endIndex
]

{ #category : #accessing }
FASTJavaCodeGeneratorKeepingFormatting >> operationList [

	^ operationList
]

{ #category : #accessing }
FASTJavaCodeGeneratorKeepingFormatting >> operationList: anObject [

	operationList := anObject
]

{ #category : #processing }
FASTJavaCodeGeneratorKeepingFormatting >> processDeleteOperation [

	currentOperation buildNewNode
		"if the anchor node must be fully removed"
		ifNil: [ self applyDeleteOperation ]
		"if the anchor node is removed by replacing its parent node"
		ifNotNil: [ self applyReplacingOperation ]
]

{ #category : #processing }
FASTJavaCodeGeneratorKeepingFormatting >> processGroupOperation [
	"a group operation is only for replacing, so either signature insertion or replacing is called"
	(currentOperation operations anySatisfy: [ :o | 
		 o class = SignatureInsertionOperation ])
		ifTrue: [ self applySignatureInsertionOperation ]
		ifFalse: [ self applyReplacingOperation ]
]

{ #category : #processing }
FASTJavaCodeGeneratorKeepingFormatting >> processInsertionOperation [

	currentOperation class = SignatureInsertionOperation ifTrue: [ 
		^ self applySignatureInsertionOperation ].

	"only two possible classes remaining at this point"
	self applyStatementOrDeclarationInsertionOperation 
]

{ #category : #processing }
FASTJavaCodeGeneratorKeepingFormatting >> processOperation: aTransformationOperation [

	| oldSourceSize |
	currentOperation := aTransformationOperation.
	oldSourceSize := sourceCode size.

	self processOperationByType. 

	self addTransformationPointerIfNeeded.

	offsetToApply := offsetToApply + (sourceCode size - oldSourceSize)
]

{ #category : #processing }
FASTJavaCodeGeneratorKeepingFormatting >> processOperationByType [

	"InsertionOperation actually replace the parent node, so true insertion behaviour is only used for its subclasses"

	(currentOperation class inheritsFrom: InsertionOperation) ifTrue: [ 
		^ self processInsertionOperation ].

	"processing again to check how to delete the node (by replacing its parent node or not)"
	currentOperation class = DeleteOperation ifTrue: [ 
		^ self processDeleteOperation ].

	currentOperation class = GroupOfTransformationOperations ifTrue: [ 
		^ self processGroupOperation ].

	"if not a (true) insertion or delete operation, then we will use replacing behaviour"
	self applyReplacingOperation
]

{ #category : #accessing }
FASTJavaCodeGeneratorKeepingFormatting >> removedHighlights [

	^ removedHighlights
]

{ #category : #accessing }
FASTJavaCodeGeneratorKeepingFormatting >> sourceCode [

	^ sourceCode
]

{ #category : #accessing }
FASTJavaCodeGeneratorKeepingFormatting >> sourceCode: anObject [

	sourceCode := anObject
]

{ #category : #accessing }
FASTJavaCodeGeneratorKeepingFormatting >> transformedEntitiesPosition [

	^ transformedEntitiesPosition
]
