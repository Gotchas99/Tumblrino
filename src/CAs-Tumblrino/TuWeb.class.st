Class {
	#name : #TuWeb,
	#superclass : #Object,
	#classVars : [
		'Default'
	],
	#category : #'CAs-Tumblrino-Web'
}

{ #category : #private }
TuWeb >> start [

	(ZnServer startDefaultOn: 1701) delegate:
		(ZnStaticFileServerDelegate new
			 directory: (TuLibrary default basePath / '_posts');
			 prefixFromString: 'static-files';
			 yourself)
]
