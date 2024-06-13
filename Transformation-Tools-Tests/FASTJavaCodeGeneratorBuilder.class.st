Class {
	#name : #FASTJavaCodeGeneratorBuilder,
	#superclass : #Object,
	#category : #'Transformation-Tools-Tests'
}

{ #category : #test }
FASTJavaCodeGeneratorBuilder >> declarationInsertionOperation1 [

	| anchorNode newNode |
	anchorNode := self fastClassWithTestMethodMethod.

	newNode := FASTJavaMethodEntity new
		           name: 'Test';
		           modifiers: { (FASTJavaModifier new token: 'public') };
		           statementBlock: (FASTJavaStatementBlock new statements:
					            { (FASTJavaExpressionStatement new expression:
							             (FASTJavaMethodInvocation new
								              receiver:
									              (FASTJavaIdentifier new name: 'GlobalLogger');
								              name: 'log';
								              arguments:
									              { (FASTJavaStringLiteral new primitiveValue:
											               'Created class.') })) }).

	^ DeclarationInsertionOperation new
		  anchorNode: anchorNode;
		  transformedNode: newNode;
		  insertBefore: true;
		  yourself
]

{ #category : #test }
FASTJavaCodeGeneratorBuilder >> declarationInsertionOperation2 [

	| anchorNode newNode |
	anchorNode := self fastClassWithTestMethodMethod.

	newNode := FASTJavaMethodEntity new
		           name: 'Test';
		           modifiers: { (FASTJavaModifier new token: 'public') };
		           statementBlock: (FASTJavaStatementBlock new statements:
					            { (FASTJavaExpressionStatement new expression:
							             (FASTJavaMethodInvocation new
								              receiver:
									              (FASTJavaIdentifier new name: 'GlobalLogger');
								              name: 'log';
								              arguments:
									              { (FASTJavaStringLiteral new primitiveValue:
											               'Created class.') })) }).

	^ DeclarationInsertionOperation new
		  anchorNode: anchorNode;
		  transformedNode: newNode;
		  yourself
]

{ #category : #test }
FASTJavaCodeGeneratorBuilder >> deleteOperation1 [

	| nodeToDelete |
	nodeToDelete := self fastMethodGetEdgesIfNode.

	^ DeleteOperation new
		  transformedNode: nodeToDelete;
		  parentNode: nodeToDelete parentNode;
		  yourself
]

{ #category : #'as yet unclassified' }
FASTJavaCodeGeneratorBuilder >> fastClassWithTestMethod [

	^ (JavaSmaCCProgramNodeImporterVisitor new parseCodeMethodString:
		   self sourceClassWithTestMethod) allFASTJavaClassDeclaration first
]

{ #category : #'as yet unclassified' }
FASTJavaCodeGeneratorBuilder >> fastClassWithTestMethodMethod [

	^ self fastClassWithTestMethod declarations first
]

{ #category : #'as yet unclassified' }
FASTJavaCodeGeneratorBuilder >> fastMethodGetEdges [

	^ (JavaSmaCCProgramNodeImporterVisitor new parseCodeMethodString:
		   self sourceMethodGetEdges) allFASTNamedBehaviouralEntity first
]

{ #category : #'as yet unclassified' }
FASTJavaCodeGeneratorBuilder >> fastMethodGetEdgesIfNode [

	^ self fastMethodGetEdges statements do: [ :s | 
		  s class = FASTJavaIfStatement ifTrue: [ ^ s ] ]
]

{ #category : #'as yet unclassified' }
FASTJavaCodeGeneratorBuilder >> fastMethodGetEdgesSuperNode [

	^ self fastMethodGetEdges statements do: [ :s | 
		  s class = FASTJavaReturnStatement ifTrue: [ 
			  ^ s expression receiver ] ]
]

{ #category : #'as yet unclassified' }
FASTJavaCodeGeneratorBuilder >> fastMethodTestMethod [

	^ (JavaSmaCCProgramNodeImporterVisitor new parseCodeMethodString:
		   self sourceMethodTestMethod) allFASTNamedBehaviouralEntity first
]

{ #category : #test }
FASTJavaCodeGeneratorBuilder >> fastMethodTestMethodGetCat [

	^ self fastMethodTestMethod statements do: [ :s | 
		  (s class = FASTJavaVarDeclStatement and: [ 
			   s declarators first variable name = 'cat' ]) ifTrue: [ 
			  ^ s declarators first expression ] ]
]

{ #category : #test }
FASTJavaCodeGeneratorBuilder >> fastMethodTestMethodTableNode [

	^ self fastMethodTestMethod statements do: [ :s | 
		  (s class = FASTJavaVarDeclStatement and: [ 
			   s declarators first variable name = 'table' ]) ifTrue: [ 
			  ^ s ] ]
]

{ #category : #test }
FASTJavaCodeGeneratorBuilder >> insertionOperation1 [

	| parentNode newNode |
	parentNode := self fastMethodTestMethodGetCat.

	newNode := FASTJavaStringLiteral new
		           primitiveValue: 'black';
		           yourself.

	^ InsertionOperation new
		  parentNode: parentNode;
		  transformedNode: newNode;
		  selector: #addArgument:
		  yourself
]

{ #category : #test }
FASTJavaCodeGeneratorBuilder >> replacingOperation1 [

	| nodeToReplace newNode |
	nodeToReplace := self fastMethodGetEdgesSuperNode.

	newNode := FASTJavaMethodInvocation new
		           name: 'getOtherGraphModel';
		           yourself.

	^ ReplacingOperation new
		  originalNode: nodeToReplace;
		  transformedNode: newNode;
		  yourself
]

{ #category : #test }
FASTJavaCodeGeneratorBuilder >> signatureInsertionOperation1 [

	| parentNode newNode |
	parentNode := self fastMethodTestMethod.

	newNode := FASTJavaClassTypeExpression new
		           typeName: (FASTJavaTypeName new
				            name: 'NotFedError';
				            yourself);
		           yourself.

	^ SignatureInsertionOperation new
		  parentNode: parentNode;
		  transformedNode: newNode;
		  selector: #addThrow: yourself
]

{ #category : #test }
FASTJavaCodeGeneratorBuilder >> signatureInsertionOperation2 [

	| parentNode newNode |
	parentNode := self fastClassWithTestMethod.

	newNode := FASTJavaClassTypeExpression new
		           typeName: (FASTJavaTypeName new
				            name: 'House';
				            yourself);
		           yourself.

	^ SignatureInsertionOperation new
		  parentNode: parentNode;
		  transformedNode: newNode;
		  selector: #superclass: yourself
]

{ #category : #test }
FASTJavaCodeGeneratorBuilder >> signatureInsertionOperation3 [

	| parentNode newNode |
	parentNode := self fastClassWithTestMethod.

	newNode := FASTJavaClassTypeExpression new
		           typeName: (FASTJavaTypeName new
				            name: 'TestCase';
				            yourself);
		           yourself.

	^ SignatureInsertionOperation new
		  parentNode: parentNode;
		  transformedNode: newNode;
		  selector: #addInterface: yourself
]

{ #category : #'as yet unclassified' }
FASTJavaCodeGeneratorBuilder >> sourceClassWithTestMethod [

	^ 
'public class Test {

	public boolean testMethod() {
		Cat cat = new Cat();
		Table table = new Table();
		cat.sits(table);
		return table.isClear();
	}
	
}'
]

{ #category : #'as yet unclassified' }
FASTJavaCodeGeneratorBuilder >> sourceClassWithTestMethodAndConstructorAfter [

	^ 
'public class Test {

	public boolean testMethod() {
		Cat cat = new Cat();
		Table table = new Table();
		cat.sits(table);
		return table.isClear();
	}

	public Test() {
	  GlobalLogger.log("Created class.");
	}
	
}'
]

{ #category : #'as yet unclassified' }
FASTJavaCodeGeneratorBuilder >> sourceClassWithTestMethodAndConstructorBefore [

	^ 
'public class Test {

	public Test() {
	  GlobalLogger.log("Created class.");
	}

	public boolean testMethod() {
		Cat cat = new Cat();
		Table table = new Table();
		cat.sits(table);
		return table.isClear();
	}
	
}'
]

{ #category : #'as yet unclassified' }
FASTJavaCodeGeneratorBuilder >> sourceClassWithTestMethodAndSuperclass [

	^ 
'public class Test extends House {
	
	public boolean testMethod() {
		Cat cat = new Cat();
		Table table = new Table();
		cat.sits(table);
		return table.isClear();
	}
	
}'
]

{ #category : #'as yet unclassified' }
FASTJavaCodeGeneratorBuilder >> sourceClassWithTestMethodAndSuperclassAndInterface [

	^ 
'public class Test extends House implements TestCase {
	
	public boolean testMethod() {
		Cat cat = new Cat();
		Table table = new Table();
		cat.sits(table);
		return table.isClear();
	}
	
}'
]

{ #category : #'as yet unclassified' }
FASTJavaCodeGeneratorBuilder >> sourceMethodGetEdges [

	^ 'public List getEdges() {
        if (getGraphModel() != null) {
            return getGraphModel().getEdges();
        }
        return super.getEdges();
}'
]

{ #category : #'as yet unclassified' }
FASTJavaCodeGeneratorBuilder >> sourceMethodGetEdgesDeletingIf [

	^ 'public List getEdges() {
        return super.getEdges();
}'
]

{ #category : #'as yet unclassified' }
FASTJavaCodeGeneratorBuilder >> sourceMethodGetEdgesReplacingSuperNode [

	^ 'public List getEdges() {
        if (getGraphModel() != null) {
            return getGraphModel().getEdges();
        }
        return getOtherGraphModel().getEdges();
}'
]

{ #category : #'as yet unclassified' }
FASTJavaCodeGeneratorBuilder >> sourceMethodTestMethod [

	^ 'public boolean testMethod() {
	Cat cat = new Cat();
	Table table = new Table();
	cat.sits(table);
	return table.isClear();
}'
]

{ #category : #'as yet unclassified' }
FASTJavaCodeGeneratorBuilder >> sourceMethodTestMethodWithCatColor [

	^ 'public boolean testMethod() {
	Cat cat = new Cat("black");
	Table table = new Table();
	cat.sits(table);
	return table.isClear();
}'
]

{ #category : #'as yet unclassified' }
FASTJavaCodeGeneratorBuilder >> sourceMethodTestMethodWithCatMeows [

	^ 'public boolean testMethod() {
	Cat cat = new Cat();
	Table table = new Table();
	cat.meows();
	cat.sits(table);
	return table.isClear();
}'
]

{ #category : #'as yet unclassified' }
FASTJavaCodeGeneratorBuilder >> sourceMethodTestMethodWithException [

	^ 'public boolean testMethod()  throws NotFedError {
	Cat cat = new Cat();
	Table table = new Table();
	cat.sits(table);
	return table.isClear();
}'
]

{ #category : #test }
FASTJavaCodeGeneratorBuilder >> statementInsertionOperation1 [

	| anchorNode newNode |
	anchorNode := self fastMethodTestMethodTableNode.

	newNode := FASTJavaExpressionStatement new expression:
		           (FASTJavaMethodInvocation new
			            receiver: (FASTJavaIdentifier new
					             name: 'cat';
					             yourself);
			            name: 'meows';
			            yourself).

	^ StatementInsertionOperation new
		  anchorNode: anchorNode;
		  transformedNode: newNode;
		  yourself
]
