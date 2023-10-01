Class {
	#name : #TuTumblrMain,
	#superclass : #ComposableModel,
	#instVars : [
		'buttonLikes',
		'buttonPosts',
		'lstItems',
		'lstTags',
		'picture',
		'gif',
		'buttonUnlike'
	],
	#classVars : [
		'Likes'
	],
	#category : #'CAs-Tumblrino-GUI'
}

{ #category : #'as yet unclassified' }
TuTumblrMain class >> defaultSpec [
	^ SpecLayout composed
		newRow: [ :row | 
			row
				add: #buttonLikes;
				add: #buttonPosts;
				add: #buttonUnlike ]
			height: self buttonHeight;
		"	origin: 0 @ 0 corner: 1 @ 0.7;"
			newRow: [ :row | 
			row
				newColumn: [ :col | col add: #lstTags ] width: 30;
				newColumn: [ :col | col add: #lstItems ] width: 200;
				newColumn: [ :col | 
					col
						add: #picture;
						add: #gif ] ]
			top: 30;
		"origin: 0 @ 0.7
			corner: 1 @ 1"
			yourself
]

{ #category : #'as yet unclassified' }
TuTumblrMain class >> likes [
	| c u |
	^ Likes
		ifNil: [ c := TuTumblrClient default.
			u := c userInfo.
			u likes.
			Likes := c likes ]
]

{ #category : #'as yet unclassified' }
TuTumblrMain class >> resetLikes [
	^ Likes := nil
]

{ #category : #accessing }
TuTumblrMain >> buttonLikes [
	^ buttonLikes
]

{ #category : #accessing }
TuTumblrMain >> buttonLikes: anObject [
	buttonLikes := anObject
]

{ #category : #accessing }
TuTumblrMain >> buttonPosts [
	^ buttonPosts
]

{ #category : #accessing }
TuTumblrMain >> buttonPosts: anObject [
	buttonPosts := anObject
]

{ #category : #accessing }
TuTumblrMain >> buttonUnlike [
	^ buttonUnlike
]

{ #category : #accessing }
TuTumblrMain >> buttonUnlike: anObject [
	buttonUnlike := anObject
]

{ #category : #'initialize - release' }
TuTumblrMain >> extent [
	^ 600 @ 500
]

{ #category : #accessing }
TuTumblrMain >> gif [
	^ gif
]

{ #category : #accessing }
TuTumblrMain >> gif: anObject [
	gif := anObject
]

{ #category : #'initialize - release' }
TuTumblrMain >> initializePresenter [
	buttonLikes action: [  ].
	buttonPosts action: [  ].
	buttonUnlike action: [ self unlike ].
	lstItems whenSelectionChanged: [ self updatePicture ]
	"	self whenBuiltDo: [ self updatePictureSizes ]"
]

{ #category : #'initialize - release' }
TuTumblrMain >> initializeWidgets [
	"widget instantiation"

	buttonLikes := self newButton.
	buttonPosts := self newButton.
	buttonUnlike := self newButton.
	lstTags := self newList.
	lstItems := self newList.
	picture := self newImage.
	gif := self instantiate: GifModel.
	"widget configuration"
	buttonLikes label: 'Likes'.
	buttonPosts label: 'Posts'.
	buttonUnlike label: 'Unlike'.
	lstItems
		items: self class likes;
		displayBlock: [ :it | it summary ].
	"specification of order of focus"
	self focusOrder
		add: buttonLikes;
		add: buttonPosts;
		add: buttonUnlike
]

{ #category : #accessing }
TuTumblrMain >> lstItems [
	^ lstItems
]

{ #category : #accessing }
TuTumblrMain >> lstItems: anObject [
	lstItems := anObject
]

{ #category : #accessing }
TuTumblrMain >> lstTags [
	^ lstTags
]

{ #category : #accessing }
TuTumblrMain >> lstTags: anObject [
	lstTags := anObject
]

{ #category : #accessing }
TuTumblrMain >> picture [
	^ picture
]

{ #category : #accessing }
TuTumblrMain >> picture: anObject [
	picture := anObject
]

{ #category : #'initialize - release' }
TuTumblrMain >> title [
	^ 'Tumblrino'
]

{ #category : #'initialize - release' }
TuTumblrMain >> unlike [
	| post |
	post := lstItems selectedItem.
	post
		ifNotNil: [ post unlike.
			self class resetLikes.
			self changed lstItems ]
]

{ #category : #'initialize - release' }
TuTumblrMain >> updatePicture [
	| it ph form stream |
	picture widget widget layout: #scaledAspect.
	it := lstItems selectedItem.
	it
		ifNotNil: [ ph := it photo_orig.
			ph isGif
				ifTrue: [ stream := ph stream.
					gif stream: stream ]
				ifFalse: [ form := ph form.
					picture image: form ].
			gif widget widget visible: ph isGif.
			picture widget widget visible: ph isGif not ]
		ifNil: [ picture image: nil.
			"gif stream: nil" ]
]

{ #category : #'initialize - release' }
TuTumblrMain >> updatePictureSizes [
| gifW picW |
self halt.
	gifW:= gif widget widget.
	gifW bounds: gifW owner bounds.
		picW:= picture widget widget.
	picW bounds: picW owner bounds.
]
