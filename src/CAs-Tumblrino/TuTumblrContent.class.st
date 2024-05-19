Class {
	#name : #TuTumblrContent,
	#superclass : #TuTumblrObject,
	#instVars : [
		'type',
		'owner'
	],
	#category : #'CAs-Tumblrino-Core'
}

{ #category : #'as yet unclassified' }
TuTumblrContent class >> forFile: aFileRef [

	| ext |
	ext := aFileRef extension asLowercase.
	(#( #jpg #jpeg #png #gif ) includes: ext) ifTrue: [
		^ TuTumblrImage new forFile: aFileRef ].
	(#( #mp4 ) includes: ext) ifTrue: [
		^ TuTumblrVideo new forFile: aFileRef ].
	Error signal: 'unknown file extension'
]

{ #category : #'instance creation' }
TuTumblrContent class >> from: aJson [

	| type className |
	type := aJson at: #type.
	className := 'TuTumblr' , type capitalized.
	^ (Smalltalk classNamed:className)  new setJson: aJson
]

{ #category : #initialization }
TuTumblrContent >> initialize [

	super initialize.
	
]

{ #category : #accessing }
TuTumblrContent >> owner:aPost [
owner:=aPost
]

{ #category : #initialization }
TuTumblrContent >> parseJson [ 
super parseJson .type:= json at:#type
]

{ #category : #accessing }
TuTumblrContent >> saveToFile [

	
]

{ #category : #accessing }
TuTumblrContent >> setId [

	self id: UUIDGenerator next asString
]

{ #category : #accessing }
TuTumblrContent >> type [

	^ type
]
