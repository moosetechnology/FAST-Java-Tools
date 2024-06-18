"
This transformation operation is used to insert a node (and its eventual children nodes) into the signature of a method or declaration of a class.
This allows to transform only the source code preceding the opening bracket (`{`) without risking to regenerate and overwrite the whole source code of the entity.

This operation requires to be given as the `transformedNode` the node to insert, and its parent (a `FASTJavaMethodEntity` or `FASTJavaClassDeclaration` node) using the `parentNode:` or `anchorNode:` setter.
The selector used to insert the `transformedNode` to the `anchorNode` must also be specified as a symbol (check `FASTJavaCodeGeneratorBuilder` `>> signatureInsertionOperation1`).

An example of use is shown in the test in the class `SignatureInsertionOperationTest`.
"
Class {
	#name : #SignatureInsertionOperation,
	#superclass : #InsertionOperation,
	#category : #'Transformation-Tools'
}

{ #category : #'applying operation' }
SignatureInsertionOperation >> applyOperation [

	^ self replaceSignature
]

{ #category : #'applying operation' }
SignatureInsertionOperation >> getClosingSignatureCharacterOfAnchorNode [

	"if the signature to transform is a method declared in an interface or is abstract"
	(anchorNode class = FASTJavaMethodEntity and: [ 
		 anchorNode statementBlock isNil ]) ifTrue: [ ^ $; ].

	"every other method or class"
	^ ${
]

{ #category : #'applying operation' }
SignatureInsertionOperation >> replaceSignature [

	| generatedSignature searchedCharacter indexOfSearchedCharacter |
	generatedSignature := self generateNode: transformedNode.

	1halt.

	anchorNode class = FASTJavaMethodEntity ifTrue: [ 
		anchorNode statementBlock
			ifNil: [ "only removing the cr if the method is abstract or is declared in an interface"
				generatedSignature := (generatedSignature allButLast: 2)
				                      , String space ]
			ifNotNil: [ "removing the extra semi colon and cr in a method signature" 
				generatedSignature := generatedSignature allButLast ] ].

	"copying only the signature for a class declaration, so everything before the opening bracket"
	self parentNode class = FASTJavaClassDeclaration ifTrue: [ 
		generatedSignature := generatedSignature
			                      copyFrom: 1
			                      to: (generatedSignature indexOf: ${) - 1 ].

	searchedCharacter := self getClosingSignatureCharacterOfAnchorNode.
	indexOfSearchedCharacter := sourceCode
		                            indexOf: searchedCharacter
		                            startingAt:
		                            anchorNode startPos + offsetToApply.

	removedHighlight := anchorNode startPos
	                    @ (indexOfSearchedCharacter - offsetToApply).
	addedHighlight := anchorNode startPos + offsetToApply
	                  @
	                  (anchorNode startPos + offsetToApply
	                   + generatedSignature size).

	^ String streamContents: [ :s | 
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
			  yourself ]
]

{ #category : #'applying operation' }
SignatureInsertionOperation >> transformNodeIfNeeded [

	| emptyCopy |
	emptyCopy := self copyNode: self parentNode.

	"if the modified signature is for a method, remove the source code from it"
	(emptyCopy class = FASTJavaMethodEntity and: [ 
		 emptyCopy statementBlock isNotNil ]) ifTrue: [ 
		emptyCopy statementBlock removeAllPotentialParentNode ].

	"if the modified signature is for a class, remove the declarations of methods and variables"
	emptyCopy class = FASTJavaClassDeclaration ifTrue: [ 
		[ emptyCopy declarations isEmpty ] whileFalse: [ 
			emptyCopy declarations first removeAllPotentialParentNode ] ].

	emptyCopy perform: selector withArguments: { transformedNode }.

	"setting the copy as transformedNode to use it when replacing the parent node"
	transformedNode := emptyCopy
]
