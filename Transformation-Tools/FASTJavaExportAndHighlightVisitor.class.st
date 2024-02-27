Class {
	#name : #FASTJavaExportAndHighlightVisitor,
	#superclass : #FASTJavaExportVisitor,
	#instVars : [
		'charCount',
		'highlightOn',
		'currentlyHiglightedEntity',
		'startOfCurrentHighlight',
		'nOfCharToTrimAtEndOfHighlight',
		'entitiesToHighlight',
		'highlights'
	],
	#category : #'Transformation-Tools'
}

{ #category : #'as yet unclassified' }
FASTJavaExportAndHighlightVisitor >> checkIfDoneHighlightingEntity: aFASTEntity [

	highlightOn ifTrue: [ 
		currentlyHiglightedEntity = aFASTEntity ifTrue: [ 
			highlightOn := false.
			highlights add:
				startOfCurrentHighlight
				@ (charCount - nOfCharToTrimAtEndOfHighlight) ] ]
]

{ #category : #'as yet unclassified' }
FASTJavaExportAndHighlightVisitor >> checkIfHighlightingEntity: aFASTEntity [

	highlightOn ifFalse: [ 
		(entitiesToHighlight includes: aFASTEntity) ifTrue: [ 
			highlightOn := true.
			startOfCurrentHighlight := charCount.
			nOfCharToTrimAtEndOfHighlight := 0.
			currentlyHiglightedEntity := aFASTEntity ] ]
]

{ #category : #accessing }
FASTJavaExportAndHighlightVisitor >> entitiesToHighlight [

	^ entitiesToHighlight
]

{ #category : #accessing }
FASTJavaExportAndHighlightVisitor >> entitiesToHighlight: anObject [

	entitiesToHighlight := anObject
]

{ #category : #api }
FASTJavaExportAndHighlightVisitor >> export: aFASTNode [

	self setDefaultVariables.
	^ super export: aFASTNode
]

{ #category : #api }
FASTJavaExportAndHighlightVisitor >> exportAsHighlightedText: aFASTNode withColor: aColor [

	| output |
	self setDefaultVariables.
	output := (super export: aFASTNode) asText.

	highlights do: [ :h | 
		output
			addAttribute: (TextBackgroundColor color: aColor)
			from: h x
			to: h y ].

	^ output
]

{ #category : #outputting }
FASTJavaExportAndHighlightVisitor >> goBack: aNumber [

	charCount := charCount - aNumber.
	super goBack: aNumber
]

{ #category : #accessing }
FASTJavaExportAndHighlightVisitor >> highlights [

	^ highlights
]

{ #category : #initialization }
FASTJavaExportAndHighlightVisitor >> initialize [

	self setDefaultVariables
]

{ #category : #outputting }
FASTJavaExportAndHighlightVisitor >> newLine [

	"remove it from the highlighting"

	highlightOn ifTrue: [ 
		startOfCurrentHighlight = charCount
			ifTrue: [ startOfCurrentHighlight := startOfCurrentHighlight + 1 ]
			ifFalse: [ 
			nOfCharToTrimAtEndOfHighlight := nOfCharToTrimAtEndOfHighlight + 1 ] ].
	self output: Character cr asString
]

{ #category : #outputting }
FASTJavaExportAndHighlightVisitor >> output: aPrintable [

	aPrintable class = Character
		ifTrue: [ charCount := charCount + 1 ]
		ifFalse: [ charCount := charCount + aPrintable size ].
	super output: aPrintable
]

{ #category : #initialization }
FASTJavaExportAndHighlightVisitor >> setDefaultVariables [

	charCount := 0.
	highlights := OrderedCollection new.
	highlightOn := false.
	currentlyHiglightedEntity := nil.
	startOfCurrentHighlight := nil.
	nOfCharToTrimAtEndOfHighlight := 0
]

{ #category : #outputting }
FASTJavaExportAndHighlightVisitor >> space [

	"remove it from the highlighting"

	highlightOn ifTrue: [ 
		startOfCurrentHighlight = charCount
			ifTrue: [ startOfCurrentHighlight := startOfCurrentHighlight + 1 ]
			ifFalse: [ 
			nOfCharToTrimAtEndOfHighlight := nOfCharToTrimAtEndOfHighlight + 1 ] ].
	super space
]

{ #category : #visiting }
FASTJavaExportAndHighlightVisitor >> visitFASTJavaAnnotation: aFASTJavaAnnotation [

	self checkIfHighlightingEntity: aFASTJavaAnnotation.
	super visitFASTJavaAnnotation: aFASTJavaAnnotation.
	self checkIfDoneHighlightingEntity: aFASTJavaAnnotation 
]

{ #category : #visiting }
FASTJavaExportAndHighlightVisitor >> visitFASTJavaArgumentsList: aFASTJavaArgumentList [

	self checkIfHighlightingEntity: aFASTJavaArgumentList.
	super visitFASTJavaArgumentsList: aFASTJavaArgumentList.
	self checkIfDoneHighlightingEntity: aFASTJavaArgumentList 
]

{ #category : #visiting }
FASTJavaExportAndHighlightVisitor >> visitFASTJavaArrayAccess: aFASTJavaArrayAccess [

	self checkIfHighlightingEntity: aFASTJavaArrayAccess.
	super visitFASTJavaArrayAccess: aFASTJavaArrayAccess.
	self checkIfDoneHighlightingEntity: aFASTJavaArrayAccess 
]

{ #category : #visiting }
FASTJavaExportAndHighlightVisitor >> visitFASTJavaArrayAnnotationElement: aFASTJavaArrayAnnotationElement [

	self checkIfHighlightingEntity: aFASTJavaArrayAnnotationElement.
	super visitFASTJavaArrayAnnotationElement: aFASTJavaArrayAnnotationElement.
	self checkIfDoneHighlightingEntity: aFASTJavaArrayAnnotationElement 
]

{ #category : #visiting }
FASTJavaExportAndHighlightVisitor >> visitFASTJavaArrayInitializer: aFASTJavaArrayInitializer [

	self checkIfHighlightingEntity: aFASTJavaArrayInitializer.
	super visitFASTJavaArrayInitializer: aFASTJavaArrayInitializer.
	self checkIfDoneHighlightingEntity: aFASTJavaArrayInitializer 
]

{ #category : #visiting }
FASTJavaExportAndHighlightVisitor >> visitFASTJavaArrayTypeExpression: aFASTJavaArrayTypeExpression [

	self checkIfHighlightingEntity: aFASTJavaArrayTypeExpression.
	super visitFASTJavaArrayTypeExpression: aFASTJavaArrayTypeExpression.
	self checkIfDoneHighlightingEntity: aFASTJavaArrayTypeExpression 
]

{ #category : #visiting }
FASTJavaExportAndHighlightVisitor >> visitFASTJavaAssertStatement: aFASTJavaAssertStatement [

	self checkIfHighlightingEntity: aFASTJavaAssertStatement.
	super visitFASTJavaAssertStatement: aFASTJavaAssertStatement.
	self checkIfDoneHighlightingEntity: aFASTJavaAssertStatement 
]

{ #category : #visiting }
FASTJavaExportAndHighlightVisitor >> visitFASTJavaAssignmentExpression: aFASTJavaAssignmentExpression [

	self checkIfHighlightingEntity: aFASTJavaAssignmentExpression.
	super visitFASTJavaAssignmentExpression: aFASTJavaAssignmentExpression.
	self checkIfDoneHighlightingEntity: aFASTJavaAssignmentExpression 
]

{ #category : #visiting }
FASTJavaExportAndHighlightVisitor >> visitFASTJavaBlockOrStatement: aFASTJavaStatement [

	self checkIfHighlightingEntity: aFASTJavaStatement.
	super visitFASTJavaBlockOrStatement: aFASTJavaStatement.
	self checkIfDoneHighlightingEntity: aFASTJavaStatement 
]

{ #category : #visiting }
FASTJavaExportAndHighlightVisitor >> visitFASTJavaBooleanTypeExpression: aFASTJavaBooleanTypeExpression [

	self checkIfHighlightingEntity: aFASTJavaBooleanTypeExpression.
	super visitFASTJavaBooleanTypeExpression: aFASTJavaBooleanTypeExpression.
	self checkIfDoneHighlightingEntity: aFASTJavaBooleanTypeExpression 
]

{ #category : #visiting }
FASTJavaExportAndHighlightVisitor >> visitFASTJavaBreakStatement: aFASTJavaBreakStatement [

	self checkIfHighlightingEntity: aFASTJavaBreakStatement.
	super visitFASTJavaBreakStatement: aFASTJavaBreakStatement.
	self checkIfDoneHighlightingEntity: aFASTJavaBreakStatement 
]

{ #category : #visiting }
FASTJavaExportAndHighlightVisitor >> visitFASTJavaByteTypeExpression: aFASTJavaByteTypeExpression [

	self checkIfHighlightingEntity: aFASTJavaByteTypeExpression.
	super visitFASTJavaByteTypeExpression: aFASTJavaByteTypeExpression.
	self checkIfDoneHighlightingEntity: aFASTJavaByteTypeExpression 
]

{ #category : #visiting }
FASTJavaExportAndHighlightVisitor >> visitFASTJavaCastExpression: aFASTJavaCastExpression [

	self checkIfHighlightingEntity: aFASTJavaCastExpression.
	super visitFASTJavaCastExpression: aFASTJavaCastExpression.
	self checkIfDoneHighlightingEntity: aFASTJavaCastExpression 
]

{ #category : #visiting }
FASTJavaExportAndHighlightVisitor >> visitFASTJavaCatchPartStatement: aFASTJavaCatchPartStatement [

	self checkIfHighlightingEntity: aFASTJavaCatchPartStatement.
	super visitFASTJavaCatchPartStatement: aFASTJavaCatchPartStatement.
	self checkIfDoneHighlightingEntity: aFASTJavaCatchPartStatement 
]

{ #category : #visiting }
FASTJavaExportAndHighlightVisitor >> visitFASTJavaCharTypeExpression: aFASTJavaCharTypeExpression [

	self checkIfHighlightingEntity: aFASTJavaCharTypeExpression.
	super visitFASTJavaCharTypeExpression: aFASTJavaCharTypeExpression.
	self checkIfDoneHighlightingEntity: aFASTJavaCharTypeExpression 
]

{ #category : #visiting }
FASTJavaExportAndHighlightVisitor >> visitFASTJavaCharacterLiteral: aFASTJavaCharacterLiteral [

	self checkIfHighlightingEntity: aFASTJavaCharacterLiteral.
	super visitFASTJavaCharacterLiteral: aFASTJavaCharacterLiteral.
	self checkIfDoneHighlightingEntity: aFASTJavaCharacterLiteral 
]

{ #category : #visiting }
FASTJavaExportAndHighlightVisitor >> visitFASTJavaClassDeclaration: aFASTJavaClassDeclaration [

	self checkIfHighlightingEntity: aFASTJavaClassDeclaration.
	super visitFASTJavaClassDeclaration: aFASTJavaClassDeclaration.
	self checkIfDoneHighlightingEntity: aFASTJavaClassDeclaration 
]

{ #category : #visiting }
FASTJavaExportAndHighlightVisitor >> visitFASTJavaClassProperty: aFASTJavaClassProperty [

	self checkIfHighlightingEntity: aFASTJavaClassProperty.
	super visitFASTJavaClassProperty: aFASTJavaClassProperty.
	self checkIfDoneHighlightingEntity: aFASTJavaClassProperty 
]

{ #category : #visiting }
FASTJavaExportAndHighlightVisitor >> visitFASTJavaClassTypeExpression: aFASTJavaClassTypeExpression [

	self checkIfHighlightingEntity: aFASTJavaClassTypeExpression.
	super visitFASTJavaClassTypeExpression: aFASTJavaClassTypeExpression.
	self checkIfDoneHighlightingEntity: aFASTJavaClassTypeExpression 
]

{ #category : #visiting }
FASTJavaExportAndHighlightVisitor >> visitFASTJavaCompilationUnit: aFASTJavaCompilationUnit [

	self checkIfHighlightingEntity: aFASTJavaCompilationUnit.
	super visitFASTJavaCompilationUnit: aFASTJavaCompilationUnit.
	self checkIfDoneHighlightingEntity: aFASTJavaCompilationUnit 
]

{ #category : #visiting }
FASTJavaExportAndHighlightVisitor >> visitFASTJavaConditionalExpression: aFASTJavaConditionalExpression [

	self checkIfHighlightingEntity: aFASTJavaConditionalExpression.
	super visitFASTJavaConditionalExpression: aFASTJavaConditionalExpression.
	self checkIfDoneHighlightingEntity: aFASTJavaConditionalExpression 
]

{ #category : #visiting }
FASTJavaExportAndHighlightVisitor >> visitFASTJavaContinueStatement: aFASTJavaContinueStatement [

	self checkIfHighlightingEntity: aFASTJavaContinueStatement.
	super visitFASTJavaContinueStatement: aFASTJavaContinueStatement.
	self checkIfDoneHighlightingEntity: aFASTJavaContinueStatement 
]

{ #category : #visiting }
FASTJavaExportAndHighlightVisitor >> visitFASTJavaDefaultCaseStatement: aFASTJavaDefaultCaseStatement [

	self checkIfHighlightingEntity: aFASTJavaDefaultCaseStatement.
	super visitFASTJavaDefaultCaseStatement: aFASTJavaDefaultCaseStatement.
	self checkIfDoneHighlightingEntity: aFASTJavaDefaultCaseStatement 
]

{ #category : #visiting }
FASTJavaExportAndHighlightVisitor >> visitFASTJavaDoWhileStatement: aFASTJavaDoWhileStatement [

	self checkIfHighlightingEntity: aFASTJavaDoWhileStatement.
	super visitFASTJavaDoWhileStatement: aFASTJavaDoWhileStatement.
	self checkIfDoneHighlightingEntity: aFASTJavaDoWhileStatement 
]

{ #category : #visiting }
FASTJavaExportAndHighlightVisitor >> visitFASTJavaDoubleTypeExpression: aFASTJavaDoubleTypeExpression [

	self checkIfHighlightingEntity: aFASTJavaDoubleTypeExpression.
	super visitFASTJavaDoubleTypeExpression: aFASTJavaDoubleTypeExpression.
	self checkIfDoneHighlightingEntity: aFASTJavaDoubleTypeExpression 
]

{ #category : #visiting }
FASTJavaExportAndHighlightVisitor >> visitFASTJavaElsePartStatement: aFASTJavaStatement [

	self checkIfHighlightingEntity: aFASTJavaStatement.
	super visitFASTJavaElsePartStatement: aFASTJavaStatement.
	self checkIfDoneHighlightingEntity: aFASTJavaStatement 
]

{ #category : #visiting }
FASTJavaExportAndHighlightVisitor >> visitFASTJavaEmptyMethodDeclaration: aFASTJavaEmptyMethodDeclaration [

	self checkIfHighlightingEntity: aFASTJavaEmptyMethodDeclaration.
	super visitFASTJavaEmptyMethodDeclaration: aFASTJavaEmptyMethodDeclaration.
	self checkIfDoneHighlightingEntity: aFASTJavaEmptyMethodDeclaration 
]

{ #category : #visiting }
FASTJavaExportAndHighlightVisitor >> visitFASTJavaEnumConstant: aFASTJavaEnumConstant [

	self checkIfHighlightingEntity: aFASTJavaEnumConstant.
	super visitFASTJavaEnumConstant: aFASTJavaEnumConstant.
	self checkIfDoneHighlightingEntity: aFASTJavaEnumConstant 
]

{ #category : #visiting }
FASTJavaExportAndHighlightVisitor >> visitFASTJavaEnumDeclaration: aFASTJavaEnumDeclaration [

	self checkIfHighlightingEntity: aFASTJavaEnumDeclaration.
	super visitFASTJavaEnumDeclaration: aFASTJavaEnumDeclaration.
	self checkIfDoneHighlightingEntity: aFASTJavaEnumDeclaration 
]

{ #category : #visiting }
FASTJavaExportAndHighlightVisitor >> visitFASTJavaFieldAccess: aFASTJavaFieldAccess [

	self checkIfHighlightingEntity: aFASTJavaFieldAccess.
	super visitFASTJavaFieldAccess: aFASTJavaFieldAccess.
	self checkIfDoneHighlightingEntity: aFASTJavaFieldAccess 
]

{ #category : #visiting }
FASTJavaExportAndHighlightVisitor >> visitFASTJavaFloatLiteral: aFASTJavaFloatLiteral [

	self checkIfHighlightingEntity: aFASTJavaFloatLiteral.
	super visitFASTJavaFloatLiteral: aFASTJavaFloatLiteral.
	self checkIfDoneHighlightingEntity: aFASTJavaFloatLiteral 
]

{ #category : #visiting }
FASTJavaExportAndHighlightVisitor >> visitFASTJavaFloatTypeExpression: aFASTJavaFloatTypeExpression [

	self checkIfHighlightingEntity: aFASTJavaFloatTypeExpression.
	super visitFASTJavaFloatTypeExpression: aFASTJavaFloatTypeExpression.
	self checkIfDoneHighlightingEntity: aFASTJavaFloatTypeExpression 
]

{ #category : #visiting }
FASTJavaExportAndHighlightVisitor >> visitFASTJavaForEachStatement: aFASTJavaForEachStatement [

	self checkIfHighlightingEntity: aFASTJavaForEachStatement.
	super visitFASTJavaForEachStatement: aFASTJavaForEachStatement.
	self checkIfDoneHighlightingEntity: aFASTJavaForEachStatement 
]

{ #category : #visiting }
FASTJavaExportAndHighlightVisitor >> visitFASTJavaForStatement: aFASTJavaForStatement [

	self checkIfHighlightingEntity: aFASTJavaForStatement.
	super visitFASTJavaForStatement: aFASTJavaForStatement.
	self checkIfDoneHighlightingEntity: aFASTJavaForStatement 
]

{ #category : #visiting }
FASTJavaExportAndHighlightVisitor >> visitFASTJavaForStatementCondition: aFASTJavaForStatementCondition [

	self checkIfHighlightingEntity: aFASTJavaForStatementCondition.
	super visitFASTJavaForStatementCondition: aFASTJavaForStatementCondition.
	self checkIfDoneHighlightingEntity: aFASTJavaForStatementCondition 
]

{ #category : #visiting }
FASTJavaExportAndHighlightVisitor >> visitFASTJavaForStatementIncrementor: aFASTJavaForStatementIncrementor [

	self checkIfHighlightingEntity: aFASTJavaForStatementIncrementor.
	super visitFASTJavaForStatementIncrementor: aFASTJavaForStatementIncrementor.
	self checkIfDoneHighlightingEntity: aFASTJavaForStatementIncrementor 
]

{ #category : #visiting }
FASTJavaExportAndHighlightVisitor >> visitFASTJavaForStatementInitializer: aFASTJavaForStatementInitializer [

	self checkIfHighlightingEntity: aFASTJavaForStatementInitializer.
	super visitFASTJavaForStatementInitializer: aFASTJavaForStatementInitializer.
	self checkIfDoneHighlightingEntity: aFASTJavaForStatementInitializer 
]

{ #category : #visiting }
FASTJavaExportAndHighlightVisitor >> visitFASTJavaIdentifier: aFASTJavaIdentifier [

	self checkIfHighlightingEntity: aFASTJavaIdentifier.
	super visitFASTJavaIdentifier: aFASTJavaIdentifier.
	self checkIfDoneHighlightingEntity: aFASTJavaIdentifier 
]

{ #category : #visiting }
FASTJavaExportAndHighlightVisitor >> visitFASTJavaIfStatement: aFASTJavaIfStatement [

	self checkIfHighlightingEntity: aFASTJavaIfStatement.
	super visitFASTJavaIfStatement: aFASTJavaIfStatement.
	self checkIfDoneHighlightingEntity: aFASTJavaIfStatement 
]

{ #category : #visiting }
FASTJavaExportAndHighlightVisitor >> visitFASTJavaImportDeclaration: aFASTJavaImportDeclaration [

	self checkIfHighlightingEntity: aFASTJavaImportDeclaration.
	super visitFASTJavaImportDeclaration: aFASTJavaImportDeclaration.
	self checkIfDoneHighlightingEntity: aFASTJavaImportDeclaration 
]

{ #category : #visiting }
FASTJavaExportAndHighlightVisitor >> visitFASTJavaInfixOperation: aFASTJavaInfixOperation [

	self checkIfHighlightingEntity: aFASTJavaInfixOperation.
	super visitFASTJavaInfixOperation: aFASTJavaInfixOperation.
	self checkIfDoneHighlightingEntity: aFASTJavaInfixOperation 
]

{ #category : #visiting }
FASTJavaExportAndHighlightVisitor >> visitFASTJavaIntTypeExpression: aFASTJavaIntTypeExpression [

	self checkIfHighlightingEntity: aFASTJavaIntTypeExpression.
	super visitFASTJavaIntTypeExpression: aFASTJavaIntTypeExpression.
	self checkIfDoneHighlightingEntity: aFASTJavaIntTypeExpression 
]

{ #category : #visiting }
FASTJavaExportAndHighlightVisitor >> visitFASTJavaInterfaceDeclaration: aFASTJavaInterfaceDeclaration [

	self checkIfHighlightingEntity: aFASTJavaInterfaceDeclaration.
	super visitFASTJavaInterfaceDeclaration: aFASTJavaInterfaceDeclaration.
	self checkIfDoneHighlightingEntity: aFASTJavaInterfaceDeclaration 
]

{ #category : #visiting }
FASTJavaExportAndHighlightVisitor >> visitFASTJavaLabeledCaseStatement: aFASTJavaLabeledCaseStatement [

	self checkIfHighlightingEntity: aFASTJavaLabeledCaseStatement.
	super visitFASTJavaLabeledCaseStatement: aFASTJavaLabeledCaseStatement.
	self checkIfDoneHighlightingEntity: aFASTJavaLabeledCaseStatement 
]

{ #category : #visiting }
FASTJavaExportAndHighlightVisitor >> visitFASTJavaLabeledStatement: aFASTJavaLabeledStatement [

	self checkIfHighlightingEntity: aFASTJavaLabeledStatement.
	super visitFASTJavaLabeledStatement: aFASTJavaLabeledStatement.
	self checkIfDoneHighlightingEntity: aFASTJavaLabeledStatement 
]

{ #category : #visiting }
FASTJavaExportAndHighlightVisitor >> visitFASTJavaLambdaExpression: aFASTJavaLambdaExpression [

	self checkIfHighlightingEntity: aFASTJavaLambdaExpression.
	super visitFASTJavaLambdaExpression: aFASTJavaLambdaExpression.
	self checkIfDoneHighlightingEntity: aFASTJavaLambdaExpression 
]

{ #category : #visiting }
FASTJavaExportAndHighlightVisitor >> visitFASTJavaLongLiteral: aFASTJavaLongLiteral [

	self checkIfHighlightingEntity: aFASTJavaLongLiteral.
	super visitFASTJavaLongLiteral: aFASTJavaLongLiteral.
	self checkIfDoneHighlightingEntity: aFASTJavaLongLiteral 
]

{ #category : #visiting }
FASTJavaExportAndHighlightVisitor >> visitFASTJavaLongTypeExpression: aFASTJavaLongTypeExpression [

	self checkIfHighlightingEntity: aFASTJavaLongTypeExpression.
	super visitFASTJavaLongTypeExpression: aFASTJavaLongTypeExpression.
	self checkIfDoneHighlightingEntity: aFASTJavaLongTypeExpression 
]

{ #category : #visiting }
FASTJavaExportAndHighlightVisitor >> visitFASTJavaMethodEntity: aFASTJavaMethodEntity [

	self checkIfHighlightingEntity: aFASTJavaMethodEntity.
	super visitFASTJavaMethodEntity: aFASTJavaMethodEntity.
	self checkIfDoneHighlightingEntity: aFASTJavaMethodEntity 
]

{ #category : #visiting }
FASTJavaExportAndHighlightVisitor >> visitFASTJavaMethodInvocation: aFASTJavaMethodInvocation [

	self checkIfHighlightingEntity: aFASTJavaMethodInvocation.
	super visitFASTJavaMethodInvocation: aFASTJavaMethodInvocation.
	self checkIfDoneHighlightingEntity: aFASTJavaMethodInvocation 
]

{ #category : #visiting }
FASTJavaExportAndHighlightVisitor >> visitFASTJavaMethodInvocationReceiver: aFASTJavaMethodInvocation [

	self checkIfHighlightingEntity: aFASTJavaMethodInvocation.
	super visitFASTJavaMethodInvocationReceiver: aFASTJavaMethodInvocation.
	self checkIfDoneHighlightingEntity: aFASTJavaMethodInvocation 
]

{ #category : #visiting }
FASTJavaExportAndHighlightVisitor >> visitFASTJavaMethodThrows: aFASTJavaThrownExceptionsCollection [

	self checkIfHighlightingEntity: aFASTJavaThrownExceptionsCollection.
	super visitFASTJavaMethodThrows: aFASTJavaThrownExceptionsCollection.
	self checkIfDoneHighlightingEntity: aFASTJavaThrownExceptionsCollection 
]

{ #category : #visiting }
FASTJavaExportAndHighlightVisitor >> visitFASTJavaModifier: aFASTJavaModifier [

	self checkIfHighlightingEntity: aFASTJavaModifier.
	super visitFASTJavaModifier: aFASTJavaModifier.
	self checkIfDoneHighlightingEntity: aFASTJavaModifier 
]

{ #category : #visiting }
FASTJavaExportAndHighlightVisitor >> visitFASTJavaModifiers: aFASTJavaModifierCollection [

	self checkIfHighlightingEntity: aFASTJavaModifierCollection.
	super visitFASTJavaModifiers: aFASTJavaModifierCollection.
	self checkIfDoneHighlightingEntity: aFASTJavaModifierCollection 
]

{ #category : #visiting }
FASTJavaExportAndHighlightVisitor >> visitFASTJavaNewArray: aFASTJavaNewArray [

	self checkIfHighlightingEntity: aFASTJavaNewArray.
	super visitFASTJavaNewArray: aFASTJavaNewArray.
	self checkIfDoneHighlightingEntity: aFASTJavaNewArray 
]

{ #category : #visiting }
FASTJavaExportAndHighlightVisitor >> visitFASTJavaNewClassExpression: aFASTJavaNewClassExpression [

	self checkIfHighlightingEntity: aFASTJavaNewClassExpression.
	super visitFASTJavaNewClassExpression: aFASTJavaNewClassExpression.
	self checkIfDoneHighlightingEntity: aFASTJavaNewClassExpression 
]

{ #category : #visiting }
FASTJavaExportAndHighlightVisitor >> visitFASTJavaNewExpression: aFASTJavaNewExpression [

	self checkIfHighlightingEntity: aFASTJavaNewExpression.
	super visitFASTJavaNewExpression: aFASTJavaNewExpression.
	self checkIfDoneHighlightingEntity: aFASTJavaNewExpression 
]

{ #category : #visiting }
FASTJavaExportAndHighlightVisitor >> visitFASTJavaNullLiteral: aFASTJavaNullLiteral [

	self checkIfHighlightingEntity: aFASTJavaNullLiteral.
	super visitFASTJavaNullLiteral: aFASTJavaNullLiteral.
	self checkIfDoneHighlightingEntity: aFASTJavaNullLiteral 
]

{ #category : #visiting }
FASTJavaExportAndHighlightVisitor >> visitFASTJavaOuterThis: aFASTJavaOuterThis [

	self checkIfHighlightingEntity: aFASTJavaOuterThis.
	super visitFASTJavaOuterThis: aFASTJavaOuterThis.
	self checkIfDoneHighlightingEntity: aFASTJavaOuterThis 
]

{ #category : #visiting }
FASTJavaExportAndHighlightVisitor >> visitFASTJavaPackageDeclaration: aFASTJavaPackageDeclaration [

	self checkIfHighlightingEntity: aFASTJavaPackageDeclaration.
	super visitFASTJavaPackageDeclaration: aFASTJavaPackageDeclaration.
	self checkIfDoneHighlightingEntity: aFASTJavaPackageDeclaration 
]

{ #category : #visiting }
FASTJavaExportAndHighlightVisitor >> visitFASTJavaParameter: aFASTJavaParameter [

	self checkIfHighlightingEntity: aFASTJavaParameter.
	super visitFASTJavaParameter: aFASTJavaParameter.
	self checkIfDoneHighlightingEntity: aFASTJavaParameter 
]

{ #category : #visiting }
FASTJavaExportAndHighlightVisitor >> visitFASTJavaParameters: aFASTJavaParameterCollection [

	self checkIfHighlightingEntity: aFASTJavaParameterCollection.
	super visitFASTJavaParameters: aFASTJavaParameterCollection.
	self checkIfDoneHighlightingEntity: aFASTJavaParameterCollection 
]

{ #category : #visiting }
FASTJavaExportAndHighlightVisitor >> visitFASTJavaQualifiedName: aFASTJavaQualifiedName [

	self checkIfHighlightingEntity: aFASTJavaQualifiedName.
	super visitFASTJavaQualifiedName: aFASTJavaQualifiedName.
	self checkIfDoneHighlightingEntity: aFASTJavaQualifiedName 
]

{ #category : #visiting }
FASTJavaExportAndHighlightVisitor >> visitFASTJavaQualifiedTypeName: aFASTJavaQualifiedTypeName [

	self checkIfHighlightingEntity: aFASTJavaQualifiedTypeName.
	super visitFASTJavaQualifiedTypeName: aFASTJavaQualifiedTypeName.
	self checkIfDoneHighlightingEntity: aFASTJavaQualifiedTypeName 
]

{ #category : #visiting }
FASTJavaExportAndHighlightVisitor >> visitFASTJavaShortTypeExpression: aFASTJavaShortTypeExpression [

	self checkIfHighlightingEntity: aFASTJavaShortTypeExpression.
	super visitFASTJavaShortTypeExpression: aFASTJavaShortTypeExpression.
	self checkIfDoneHighlightingEntity: aFASTJavaShortTypeExpression 
]

{ #category : #visiting }
FASTJavaExportAndHighlightVisitor >> visitFASTJavaStatement: aFASTJavaStatement [

	self checkIfHighlightingEntity: aFASTJavaStatement.
	super visitFASTJavaStatement: aFASTJavaStatement.
	self checkIfDoneHighlightingEntity: aFASTJavaStatement 
]

{ #category : #visiting }
FASTJavaExportAndHighlightVisitor >> visitFASTJavaStringLiteral: aFASTJavaStringLiteral [

	self checkIfHighlightingEntity: aFASTJavaStringLiteral.
	super visitFASTJavaStringLiteral: aFASTJavaStringLiteral.
	self checkIfDoneHighlightingEntity: aFASTJavaStringLiteral 
]

{ #category : #visiting }
FASTJavaExportAndHighlightVisitor >> visitFASTJavaSwitchStatement: aFASTJavaSwitchStatement [

	self checkIfHighlightingEntity: aFASTJavaSwitchStatement.
	super visitFASTJavaSwitchStatement: aFASTJavaSwitchStatement.
	self checkIfDoneHighlightingEntity: aFASTJavaSwitchStatement 
]

{ #category : #visiting }
FASTJavaExportAndHighlightVisitor >> visitFASTJavaSynchronizedStatement: aFASTJavaSynchronizedStatement [

	self checkIfHighlightingEntity: aFASTJavaSynchronizedStatement.
	super visitFASTJavaSynchronizedStatement: aFASTJavaSynchronizedStatement.
	self checkIfDoneHighlightingEntity: aFASTJavaSynchronizedStatement 
]

{ #category : #visiting }
FASTJavaExportAndHighlightVisitor >> visitFASTJavaThenPartStatement: aFASTJavaStatement [

	self checkIfHighlightingEntity: aFASTJavaStatement.
	super visitFASTJavaThenPartStatement: aFASTJavaStatement.
	self checkIfDoneHighlightingEntity: aFASTJavaStatement 
]

{ #category : #visiting }
FASTJavaExportAndHighlightVisitor >> visitFASTJavaThrowStatement: aFASTJavaThrowStatement [

	self checkIfHighlightingEntity: aFASTJavaThrowStatement.
	super visitFASTJavaThrowStatement: aFASTJavaThrowStatement.
	self checkIfDoneHighlightingEntity: aFASTJavaThrowStatement 
]

{ #category : #visiting }
FASTJavaExportAndHighlightVisitor >> visitFASTJavaTryCatchStatement: aFASTJavaTryCatchStatement [

	self checkIfHighlightingEntity: aFASTJavaTryCatchStatement.
	super visitFASTJavaTryCatchStatement: aFASTJavaTryCatchStatement.
	self checkIfDoneHighlightingEntity: aFASTJavaTryCatchStatement 
]

{ #category : #visiting }
FASTJavaExportAndHighlightVisitor >> visitFASTJavaTypeName: aFASTJavaTypeName [

	self checkIfHighlightingEntity: aFASTJavaTypeName.
	super visitFASTJavaTypeName: aFASTJavaTypeName.
	self checkIfDoneHighlightingEntity: aFASTJavaTypeName 
]

{ #category : #visiting }
FASTJavaExportAndHighlightVisitor >> visitFASTJavaTypeParameter: aFASTJavaTypeParameterExpression [

	self checkIfHighlightingEntity: aFASTJavaTypeParameterExpression.
	super visitFASTJavaTypeParameter: aFASTJavaTypeParameterExpression.
	self checkIfDoneHighlightingEntity: aFASTJavaTypeParameterExpression 
]

{ #category : #visiting }
FASTJavaExportAndHighlightVisitor >> visitFASTJavaUnaryExpression: aFASTJavaUnaryExpression [

	self checkIfHighlightingEntity: aFASTJavaUnaryExpression.
	super visitFASTJavaUnaryExpression: aFASTJavaUnaryExpression.
	self checkIfDoneHighlightingEntity: aFASTJavaUnaryExpression 
]

{ #category : #visiting }
FASTJavaExportAndHighlightVisitor >> visitFASTJavaVarDeclStatement: aFASTJavaVarDeclStatement [

	self checkIfHighlightingEntity: aFASTJavaVarDeclStatement.
	super visitFASTJavaVarDeclStatement: aFASTJavaVarDeclStatement.
	self checkIfDoneHighlightingEntity: aFASTJavaVarDeclStatement 
]

{ #category : #visiting }
FASTJavaExportAndHighlightVisitor >> visitFASTJavaVariableDeclarator: aFASTJavaVariableDeclarator [

	self checkIfHighlightingEntity: aFASTJavaVariableDeclarator.
	super visitFASTJavaVariableDeclarator: aFASTJavaVariableDeclarator.
	self checkIfDoneHighlightingEntity: aFASTJavaVariableDeclarator 
]

{ #category : #visiting }
FASTJavaExportAndHighlightVisitor >> visitFASTJavaVariableExpression: aFASTJavaVariableExpression [

	self checkIfHighlightingEntity: aFASTJavaVariableExpression.
	super visitFASTJavaVariableExpression: aFASTJavaVariableExpression.
	self checkIfDoneHighlightingEntity: aFASTJavaVariableExpression 
]

{ #category : #visiting }
FASTJavaExportAndHighlightVisitor >> visitFASTJavaVoidTypeExpression: aFASTJavaBooleanTypeExpression [

	self checkIfHighlightingEntity: aFASTJavaBooleanTypeExpression.
	super visitFASTJavaVoidTypeExpression: aFASTJavaBooleanTypeExpression.
	self checkIfDoneHighlightingEntity: aFASTJavaBooleanTypeExpression 
]

{ #category : #visiting }
FASTJavaExportAndHighlightVisitor >> visitFASTJavaWhileStatement: aFASTJavaWhileStatement [

	self checkIfHighlightingEntity: aFASTJavaWhileStatement.
	super visitFASTJavaWhileStatement: aFASTJavaWhileStatement.
	self checkIfDoneHighlightingEntity: aFASTJavaWhileStatement 
]

{ #category : #visiting }
FASTJavaExportAndHighlightVisitor >> visitFASTTExpressionStatement: aFASTTExpressionStatement [

	self checkIfHighlightingEntity: aFASTTExpressionStatement.
	super visitFASTTExpressionStatement: aFASTTExpressionStatement.
	self checkIfDoneHighlightingEntity: aFASTTExpressionStatement 
]

{ #category : #visiting }
FASTJavaExportAndHighlightVisitor >> visitFASTTLiteral: aFASTTLiteral [

	self checkIfHighlightingEntity: aFASTTLiteral.
	super visitFASTTLiteral: aFASTTLiteral.
	self checkIfDoneHighlightingEntity: aFASTTLiteral 
]

{ #category : #visiting }
FASTJavaExportAndHighlightVisitor >> visitFASTTReturnStatement: aFASTTReturnStatement [

	self checkIfHighlightingEntity: aFASTTReturnStatement.
	super visitFASTTReturnStatement: aFASTTReturnStatement.
	self checkIfDoneHighlightingEntity: aFASTTReturnStatement 
]

{ #category : #visiting }
FASTJavaExportAndHighlightVisitor >> visitFASTTStatementBlock: aFASTJavaStatementBlock [

	self checkIfHighlightingEntity: aFASTJavaStatementBlock.
	super visitFASTTStatementBlock: aFASTJavaStatementBlock.
	self checkIfDoneHighlightingEntity: aFASTJavaStatementBlock 
]

{ #category : #visiting }
FASTJavaExportAndHighlightVisitor >> visitJavaClassMemberDeclarations: classDeclarationsList [

	self checkIfHighlightingEntity: classDeclarationsList.
	super visitJavaClassMemberDeclarations: classDeclarationsList.
	self checkIfDoneHighlightingEntity: classDeclarationsList 
]

{ #category : #visiting }
FASTJavaExportAndHighlightVisitor >> visitNodeListSeparatedByCommas: aCollection [
	"pas bien, à refaire"
	self checkIfHighlightingEntity: aCollection.
	super visitNodeListSeparatedByCommas: aCollection.
	self checkIfDoneHighlightingEntity: aCollection 
]

{ #category : #visiting }
FASTJavaExportAndHighlightVisitor >> visitTryResources: tryResources [
	"pas bien, à refaire"
	self checkIfHighlightingEntity: tryResources.
	super visitTryResources: tryResources.
	self checkIfDoneHighlightingEntity: tryResources 
]
