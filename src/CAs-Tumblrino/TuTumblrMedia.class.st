Class {
	#name : #TuTumblrMedia,
	#superclass : #TuTumblrObject,
	#instVars : [
		'type',
		'owner',
		'extent'
	],
	#category : #'CAs-Tumblrino-Core'
}

{ #category : #comparing }
TuTumblrMedia >> <= other [
^self size <= other size
]

{ #category : #testing }
TuTumblrMedia >> cropped [

	^ json at: #cropped ifAbsent: [ false ]
]

{ #category : #testing }
TuTumblrMedia >> hasOriginalDimensions [ 
^(json at: #height ifAbsent: [false])
]

{ #category : #'as yet unclassified' }
TuTumblrMedia >> idTag [ ^#url
]

{ #category : #accessing }
TuTumblrMedia >> owner:aContent [
owner:=aContent 
]

{ #category : #parsing }
TuTumblrMedia >> parseJson [

	super parseJson..
	type := (json at: #type).
	extent := (json at: #width) @ (json at: #height)
]

{ #category : #accessing }
TuTumblrMedia >> saveToFile [

	| url fref |
	url := self url asUrl.
	fref := (owner path / url lastPathSegment) asFileReference.
	fref exists ifTrue: [ ^ self ].
	url saveContentsToFile: fref
]

{ #category : #accessing }
TuTumblrMedia >> size [  
^ extent x * extent y
]

{ #category : #accessing }
TuTumblrMedia >> url [ ^(json at: #url)
]
