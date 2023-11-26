Class {
	#name : #TuTumblrObject,
	#superclass : #Object,
	#instVars : [
		'json'
	],
	#category : #'CAs-Tumblrino-Core'
}

{ #category : #'instance creation' }
TuTumblrObject class >> from: aJson [
	^ self new setJson: aJson
]

{ #category : #initialization }
TuTumblrObject >> parseJson [
]

{ #category : #initialization }
TuTumblrObject >> setJson: aJson [
	json := aJson.
	self parseJson
]
