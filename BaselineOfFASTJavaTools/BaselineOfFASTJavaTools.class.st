Class {
	#name : #BaselineOfFASTJavaTools,
	#superclass : #BaselineOf,
	#category : #BaselineOfFASTJavaTools
}

{ #category : #baselines }
BaselineOfFASTJavaTools >> baseline: spec [

	<baseline>
	spec for: #common do: [ 
		self fastJava: spec.
		spec
			package: 'Transformation-Tools'
			with: [ spec requires: #( 'FASTJava' ) ] ]
]

{ #category : #baselines }
BaselineOfFASTJavaTools >> fastJava: spec [

	spec
		baseline: 'FASTJava'
		with: [ 
		spec repository: 'github://moosetechnology/FAST-JAVA:v3/src' ]
]
