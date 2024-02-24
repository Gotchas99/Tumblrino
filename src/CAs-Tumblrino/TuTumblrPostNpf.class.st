Class {
	#name : #TuTumblrPostNpf,
	#superclass : #TuTumblrObject,
	#instVars : [
		'blogId',
		'content',
		'path',
		'tags'
	],
	#category : #'CAs-Tumblrino-Core'
}

{ #category : #accessing }
TuTumblrPostNpf >> blogId [

	^ blogId ifEmpty: [ blogId:=json at: #blog at: #uuid].
]

{ #category : #accessing }
TuTumblrPostNpf >> blogId:anId [

	blogId:=anId 
]

{ #category : #accessing }
TuTumblrPostNpf >> content [

	^ content
]

{ #category : #testing }
TuTumblrPostNpf >> hasNoTag [

	^ tags isEmpty
]

{ #category : #testing }
TuTumblrPostNpf >> hasTag: aTag [
 
	^ tags includes: aTag
]

{ #category : #accessing }
TuTumblrPostNpf >> id: anId [

	self
		deprecated: 'Use #setId instead'
		on: '24 February 2024'
		in:
		'Pharo-11.0.0+build.720.sha.dc4ec9ea9b9b8d3802b5fa1e3666815b9208b589 (64 Bit)'.

	super id: anId.
	path := TuLibrary default postPath / anId
]

{ #category : #accessing }
TuTumblrPostNpf >> imgPaths [

	| tmp |
	tmp := content
		       select: [ :c | c class = TuTumblrImage ]
		       thenCollect: [ :c | c media first ].
	tmp := tmp collect: [ :m | m path relativeTo: TuLibrary default postPath ].
	tmp := tmp collect: [ :p |
		       'http://localhost:1701/statics/' , p pathString ].
	^ tmp
]

{ #category : #initialization }
TuTumblrPostNpf >> initialize [

	super initialize.
	content := OrderedCollection  new
]

{ #category : #testing }
TuTumblrPostNpf >> isLoaded [

	^ self content isNotEmpty
]

{ #category : #action }
TuTumblrPostNpf >> load [

	"json := TuTumblrClient default
		        getPost: '735400205192675328'
		        from: 'henk-heijmans'"

	json := TuTumblrClient default
		        getPost: id
		        from: blogId .
	self parseJson
]

{ #category : #action }
TuTumblrPostNpf >> parseJson [

	| trail tmp |
	super parseJson.
	self blogId: (json at: #blog at: #uuid).
	content := (json at: #content) collect: [ :each |
		           TuTumblrContent from: each ].
	json at: #trail ifPresent: [ :tr |
		trail := (tr collect: [ :each |
			          (each at: #content) collect: [ :m |
				          TuTumblrContent from: m ] ]) flattened.
		content := content , trail ].
	tmp := json at: #tags.
	tags := tmp collect: [ :t | t asLowercase ]
]

{ #category : #accessing }
TuTumblrPostNpf >> path [ ^path
]

{ #category : #action }
TuTumblrPostNpf >> saveToFile [

	| fref tmp |
	self isLoaded ifFalse: [ Error signal: 'not loaded' ].
	path ensureCreateDirectory.
	fref := (path / 'content.json') asFileReference.
	"	fref exists ifTrue: [ ^ self ]."
	self crTrace: 'Saving: ' , fref fullName.
	fref writeStreamDo: [ :s |
		tmp := NeoJSONWriter toString: json.
		s << tmp ].
	content do: [ :cont |
		cont owner: self.
		cont saveToFile ]
]

{ #category : #accessing }
TuTumblrPostNpf >> setId [

	super setId.
	path := TuLibrary default postPath / id asString
]

{ #category : #accessing }
TuTumblrPostNpf >> summary [

	^ json at: #summary
]

{ #category : #accessing }
TuTumblrPostNpf >> tags [

	^ tags
]
