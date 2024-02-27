Class {
	#name : #JavaMethodToTransformWrapper,
	#superclass : #Object,
	#instVars : [
		'famixMethod',
		'originalFastMethod',
		'transformedFastMethod',
		'originalFastNodes',
		'transformedFastNodes'
	],
	#category : #'Transformation-Tools'
}

{ #category : #adding }
JavaMethodToTransformWrapper >> addOriginalFastNode: aFASTEntity [

	originalFastNodes add: aFASTEntity
]

{ #category : #adding }
JavaMethodToTransformWrapper >> addTransformedFastNode: aFASTEntity [

	transformedFastNodes add: aFASTEntity
]

{ #category : #accessing }
JavaMethodToTransformWrapper >> famixMethod [

	^ famixMethod
]

{ #category : #accessing }
JavaMethodToTransformWrapper >> famixMethod: anObject [

	famixMethod := anObject
]

{ #category : #initialization }
JavaMethodToTransformWrapper >> initialize [ 

	originalFastNodes := OrderedCollection new.
	transformedFastNodes := OrderedCollection new
]

{ #category : #accessing }
JavaMethodToTransformWrapper >> originalFastMethod [

	^ originalFastMethod
]

{ #category : #accessing }
JavaMethodToTransformWrapper >> originalFastMethod: anObject [

	originalFastMethod := anObject
]

{ #category : #accessing }
JavaMethodToTransformWrapper >> originalFastNodes [

	^ originalFastNodes
]

{ #category : #accessing }
JavaMethodToTransformWrapper >> originalFastNodes: anObject [

	originalFastNodes := anObject
]

{ #category : #initialization }
JavaMethodToTransformWrapper >> runMotionQuery: aMotionQuery [
	"run motion query on both FAST (original and transformed), save the nodes from original tree for highlighting, and returns the nodes from the transformed FAST"
	
]

{ #category : #accessing }
JavaMethodToTransformWrapper >> transformedFastMethod [

	^ transformedFastMethod
]

{ #category : #accessing }
JavaMethodToTransformWrapper >> transformedFastMethod: anObject [

	transformedFastMethod := anObject
]

{ #category : #accessing }
JavaMethodToTransformWrapper >> transformedFastNodes [

	^ transformedFastNodes
]

{ #category : #accessing }
JavaMethodToTransformWrapper >> transformedFastNodes: anObject [

	transformedFastNodes := anObject
]
