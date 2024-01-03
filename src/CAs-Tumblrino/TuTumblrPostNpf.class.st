Class {
	#name : #TuTumblrPostNpf,
	#superclass : #TuTumblrObject,
	#instVars : [
		'blogId',
		'content',
		'trail',
		'path'
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

{ #category : #accessing }
TuTumblrPostNpf >> id: anId [

	super id: anId.
	path := TuLibrary default basePath  / '_posts' / anId
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

{ #category : #initialization }
TuTumblrPostNpf >> load [

	"json := TuTumblrClient default
		        getPost: '735400205192675328'
		        from: 'henk-heijmans'"

	json := TuTumblrClient default
		        getPost: id
		        from: blogId .
	self parseJson
]

{ #category : #initialization }
TuTumblrPostNpf >> parseJson [

	super parseJson.
	self blogId: (json at: #blog at: #uuid).
	"self blogId: (json at: #tumblelog_uuid)."
	content := (json at: #content) collect: [ :each | 
		           TuTumblrContent from: each ].
	json at: #trail ifPresent: [ :tr | 
		trail := (tr collect: [ :each | 
			          (each at: #content) collect: [ :m | 
				          TuTumblrContent from: m ] ]) flattened.
		content := content, trail ]
]

{ #category : #accessing }
TuTumblrPostNpf >> path [ ^path
]

{ #category : #'as yet unclassified' }
TuTumblrPostNpf >> saveToFile [

	| dir |
	self isLoaded ifFalse: [ Error signal: 'not loaded' ].
	dir := path .
	dir ensureCreateDirectory.
	content do: [ :cont | 
		cont owner: self.
		cont saveToFile ]
]

{ #category : #accessing }
TuTumblrPostNpf >> summary [

	^ json at: #summary
]

{ #category : #accessing }
TuTumblrPostNpf >> tags [
^json at:#tags
]
