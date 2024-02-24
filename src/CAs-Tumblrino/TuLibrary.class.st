Class {
	#name : #TuLibrary,
	#superclass : #Object,
	#instVars : [
		'posts'
	],
	#classVars : [
		'Default'
	],
	#category : #'CAs-Tumblrino-Core'
}

{ #category : #accessing }
TuLibrary class >> default [
^Default ifNil:[Default := self new]
]

{ #category : #accessing }
TuLibrary >> basePath [

	^ 'D:\Temp\TumblrLibrary\' asFileReference
]

{ #category : #action }
TuLibrary >> fetchLikes [

	| api  |
	api := TuTumblrClient default.
	posts := api likes.
	posts do: [ :p |
		p
			load;
			saveToFile ]
]

{ #category : #accessing }
TuLibrary >> post: anID [

	| post dict |
	self traceCr: 'Retrieving post: ' , anID.
	post := posts detect: [ :l | l id = anID  ].
	dict := Dictionary new.
	dict
		at: #id put: post id asString;
		at: #imgPaths put: post imgPaths;
		at: #tags put: post tags.
	^ dict
]

{ #category : #accessing }
TuLibrary >> postPath [

	^ self basePath /'_posts'
]

{ #category : #accessing }
TuLibrary >> posts [

	^posts
]

{ #category : #accessing }
TuLibrary >> postsHaving: aTagList butNot: aBlacklist [

	| res ids |
	aTagList isEmpty ifTrue: [
		self traceCr: '<empty taglist>'.
		res := posts select: [ :p | p hasNoTag ] ]ifFalse:[
	self traceCr: aTagList.
	res := posts.
	','
		split: aTagList
		do: [ :tag | res := res select: [ :p | p hasTag: tag ] ]].
	ids := res collect: [ :p | { (#id -> p id asString) } asDictionary ].
	self traceCr: ids.
	^ ids
]

{ #category : #accessing }
TuLibrary >> tags [

	| tmp tmp2 tmp3 dict res |
	self traceCr: 'Tags accessed'.
	tmp := posts collect: [ :l | l tags ].
	tmp2 := tmp flattened.
	res := OrderedCollection new.
	tmp3 := tmp2 asBag sortedElements do: [ :assoc |
		        dict := Dictionary new.
		        dict at: #tag put: assoc key.
		        dict at: #count put: assoc value.
		        res add: dict ].
	
	^ res
]
