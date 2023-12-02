Class {
	#name : #TuTumblrContent,
	#superclass : #TuTumblrObject,
	#instVars : [
		'type'
	],
	#category : #'CAs-Tumblrino-Core'
}

{ #category : #'instance creation' }
TuTumblrContent class >> from: aJson [

	| type className |
	type := aJson at: #type.
	className := 'TuTumblr' , type capitalized.
	^ (Smalltalk classNamed:className)  new setJson: aJson
]

{ #category : #initialization }
TuTumblrContent >> initialize [

	super initialize.type:=json at: #type
]

{ #category : #initialization }
TuTumblrContent >> setId [

	id := UUIDGenerator next asString
]

{ #category : #accessing }
TuTumblrContent >> type [

	^ type
]
