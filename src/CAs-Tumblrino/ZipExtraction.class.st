Class {
	#name : 'ZipExtraction',
	#superclass : 'Object',
	#instVars : [
		'mediaFolder',
		'xmlFolder',
		'exportPath',
		'htmlFolder'
	],
	#category : 'CAs-Tumblrino-Zip',
	#package : 'CAs-Tumblrino',
	#tag : 'Zip'
}

{ #category : 'html' }
ZipExtraction >> createContentFor: aFref [

	| cont |
	cont := TuTumblrContent forFile: aFref. 
	^ cont
]

{ #category : 'process' }
ZipExtraction >> getPostsFrom: aZipArchiveName [

	| zip postMember postZip posts postsXml html |
	zip := ZipArchive new readFrom: aZipArchiveName.
	postMember := zip memberNamed: 'posts.zip'.
	postZip := ByteArray
		           new: postMember uncompressedSize
		           streamContents: [ :stream | postMember extractTo: stream ].
	posts := ZipArchive new readFrom: postZip readStream.
	postsXml := (posts memberNamed: 'posts.xml') contents asString.
	self saveXml: postsXml forZip:aZipArchiveName.
	html := posts membersMatching: '*.html'.
	html do: [ :h | self saveHtml: h ]
]

{ #category : 'initialization' }
ZipExtraction >> initialize [

	exportPath := TuLibrary default basePath / '_Export'.
	mediaFolder := (exportPath / 'media') ensureCreateDirectory.
	xmlFolder := (exportPath / 'xml') ensureCreateDirectory.
	htmlFolder := (exportPath / 'html') ensureCreateDirectory
]

{ #category : 'initialization' }
ZipExtraction >> log: aBlock [
	WorldState addDeferredUIMessage: [ self traceCr: aBlock value ]
]

{ #category : 'initialization' }
ZipExtraction >> misc [

	| zips zip postMember postZip posts postXml |
	self flag:'old stuff. pick and reuse3.'.
	zips := exportPath asFileReference filesMatching: '*.zip'.
	zip := ZipArchive new readFrom: zips first.
	[ 
	zip memberNames
		select: [ :fn | fn includesSubstring: 'media/' ]
		thenDo: [ :fn | 
			| member |
			(mediaFolder / fn) exists ifFalse: [ 
				member := zip member: fn.
				member ifNotNil: [ 
					member
						extractToFileNamed: fn asFileReference basename
						inDirectory: mediaFolder
						overwrite: false ] ] ] ] fork.
	postMember := zip memberNamed: 'posts.zip'.
	postZip := ByteArray
		           new: postMember uncompressedSize
		           streamContents: [ :stream | postMember extractTo: stream ].
	posts := ZipArchive new readFrom: postZip readStream.
	postXml := (posts memberNamed: 'posts.xml') contents asString
]

{ #category : 'xml' }
ZipExtraction >> parsePost: pel [

	| dict tags |
	dict := Dictionary new.
	dict at: #xml put: pel.
	dict at: #id put: (pel attributeAt: #id).
	dict at: #type put: (pel attributeAt: #type).
	dict at: #height put: (pel attributeAt: #height) asInteger.
	dict at: #width put: (pel attributeAt: #width) asInteger.
	tags := (pel elementsAt: #tag) collect: [ :el |
		        el innerXML asLowercase ].
	dict at: #tags put: tags asSet.
	(dict at: #type) asLowercase = #photo
		ifTrue: [ self processXmlPhoto: pel into: dict ]
		ifFalse: [
			(dict at: #type) asLowercase = #regular
				ifTrue: [ self processXmlRegular: pel into: dict ]
				ifFalse: [
					(dict at: #type) asLowercase = #answer
						ifTrue: [ self processXmlAnswer: pel into: dict ]
						ifFalse: [
							(dict at: #type) asLowercase = #video
								ifTrue: [ self processXmlVideo: pel into: dict ]
								ifFalse: [ (dict at: #type) asLowercase = #quote
								ifTrue: [ self processXmlQuote: pel into: dict ]
								ifFalse: [ self halt ]  ] ] ] ].
	^ dict
]

{ #category : 'process' }
ZipExtraction >> processAllFiles [

	| zips |
	zips := exportPath asFileReference / 'zips' filesMatching: '*.zip'.
	zips do: [ :z | 
		self log: [ 'Export file: ' , z basename ].
		self getPostsFrom: z.
		self saveMediaFrom: z ] 
]

{ #category : 'html' }
ZipExtraction >> processHTML [

	| frefs postID |
	frefs := htmlFolder filesMatching: '*.html'.
	frefs do: [ :f |
		postID := f base.
		self processHTMLmediaId: postID html: f contents  ]
]

{ #category : 'html' }
ZipExtraction >> processHTMLmediaId: aPostId html: aString [

	| mediaFiles s tags post cont |
	s := Soup fromString: aString trimmed.
	tags := (s // 'span'
		         select: [ :t | t @ #class = #tag ]
		         thenCollect: [ :t | t string ]) asSet.
	post := TuLibrary default post: aPostId.
	post tags ifEmpty: [ post tags: tags ].
	post path ensureCreateDirectory.
	"can't save, since no content
	post save."
	mediaFiles := mediaFolder filesMatching: aPostId , '*'.
	mediaFiles do: [ :mf |
		(post hasBinaryFile: mf) ifFalse: [
			cont := self createContentFor: mf.
			cont owner: post.
			cont copyFileFrom: mf.
			post addContent: cont.self halt.
			post save ] ]
]

{ #category : 'xml' }
ZipExtraction >> processXML [

	| doc top posts postElements p |
	posts := Dictionary new.
	(xmlFolder filesMatching: '*.xml') do: [ :f | 
		f readStreamDo: [ :str | doc := XMLDOMParser parse: str ].
		top := doc root.
		postElements := top descendantElementsNamed: 'post'.
		postElements do: [ :pel | 
			p := self parsePost: pel.
			posts at: (p at: #id) put: p ] ]. ^posts
]

{ #category : 'xml' }
ZipExtraction >> processXmlAnswer: pel into: dict [
]

{ #category : 'xml' }
ZipExtraction >> processXmlPhoto: pel into: dict [

	"self halt."
]

{ #category : 'xml' }
ZipExtraction >> processXmlQuote: pel into: dict [
]

{ #category : 'xml' }
ZipExtraction >> processXmlRegular: pel into: dict [

	"self halt."
]

{ #category : 'xml' }
ZipExtraction >> processXmlVideo: pel into: dict [
]

{ #category : 'process' }
ZipExtraction >> saveHtml: aHtmlString [

	aHtmlString extractInDirectory: exportPath overwrite: true
]

{ #category : 'process' }
ZipExtraction >> saveMediaFrom: aZipArchive [

	| zip |
	zip := ZipArchive new readFrom: aZipArchive.
	zip memberNames
		select: [ :fn | fn includesSubstring: 'media/' ]
		thenDo: [ :fn | 
			| member |
			(mediaFolder / (fn asFileReference basename)) exists ifFalse: [ 
				member := zip member: fn.
				member ifNotNil: [ 
					self log: [ 'member extraction: ' , fn ].
					member
						extractToFileNamed: fn asFileReference basename
						inDirectory: mediaFolder
						overwrite: false ] ] ]
]

{ #category : 'process' }
ZipExtraction >> saveXml: anXmlString forZip: aFileRef [

	"doc := XMLDOMParser parse: postsXml.
	p1 := doc firstElement elementsNamed: 'post'."

	| basename |
	basename := aFileRef basenameWithoutExtension.
	xmlFolder / basename , #xml writeStreamDo: [ :s | s << anXmlString ]
]
