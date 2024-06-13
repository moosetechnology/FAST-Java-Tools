Class {
	#name : #StatementInsertionOperation,
	#superclass : #InsertionOperation,
	#instVars : [
		'addingEmptyLineBefore',
		'addingEmptyLineAfter',
		'insertBefore'
	],
	#category : #'Transformation-Tools'
}

{ #category : #initialization }
StatementInsertionOperation >> addEmptyLineAfter [

	addingEmptyLineAfter := true
]

{ #category : #initialization }
StatementInsertionOperation >> addEmptyLineBefore [

	addingEmptyLineBefore := true
]

{ #category : #'applying operation' }
StatementInsertionOperation >> applyOperation [

	| newSource |
	insertBefore
		ifTrue: [ 
			newSource := self insertNewNodeStringAt:
				             self getStartOfLineIndexForAnchorNode.
			addedHighlight := self getStartOfLineIndexForAnchorNode
			                  @
				                  (self getStartOfLineIndexForAnchorNode
				                   + newSource size - sourceCode size) ]
		ifFalse: [ 
			newSource := self insertNewNodeStringAt:
				             self getStartOfNextLineIndexFromAnchorNode.
			addedHighlight := self getStartOfNextLineIndexFromAnchorNode
			                  @
				                  (self getStartOfNextLineIndexFromAnchorNode
				                   + newSource size - sourceCode size) ].

	^ newSource
]

{ #category : #'applying operation' }
StatementInsertionOperation >> buildStatementString [

	| statementString |
	(transformedNode class usesTrait: FASTTStatement) ifFalse: [ "do something" ].

	statementString := String streamContents: [ :s | 
		                   s
			                   nextPutAll: self stringPrefix;
			                   nextPutAll: self generateNodeAndCleanString;
			                   nextPutAll: self stringSuffix;
			                   yourself ].

	^ statementString
]

{ #category : #'applying operation' }
StatementInsertionOperation >> carriageReturn [

	^ (sourceCode includes: Character lf)
		  ifTrue: [ String crlf ]
		  ifFalse: [ String cr ]
]

{ #category : #'as yet unclassified' }
StatementInsertionOperation >> findNewOffsetPosWithOffsetDict: aDictionary [.
	
	^ insertBefore
		ifTrue: [ self getStartOfLineIndexForAnchorNode ]
		ifFalse: [ self getStartOfNextLineIndexFromAnchorNode ]
]

{ #category : #'applying operation' }
StatementInsertionOperation >> generateNodeAndCleanString [

	| codeString |
	codeString := self generateTransformedNode.
	^ codeString trimLeft
]

{ #category : #'applying operation' }
StatementInsertionOperation >> getIndentFromAnchorStatement [

	^ sourceCode
		  copyFrom: self getStartOfLineIndexForAnchorNode
		  to: anchorNode startPos + offsetToApply - 1
]

{ #category : #'as yet unclassified' }
StatementInsertionOperation >> getPosForSorting [

	"returns a position in the source code string, used to sort the operation list"

	^ insertBefore
		ifTrue: [ self getStartOfLineIndexForAnchorNode ]
		ifFalse: [ self getStartOfNextLineIndexFromAnchorNode ]
]

{ #category : #'applying operation' }
StatementInsertionOperation >> getStartOfLineIndexForAnchorNode [

	| index |
	index := anchorNode startPos + offsetToApply - 1.

	[ 
	(sourceCode at: index) = Character lf or: [ 
		(sourceCode at: index) = Character cr ] ] whileFalse: [ 
		index := index - 1 ].
	
	"returning the index after the cr or crlf to get the start of the new line"
	^ index + 1
]

{ #category : #'applying operation' }
StatementInsertionOperation >> getStartOfNextLineIndexFromAnchorNode [

	| index |
	index := anchorNode endPos + offsetToApply + 1.

	"stop when finding a cr character"
	[ (sourceCode at: index) = Character cr ] whileFalse: [ 
		index := index + 1 ].

	"to get the start of the next line, get one character after cr or crlf"
	index := (sourceCode at: index + 1) = Character lf
		         ifTrue: [ index + 2 ]
		         ifFalse: [ index + 1 ].

	^ index
]

{ #category : #initialization }
StatementInsertionOperation >> initialize [ 

	super initialize.
	
	insertBefore := false.
	addingEmptyLineBefore := false.
	addingEmptyLineAfter := false
]

{ #category : #accessing }
StatementInsertionOperation >> insertBefore [

	^ insertBefore
]

{ #category : #accessing }
StatementInsertionOperation >> insertBefore: aBoolean [

	insertBefore := aBoolean
]

{ #category : #'applying operation' }
StatementInsertionOperation >> insertNewNodeStringAt: anIndex [

	^ String streamContents: [ :s | 
		  s
			  nextPutAll: (sourceCode copyFrom: 1 to: anIndex - 1);
			  nextPutAll: self buildStatementString;
			  nextPutAll: (sourceCode copyFrom: anIndex to: sourceCode size);
			  yourself ]
]

{ #category : #'applying operation' }
StatementInsertionOperation >> stringPrefix [

	^ String streamContents: [ :s | 
		  "if adding an empty line, add a carriage return"
		  addingEmptyLineBefore ifTrue: [ s nextPutAll: self carriageReturn ].
		  s
			  nextPutAll: self getIndentFromAnchorStatement;
			  yourself ]
]

{ #category : #'applying operation' }
StatementInsertionOperation >> stringSuffix [

	^ String streamContents: [ :s | 
		  s nextPutAll: ''.
		  "if adding an empty line, add a carriage return"
		  addingEmptyLineAfter ifTrue: [ s nextPutAll: self carriageReturn ].
		  "if the new node is inserted before the anchor statement, the carriage return is in the suffix"
		  insertBefore ifTrue: [ s nextPutAll: self carriageReturn ] ]
]

{ #category : #'applying operation' }
StatementInsertionOperation >> transformNodeIfNeeded [

	"nothing to do here"
]
