"
This class represents an abstract operation of code transformation on FAST trees. 
These operations do not modify the FAST of the entities that are transformed, but use the information within those nodes (most notably, their `startPos` and `endPos` attribute), in order to properly transform the code as necessary.

This way of transforming the code allows us to maintain the ""aspect"" of the code, namely the indentation, comments and empty lines, which would be lost if we were to regenerate the code of the entire FAST tree.

The API of those operations includes :
- `applyOperationOnSource: sourceCode withOffset: offset` : Calling this method transforms and return the transformed code string of the entity (given as `sourceCode`). The offset parameter is used to ajust the localisation of the code for the entity to transform, which will change as the code string evolves with each transformation.
- `addedHighlight` : After a transformation, this selector will return a `Point`, with the start position of a transformed portion of code in `x` and the end position in `y`. This allows to highlight every modification in the transformed code string, using the `TransformationEditor` modal window.
- `removedHighlight` : After a transformation, this selector will return a `Point`, with the start position of a transformed portion of code in `x` and the end position in `y`. This allows to highlight every modification in the original code string, using the `TransformationEditor` modal window.
- `copyNode: aFASTNode` : This method copies the given node and children of this node using the `FASTJavaCopyVisitor`. The `copyTransformedNode` and `copyTransformedNodeParent` use this method on the specified node in their name.
- `generateNode: aFASTNode` : This method generates the code string representing the given node and children of this node using the `FASTJavaExportVisitor`. The `generateTransformedNode` and `generateTransformedNodeParent` use this method on the specified node in their name.
- `replaceNode: aFASTNode` : This method replaces in the code string the code snippet representing the given node, with the generated code from the `transformedNode` variable. 

The methods that subclasses must implements are :
- `getPosForSorting` : This method returns an index representing a position in the source code. Using this index allows to sort all operations applied to the same entity to properly calculate the offset to apply on string edits.
- `findNewOffsetPosWithOffsetDict: aDictionary` : ???
- `transformNodeIfNeeded` : This method is the one in which the FAST (specifically, the anchor and transformed node) may be copied and modified, in order to create the node representing the new code snippet to insert in the original code string. The code string is however, not modified at this point. The node (or tree) resulting should be stored in the `transformedNode` variable.
- `applyOperation` : This method is responsable for the edition of the code string, using the result of the `transformNodeIfNeeded` method.


"
Class {
	#name : #AbstractTransformationOperation,
	#superclass : #Object,
	#instVars : [
		'transformedNode',
		'anchorNode'
	],
	#category : #'Transformation-Tools'
}

{ #category : #accessing }
AbstractTransformationOperation >> anchorNode [

	^ anchorNode
]

{ #category : #accessing }
AbstractTransformationOperation >> anchorNode: anObject [

	anchorNode := anObject
]

{ #category : #'applying operation' }
AbstractTransformationOperation >> buildNewNode [
	"returns the new node created using the anchor and transformed node"
	^ self subclassResponsibility
]

{ #category : #'as yet unclassified' }
AbstractTransformationOperation >> copyNode: aFASTJavaNode [

	^ FASTJavaCopyVisitor new copy: aFASTJavaNode 
]

{ #category : #'as yet unclassified' }
AbstractTransformationOperation >> copyTransformedNode [

	^ self copyNode: transformedNode 
]

{ #category : #'as yet unclassified' }
AbstractTransformationOperation >> copyTransformedNodeParent [

	^ self copyNode: transformedNode parentNode
]

{ #category : #'as yet unclassified' }
AbstractTransformationOperation >> getPosForSorting [
	"returns a position in the source code string, used to sort the operation list"
	^ self subclassResponsibility 
]

{ #category : #accessing }
AbstractTransformationOperation >> transformedNode [

	^ transformedNode
]

{ #category : #accessing }
AbstractTransformationOperation >> transformedNode: anObject [

	transformedNode := anObject
]
