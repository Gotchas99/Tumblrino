Class {
	#name : #ZipExtraction,
	#superclass : #Object,
	#instVars : [
		'basePath',
		'mediaFolder',
		'xmlFolder'
	],
	#category : #'CAs-Tumblrino-Zip'
}

{ #category : #'as yet unclassified' }
ZipExtraction >> getPostsFrom: aZipArchiveName [
	| zip postMember postZip posts postsXml p1 doc |
	zip := ZipArchive new readFrom: aZipArchiveName.
	postMember := zip memberNamed: 'posts.zip'.
	postZip := ByteArray
		new: postMember uncompressedSize
		streamContents: [ :stream | postMember extractTo: stream ].
	posts := ZipArchive new readFrom: postZip readStream.
	postsXml := (posts memberNamed: 'posts.xml') contents asString.
	"doc := XMLDOMParser parse: postsXml."
	"p1 := doc firstElement elementsNamed: 'post'."
	^ p1
]

{ #category : #initialization }
ZipExtraction >> initialize [
	basePath := 'E:\Temp\Tumblr\_Export'.
	mediaFolder := (basePath asFileReference / 'media')
		ensureCreateDirectory.
	xmlFolder := (basePath asFileReference / 'xml') ensureCreateDirectory
]

{ #category : #initialization }
ZipExtraction >> log: aBlock [
	WorldState addDeferredUIMessage: [ self traceCr: aBlock value ]
]

{ #category : #initialization }
ZipExtraction >> misc [

	| zips zip postMember postZip posts postXml |
	self flag:'old stuff. pick and reuse3.'.
	zips := basePath asFileReference filesMatching: '*.zip'.
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
	zips := basePath asFileReference filesMatching: '*.zip'.
	zips do: [ :z | 
		self log: [ 'Export file: ' , z basename ].
		self saveMediaFrom: z ]
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
