Extension { #name : 'ZnOAuth1Service' }

{ #category : '*CAs-Tumblrino' }
ZnOAuth1Service >> postRequestToken [
	"special vrsion using POST"

	"The first step is to get a token and token_secret. Use this mthod only with OAuth 1.0 providers.
	OAuth version 1.0a requires a callback url."

	| calculator request response responseProperties |
	calculator := self providerAccount newCalculator
		callback: nil;
		yourself.
	request := ZnRequest post: self providerAccount getRequestTokenUrl.
	request
		setAccept: '*/*';
		setAuthorization: (calculator getAuthorizationHeader: request).
	response := self httpClient
		request: request;
		execute;
		response.
	response isSuccess
		ifFalse: [ self error: 'Invalid response' ].
	responseProperties := response contents.
	responseProperties isString
		ifTrue: [ responseProperties := self resourceMetaUtils
				parseQueryFrom: responseProperties readStream ].
	^ ZnOAuth1Token newFromDictionary: responseProperties
]
