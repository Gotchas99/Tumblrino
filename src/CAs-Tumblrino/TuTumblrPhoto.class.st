Class {
	#name : #TuTumblrPhoto,
	#superclass : #TuTumblrObject,
	#instVars : [
		'form',
		'forms',
		'stream'
	],
	#category : #'CAs-Tumblrino-Core'
}

{ #category : #'as yet unclassified' }
TuTumblrPhoto >> extent [
	^ (json at: #width)@(json at:#height)
]

{ #category : #'as yet unclassified' }
TuTumblrPhoto >> filename [
	| tmp |
	tmp := self url asUrl path.
	^ tmp copyWithout: $/
]

{ #category : #'as yet unclassified' }
TuTumblrPhoto >> form [
	^ form ifNil: [ self getForms ]
]

{ #category : #'as yet unclassified' }
TuTumblrPhoto >> forms [
	^ forms ifNil: [ self getForms ]
]

{ #category : #'as yet unclassified' }
TuTumblrPhoto >> fullFilename [
	| tmp root |
	root := 'D:\Temp\tumblr\Tumblrino' asPath.
	tmp := root / self filename.
	^ tmp printWithDelimiter: $\
]

{ #category : #'as yet unclassified' }
TuTumblrPhoto >> getForms [
	(self url endsWith: '.gif')
		ifTrue: [ forms := (AnimatedGIFReadWriter formsFromStream: self stream) forms.
			form := forms first.
			^ forms ].
	(self url endsWith: '.jpg')
		ifTrue: [ 
			form := ImageReadWriter formFromStream: self stream.
			forms := {form}.
			^ form ].
	self halt
]

{ #category : #'as yet unclassified' }
TuTumblrPhoto >> getStream [
	| url gifBytes gifStream fref |
	fref := self fullFilename asFileReference.
	fref exists
		ifTrue: [ gifStream := fref readStream ]
		ifFalse: [ url := ZnUrl fromString: self url.
			gifBytes := (ZnEasy get: url) entity contents.
			fref writeStreamDo: [ :s | s nextPutAll: gifBytes ].
			gifStream := ReadStream on: gifBytes ].
	^ gifStream
]

{ #category : #'as yet unclassified' }
TuTumblrPhoto >> isGif [
	^ self url endsWith: '.gif'
]

{ #category : #'as yet unclassified' }
TuTumblrPhoto >> stream [
	^ stream ifNil: [ self getStream ]
]

{ #category : #'as yet unclassified' }
TuTumblrPhoto >> type [
	^ json at: #type
]

{ #category : #'as yet unclassified' }
TuTumblrPhoto >> url [
	^ json at: #url
]
