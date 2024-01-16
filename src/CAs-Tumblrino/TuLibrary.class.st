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

{ #category : #'as yet unclassified' }
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
TuLibrary >> postPath [

	^ self basePath /'_posts'
]

{ #category : #accessing }
TuLibrary >> posts [

	^likes
]

{ #category : #accessing }
TuLibrary >> postsHaving: aTagList butNot: aBlacklist [

	^#()
]

{ #category : #accessing }
TuLibrary >> tags [

	| tmp tmp2 |
	tmp := likes collect: [ :l | l tags ].
	tmp2 := tmp flattened.
	^ tmp2 asSet sorted
]
