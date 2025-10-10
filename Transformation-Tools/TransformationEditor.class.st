Class {
	#name : 'TransformationEditor',
	#superclass : 'SpPresenter',
	#instVars : [
		'originalText',
		'originalTextPresenter',
		'transformedText',
		'editingTextPresenter',
		'okButton',
		'toolbar',
		'originalEntity',
		'removedHighlights',
		'addedHighlights',
		'currentPointer',
		'transformationPointers'
	],
	#category : 'Transformation-Tools',
	#package : 'Transformation-Tools'
}

{ #category : 'as yet unclassified' }
TransformationEditor class >> openForOriginalText: originalCode andTransformed: transformedCode [

	| modalWindow |

	modalWindow := self new
		  originalText: originalCode;
		  transformedText: transformedCode;
		  setTextValues;
		  openModal.
		
	^ modalWindow 
]

{ #category : 'as yet unclassified' }
TransformationEditor class >> openForOriginalText: originalCode transformed: transformedCode originalEntity: originalEntity [

	| modalWindow |

	modalWindow := self new
		  originalText: originalCode;
		  transformedText: transformedCode;
		  originalEntity: originalEntity;
		  setTextValues;
		  openModal.
	
	^ modalWindow
]

{ #category : 'as yet unclassified' }
TransformationEditor class >> openForOriginalText: originalCode transformed: transformedCode removedHighlights: removedHighlights addedHighlights: addedHighLights originalEntity: originalEntity [

	| modalWindow |
	modalWindow := self new
		               originalText: originalCode;
		               transformedText: transformedCode;
		               originalEntity: originalEntity;
		               removedHighlights: removedHighlights;
		               addedHighlights: addedHighLights;
		               setTextValuesWithHighlights;
		               openModal.

	^ modalWindow
]

{ #category : 'as yet unclassified' }
TransformationEditor class >> openForOriginalText: originalCode transformed: transformedCode removedHighlights: removedHighlights addedHighlights: addedHighLights originalEntity: originalEntity transformationPointers: transformationPointersList [

	| modalWindow |
	modalWindow := self new
		               originalText: originalCode;
		               transformedText: transformedCode;
		               originalEntity: originalEntity;
		               removedHighlights: removedHighlights;
		               addedHighlights: addedHighLights;
		               transformedEntitiesPosition:
			               transformationPointersList;
		               setTextValuesWithHighlights;
		               openModal.

	^ modalWindow
]

{ #category : 'accessing' }
TransformationEditor >> addedHighlights [

	^ addedHighlights
]

{ #category : 'accessing' }
TransformationEditor >> addedHighlights: anObject [

	addedHighlights := anObject
]

{ #category : 'layout' }
TransformationEditor >> defaultLayout [

	^ SpBoxLayout newTopToBottom
		add: toolbar expand: false;
		  add: (SpBoxLayout newLeftToRight
				   add: (SpBoxLayout newTopToBottom
						    add: 'Original code' expand: false;
						    spacing: 2;
						    add: originalTextPresenter;
						    yourself);
				   spacing: 5;
				   add: (SpBoxLayout newTopToBottom
						    add: 'Transformed code' expand: false;
						    spacing: 2;
						    add: editingTextPresenter;
						    yourself);
				   yourself);
		  spacing: 5;
		  "add: (SpBoxLayout newLeftToRight
				   addLast: okButton expand: false;
				   yourself)
		  expand: false;"
		  yourself
]

{ #category : 'initialization' }
TransformationEditor >> defaultTitle [

	^ 'Transformation Editor'
]

{ #category : 'accessing' }
TransformationEditor >> editingTextPresenter [

	^ editingTextPresenter
]

{ #category : 'initialization' }
TransformationEditor >> goToNextTransformationPointer [

	(currentPointer isNil or: [ 
		 currentPointer = transformationPointers last ]) ifTrue: [ 
		currentPointer := transformationPointers first.
		self goToPointer: currentPointer.
		^ self ].

	currentPointer := transformationPointers at:
		                  (transformationPointers indexOf:
			                   currentPointer) + 1.

	self goToPointer: currentPointer
]

{ #category : 'interaction' }
TransformationEditor >> goToPointer: aTransformationPointerWrapper [
"uses morph to jump to next transfomation pointer (made by Rémi Dufloer)"		
	| originalVScrollPane originalLineToIndex editingVScrollPane editingLineToIndex |
    originalVScrollPane := originalTextPresenter morph scrollPane.
    originalLineToIndex := (originalText string lineNumberCorrespondingToIndex: aTransformationPointerWrapper oldVersionStartIndex) -1 .
    
    editingVScrollPane := editingTextPresenter morph scrollPane.
    editingLineToIndex := (transformedText string lineNumberCorrespondingToIndex: aTransformationPointerWrapper newVersionStartIndex) -1 .
    
    originalVScrollPane vScrollbar setValue:
     ((originalLineToIndex  + ( originalLineToIndex * originalVScrollPane vScrollbarInterval ) ) / originalText lineCount).
    
    editingVScrollPane vScrollbar setValue:
     ((editingLineToIndex  + ( editingLineToIndex * editingVScrollPane vScrollbarInterval ) ) / transformedText lineCount).
		
	"updating scrollbars to set to new value"
	originalTextPresenter morph scrollPane updateScrollbars.
	editingTextPresenter morph scrollPane updateScrollbars 
]

{ #category : 'initialization' }
TransformationEditor >> initialize [

	super initialize.
	
	transformationPointers := OrderedCollection new.
]

{ #category : 'initialization' }
TransformationEditor >> initializeDialogWindow: aDialogWindowPresenter [
	"Used to initialize the model in the case of the use into a dialog window.
	 Override this to set buttons other than the default (Ok, Cancel)."

	aDialogWindowPresenter
		addButton: 'Reject changes'
		do: [ :presenter | presenter triggerCancelAction ];
		addButton: 'Accept changes'
		do: [ :presenter | presenter triggerOkAction ];
		centered
]

{ #category : 'initialization' }
TransformationEditor >> initializePresenters [

	super initializePresenters.
	self initializeToolbar.

	originalTextPresenter := SpMorphPresenter new
		                         morph: (RubScrolledTextMorph new
				                          in: [ :this | 
					                          this textArea readOnly: true ];
				                          yourself);
		                         yourself.

	editingTextPresenter := SpMorphPresenter new
		                        morph: (RubScrolledTextMorph new
				                         autoAccept: true;
				                         yourself);
		                        yourself.

	okButton := SpButtonPresenter new
		            icon: (self iconNamed: #smallOk);
		            label: 'Apply changes';
		            action: [  ];
		            yourself
]

{ #category : 'initialization' }
TransformationEditor >> initializeToolbar [

	toolbar := self newToolbar
		           addItem: self inspectOriginalEntity;
		           addItemRight: self nextEntityButton;
		           yourself
]

{ #category : 'initialization' }
TransformationEditor >> initializeWindow: aWindowPresenter [	
	super initializeWindow: aWindowPresenter.
	aWindowPresenter
		title: self defaultTitle;
		initialExtent: 1920 @ 1080
]

{ #category : 'initialization' }
TransformationEditor >> inspectOriginalEntity [

	^ self newToolbarButton
		  label: 'Inspect original entity';
		  icon: (Smalltalk ui iconNamed: #glamorousInspect);
		  action: [ originalEntity inspect ];
		  yourself
]

{ #category : 'initialization' }
TransformationEditor >> nextEntityButton [

	^ self newToolbarButton
		  label: 'Next transformed entity';
		  icon: (Smalltalk ui iconNamed: #glamorousRight);
		  action: [ self goToNextTransformationPointer ];
		  yourself
]

{ #category : 'accessing' }
TransformationEditor >> originalEntity: anObject [

	originalEntity := anObject
]

{ #category : 'accessing' }
TransformationEditor >> originalText: anObject [

	originalText := anObject
]

{ #category : 'accessing' }
TransformationEditor >> removedHighlights [

	^ removedHighlights
]

{ #category : 'accessing' }
TransformationEditor >> removedHighlights: anObject [

	removedHighlights := anObject
]

{ #category : 'accessing' }
TransformationEditor >> setTextValues [

	originalTextPresenter morph setText: originalText.
	editingTextPresenter morph setText: transformedText
]

{ #category : 'accessing' }
TransformationEditor >> setTextValuesWithHighlights [

	originalText := originalText class = Text
		                ifTrue: [ originalText ]
		                ifFalse: [ Text fromString: originalText ].
		
	transformedText := transformedText class = Text
		                ifTrue: [ transformedText ]
		                ifFalse: [ Text fromString: transformedText ].

	addedHighlights do: [ :h | 
		transformedText
			addAttribute: (TextBackgroundColor color: Color lightGreen)
			from: h first
			to: h stop ].
		
	removedHighlights do: [ :h | 
		originalText
			addAttribute: (TextBackgroundColor color: Color lightRed)
			from: h first
			to: h stop ].

	originalTextPresenter morph setText: originalText.
	editingTextPresenter morph setText: transformedText
]

{ #category : 'accessing' }
TransformationEditor >> transformationPointers [

	^ transformationPointers
]

{ #category : 'accessing' }
TransformationEditor >> transformedEntitiesPosition: anObject [

	transformationPointers := anObject
]

{ #category : 'accessing' }
TransformationEditor >> transformedText [

	^ transformedText
]

{ #category : 'accessing' }
TransformationEditor >> transformedText: anObject [

	transformedText := anObject
]
