"
Please describe the package using the class comment of the included manifest class. The manifest class also includes other additional metadata for the package. These meta data are used by other tools such as the SmalllintManifestChecker and the critics Browser
"
Class {
	#name : #ManifestCAsTumblrino,
	#superclass : #PackageManifest,
	#category : #'CAs-Tumblrino-Manifest'
}

{ #category : #'code-critics' }
ManifestCAsTumblrino class >> ruleTempsReadBeforeWrittenRuleV1FalsePositive [

	<ignoreForCoverage>
	^ #(#(#(#RGMethodDefinition #(#TuDB #postExists: #false)) #'2024-02-24T10:12:08.99+01:00') )
]

{ #category : #'code-critics' }
ManifestCAsTumblrino class >> ruleUncommonMessageSendRuleV1FalsePositive [

	<ignoreForCoverage>
	^ #(#(#(#RGMethodDefinition #(#TuWeb #start #false)) #'2024-01-14T10:00:39.107+01:00') )
]
