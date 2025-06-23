"
I am a tool applying a code transformation on a source file. 

After being instantiated, using either the `transformClass:withNewSource` or `transformMethod:withNewSource:`, with a Famix entity as the first parameter, either Class or Method, and a String as the second parameter, I go find the source file and the `startPos` and `endPos` of the entity to transform to replace the code of this entity in its source file, and replace it with the String passed as parameter. Once that's done, I go through all the entities with a source anchor located in this file, and update their `startPos` and `endPos` values, so that their source text remains accurate (only in the case of a method transformation).

Public API and Key Messages

- `transformClass: aFamixJavaClass withNewSource: aString`
- `transformMethod: aFamixJavaMethod withNewSource: aString`
- `importStrings: aCollection` => In the case of transforming a class, giving to the tool a Collection of Strings, with each String an import declaration (Format : ""import some.package.somewhere;"") will add those import declarations to the source file.

Internal Representation and Key Implementation Points.

    Instance Variables
	entityToTransform:		Famix Java entity whose code is being replaced
	fileSourceText:		Text present within the source file; is edited during the tool process before being re-inserted to the original source file
	importStrings:		Collections of Strings representing Java import declarations
	offset:		An int representing the number of character added or removed after transforming the source code
	transformedEntityEndPos:	 An int representing the `endPos` of the transformed entity, kept in memory to properly determine all entities next in the file (those entities need their `startPos` and `endPos` edited)


    Implementation Points
"
Class {
	#name : #TransformationApplyerOnSourceAnchor,
	#superclass : #Object,
	#instVars : [
		'fileSourceText',
		'importStrings',
		'offset',
		'transformedEntityEndPos',
		'entityToTransform'
	],
	#category : #'Transformation-Tools'
}

{ #category : #transformation }
TransformationApplyerOnSourceAnchor >> addImportStringsIfNeeded [

	| stringToInsert insertIndex packageDeclarationString |
	importStrings ifEmpty: [ ^ self ].

	stringToInsert := self carriageReturn , self carriageReturn.

	importStrings do: [ :is |
		| current |
		current := is trim.
		current last = $; ifFalse: [ current := current , ';' ].
		current := current , self carriageReturn.
		stringToInsert := stringToInsert , current ].
	stringToInsert := stringToInsert trimRight.

	packageDeclarationString := self buildPackageDeclarationString.
	insertIndex := fileSourceText findString: packageDeclarationString.

	fileSourceText := String streamContents: [ :s |
		                  s
			                  nextPutAll: (fileSourceText
					                   copyFrom: 1
					                   to:
						                   insertIndex + packageDeclarationString size
						                   - 1);
			                  nextPutAll: stringToInsert;
			                  nextPutAll: (fileSourceText
					                   copyFrom:
						                   insertIndex + packageDeclarationString size
					                   to: fileSourceText size) ].

	self updateEntityPosValuesWithSize: stringToInsert size
]

{ #category : #transformation }
TransformationApplyerOnSourceAnchor >> buildPackageDeclarationString [

	| packagesStack currentPackage |
	packagesStack := Stack new.
	currentPackage := self findRootClass typeContainer.
	packagesStack push: currentPackage.

	[ currentPackage parentPackage isNotNil ] whileTrue: [
		currentPackage := currentPackage parentPackage.
		packagesStack push: currentPackage ].

	^ String streamContents: [ :s |
		  s nextPutAll: 'package '.
		  [ packagesStack size = 1 ] whileFalse: [
			  s
				  nextPutAll: packagesStack pop name;
				  nextPut: $. ].
		  s
			  nextPutAll: packagesStack pop name;
			  nextPut: $; ]
]

{ #category : #adding }
TransformationApplyerOnSourceAnchor >> carriageReturn [

	^ (fileSourceText includes: Character lf)
		  ifTrue: [ String crlf ]
		  ifFalse: [ String cr ]
]

{ #category : #copying }
TransformationApplyerOnSourceAnchor >> copyOriginalFileContent [
	
	| stream content |
	stream := entityToTransform sourceAnchor fileReference readStream.
	content := stream upToEnd.
	stream close.
	
	fileSourceText := content
]

{ #category : #accessing }
TransformationApplyerOnSourceAnchor >> entityToTransform [

	^ entityToTransform
]

{ #category : #accessing }
TransformationApplyerOnSourceAnchor >> entityToTransform: anObject [

	entityToTransform := anObject
]

{ #category : #'private - accessing' }
TransformationApplyerOnSourceAnchor >> fileSourceText [

	^ fileSourceText
]

{ #category : #'updating entity' }
TransformationApplyerOnSourceAnchor >> findAndUpdatePosOfNextEntitiesInFile [

	| entitiesInFile |
	entitiesInFile := self findEntitiesInFile.

	entitiesInFile do: [ :entity |
		entity sourceAnchor endPos > transformedEntityEndPos ifTrue: [
			entity sourceAnchor startPos > transformedEntityEndPos
				ifTrue: [ self updatePosValuesOfEntity: entity ]
				ifFalse: [ self updateEndPosValueOfEntity: entity ] ] ]
]

{ #category : #'updating entity' }
TransformationApplyerOnSourceAnchor >> findEntitiesInFile [

	| rootClass |
	rootClass := self findRootClass.

	^ (rootClass withAllChildren reject: [ :e | e = entityToTransform ])
		  select: [ :e | e usesFamixTrait: FamixTSourceEntity ]
]

{ #category : #'updating entity' }
TransformationApplyerOnSourceAnchor >> findRootClass [

	^ entityToTransform withAllParents detect: [ :e |
		  e class = FamixJavaClass and: [
			  e typeContainer class = FamixJavaPackage ] ]
]

{ #category : #accessing }
TransformationApplyerOnSourceAnchor >> importStrings [

	^ importStrings
]

{ #category : #accessing }
TransformationApplyerOnSourceAnchor >> importStrings: anObject [

	importStrings := anObject
]

{ #category : #adding }
TransformationApplyerOnSourceAnchor >> initialize [

	importStrings := OrderedCollection new
]

{ #category : #'private - accessing' }
TransformationApplyerOnSourceAnchor >> offset: anObject [

	offset := anObject
]

{ #category : #transformation }
TransformationApplyerOnSourceAnchor >> transformClass: aFamixJavaClass withNewSource: aString [

	entityToTransform := aFamixJavaClass.
	transformedEntityEndPos := entityToTransform sourceAnchor endPos.
	offset := aString size - (entityToTransform sourceAnchor endPos
	           - entityToTransform sourceAnchor startPos).

	self copyOriginalFileContent.
	self transformEntity: entityToTransform withNewSource: aString.
	self updateEntityEndPosValue.
	self addImportStringsIfNeeded.
	self transformSourceFile
]

{ #category : #transformation }
TransformationApplyerOnSourceAnchor >> transformEntity: aFamixEntity withNewSource: aString [

	fileSourceText := String streamContents: [ :s | 
		                  s
			                  nextPutAll:
				                  (fileSourceText
					                   copyFrom: 1
					                   to: aFamixEntity sourceAnchor startPos - 1);
			                  nextPutAll: aString;
			                  nextPutAll: (fileSourceText
					                   copyFrom: aFamixEntity sourceAnchor endPos + 1
					                   to: fileSourceText size);
			                  yourself ]
]

{ #category : #transformation }
TransformationApplyerOnSourceAnchor >> transformMethod: aFamixJavaMethod withNewSource: aString [

	entityToTransform := aFamixJavaMethod.
	transformedEntityEndPos := entityToTransform sourceAnchor endPos.
	offset := aString size - (entityToTransform sourceAnchor endPos
	           - entityToTransform sourceAnchor startPos + 1).

	self copyOriginalFileContent.
	self transformEntity: entityToTransform withNewSource: aString.
	self updateEntityEndPosValue.
	self findAndUpdatePosOfNextEntitiesInFile.
	self transformSourceFile
]

{ #category : #transformation }
TransformationApplyerOnSourceAnchor >> transformSourceFile [

	| fileReference stream |
	fileReference := entityToTransform sourceAnchor fileReference.
	fileReference delete.
	
	stream := fileReference writeStream.
	stream nextPutAll: fileSourceText.
	stream close
]

{ #category : #'private - accessing' }
TransformationApplyerOnSourceAnchor >> transformedEntityEndPos: anInt [

	transformedEntityEndPos := anInt
]

{ #category : #'updating entity' }
TransformationApplyerOnSourceAnchor >> updateEndPosValueOfEntity: entity [

	entity sourceAnchor endPos:
		entity sourceAnchor endPos + offset
]

{ #category : #'updating entity' }
TransformationApplyerOnSourceAnchor >> updateEntityEndPosValue [

	entityToTransform sourceAnchor endPos: transformedEntityEndPos + offset
]

{ #category : #'updating entity' }
TransformationApplyerOnSourceAnchor >> updateEntityPosValuesWithSize: aNumber [

	entityToTransform sourceAnchor startPos:
		entityToTransform sourceAnchor startPos + aNumber.

	entityToTransform sourceAnchor endPos:
		entityToTransform sourceAnchor endPos + aNumber
]

{ #category : #'updating entity' }
TransformationApplyerOnSourceAnchor >> updatePosValuesOfEntity: entity [

	entity sourceAnchor startPos:
		entity sourceAnchor startPos + offset.

	entity sourceAnchor endPos:
		entity sourceAnchor endPos + offset
]
