Class {
	#name : #DeclarationInsertionOperation,
	#superclass : #StatementInsertionOperation,
	#category : #'Transformation-Tools'
}

{ #category : #'as yet unclassified' }
DeclarationInsertionOperation >> buildDeclarationString [

	| declarationString |
	declarationString := String streamContents: [ :s | 
		                   s
			                   nextPutAll: self stringPrefix;
			                   nextPutAll: self generateNodeAndCleanString;
			                   nextPutAll: self stringSuffix;
			                   yourself ].

	^ declarationString
]

{ #category : #'as yet unclassified' }
DeclarationInsertionOperation >> generateNodeAndCleanString [

	| codeString indentOfAnchorDeclaration joinString |
	codeString := self generateTransformedNode trim.
	indentOfAnchorDeclaration := self getIndentFromAnchorStatement.
	"making sure to keep the same type of end of line"
	joinString := self carriageReturn.

	"adding the same indent to the whole declaration"
	^ joinString join:
		  (codeString lines collect: [ :l | indentOfAnchorDeclaration , l ])
]

{ #category : #accessing }
DeclarationInsertionOperation >> insertNewNodeStringAt: anIndex [

	^ String streamContents: [ :s | 
		  s
			  nextPutAll: (sourceCode copyFrom: 1 to: anIndex - 1);
			  nextPutAll: self buildDeclarationString;
			  nextPutAll: (sourceCode copyFrom: anIndex to: sourceCode size);
			  yourself ]
]

{ #category : #'as yet unclassified' }
DeclarationInsertionOperation >> stringPrefix [

	^ insertBefore
		  ifTrue: [ '' ]
		  ifFalse: [ self carriageReturn ]
]

{ #category : #'as yet unclassified' }
DeclarationInsertionOperation >> stringSuffix [

	^ String streamContents: [ :s | 
		  s nextPutAll: self carriageReturn.
		  "if the new node is inserted before the anchor statement, the carriage return is in the suffix"
		  insertBefore ifTrue: [ s nextPutAll: self carriageReturn ] ]
]
