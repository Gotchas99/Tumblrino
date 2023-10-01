Class {
	#name : #TuTumblrPost,
	#superclass : #TuTumblrObject,
	#instVars : [
		'orig'
	],
	#category : #'CAs-Tumblrino'
}

{ #category : #'as yet unclassified' }
TuTumblrPost >> id [
	^ json at: #id
]

{ #category : #'as yet unclassified' }
TuTumblrPost >> photo_orig [
	^ orig
		ifNil: [ orig := TuTumblrPhoto from: ((json at: #photos) first at: #original_size) ]
]

{ #category : #'as yet unclassified' }
TuTumblrPost >> photos [
	^ ((json at: #photos) first at: #alt_sizes) collect: [ :p | TuTumblrPhoto from: p ]
]

{ #category : #'as yet unclassified' }
TuTumblrPost >> reblog_key [
	^ json at: #reblog_key
]

{ #category : #'as yet unclassified' }
TuTumblrPost >> summary [
	^ json at: #summary
]

{ #category : #'as yet unclassified' }
TuTumblrPost >> tags [
	^ json at: #tags
]

{ #category : #'as yet unclassified' }
TuTumblrPost >> type [
	^ json at: #type
]

{ #category : #'as yet unclassified' }
TuTumblrPost >> unlike [
	TuTumblrClient default unlike: self
]
