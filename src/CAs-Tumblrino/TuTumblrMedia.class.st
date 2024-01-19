Class {
	#name : #TuTumblrMedia,
	#superclass : #TuTumblrObject,
	#instVars : [
		'type',
		'owner',
		'extent',
		'path',
		'cropped',
		'origDimension',
		'url'
	],
	#category : #'CAs-Tumblrino-Core'
}

{ #category : #comparing }
TuTumblrMedia >> <= other [
^self size <= other size
]

{ #category : #testing }
TuTumblrMedia >> cropped [

	^ cropped ifNil:[cropped:=json at: #cropped ifAbsent: [ false ]]
]

{ #category : #testing }
TuTumblrMedia >> hasOriginalDimensions [

	^ origDimension ifNil: [ origDimension := json at: #origDimension ifAbsent: [ false ] ]
]

{ #category : #accessing }
TuTumblrMedia >> idTag [ ^#url
]

{ #category : #accessing }
TuTumblrMedia >> owner:aContent [
owner:=aContent 
]

{ #category : #parsing }
TuTumblrMedia >> parseJson [

	super parseJson.
	url:= json at:#url.
	type := json at: #type.
	extent := (json at: #width) @ (json at: #height).
	cropped := json at: #cropped ifAbsent: [ false ].
	 origDimension := json at: #origDimension ifAbsent: [ false ].
]

{ #category : #accessing }
TuTumblrMedia >> path [

	| url fref |
	^ path ifNil:[	url := self url asUrl.
	fref := (owner path / url lastPathSegment) asFileReference.
	path := fref.
]
]

{ #category : #action }
TuTumblrMedia >> saveToFile [

	| url fref |
	url := self url asUrl.
	fref := (owner path / url lastPathSegment) asFileReference.
	path:=fref.
	fref exists ifTrue: [ ^ self ].
	self crTrace: 'Saving: ' , fref fullName.
	url saveContentsToFile: fref
]

{ #category : #accessing }
TuTumblrMedia >> size [  
^ extent x * extent y
]

{ #category : #accessing }
TuTumblrMedia >> url [

	^ url ifNil:[url:=url := json at: #url.]
]
