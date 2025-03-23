Class {
	#name : 'TuTumblrContent',
	#superclass : 'TuTumblrObject',
	#instVars : [
		'type',
		'owner'
	],
	#category : 'CAs-Tumblrino-Core',
	#package : 'CAs-Tumblrino',
	#tag : 'Core'
}

{ #category : 'instance creation' }
TuTumblrContent class >> forFile: aFileRef [

	| ext |
	ext := aFileRef extension asLowercase.
	(#( #jpg #jpeg #png #gif ) includes: ext) ifTrue: [
		^ TuTumblrImage new forFile: aFileRef ].
	(#( #mp4 ) includes: ext) ifTrue: [self halt.
		^ TuTumblrVideo new forFile: aFileRef ].
	Error signal: 'unknown file extension'
]

{ #category : 'instance creation' }
TuTumblrContent class >> from: aJson [

	| type className |
	type := aJson at: #type.
	className := 'TuTumblr' , type capitalized.
	^ (Smalltalk classNamed:className)  new setJson: aJson
]

{ #category : 'initialization' }
TuTumblrContent >> initialize [

	super initialize.
	
]

{ #category : 'accessing' }
TuTumblrContent >> owner:aPost [
owner:=aPost
]

{ #category : 'parsing' }
TuTumblrContent >> parseJson [ 
super parseJson .type:= json at:#type
]

{ #category : 'accessing' }
TuTumblrContent >> saveToFile [

	self assert: [ owner isNotNil ]
]

{ #category : 'accessing' }
TuTumblrContent >> setId [

	self id: UUID new asString
]

{ #category : 'accessing' }
TuTumblrContent >> type [

	^ type
]
