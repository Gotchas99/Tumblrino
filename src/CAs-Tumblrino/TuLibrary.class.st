Class {
	#name : #TuLibrary,
	#superclass : #Object,
	#instVars : [
		'basePath'
	],
	#classVars : [
		'Default'
	],
	#category : #'CAs-Tumblrino-Core'
}

{ #category : #accessing }
TuLibrary class >> default [
^Default ifNil:[Default := self new]
]

{ #category : #accessing }
TuLibrary >> basePath [

	^ 'D:\Temp\TumblrLibrary\' asFileReference
]

{ #category : #accessing }
TuLibrary >> postPath [

	^ self basePath /'_posts'
]
