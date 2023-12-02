Class {
	#name : #TuTumblrImage,
	#superclass : #TuTumblrContent,
	#instVars : [
		'media',
		'form',
		'forms',
		'stream'
	],
	#category : #'CAs-Tumblrino-Core'
}

{ #category : #'as yet unclassified' }
TuTumblrImage >> extent [
	^ (json at: #width)@(json at:#height)
]

{ #category : #'as yet unclassified' }
TuTumblrImage >> filename [
	| tmp |
	tmp := self url asUrl path.
	^ tmp copyWithout: $/
]

{ #category : #'as yet unclassified' }
TuTumblrImage >> form [
	^ form ifNil: [ self getForms ]
]

{ #category : #'as yet unclassified' }
TuTumblrImage >> forms [
	^ forms ifNil: [ self getForms ]
]

{ #category : #'as yet unclassified' }
TuTumblrImage >> fullFilename [
	| tmp root |
	root := 'D:\Temp\tumblr\Tumblrino' asPath.
	tmp := root / self filename.
	^ tmp printWithDelimiter: $\
]

{ #category : #'as yet unclassified' }
TuTumblrImage >> getForms [
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
TuTumblrImage >> getStream [
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
TuTumblrImage >> isGif [
	^ self url endsWith: '.gif'
]

{ #category : #'as yet unclassified' }
TuTumblrImage >> stream [
	^ stream ifNil: [ self getStream ]
]

{ #category : #'as yet unclassified' }
TuTumblrImage >> type [
	^ json at: #type
]

{ #category : #'as yet unclassified' }
TuTumblrImage >> url [
	^ json at: #url
]