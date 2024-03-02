Class {
	#name : #TuDB,
	#superclass : #Object,
	#instVars : [
		'db',
		'conn',
		'writeQ',
		'writeProcess'
	],
	#classVars : [
		'Default'
	],
	#category : #'CAs-Tumblrino-Core'
}

{ #category : #accessing }
TuDB class >> default [
^Default ifNil:[Default:= self new].
]

{ #category : #'class initialization' }
TuDB class >> initialize [

	SessionManager default registerUserClassNamed: self name
]

{ #category : #accessing }
TuDB class >> reset [
Default ifNotNil:[self default close.
	Default := nil]
]

{ #category : #'class initialization' }
TuDB class >> shutDown: quitting [
	"Our system shutDown hook: stop all servers we manage"

 self default close 
]

{ #category : #'class initialization' }
TuDB class >> startUp: resuming [
	"Our system startUp hook"
self default ensureLibrary .
	self default open
]

{ #category : #'connection handling' }
TuDB >> close [

	db ifNotNil: [
		writeProcess terminate.
		writeQ flush.
		db close.
		self traceCr: 'db closed'.
		db := nil ]
]

{ #category : #schema }
TuDB >> colExists: colName inTable: tableName [

	| tbl |
	tbl := db tables detect: [ :t | t name = tableName ].
	^tbl columnNames includes: colName
]

{ #category : #accessing }
TuDB >> conn [ ^conn
]

{ #category : #schema }
TuDB >> createPosts [

	(self tableExists: #posts) ifTrue: [ ^ self ].
	conn execute: 'create table posts(id INTEGER PRIMARY KEY
		, blog_id TEXT
		, tags TEXT
	 )'

]

{ #category : #accessing }
TuDB >> db [

	^ db
]

{ #category : #accessing }
TuDB >> dbFilename [

	^ TuLibrary default basePath / 'TuDatabase.db'
]

{ #category : #schema }
TuDB >> dropPosts [

	(self tableExists: #posts) ifFalse: [ ^ self ].
	conn execute: 'DROP TABLE posts'
]

{ #category : #schema }
TuDB >> ensureColumn: colName type: colType default: defValue inTable: tblName [

	(self colExists: colName inTable: tblName) ifTrue: [ ^ self ].
	db execute:
		'ALTER TABLE ' , tblName , ' ADD COLUMN ' , colName , ' ' , colType
		, ' DEFAULT (' , defValue,')'
]

{ #category : #schema }
TuDB >> ensureColumn: colName type: colType inTable: tblName [

	self
		ensureColumn: colName
		type: colType
		default: 'NULL' 
		inTable: tblName
]

{ #category : #initialization }
TuDB >> ensureLibrary [

	| fromName toName dll |
	dll := 'sqlite3.dll'.
	toName := Smalltalk imageDirectory asFileReference / dll.
	toName exists ifTrue: [ ^ self ].
	fromName := Smalltalk imageDirectory asFileReference / 'pharo-local'
	            / 'iceberg' / 'pharo-rdbms' / 'Pharo-SQLite3' / 'bin'
	            / 'windows' / '64bit' / dll.
	fromName copyTo: toName
]

{ #category : #initialization }
TuDB >> initialize [

	writeQ := AtomicSharedQueue new.

]

{ #category : #'connection handling' }
TuDB >> open [

	db ifNotNil: [ db connection isOpen ifTrue: [ ^ self ] ].
	db := SQLite3Database openOn: self dbFilename pathString.
	conn := db connection.
	writeProcess := [
	                [
	                | msg |
	                msg := writeQ next.
	                self traceCr: 'get, writeQ: ' , writeQ size asString.
	                msg sendTo: self .Processor yield.] repeat.
	                self traceCr: 'writeProcess died' ]
		                forkAt: 33
		                named: #dbWriter.
	self traceCr: 'db opened'
]

{ #category : #testing }
TuDB >> postExists: aPostId [

	| sql tmp |
	sql := 'select count(0) from posts where id=' , aPostId asString.
	db execute: sql doing: [  :cursor|tmp := cursor onlyValue = 1 ].
	^ tmp
]

{ #category : #operations }
TuDB >> queueWrite: aMsg [

	writeQ nextPut: aMsg.
	self traceCr: 'add, writeQ: ' , writeQ size asString.Processor yield.
]

{ #category : #schema }
TuDB >> setupContent [

	
]

{ #category : #schema }
TuDB >> setupMedia [

	
]

{ #category : #schema }
TuDB >> setupPosts [

	self createPosts.
	self ensureColumn: #tags type: #TEXT inTable: #posts.
	self ensureColumn: #hidden type: #INTEGER default: 'FALSE' inTable: #posts
]

{ #category : #schema }
TuDB >> setupSchema [

	self setupPosts.
	self setupContent.
	self setupMedia 
]

{ #category : #testing }
TuDB >> tableExists: tableName [

	^ db tables anySatisfy: [ :t | t name = tableName ] 
]

{ #category : #operations }
TuDB >> writePost: aPostData [

	| sql |
	sql := 'INSERT INTO posts(id, blog_id, tags) VALUES (:id, :blog_id, :tags)
		ON CONFLICT (id) DO
		UPDATE SET blog_id=excluded.blog_id, tags=excluded.tags;'.
	db connection execute: sql with: aPostData
]
