Extension { #name : 'SoupDecoder' }

{ #category : '*CAs-Tumblrino' }
SoupDecoder >> decodeFrom: encodingName [

	| converter |
	encodingName = 'utf-8' ifTrue: [ ^ xmlData ]. 
	converter := self encoderClass newForEncoding: encodingName.
	converter ifNil: [
		self error: 'No text converter for ' , encodingName ].
	(self shouldConvertSmartQuotes: encodingName) ifTrue: [
		xmlData := self convertSmartQuotes: xmlData ].
	^ [ converter decodeBytes: xmlData asByteArray ]
		  on: Error
		  do: [ :e | nil ]
]

{ #category : '*CAs-Tumblrino' }
SoupDecoder >> detectEncoding [

	xmlData := string.
	[
	self sniffNonAsciiCompatibleEncoding.
	self sniffEncoding. 
	self sniffEncodingMeta ]
		on: Error
		do: [ :e |  ]
]

{ #category : '*CAs-Tumblrino' }
SoupDecoder >> sniffEncoding [

	| xmlEncodingMatcher |
	"xmlEncodingMatcher := '^<\?.*encoding=[''""](.*?)[''""].*\?>' asRegex."
	xmlEncodingMatcher := '^<\?.*encoding=[''"](.*)[''"].*\?>' asRegex.
	(xmlEncodingMatcher matches: xmlData) ifTrue: [
		xmlEncoding = (xmlEncodingMatcher subexpression: 1) asLowercase.
		(sniffedXmlEncoding notNil and: [
			 #( 'iso-10646-ucs-2' 'ucs-2' 'csunicode' 'iso-10646-ucs-4'
			    'ucs-4' 'csucs4' 'utf-16' 'utf-32' 'utf_16' 'utf_32' 'utf16'
			    'u16' ) includes: xmlEncoding ]) ifTrue: [
			xmlEncoding := sniffedXmlEncoding ] ]
]

{ #category : '*CAs-Tumblrino' }
SoupDecoder >> sniffEncodingMeta [

	| charsetMatcher equivMatcher |
	(xmlData includesSubstring: 'utf-8') ifTrue: [
		xmlEncoding := 'utf-8' ]
	"<meta charset=""utf-8"">"
	"charsetMatcher := '^\s*<meta.*charset=[''""](.*)[''""].*>' asRegex.
	equivMatcher := '^\s*<meta.*charset=(.*)[''""].*>' asRegex.
	(charsetMatcher matches: xmlData)
		ifTrue: [
		xmlEncoding := (charsetMatcher subexpression: 1) asLowercase ]
		ifFalse: [
			(equivMatcher matches: xmlData)
				ifTrue: [
				xmlEncoding := (equivMatcher subexpression: 1) asLowercase ]
				ifFalse: [ ^ self ] ].
	sniffedXmlEncoding ifNil: [ ^ self ].
	(#( 'latin-1' 'iso-8859-1' 'utf-8' ) includes: xmlEncoding) ifFalse: [
		^ self ].
	xmlEncoding := sniffedXmlEncoding"
]
