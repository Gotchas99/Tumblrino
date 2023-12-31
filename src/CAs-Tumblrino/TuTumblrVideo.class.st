Class {
	#name : #TuTumblrVideo,
	#superclass : #TuTumblrContent,
	#instVars : [
		'media'
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
	media := TuTumblrMedia from:(json at: #media) 
]

{ #category : #accessing }
TuTumblrVideo >> saveToFile [
	super saveToFile.

	self halt
]
