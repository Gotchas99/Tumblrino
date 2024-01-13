Class {
	#name : #BaselineOfTumblrino,
	#superclass : #BaselineOf,
	#category : #BaselineOfTumblrino
}

{ #category : #actions }
BaselineOfTumblrino >> baseline: spec [

	<baseline>
	spec for: #common do: [ 
		spec preLoadDoIt: #preload:package:.
		spec postLoadDoIt: #postload:package:.
		self
			defineDependencies: spec;
			definePackages: spec.
		spec
			group: 'default' with: #( 'core' );
			group: 'core' with: #( 'CAs-Tumblrino' );
			group: 'web' with: #( 'CAs-Tumblrino-Web' );
			group: 'tests' with: #( #'CAs-Tumblrino-Test' ) ]
]

{ #category : #actions }
BaselineOfTumblrino >> defineDependencies: spec [

	^ spec
		  baseline: 'XMLParser'
		  with: [
			  spec repository: 'github://pharo-contributions/XML-XMLParser/src' ];
		  baseline: 'Soup'
		  with: [ spec repository: 'github://pharo-contributions/Soup/' ];
		  baseline: 'NeoJSON'
		  with: [ spec repository: 'github://svenvc/NeoJSON/repository' ];
		  baseline: 'ZincHTTPComponents' with: [
			  spec
				  loads: #( 'SSO-OAuth1' );
				  repository: 'github://svenvc/zinc/repository' ];
		  baseline: 'BabyMock2'
		  with: [ spec repository: 'github://Gotchas99/BabyMock2/src' ];
		
	
  baseline: 'Teapot' with:[
spec  repository: 'github://zeroflag/Teapot/source'];

		
		  baseline: 'Seaside' with: [
		  spec
			  loads: #( 'Core' );
			  repository: 'github://SeasideSt/Seaside/repository' ];
		  "baseline: 'STON-Core'
					with: [ spec repository: 'github://svenvc/ston/repository' ] ;
			baseline: 'NeoJSON'
			with: [ spec
				loads: 'core';
				repository: 'github://svenvc/NeoJSON:v17' ]; baseline: 'NeoConsole'
			with: [ spec repository: 'github://svenvc/NeoConsole:master' ];"
			  yourself
]

{ #category : #actions }
BaselineOfTumblrino >> definePackages: spec [
	"also depends on 'STON-Core' which is currently in the base image"

	^ spec
		  package: 'CAs-Tumblrino'
		  with: [
			  spec requires: #( 'XMLParser' 'NeoJSON' 'ZincHTTPComponents' ) ];
		  package: #'CAs-Tumblrino-Gui'
		  with: [ spec requires: #( 'CAs-Tumblrino' ) ];
		  package: #'CAs-Tumblrino-Test'
		  with: [ spec requires: #( 'CAs-Tumblrino' 'BabyMock2' ) ];
		  package: #'CAs-Tumblrino-Web'
		  with: [ spec requires: #( 'CAs-Tumblrino' 'Teapot' 'Seaside' ) ];
		  yourself
]

{ #category : #actions }
BaselineOfTumblrino >> loadDeps [
	"utility method. not part of baseline itself"

	Metacello new
		repository: 'github://svenvc/zinc/repository';
		baseline: 'ZincHTTPComponents';
		load: 'SSO-OAuth1'.

	Metacello new
		repository: 'github://pharo-contributions/XML-XMLParser/src';
		baseline: 'XMLParser';
		load.

	Metacello new
		baseline: 'Soup';
		repository: 'github://pharo-contributions/Soup';
		load.

Metacello new
  baseline: 'Teapot';
  repository: 'github://zeroflag/Teapot/source';
  load.		
]

{ #category : #actions }
BaselineOfTumblrino >> loadSelf [

	Metacello new
		repository: 'github://svenvc/zinc/repository';
		baseline: 'ZincHTTPComponents';
		load: 'SSO-OAuth1'.

	Metacello new
		repository: 'github://pharo-contributions/XML-XMLParser/src';
		baseline: 'XMLParser';
		load.

	Metacello new
		baseline: 'Soup';
		repository: 'github://pharo-contributions/Soup';
		load.
		
	Metacello new
  baseline: 'Teapot';
  repository: 'github://zeroflag/Teapot/source';
  load.
]

{ #category : #actions }
BaselineOfTumblrino >> postload: loader package: packageSpec [
	
]

{ #category : #actions }
BaselineOfTumblrino >> preload: loader package: packageSpec [
	
]
