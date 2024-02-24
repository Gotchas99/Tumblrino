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

	self
		deprecated: 'Use #setId instead'
		on: '24 February 2024'
		in:
		'Pharo-11.0.0+build.720.sha.dc4ec9ea9b9b8d3802b5fa1e3666815b9208b589 (64 Bit)'.

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
