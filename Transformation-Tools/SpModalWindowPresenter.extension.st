Extension { #name : 'SpModalWindowPresenter' }

{ #category : '*Transformation-Tools' }
SpModalWindowPresenter >> fetchEditedCode [

	^ presenter editingTextPresenter morph text asString
]
