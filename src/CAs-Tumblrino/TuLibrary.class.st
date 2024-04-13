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

{ #category : #action }
TuLibrary >> addPost: aPost [

	posts add: aPost.
	aPost
		saveToFile;
		saveToDb.
	
]

{ #category : #accessing }
TuLibrary >> basePath [

	^ 'D:\Temp\TumblrLibrary\' asFileReference
]

{ #category : #action }
TuLibrary >> fetchLikes [

	| api likes |
	api := TuTumblrClient default.
	likes := api likes.
	likes do: [ :l |
		(posts anySatisfy: [ :p | p id = l id ]) ifFalse: [
			l
				load;
				saveToFile;saveToDb .
			posts add: l ] ]
]

{ #category : #accessing }
TuLibrary >> post: anID [

	| post |
	"self traceCr: 'Retrieving post: ' , anID asString."
	post := posts detect: [ :p | p id = anID asString ]ifNone: [TuTumblrPostNpf new id:anID  ].
	^ post
]

{ #category : #accessing }
TuLibrary >> postDict: anID [

	| post dict |
	self traceCr: 'Retrieving post: ' , anID asString.
	post := self post: anID.
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
	tmp := posts collect: [ :p | p tags ].
	tmp2 := tmp flattened.
	res := OrderedCollection new.
	tmp3 := tmp2 asBag sortedElements do: [ :assoc |
		        dict := Dictionary new.
		        dict at: #tag put: assoc key.
		        dict at: #count put: assoc value.
		        res add: dict ].

	^ res
]
