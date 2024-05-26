Class {
	#name : 'TuTumblrImage',
	#superclass : 'TuTumblrContent',
	#instVars : [
		'media',
		'form',
		'forms',
		'stream'
	],
	#category : 'CAs-Tumblrino-Core',
	#package : 'CAs-Tumblrino',
	#tag : 'Core'
}

{ #category : 'accessing' }
TuTumblrImage >> extent [
	^ (json at: #width)@(json at:#height)
]

{ #category : 'accessing' }
TuTumblrImage >> filename [
	| tmp |
	tmp := self url asUrl path.
	^ tmp copyWithout: $/
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
super initialize .media:= OrderedCollection new.
]

{ #category : 'testing' }
TuTumblrImage >> isGif [
	^ self url endsWith: '.gif'
]

{ #category : 'accessing' }
TuTumblrImage >> media [ ^media
]

{ #category : 'parsing' }
TuTumblrImage >> parseJson [

	super parseJson.
	media := (json at: #media) collect: [ :each |
		         TuTumblrMedia from: each ].
	media do:[:m|m owner: self].
]

{ #category : 'accessing' }
TuTumblrImage >> path [ ^(owner path / id)
]

{ #category : 'accessing' }
TuTumblrImage >> saveToFile [

	super saveToFile.
	self path asFileReference ensureCreateDirectory.
	media do: [ :m |
		
		m saveToFile ]
]

{ #category : 'initialization' }
TuTumblrImage >> setId [

	| url |
	url := (json at: #media) first at: #url.
	self id: url asUrl firstPathSegment
]

{ #category : 'gui' }
TuTumblrImage >> stream [
	^ stream ifNil: [ self getStream ]
]

{ #category : 'accessing' }
TuTumblrImage >> url [
	^ json at: #url
]
