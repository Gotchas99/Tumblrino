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
SessionManager default
		registerUserClassNamed: self name
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
	SessionManager default currentSession
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
		after: '*' -> [ :req :resp |
				resp headers at: 'Access-Control-Allow-Origin' put: '*' ];
		serveStatic: '/statics' from: TuLibrary default postPath;
		GET: '/tags' -> TuLibrary default tags;
		GET: '/posts' -> [ :req |
				TuLibrary default
					postsHaving: (req at: #having)
					butNot: (req at: #not) ];
		GET: '/post' -> [ :req | TuLibrary default postDict: (req at: #id) ].
	"before:
			'*' -> [ :req | self traceCr: 'Teapot: ' , req uri asString ];"
	teapot start
	
]

{ #category : #action }
TuWeb >> stop [

	teapot stop
]
