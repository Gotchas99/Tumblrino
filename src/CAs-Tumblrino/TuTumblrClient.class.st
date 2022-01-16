Class {
	#name : #TuTumblrClient,
	#superclass : #Object,
	#instVars : [
		'oauth1Service',
		'consdata',
		'consData'
	],
	#classVars : [
		'Default'
	],
	#category : #'CAs-Tumblrino-API'
}

{ #category : #accessing }
TuTumblrClient class >> default [
	^ Default ifNil: [ Default := self new ]
]

{ #category : #accessing }
TuTumblrClient class >> keyString [
	"gå till 
	https://api.tumblr.com/console/
	och tryck på 'Show keys', och klistra in de fyra raderna här.
	whitespace tas bort"

	^ '
	Consumer Key XXXXXX
Consumer Secret XXXXXX
Token XXXXXX
Token Secret XXXXXX
	'
]

{ #category : #accessing }
TuTumblrClient class >> keys [
	| lines keys parts val key |
	lines := self keyString lines collect: #trim thenReject: #isEmpty.
	keys := Dictionary new.
	lines
		do: [ :each | 
			parts := ' ' split: each.
			val := parts last.
			key := ' ' join: parts allButLast.
			keys at: key put: val ].
	^ keys
]

{ #category : #accessing }
TuTumblrClient class >> reset [
	Default := nil
]

{ #category : #accessing }
TuTumblrClient class >> xAuth [
	"application name: Tmblrino"

	"https://www.tumblr.com/oauth/edit/XXXXXX"

	"OAuth Consumer Key: XXXXXX
	(Consumer) Secret Key: XXXXXX
	Token XXXXXX
Token Secret XXXXXX"

	"Use your OAuth Consumer Key as your api_key"

	"About Tumblr OAuth
Tumblr supports OAuth 1.0a, accepting parameters via the Authorization header, with the HMAC-SHA1 signature method only. There's probably already an OAuth client library for your platform.

If you've worked with Twitter's OAuth implementation, you'll feel right at home with ours.
Request-token URL:
POST https://www.tumblr.com/oauth/request_token
Authorize URL:
https://www.tumblr.com/oauth/authorize
Access-token URL:
POST https://www.tumblr.com/oauth/access_token
Rate Limits
Newly registered consumers are rate limited to 1,000 requests per hour, and 5,000 requests per day. If your application requires more requests for either of these periods, please use the 'Request rate limit removal' link on an app above."

	
]
