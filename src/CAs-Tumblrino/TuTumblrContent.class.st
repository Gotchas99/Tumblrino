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

{ #category : 'initialization' }
TuTumblrContent >> parseJson [ 
super parseJson .type:= json at:#type
]

{ #category : 'accessing' }
TuTumblrContent >> saveToFile [


]

{ #category : 'accessing' }
TuTumblrContent >> setId [

	self id: UUIDGenerator next asString
]

{ #category : 'accessing' }
TuTumblrContent >> type [

	^ type
]
