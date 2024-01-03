Class {
	#name : #ZipExtraction,
	#superclass : #Object,
	#instVars : [
		'mediaFolder',
		'xmlFolder',
		'exportPath'
	],
	#category : #'CAs-Tumblrino-Zip'
}

{ #category : #'as yet unclassified' }
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

{ #category : #initialization }
ZipExtraction >> initialize [

	exportPath := TuLibrary default basePath  / '_Export'.
	mediaFolder := (exportPath / 'media') ensureCreateDirectory.
	xmlFolder := (exportPath / 'xml') ensureCreateDirectory
]

{ #category : #initialization }
ZipExtraction >> log: aBlock [
	WorldState addDeferredUIMessage: [ self traceCr: aBlock value ]
]

{ #category : #initialization }
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

{ #category : #initialization }
ZipExtraction >> processAllFiles [

	| zips |
	zips := exportPath asFileReference / 'zips' filesMatching: '*.zip'.
	zips do: [ :z | 
		self log: [ 'Export file: ' , z basename ].
		self getPostsFrom: z.
		self saveMediaFrom: z ] 
]

{ #category : #initialization }
ZipExtraction >> saveHtml: aHtmlString [

	aHtmlString extractInDirectory: exportPath overwrite: true
]

{ #category : #initialization }
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

{ #category : #initialization }
ZipExtraction >> saveXml: anXmlString forZip:aFileRef [

	"doc := XMLDOMParser parse: postsXml.
	p1 := doc firstElement elementsNamed: 'post'."

	self halt
]
