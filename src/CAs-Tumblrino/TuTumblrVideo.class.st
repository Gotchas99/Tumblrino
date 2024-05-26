Class {
	#name : 'TuTumblrVideo',
	#superclass : 'TuTumblrFilebased',
	#instVars : [
		'poster',
		'filmstrip'
	],
	#category : 'CAs-Tumblrino-Core',
	#package : 'CAs-Tumblrino',
	#tag : 'Core'
}

{ #category : 'as yet unclassified' }
TuTumblrVideo >> forFile: aFileRef [

	| ext |
	self halt.	super forFile: aFileRef
]

{ #category : 'accessing' }
TuTumblrVideo >> media [

	^ media
]

{ #category : 'parsing' }
TuTumblrVideo >> parseJson [

	super parseJson.
	media := TuTumblrMedia from: (json at: #media).
	poster := TuTumblrMedia from: (json at: #poster) first.
	{
		media.
		poster } do: [ :each | each owner: self ].
	json at: #filmstrip ifPresent: [ :strip |
		filmstrip := TuTumblrMedia from: strip.
		filmstrip owner: self ]
]

{ #category : 'accessing' }
TuTumblrVideo >> saveToFile [

	super saveToFile.
	{
		poster.
		filmstrip.
		media } do: [ :each | each ifNotNil: [ each owner: owner.each saveToFile ] ].

]
