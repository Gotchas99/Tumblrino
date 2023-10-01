Class {
	#name : #TuTumblrPostNpf,
	#superclass : #TuTumblrObject,
	#instVars : [
		'media'
	],
	#category : #'CAs-Tumblrino'
}

{ #category : #accessing }
TuTumblrPostNpf >> content [
	"redirected to trail, as content semms empty"

	^ (((json at: #trail) first at: #content) first)at:#media.
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
	media := tags collect: [ :each | TuTumblrPhoto from: each ]
]
