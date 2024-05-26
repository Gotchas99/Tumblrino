Class {
	#name : 'TuTumblrFilebased',
	#superclass : 'TuTumblrContent',
	#instVars : [
		'media'
	],
	#category : 'CAs-Tumblrino-Core',
	#package : 'CAs-Tumblrino',
	#tag : 'Core'
}

{ #category : 'as yet unclassified' }
TuTumblrFilebased >> forFile: aFileRef [

	self halt.
	self id: aFileRef basename.
	"fix"
"	media do: [ :m | m owner: self ]"
]
