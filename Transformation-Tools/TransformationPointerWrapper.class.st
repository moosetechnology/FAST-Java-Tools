"
I am a wrapper containing a Famix or FAST entity, and the starting index for this entity in its class source code, both for the original and transformed version.

I am used by the `TransformationEditor` window in order to easily jump to the next transformed entity when the transformations are applied on the whole source code.
"
Class {
	#name : 'TransformationPointerWrapper',
	#superclass : 'Object',
	#instVars : [
		'entity',
		'oldVersionStartIndex',
		'newVersionStartIndex'
	],
	#category : 'Transformation-Tools',
	#package : 'Transformation-Tools'
}

{ #category : 'accessing' }
TransformationPointerWrapper >> entity [

	^ entity
]

{ #category : 'accessing' }
TransformationPointerWrapper >> entity: anObject [

	entity := anObject
]

{ #category : 'accessing' }
TransformationPointerWrapper >> newVersionStartIndex [

	^ newVersionStartIndex
]

{ #category : 'accessing' }
TransformationPointerWrapper >> newVersionStartIndex: anObject [

	newVersionStartIndex := anObject
]

{ #category : 'accessing' }
TransformationPointerWrapper >> oldVersionStartIndex [

	^ oldVersionStartIndex
]

{ #category : 'accessing' }
TransformationPointerWrapper >> oldVersionStartIndex: anObject [

	oldVersionStartIndex := anObject
]
