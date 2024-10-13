Class {
	#name : 'TuTumblrImage',
	#superclass : 'TuTumblrFilebased',
	#instVars : [
		'form',
		'forms',
		'stream',
		'extent',
		'url'
	],
	#category : 'CAs-Tumblrino-Core',
	#package : 'CAs-Tumblrino',
	#tag : 'Core'
}

{ #category : 'accessing' }
TuTumblrImage >> extent [
self halt.
	^ extent
]

{ #category : 'accessing' }
TuTumblrImage >> filename [
	| tmp |
	tmp := self url asUrl path.
	^ tmp copyWithout: $/
]

{ #category : 'initialization' }
TuTumblrImage >> forFile: aFileRef [
	super forFile: aFileRef
]

{ #category : 'gui' }
TuTumblrImage >> form [
	^ form ifNil: [ self getForms ]
]

{ #category : 'gui' }
TuTumblrImage >> forms [
	^ forms ifNil: [ self getForms ]
]

{ #category : 'accessing' }
TuTumblrImage >> fullFilename [

	| tmp root |
	self halt.
	root := 'D:\Temp\tumblr\Tumblrino' asPath.
	tmp := root / self filename.
	^ tmp printWithDelimiter: $\
]

{ #category : 'gui' }
TuTumblrImage >> getForms [

	"(self url endsWith: '.gif') ifTrue: [
		forms := (AnimatedGIFReadWriter formsFromStream: self stream) forms.
		form := forms first.
		^ forms ].
	(self url endsWith: '.jpg') ifTrue: [
		form := ImageReadWriter formFromStream: self stream.
		forms := { form }.
		^ form ].
	self halt"
]

{ #category : 'gui' }
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

{ #category : 'initialization' }
TuTumblrImage >> initialize [

	super initialize.
	
]

{ #category : 'testing' }
TuTumblrImage >> isGif [
	^ self url endsWith: '.gif'
]

{ #category : 'parsing' }
TuTumblrImage >> parseJson [

	super parseJson.
	"extent := (json at: #width) @ (json at: #height)."
	"url := json at: #url."
	media := (json at: #media) collect: [ :each |
		         TuTumblrMedia from: each ].
	media do: [ :m | m owner: self ]
]

{ #category : 'accessing' }
TuTumblrImage >> saveToFile [

	super saveToFile.
	media do: [ :m | m saveToFile ]
]

{ #category : 'initialization' }
TuTumblrImage >> setId [

	
	url := (json at: #media) first at: #url.
	self id: url asUrl firstPathSegment
]

{ #category : 'gui' }
TuTumblrImage >> stream [
	^ stream ifNil: [ self getStream ]
]

{ #category : 'accessing' }
TuTumblrImage >> url [
self halt.
	^ url
]
