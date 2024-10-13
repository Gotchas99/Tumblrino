Class {
	#name : 'TuTumblrFilebased',
	#superclass : 'TuTumblrContent',
	#instVars : [
		'media'
	],
	#category : 'CAs-Tumblrino-Core',
	#package : 'CAs-Tumblrino',
	#tag : 'Core'
}

{ #category : 'action' }
TuTumblrFilebased >> cleanOut [ 
media do: #cleanOut.
	media removeAll
]

{ #category : 'copying' }
TuTumblrFilebased >> copyFileFrom: mf [
	"for importing Export-files"

self path asFileReference ensureCreateDirectory.
	media first  copyFileFrom: mf
]

{ #category : 'as yet unclassified' }
TuTumblrFilebased >> forFile: aFileRef [

	| m |
	self id: aFileRef basename.
	m:= TuTumblrMedia new.
	m owner: self.
	media add: m .
	
]

{ #category : 'testing' }
TuTumblrFilebased >> hasBinaryFile: mf [

	^ media anySatisfy: [ :cnt | cnt hasBinaryFile: mf ]
]

{ #category : 'initialization' }
TuTumblrFilebased >> initialize [ 
media := OrderedCollection new
]

{ #category : 'testing' }
TuTumblrFilebased >> isEmpty [

	| tmp |
	tmp := media select: [ :m | m exists ].
	^ tmp isEmpty
]

{ #category : 'accessing' }
TuTumblrFilebased >> media [ ^media
]

{ #category : 'accessing' }
TuTumblrFilebased >> path [ ^(owner path / id)
]

{ #category : 'accessing' }
TuTumblrFilebased >> saveToFile [

	super saveToFile.
	self path asFileReference ensureCreateDirectory.
]
