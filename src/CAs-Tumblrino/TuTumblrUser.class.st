Class {
	#name : 'TuTumblrUser',
	#superclass : 'TuTumblrObject',
	#category : 'CAs-Tumblrino-Core',
	#package : 'CAs-Tumblrino',
	#tag : 'Core'
}

{ #category : 'as yet unclassified' }
TuTumblrUser >> idTag [

	^ #name
]

{ #category : 'as yet unclassified' }
TuTumblrUser >> likes [
	^json at: #likes
]
