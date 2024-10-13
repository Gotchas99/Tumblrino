Class {
	#name : 'TuTumblrText',
	#superclass : 'TuTumblrContent',
	#instVars : [
		'text'
	],
	#category : 'CAs-Tumblrino-Core',
	#package : 'CAs-Tumblrino',
	#tag : 'Core'
}

{ #category : 'testing' }
TuTumblrText >> isEmpty [

	^ self text isEmptyOrNil 
]

{ #category : 'accessing' }
TuTumblrText >> saveToFile [
	super saveToFile.

	
]

{ #category : 'accessing' }
TuTumblrText >> text [

	^ text ifNil:[text:=json at: #text]
]
