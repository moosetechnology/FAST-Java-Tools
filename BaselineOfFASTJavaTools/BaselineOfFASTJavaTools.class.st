Class {
	#name : #BaselineOfFASTJavaTools,
	#superclass : #BaselineOf,
	#category : #BaselineOfFASTJavaTools
}

{ #category : #baselines }
BaselineOfFASTJavaTools >> baseline: spec [

	<baseline>
	spec for: #common do: [ 
		spec package: 'Transformation-Tools'.
		self fastJava: spec ]
]

{ #category : #baselines }
BaselineOfFASTJavaTools >> fastJava: spec [

	spec
		baseline: 'FASTJava'
		with: [ 
		spec repository: 'github://moosetechnology/FAST-JAVA/src' ]
]
