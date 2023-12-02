Class {
	#name : #TuTumblrText,
	#superclass : #TuTumblrContent,
	#category : #'CAs-Tumblrino-Core'
}

{ #category : #accessing }
TuTumblrText >> text [

	^ json at: #text
]
