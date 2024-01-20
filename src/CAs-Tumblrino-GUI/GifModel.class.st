"
****

****

troligen helt fel superklass !!!!!!!!!!!!!!!!!!!

***************
************
"
Class {
	#name : #GifModel,
	#superclass : #SpPresenterWithModel,
	#instVars : [
		'streamHolder'
	],
	#category : #'CAs-Tumblrino-GUI'
}

{ #category : #'as yet unclassified' }
GifModel class >> adapterName [

	^ #GifAdapter
]

{ #category : #'as yet unclassified' }
GifModel class >> defaultSpec [
	<spec>
	
	^ #(GifAdapter
		adapt: #(model))
]

{ #category : #'as yet unclassified' }
GifModel >> initialize [
	super initialize.
	streamHolder := nil asValueHolder.
	streamHolder whenChangedDo: [ self changed: #getGif]
]

{ #category : #'as yet unclassified' }
GifModel >> stream [
	^ streamHolder value
]

{ #category : #'as yet unclassified' }
GifModel >> stream: aGifStream [
	streamHolder value ifNotNil: [ :s | s close ].
	streamHolder value: aGifStream
]
