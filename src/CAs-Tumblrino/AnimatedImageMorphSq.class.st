"
I am an ImageMorph that can hold more than one image. Each image has its own delay time.

Note: Copied from Squeak 5.0
"
Class {
	#name : #AnimatedImageMorphSq,
	#superclass : #ImageMorph,
	#instVars : [
		'images',
		'delays',
		'stepTime',
		'nextTime',
		'imageIndex',
		'stepper'
	],
	#category : #'CAs-Tumblrino-GUI'
}

{ #category : #'class initialization' }
AnimatedImageMorphSq class >> additionsToViewerCategories [
	"Answer a list of (<categoryName> <list of category specs>) pairs that characterize the phrases this kind of morph wishes to add to various Viewer categories."
	^ #(

	(#'graphics' 
		(
		(slot isGifPlaying 'Whether the gif is playing' 
			Boolean readWrite Player getGifPlaying Player setGifPlaying:)
		(slot opaque 'Whether the gif opaque' 
			Boolean readWrite Player getOpaque Player setOpaque:) 
		
	))

)

]

{ #category : #'fileIn/Out' }
AnimatedImageMorphSq class >> fileReaderServicesForFile: fullName suffix: suffix [

	^((AnimatedGIFReadWriter typicalFileExtensions asSet
		add: '*'; add: 'form'; yourself)
		includes: suffix)
		ifTrue: [ self services ]
		ifFalse: [#()]

]

{ #category : #'instance creation' }
AnimatedImageMorphSq class >> fromGIFFileNamed: fileName [
	| reader |
	reader := AnimatedGIFReadWriter formsFromFileNamed: fileName.
	^reader forms size = 1
		ifTrue: [ ImageMorph new image: reader forms first ]
		ifFalse: [ self new fromReader: reader ]
]

{ #category : #'instance creation' }
AnimatedImageMorphSq class >> fromStream: aStream [
	| reader |
	reader := AnimatedGIFReadWriter formsFromStream: aStream.
	^reader forms size = 1
		ifTrue: [ ImageMorph new image: reader forms first ]
		ifFalse: [ self new fromReader: reader ]
]

{ #category : #'instance creation' }
AnimatedImageMorphSq class >> openGIFInWindow: aStream [
	^(self fromStream: aStream binary) openInWorld
]

{ #category : #'fileIn/Out' }
AnimatedImageMorphSq class >> serviceOpenGIFInWindow [
	"Answer a service for opening a gif graphic in a window"
	^ (SimpleServiceEntry
		provider: self
		label: 'open the graphic as a morph'
		selector: #openGIFInWindow:
		description: 'open a GIF graphic file as a morph'
		buttonLabel: 'open gif')
		argumentGetter: [:fileList | fileList readOnlyStream]
]

{ #category : #'fileIn/Out' }
AnimatedImageMorphSq class >> services [
	^ Array
		with: self serviceOpenGIFInWindow
		"with: Form serviceImageImports"
		"with: Form serviceImageAsBackground"
]

{ #category : #'class initialization' }
AnimatedImageMorphSq class >> unload [
	"Unload the receiver from global registries"
	self environment
		at: #FileList
		ifPresent: [:cl | cl unregisterFileReader: self]
]

{ #category : #'stepping and presenter' }
AnimatedImageMorphSq >> addCustomMenuItems: aMenu hand: aHand [
	super addCustomMenuItems: aMenu hand: aHand.
	aMenu addUpdating: #steppingString action: #toggleStepping
]

{ #category : #private }
AnimatedImageMorphSq >> fromArray: reader [ 
	images := reader first.
	delays := reader second.
	imageIndex := 0.
	self
		image: (Form extent: images first extent depth: 32).
	self isOpaque: true.
	self step
]

{ #category : #private }
AnimatedImageMorphSq >> fromGIFFileNamed: fileName [
	self fromReader: (AnimatedGIFReadWriter formsFromFileNamed: fileName)
]

{ #category : #private }
AnimatedImageMorphSq >> fromReader: reader [
	images := reader forms.
	delays := reader delays.
	imageIndex := 0.
	self image: (Form extent: images first extent depth: 32).
	self isOpaque: true.
	self setStepping: images size > 1.
	self step
]

{ #category : #private }
AnimatedImageMorphSq >> fromStream: aStream [
	self fromReader: (AnimatedGIFReadWriter formsFromStream: aStream)
]

{ #category : #private }
AnimatedImageMorphSq >> images [
	^images
]

{ #category : #private }
AnimatedImageMorphSq >> initialize [
	nextTime := Time millisecondClockValue.
	imageIndex := 1.
	stepTime := 10.
	stepper :=true.
	super initialize
]

{ #category : #'stepping and presenter' }
AnimatedImageMorphSq >> setStepping: aBoolean [
self wantsSteps ifFalse:[^false].
stepper := aBoolean.
stepper ifTrue:[self startStepping]
				ifFalse:[self stopStepping].
	
    
]

{ #category : #'stepping and presenter' }
AnimatedImageMorphSq >> step [
	| form delay |
	stepper
		ifFalse: [ self stopStepping ].
	images isEmpty
		ifTrue: [ ^ self ].
	nextTime > Time millisecondClockValue
		ifTrue: [ ^ self ].
	imageIndex > 0
		ifTrue: [ form := images at: imageIndex.
			form
				displayOn: self image
				at: 0 @ 0
				rule:
					(self isOpaque
						ifTrue: [ Form paint ]
						ifFalse: [ Form erase ]) ].
	imageIndex := imageIndex \\ images size + 1.
	form := images at: imageIndex.
	form
		displayOn: self image
		at: 0 @ 0
		rule: Form paint.
	self changed.
	delay := (delays at: imageIndex)
		ifNil: [ 0 ].
	nextTime := Time millisecondClockValue
		+ delay
]

{ #category : #'stepping and presenter' }
AnimatedImageMorphSq >> stepTime [
	^stepTime ifNil: [super stepTime]
]

{ #category : #'stepping and presenter' }
AnimatedImageMorphSq >> stepTime: anInteger [
	stepTime := anInteger
]

{ #category : #'stepping and presenter' }
AnimatedImageMorphSq >> steppingString [
	^ (stepper
		ifTrue: ['<on>']
		ifFalse: ['<off>']), 'stepping' translated
]

{ #category : #'stepping and presenter' }
AnimatedImageMorphSq >> toggleStepping [
	self wantsSteps
		ifTrue: [stepper := stepper not].
	stepper ifTrue:[self startStepping]
				ifFalse:[self stopStepping].
	
    
]

{ #category : #'stepping and presenter' }
AnimatedImageMorphSq >> wantsSteps [
	images ifNil: [ ^ false ] ifNotNil: [ ^ images size > 1 ]
]
