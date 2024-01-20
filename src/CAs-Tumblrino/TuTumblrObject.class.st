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

{ #category : #accessing }
TuTumblrObject >> id [

	^ id asString
]

{ #category : #accessing }
TuTumblrObject >> id: anId [

	id := anId asString
]

{ #category : #accessing }
TuTumblrObject >> idTag [

	^ #id
]

{ #category : #initialization }
TuTumblrObject >> initialize [

	json := Dictionary new 
]

{ #category : #initialization }
TuTumblrObject >> parseJson [

	self setId 
]

{ #category : #initialization }
TuTumblrObject >> setId [

	id := (json at: self idTag)asString
]

{ #category : #initialization }
TuTumblrObject >> setJson: aJson [
	json := aJson.
	self parseJson
]
