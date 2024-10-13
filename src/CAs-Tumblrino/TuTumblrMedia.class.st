Class {
	#name : 'TuTumblrMedia',
	#superclass : 'TuTumblrObject',
	#instVars : [
		'type',
		'owner',
		'extent',
		'path',
		'cropped',
		'origDimension',
		'url'
	],
	#category : 'CAs-Tumblrino-Core',
	#package : 'CAs-Tumblrino',
	#tag : 'Core'
}

{ #category : 'comparing' }
TuTumblrMedia >> <= other [
^self size <= other size
]

{ #category : 'action' }
TuTumblrMedia >> cleanOut [

	type := nil.
	owner := nil.
	extent := nil. 
	path := nil.
	cropped.
	origDimension := nil.
	url := nil
]

{ #category : 'copying' }
TuTumblrMedia >> copyFileFrom: mf [
	"for importing Export-files"
self assert:  owner path  exists .
path:= owner path / mf basename.
self assert:  path  exists not .
path  exists ifFalse:[	mf copyTo: path.]
]

{ #category : 'testing' }
TuTumblrMedia >> cropped [

	^ cropped ifNil:[cropped:=json at: #cropped ifAbsent: [ false ]]
]

{ #category : 'testing' }
TuTumblrMedia >> exists [
^
( path isNotNil or:[url isNotNil])
	ifTrue:[ self path exists]
	ifFalse:[false]
]

{ #category : 'testing' }
TuTumblrMedia >> hasBinaryFile: mf [

	| s1 s2 |
	path ifNil: [ ^ false ].
	path size = mf size ifFalse: [ ^ false ].
	[
	s1 := path binaryReadStream.
	s2 := mf binaryReadStream.
	[ s1 atEnd ] whileFalse: [ s1 next = s2 next ifFalse: [ ^ false ] ] ]
		ensure: [
			s1 close.
			s2 close ].
	^ true
]

{ #category : 'testing' }
TuTumblrMedia >> hasOriginalDimensions [

	^ origDimension ifNil: [ origDimension := json at: #origDimension ifAbsent: [ false ] ]
]

{ #category : 'accessing' }
TuTumblrMedia >> idTag [ ^#url
]

{ #category : 'accessing' }
TuTumblrMedia >> owner:aContent [
owner:=aContent 
]

{ #category : 'parsing' }
TuTumblrMedia >> parseJson [

	super parseJson.
	url := (json at: #url)asUrl .
	type := json at: #type.
	extent := (json at: #width) @ (json at: #height).
	cropped := json at: #cropped ifAbsent: [ false ].
	origDimension := json at: #origDimension ifAbsent: [ false ]
]

{ #category : 'accessing' }
TuTumblrMedia >> path [

	|  fref |
	^ path ifNil: [
		  fref := (owner path / self url lastPathSegment) asFileReference.
		  path := fref ]
]

{ #category : 'accessing' }
TuTumblrMedia >> path: aPath [

	path := aPath 
]

{ #category : 'action' }
TuTumblrMedia >> saveToFile [

	self assert: [ owner isNotNil ].
	self path exists ifTrue: [ ^ self ].
	self traceCr: 'Saving: ' , path fullName.
	url saveContentsToFile: path
]

{ #category : 'accessing' }
TuTumblrMedia >> size [  
^ extent x * extent y
]

{ #category : 'accessing' }
TuTumblrMedia >> url [

	^ url ifNil: [ url :=( json at: #url)asUrl  ]
]
