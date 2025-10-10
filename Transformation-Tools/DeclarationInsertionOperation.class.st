"
This transformation operation is used to insert a node (and its eventual children nodes) as a new declaration in the source code of the entity (a class).
This allows to add new statements before or after the anchor node, using the identation of the anchor node for a seamless insertion.

This operation requires to be given as the `transformedNode` the node to insert, and the node (another declaration) to use as insertion location through the `anchorNode:` setter.

This operation also has an `insertBefore` instance variable, by default set to false. By default, the declaration will be inserted after the anchor declaration, setting `insertBefore` to true will insert the declaration before the anchor node.

An example of use is shown in the test in the method `applyDeclarationInsertionOperationTest` of class `FASTJavaCodeGeneratorKeepingFormattingTest`.
"
Class {
	#name : 'DeclarationInsertionOperation',
	#superclass : 'StatementInsertionOperation',
	#category : 'Transformation-Tools',
	#package : 'Transformation-Tools'
}
