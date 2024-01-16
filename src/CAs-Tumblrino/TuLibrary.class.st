Class {
	#name : #TuLibrary,
	#superclass : #Object,
	#instVars : [
		'basePath',
		'tags',
		'posts',
		'likes'
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
	likes := api likes.
	likes do: [ :p |
		p
			load;
			saveToFile ]
]

{ #category : #accessing }
TuLibrary >> post: anID [

	| post dict |
	post := likes detect: [ :l | l id = anID asInteger ].
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

	^likes
]

{ #category : #accessing }
TuLibrary >> postsHaving: aTagList butNot: aBlacklist [

	| res ids |
	self traceCr: aTagList.
	aTagList isEmpty ifTrue: [self traceCr: 'empty taglist'. ^ #(  ) ].
	res := likes.
	','
		split: aTagList
		do: [ :tag | res := res select: [ :p | p hasTag: tag ] ].
	ids := res collect: [ :p | p id asString ].
	self traceCr: ids.
	^ ids
]

{ #category : #accessing }
TuLibrary >> tags [

	| tmp tmp2 |
	tmp := likes collect: [ :l | l tags ].
	tmp2 := tmp flattened.
	^ tmp2 asSet sorted
]
