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

{ #category : #accessing }
TuTumblrContent >> type [ ^ json at:#type
]
