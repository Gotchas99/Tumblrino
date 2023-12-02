Class {
	#name : #TuTumblrPostNpf,
	#superclass : #TuTumblrObject,
	#instVars : [
		'media'
	],
	#category : #'CAs-Tumblrino-Core'
}

{ #category : #'as yet unclassified' }
TuTumblrPostNpf >> blogUUID [

	^ json at: #blog at: #uuid
	
]

{ #category : #accessing }
TuTumblrPostNpf >> content [

	^ (json at: #content) 
]

{ #category : #accessing }
TuTumblrPostNpf >> isLoaded [
 
	^ self content isEmpty not
]

{ #category : #initialization }
TuTumblrPostNpf >> load [

	
]

{ #category : #accessing }
TuTumblrPostNpf >> media [
^media
]

{ #category : #initialization }
TuTumblrPostNpf >> parseJson [
	| tags |
	super parseJson.
	tags := self content.
	tags isDictionary
		ifTrue: [ tags := Array with: tags ].
	media := tags collect: [ :each | TuTumblrImage from: each ]
]
