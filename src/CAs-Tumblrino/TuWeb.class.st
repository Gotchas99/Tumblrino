Class {
	#name : #TuWeb,
	#superclass : #Object,
	#instVars : [
		'teapot'
	],
	#classVars : [
		'AlwaysRestart',
		'Default'
	],
	#category : #'CAs-Tumblrino-Web'
}

{ #category : #accessing }
TuWeb class >> default [

	^Default ifNil:[Default := self new]
]

{ #category : #'class initialization' }
TuWeb class >> initialize [

	
	AlwaysRestart := true.
	(self environment
		at: #SessionManager)
		default registerNetworkClassNamed: self name 
]

{ #category : #action }
TuWeb class >> restartDefault [
<script>
	self stopDefault.
	^ self startDefault
]

{ #category : #'system startup' }
TuWeb class >> shutDown: quitting [
	"Our system shutDown hook: stop all servers we manage"

	(quitting or: [ AlwaysRestart ]) ifTrue: [
self		stopDefault]
]

{ #category : #action }
TuWeb class >> startDefault [

	^self default start
]

{ #category : #'system startup' }
TuWeb class >> startUp: resuming [
	"Our system startUp hook: start all servers we manage.
	We do this using deferred startup actions to allow normal error handling."

	(resuming or: [ AlwaysRestart ]) ifTrue: [
		(self environment at: #SessionManager) default currentSession
			addDeferredStartupAction: [ self startDefault ] ]
]

{ #category : #action }
TuWeb class >> stopDefault [

	Default ifNotNil: [
		Default stop.
		Default := nil ].

]

{ #category : #action }
TuWeb >> start [

	teapot := Teapot configure: {
			          (#defaultOutput -> #json).
			          (#debugMode -> true) }.
	teapot
		after: '/*'
			-> [ :req :resp |
				resp headers at: 'Access-Control-Allow-Origin' put: '*' ];
		serveStatic: '/statics' from: TuLibrary default postPath;
		GET: '/tags' -> TuLibrary default tags;
		GET: '/welcome' -> 'Hello World!'.
	teapot start
	"(ZnServer startDefaultOn: 1701) delegate:
		(ZnStaticFileServerDelegate new
			 directory: TuLibrary default basePath / '_posts';
			 prefixFromString: 'static-files';
			 yourself)"
]

{ #category : #action }
TuWeb >> stop [

	teapot stop
]
