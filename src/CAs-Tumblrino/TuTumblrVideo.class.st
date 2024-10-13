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

{ #category : 'testing' }
TuTumblrVideo >> hasBinaryFile: mf [
self halt.
	^ {
		  media.
		  poster.
		  filmstrip } anySatisfy: [ :cnt | cnt hasBinaryFile: mf ]
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
		media } do: [ :each |
		each ifNotNil: [
			each owner: owner.
			each saveToFile ] ]
]
