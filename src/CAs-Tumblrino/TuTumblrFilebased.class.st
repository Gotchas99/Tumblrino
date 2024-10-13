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

{ #category : 'copying' }
TuTumblrFilebased >> copyFileFrom: mf [
	"for importing Export-files"
self path exists ifTrue:[^self].
	mf copyTo: self path.
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

{ #category : 'accessing' }
TuTumblrFilebased >> path [ ^(owner path / id)
]

{ #category : 'accessing' }
TuTumblrFilebased >> saveToFile [

	super saveToFile.
	self path asFileReference ensureCreateDirectory.
]
