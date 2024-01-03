Class {
	#name : #BaselineOfTumblrino,
	#superclass : #Object,
	#category : #BaselineOfTumblrino
}

{ #category : #actions }
BaselineOfTumblrino >> baseline: spec [
	<baseline>
	spec
		for: #common
		do: [ spec preLoadDoIt: #preload:package:.
			spec postLoadDoIt: #postload:package:.
			self
				defineDependencies: spec;
				definePackages: spec.
			spec
				group: 'default' with: #('core');
				group: 'core' with: #('CAs-Pirate' 'CAs-Pirate-Gui');
				group: 'web' with: #('CAs-Pirate-Web');
				group: 'tests' with: #(#'CAs-PirateTest') ]
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
		  baseline: 'SSO-OAuth1' with: [ 
			  spec
				  loads: #( 'SSO-OAuth1' );
				  repository: 'github://svenvc/zinc/repository' ];
		  baseline: 'BabyMock2'
		  with: [ spec repository: 'github://Gotchas99/BabyMock2/src' ];
		  baseline: 'Seaside' with: [ 
		  spec
			  loads: #( 'Core' );
			  repository: 'github://SeasideSt/Seaside/repository' ];
		  "baseline: 'STON-Core'
					with: [ spec repository: 'github://svenvc/ston/repository' ] ""baseline: 'NeoJSON'
			with: [ spec
				loads: 'core';
				repository: 'github://svenvc/NeoJSON:v17' ];""baseline: 'NeoConsole'
			with: [ spec repository: 'github://svenvc/NeoConsole:master' ];"
			  yourself
]

{ #category : #actions }
BaselineOfTumblrino >> definePackages: spec [
	"also depends on 'STON-Core' which is currently in the base image"

	^ spec
		package: 'CAs-Tumblrino'
			with: [ spec requires: #('XMLParser' 'NeoJSON' 'SSO-OAuth1') ];
		package: #'CAs-Tumblrino-Gui'
			with: [ spec requires: #('CAs-Tumblrino') ];
		package: #'CAs-Tumblrino-Test'
			with: [ spec requires: #('CAs-Tumblrino' 'BabyMock2') ];
		package: #'CAs-Tumblrino-Web'
			with: [ spec requires: #('CAs-Tumblrino' 'Seaside') ];
		yourself
]

{ #category : #actions }
BaselineOfTumblrino >> loadDeps [
	"TODO: fix for TvProgram"

	"utility method. not part of baseline itself"

	self flag: #todo.
	Metacello new
		repository: 'github://svenvc/zinc/repository';
		baseline: 'ZincHTTPComponents';
		load: 'SSO-OAuth1'.
	Metacello new
		repository: 'github://pharo-contributions/XML-XMLParser/src';
		baseline: 'XMLParser'.
	"--------------------------"
	Metacello new
		githubUser: 'PolyMathOrg'
			project: 'PolyMath'
			commitish: 'master'
			path: 'src';
		baseline: 'PolyMath';
		load: 'Math-DHB-Numerical'.
	Metacello new
		repository: 'github://pharo-nosql/mongotalk/src';
		baseline: 'MongoTalk';
		load.
	Metacello new
		repository: 'github://svenvc/zinc/repository';
		baseline: 'ZincHTTPComponents';
		load: 'SSO-OAuth1'.
	Metacello new
		githubUser: 'svenvc'
			project: 'NeoCSV'
			commitish: 'master'
			path: 'repository';
		baseline: 'NeoCSV';
		load.
	Metacello new
		githubUser: 'svenvc'
			project: 'NeoConsole'
			commitish: 'master'
			path: 'src';
		baseline: 'NeoConsole';
		load.
	Metacello new
		githubUser: 'zeroflag'
			project: 'Teapot'
			commitish: 'master'
			path: 'src';
		baseline: 'Teapot';
		load: 'Teapot-Core'.
	Metacello new
		smalltalkhubUser: 'PharoExtras' project: 'XMLParser';
		configuration: 'XMLParser';
		version: #stable;
		load: 'Core'.
	Metacello new
		smalltalkhubUser: 'Gotchas' project: 'ServiceBase';
		configuration: 'ServiceBase';
		version: #development
]

{ #category : #actions }
BaselineOfTumblrino >> loadSelf [
	"TODO: fix for TvProgram"

	"example. change to my values"

	self flag: #todo.
	Metacello new
		baseline: 'PDM';
		repository: 'github://RMODINRIA-Blockchain/SmaCC-Solidity';
		load
]

{ #category : #actions }
BaselineOfTumblrino >> postload: loader package: packageSpec [
	
]

{ #category : #actions }
BaselineOfTumblrino >> preload: loader package: packageSpec [
	
]
