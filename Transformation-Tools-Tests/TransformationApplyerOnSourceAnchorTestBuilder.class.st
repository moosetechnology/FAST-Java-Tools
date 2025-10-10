Class {
	#name : 'TransformationApplyerOnSourceAnchorTestBuilder',
	#superclass : 'Object',
	#instVars : [
		'memorySystem',
		'printMethod',
		'incrementMethod',
		'firstConstructor',
		'secondConstructor',
		'testClass',
		'mooseModel'
	],
	#category : 'Transformation-Tools-Tests',
	#package : 'Transformation-Tools-Tests'
}

{ #category : 'as yet unclassified' }
TransformationApplyerOnSourceAnchorTestBuilder >> buildFullClass [

	| writeStream package |
	memorySystem := FileSystem memory.
	self createMemoryDirectories.
	writeStream := self fileReference writeStream.
	writeStream nextPutAll: self classText.
	writeStream close.

	mooseModel := FamixJavaModel new.
	package := FamixJavaPackage new.

	testClass := FamixJavaClass new.
	testClass
		name: 'ClasseDeTest';
		typeContainer: package;
		sourceAnchor:
			(self createSourceAnchorForStartPos: 16 andEndPos: 351).

	incrementMethod := FamixJavaMethod new.
	incrementMethod
		name: 'increment';
		parentType: testClass;
		sourceAnchor:
			(self createSourceAnchorForStartPos: 80 andEndPos: 119).

	firstConstructor := FamixJavaMethod new.
	firstConstructor
		name: 'ClasseDeTest';
		parentType: testClass;
		sourceAnchor:
			(self createSourceAnchorForStartPos: 124 andEndPos: 177).
			
	secondConstructor := FamixJavaMethod new.
	secondConstructor
		name: 'ClasseDeTest';
		parentType: testClass;
		sourceAnchor:
			(self createSourceAnchorForStartPos: 182 andEndPos: 263).

	printMethod := FamixJavaMethod new.
	printMethod
		name: 'printTitle';
		parentType: testClass;
		sourceAnchor:
			(self createSourceAnchorForStartPos: 268 andEndPos: 347).

	package := FamixJavaPackage new.
	package
		name: 'test';
		addClass: testClass.

	mooseModel
		name: 'TestModel';
		rootFolder: self rootFolderReference;
		add: testClass;
		add: incrementMethod;
		add: printMethod.
		
]

{ #category : 'as yet unclassified' }
TransformationApplyerOnSourceAnchorTestBuilder >> classText [

	^ 
'package test;

public ClasseDeTest {

	private int i;
	public String title;
	
	private void increment() { 
		i += 1;
	}
	
	public ClasseDeTest() { 
		i = 0;
		title = "test";
	}
	
	public ClasseDeTest(int i, String title) { 
		self.i = i;
		self.title = title;
	}
	
	public void printTitle() { 
		self.increment();
		System.out.println(title); 
	}
	
}'
]

{ #category : 'as yet unclassified' }
TransformationApplyerOnSourceAnchorTestBuilder >> classTextWithAllImports [

	^ 
'package test;

import com.animals.dogs;

import some.thing.package;
import com.animals.cats;

public ClasseDeTest {

	private int i;
	public String title;
	
	private void increment() { 
		i += 1;
	}
	
	public ClasseDeTest() { 
		i = 0;
		title = "test";
	}
	
	public ClasseDeTest(int i, String title) { 
		self.i = i;
		self.title = title;
	}
	
	public void printTitle() { 
		self.increment();
		System.out.println(title); 
	}
	
}'
]

{ #category : 'as yet unclassified' }
TransformationApplyerOnSourceAnchorTestBuilder >> classTextWithFirstImports [

	^ 
'package test;

import some.thing.package;
import com.animals.cats;

public ClasseDeTest {

	private int i;
	public String title;
	
	private void increment() { 
		i += 1;
	}
	
	public ClasseDeTest() { 
		i = 0;
		title = "test";
	}
	
	public ClasseDeTest(int i, String title) { 
		self.i = i;
		self.title = title;
	}
	
	public void printTitle() { 
		self.increment();
		System.out.println(title); 
	}
	
}'
]

{ #category : 'as yet unclassified' }
TransformationApplyerOnSourceAnchorTestBuilder >> classTextWithNewMethod [

	^ 
'package test;

public ClasseDeTest {

	private int i;
	public String title;
	
	private void increment() { 
		i += 1;
	}
	
	public void decrement() {
		i--;
	}
	
	public ClasseDeTest() { 
		i = 0;
		title = "test";
	}
	
	public ClasseDeTest(int i, String title) { 
		self.i = i;
		self.title = title;
	}
	
	public void printTitle() { 
		self.increment();
		System.out.println(title); 
	}
	
}'
]

{ #category : 'as yet unclassified' }
TransformationApplyerOnSourceAnchorTestBuilder >> classTextWithTransformedIncrement [

	^ 
'package test;

public ClasseDeTest {

	private int i;
	public String title;
	
	private int increment() { 
		i += 1;
		return i;
	}
	
	public ClasseDeTest() { 
		i = 0;
		title = "test";
	}
	
	public ClasseDeTest(int i, String title) { 
		self.i = i;
		self.title = title;
	}
	
	public void printTitle() { 
		self.increment();
		System.out.println(title); 
	}
	
}'
]

{ #category : 'as yet unclassified' }
TransformationApplyerOnSourceAnchorTestBuilder >> createMemoryDirectories [

	memorySystem store createDirectory:
		(FileSystem memory / 'testapp') asPath.
	memorySystem store createDirectory:
		(FileSystem memory / 'testapp' / 'src') asPath
]

{ #category : 'as yet unclassified' }
TransformationApplyerOnSourceAnchorTestBuilder >> createSourceAnchorForStartPos: aStartPos andEndPos: anEndPos [

	| sourceAnchor |
	sourceAnchor := FamixJavaIndexedFileAnchor new.
	sourceAnchor
		mooseModel: mooseModel;
		fileName: './ClasseDeTest.java';
		startPos: aStartPos;
		endPos: anEndPos.

	^ sourceAnchor
]

{ #category : 'accessing' }
TransformationApplyerOnSourceAnchorTestBuilder >> fileReference [

	^ (memorySystem / 'testapp' / 'src' / 'ClasseDeTest.java')
		  asFileReference
]

{ #category : 'accessing' }
TransformationApplyerOnSourceAnchorTestBuilder >> firstConstructor [

	^ firstConstructor
]

{ #category : 'as yet unclassified' }
TransformationApplyerOnSourceAnchorTestBuilder >> firstConstructorSource [

	^ 
'public ClasseDeTest() { 
		i = 0;
		title = "test";
	}'
]

{ #category : 'as yet unclassified' }
TransformationApplyerOnSourceAnchorTestBuilder >> importsToAddFirst [

	^ { 'import some.thing.package;' . 'import com.animals.cats;' }
]

{ #category : 'as yet unclassified' }
TransformationApplyerOnSourceAnchorTestBuilder >> importsToAddSecond [

	^ { 'import com.animals.dogs;' }
]

{ #category : 'accessing' }
TransformationApplyerOnSourceAnchorTestBuilder >> incrementMethod [

	^ incrementMethod
]

{ #category : 'as yet unclassified' }
TransformationApplyerOnSourceAnchorTestBuilder >> incrementNewSource [

	^ 
'private int increment() {
		i+=1;
		return i;
	}'
]

{ #category : 'as yet unclassified' }
TransformationApplyerOnSourceAnchorTestBuilder >> incrementSource [

	^ 
'private void increment() { 
		i += 1;
	}'
]

{ #category : 'initialization' }
TransformationApplyerOnSourceAnchorTestBuilder >> initialize [ 
	self buildFullClass 
]

{ #category : 'accessing' }
TransformationApplyerOnSourceAnchorTestBuilder >> printMethod [

	^ printMethod
]

{ #category : 'accessing' }
TransformationApplyerOnSourceAnchorTestBuilder >> printSource [

	^ 
'public void printTitle() { 
		self.increment();
		System.out.println(title); 
	}'
]

{ #category : 'as yet unclassified' }
TransformationApplyerOnSourceAnchorTestBuilder >> rootFolderReference [

	^ (memorySystem / 'testapp' / 'src') asFileReference
]

{ #category : 'accessing' }
TransformationApplyerOnSourceAnchorTestBuilder >> secondConstructor [

	^ secondConstructor
]

{ #category : 'as yet unclassified' }
TransformationApplyerOnSourceAnchorTestBuilder >> secondConstructorSource [

	^ 
'public ClasseDeTest(int i, String title) { 
		self.i = i;
		self.title = title;
	}'
]

{ #category : 'accessing' }
TransformationApplyerOnSourceAnchorTestBuilder >> testClass [

	^ testClass
]
