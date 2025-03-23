Class {
	#name : 'TuTumblrPostNpf',
	#superclass : 'TuTumblrObject',
	#instVars : [
		'blogId',
		'content',
		'path',
		'tags',
		'hidden'
	],
	#category : 'CAs-Tumblrino-Core',
	#package : 'CAs-Tumblrino',
	#tag : 'Core'
}

{ #category : 'accessing' }
TuTumblrPostNpf >> addContent: aCont [

(content anySatisfy: [:c|c id= aCont id])ifTrue: [ ^self].
 content add: aCont 
]

{ #category : 'accessing' }
TuTumblrPostNpf >> blogId [

	^ blogId ifEmpty: [ blogId:=json at: #blog at: #uuid].
]

{ #category : 'accessing' }
TuTumblrPostNpf >> blogId:anId [

	blogId:=anId 
]

{ #category : 'action' }
TuTumblrPostNpf >> cleanOut [

	| tmp |
	tmp := content select: [ :m | m isEmpty ].
	tmp do: #cleanOut.
	content removeAll: tmp
]

{ #category : 'accessing' }
TuTumblrPostNpf >> content [

	^ content
]

{ #category : 'accessing' }
TuTumblrPostNpf >> dbData [

	| dict tagString |
	dict := Dictionary new.
	dict at: #id put: id.
	dict at: #blog_id put: blogId.
	tagString := '|' join: tags. 
	dict at: #tags put: tagString.
	^ dict
]

{ #category : 'testing' }
TuTumblrPostNpf >> hasBinaryFile: mf [

^content  anySatisfy: [:cnt|cnt hasBinaryFile: mf]
]

{ #category : 'testing' }
TuTumblrPostNpf >> hasNoTag [

	^ tags isEmpty
]

{ #category : 'testing' }
TuTumblrPostNpf >> hasTag: aTag [
 
	^ tags includes: aTag
]

{ #category : 'accessing' }
TuTumblrPostNpf >> id: anId [

super id: anId.
	path := TuLibrary default postPath / self id
]

{ #category : 'accessing' }
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

{ #category : 'initialization' }
TuTumblrPostNpf >> initialize [

	super initialize.
	content := OrderedCollection new.
	tags := OrderedCollection new 
]

{ #category : 'testing' }
TuTumblrPostNpf >> isEmpty [

	| tmp |
	tmp := content reject: #isEmpty .
	^ tmp isEmpty
]

{ #category : 'testing' }
TuTumblrPostNpf >> isHidden [ 

	^ hidden ifNil:[false]
]

{ #category : 'testing' }
TuTumblrPostNpf >> isLoaded [

	^ self content isNotEmpty
]

{ #category : 'action' }
TuTumblrPostNpf >> load [

	"json := TuTumblrClient default
		        getPost: '735400205192675328'
		        from: 'henk-heijmans'"

	json := TuTumblrClient default
		        getPost: id
		        from: blogId .
	self parseJson
]

{ #category : 'action' }
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
		content := content , trail ].content do: [ :cont |
		cont owner: self.
	 ].
	tmp := json at: #tags.
	tags := tmp collect: [ :t | t asLowercase ]
]

{ #category : 'accessing' }
TuTumblrPostNpf >> path [

	^ path 
]

{ #category : 'action' }
TuTumblrPostNpf >> save [

	TuLibrary default addPost: self.
	self saveToDb ;saveToFile 
]

{ #category : 'action' }
TuTumblrPostNpf >> saveToDb [
	
	| msg |
	msg := Message selector: #writePost: argument: self dbData.
	TuDB default queueWrite: msg
]

{ #category : 'action' }
TuTumblrPostNpf >> saveToFile [

	| fref tmp |
	self isLoaded ifFalse: [ Error signal: 'not loaded' ].
	path ensureCreateDirectory.
	fref := (path / 'content.json') asFileReference.
		fref exists ifFalse: [ 
	self crTrace: 'Saving: ' , fref fullName.
	fref writeStreamDo: [ :s |
		tmp := NeoJSONWriter toString: json.
		s << tmp ]].
	content do: [ :cont |
		cont owner: self.
		cont saveToFile ]
]

{ #category : 'accessing' }
TuTumblrPostNpf >> summary [

	^ json at: #summary
]

{ #category : 'accessing' }
TuTumblrPostNpf >> tags [

	^ tags
]

{ #category : 'accessing' }
TuTumblrPostNpf >> tags:aTaglist [

 tags:=aTaglist 
]
