Class {
	#name : #MorphicGifAdapter,
	#superclass : #SpAbstractMorphicAdapter,
	#category : #'CAs-Tumblrino-GUI'
}

{ #category : #'as yet unclassified' }
MorphicGifAdapter class >> Note [
"to make it work it needs to be installed in initializeBindings in two AdapterBindings: 
	SpecAdapterBindings and MorphicAdapterBindings
	
see: http://spec.st/docs/own-model/#the_binding"
]

{ #category : #'as yet unclassified' }
MorphicGifAdapter >> adapt: aComposableModel [
"	model := aComposableModel.
	aComposableModel addDependent: self.
	widget := self buildWidget"
	super adapt: aComposableModel.
]

{ #category : #'as yet unclassified' }
MorphicGifAdapter >> buildWidget [
	| gif |
	gif := AnimatedImageMorphSq new.
	"gif model: self."
	gif
		vResizing: #spaceFill;
		hResizing: #spaceFill;
		dragEnabled: self dragEnabled;
		dropEnabled: self dropEnabled;
		setBalloonText: self help;
		stepTime: 100;
		update: #getImage.
	"getImageSelector: #getImage;"
	^ gif
]

{ #category : #'as yet unclassified' }
MorphicGifAdapter >> update: aSymbol [
	|  |
	aSymbol = #getGif
		ifTrue: [
			widget fromStream: model stream ]
]
