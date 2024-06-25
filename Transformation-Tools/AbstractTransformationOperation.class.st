"
I represent an abstract operation of transformation on FAST trees. 
These operations do not modify the FAST of the entities that are transformed, but use the information within the given nodes to create new nodes representing the result of a transformation operation.

The two instance variables are both used to contain FAST nodes used to perform the FAST transformation :
- `anchorNode` : A FAST node found in the entity that will be transformed. It is either actively being used (copied and modified for a simple insertion, replaced in a replacing operation) or only used as a pointer to locate where to apply the transformation (for a statement or declaration operation)
- `transformedNode` : A FAST node created to be used in the transformation operation. The way to use it depends a lot from the nature of the operation (it can be a node to insert, or a node used to replace the anchor node). It can also be `nil` (for the delete operation)

The API of those operations includes : 
- `copyNode: aFASTNode` : This method copies the given node and children of this node using the `FASTJavaCopyVisitor`. The `copyTransformedNode` and `copyTransformedNodeParent` use this method on the specified node in their name.
- accessors for the two different nodes

The methods that subclasses must implements are :
- `buildNewNode` : Creates a new node from the anchor node and transformed node, to be used by the `FASTJavaCodeGeneratorKeepingFormatting` to modify the source code of the given entity.
- `getPosForSorting` : This method returns an index representing a position in the source code. Using this index allows to sort all operations applied to the same entity to properly calculate the offset to apply on string edits.


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

{ #category : #copying }
AbstractTransformationOperation >> copyAnchorNode [

	^ self copyNode: anchorNode 
]

{ #category : #copying }
AbstractTransformationOperation >> copyNode: aFASTJavaNode [

	^ FASTJavaCopyVisitor new copy: aFASTJavaNode 
]

{ #category : #sorting }
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
