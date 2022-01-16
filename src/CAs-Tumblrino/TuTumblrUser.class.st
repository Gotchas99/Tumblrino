Class {
	#name : #TuTumblrUser,
	#superclass : #TuTumblrObject,
	#category : #'CAs-Tumblrino'
}

{ #category : #'as yet unclassified' }
TuTumblrUser >> likes [
	^json at: #likes
]
