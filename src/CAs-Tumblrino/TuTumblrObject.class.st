Class {
	#name : #TuTumblrObject,
	#superclass : #Object,
	#instVars : [
		'json',
		'id'
	],
	#category : #'CAs-Tumblrino-Core'
}

{ #category : #'instance creation' }
TuTumblrObject class >> from: aJson [
	^ self new setJson: aJson
]

{ #category : #'as yet unclassified' }
TuTumblrObject >> id [
	^ json at: #id
]

{ #category : #initialization }
TuTumblrObject >> parseJson [
]

{ #category : #initialization }
TuTumblrObject >> setJson: aJson [
	json := aJson.
	self parseJson
]
