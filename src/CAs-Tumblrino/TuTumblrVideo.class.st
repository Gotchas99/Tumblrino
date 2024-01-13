Class {
	#name : #TuTumblrVideo,
	#superclass : #TuTumblrContent,
	#instVars : [
		'media',
		'poster',
		'filmstrip'
	],
	#category : #'CAs-Tumblrino-Core'
}

{ #category : #accessing }
TuTumblrVideo >> media [

	^ media
]

{ #category : #parsing }
TuTumblrVideo >> parseJson [

	super parseJson.
	media := TuTumblrMedia from: (json at: #media).
	poster := TuTumblrMedia from: (json at: #poster) first.
	json
		at: #filmstrip
		ifPresent: [ :strip | filmstrip := TuTumblrMedia from: strip ].

]

{ #category : #accessing }
TuTumblrVideo >> saveToFile [

	super saveToFile.
	self halt.
		{
		poster.
		filmstrip.
		media } do: [ :each | each ifNotNil: [ each owner: owner ] ].
	{
		poster.
		filmstrip.
		media } do: [ :each | each ifNotNil: [ each saveToFile ] ]
]
