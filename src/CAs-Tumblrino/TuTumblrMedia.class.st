Class {
	#name : #TuTumblrMedia,
	#superclass : #TuTumblrObject,
	#instVars : [
		'extent'
	],
	#category : #'CAs-Tumblrino-Core'
}

{ #category : #parsing }
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

{ #category : #parsing }
TuTumblrMedia >> parseJson [

	super parseJson.
	extent := (json at:#width )@(json at:#height)
]

{ #category : #parsing }
TuTumblrMedia >> size [  
^ extent x * extent y
]
