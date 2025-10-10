"
This transformation operation is used to insert a node (and its eventual children nodes) into the signature of a method or declaration of a class.
This allows to transform only the source code preceding the opening bracket (`{`) without risking to regenerate and overwrite the whole source code of the entity.

This operation requires to be given as the `transformedNode` the node to insert, and its parent (a `FASTJavaMethodEntity` or `FASTJavaClassDeclaration` node) using the `parentNode:` or `anchorNode:` setter.
The selector used to insert the `transformedNode` to the `anchorNode` must also be specified as a symbol (check `FASTJavaCodeGeneratorBuilder` `>> signatureInsertionOperation1`).

An example of use is shown in the test in the class `SignatureInsertionOperationTest`.
"
Class {
	#name : 'SignatureInsertionOperation',
	#superclass : 'InsertionOperation',
	#category : 'Transformation-Tools',
	#package : 'Transformation-Tools'
}

{ #category : 'applying operation' }
SignatureInsertionOperation >> buildNewNode [
	"returns the new node created using the anchor and transformed node"
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

	^ emptyCopy
]
