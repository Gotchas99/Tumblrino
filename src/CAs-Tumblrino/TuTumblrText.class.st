Class {
	#name : #TuTumblrText,
	#superclass : #TuTumblrContent,
	#instVars : [
		'form',
		'forms',
		'stream'
	],
	#category : #'CAs-Tumblrino-Core'
}

{ #category : #accessing }
TuTumblrText >> text [

	^ json at: #text
]
