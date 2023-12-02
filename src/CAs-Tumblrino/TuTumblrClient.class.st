Class {
	#name : #TuTumblrClient,
	#superclass : #Object,
	#instVars : [
		'oauth1Service',
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

	self deprecated: 'no data stored here. not used'.
	^ '
	Consumer Key XXXXXX
Consumer Secret XXXXXX
Token XXXXXX
Token Secret XXXXXX
	'
]

{ #category : #accessing }
TuTumblrClient class >> keys [

	| lines keys parts val key str |
"	str:= self keyString."
	str:= self readKeys.
	lines := str lines collect: #trim thenReject: #isEmpty.
	keys := Dictionary new.
	lines do: [ :each | 
		parts := ' ' split: each.
		val := parts last.
		key := ' ' join: parts allButLast.
		keys at: key put: val ].
	^ keys
]

{ #category : #accessing }
TuTumblrClient class >> readKeys [


	| fname str |
	fname := 'D:\Temp\tumblr\Tumblr_API.txt'.
	str := fname asFileReference contents.
	^ str
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

{ #category : #OAuth1 }
TuTumblrClient >> accToken [
	"self halt."

	^ ZnOAuth1Token new
		value: (self class keys at: 'Token');
		secret: (self class keys at: 'Token Secret')
	"Token XXXXXXXX
Token Secret XXXXXXXX"
]

{ #category : #accessing }
TuTumblrClient >> api [

	^ ZnUrl fromString: 'https://api.tumblr.com'
]

{ #category : #accessing }
TuTumblrClient >> apiKey [
	^ self consumerKey
]

{ #category : #accessing }
TuTumblrClient >> apiV2 [

	^ self api/'v2'
]

{ #category : #actions }
TuTumblrClient >> blogInfo [


	^ self blogInfo: 'henk-heijmans'
]

{ #category : #actions }
TuTumblrClient >> blogInfo: aBlogID [

	| url json blog |
	url := self apiV2/ 'blog' / aBlogID / 'info'.
	json := self getUrl: url.
	blog := json at: 'blog'.
	blog := TuTumblrBlog from: (json at: #blog).
	^ blog
]

{ #category : #OAuth1 }
TuTumblrClient >> consumerData [

	^ consData ifNil: [ 
		  consData := ZnOAuth1ConsumerData new
			              getRequestTokenUrl:
				              'https://www.tumblr.com/oauth/request_token';
			              authorizeTokenUrl:
				              'https://www.tumblr.com/oauth/authorize';
			              getAccessTokenUrl:
				              'https://www.tumblr.com/oauth/access_token';
			              consumer: self consumerKey;
			              consumerSecret: self consumerSecret  ]
]

{ #category : #accessing }
TuTumblrClient >> consumerKey [

	^ self class keys at: 'Consumer Key'
]

{ #category : #accessing }
TuTumblrClient >> consumerSecret [

	^ self class keys at: 'Consumer Secret'
]

{ #category : #actions }
TuTumblrClient >> getPost: postID from: blogID [

	| url json |
	url := self apiV2 / 'blog' / blogID / #posts / postID ? ('npf' -> true).
	json := self getUrl: url.
	^ json
]

{ #category : #OAuth1 }
TuTumblrClient >> getTokenFromCallbackUrl: aUrl [
	| ver |
	ver := aUrl asUrl query at: 'oauth_verifier'.
	^ ver
]

{ #category : #actions }
TuTumblrClient >> getUrl: aUrl [
	| response json |
	response := (self service httpGet: aUrl using: self accToken)
		asString.
	json := NeoJSONReader fromString: response.
	((json at: #meta) at: #status) ~= 200
		ifTrue: [ Error signal: 'Failed' ].
	^ json at: #response
]

{ #category : #actions }
TuTumblrClient >> likes [

	| likeNo url json liked all likedPost |
	likeNo := self userInfo likes.
	all := OrderedCollection new.
	"0 to: likeNo by: 20 do: [ :i | ""Transcript crShow: i printString , '*'.""
		url := self api / 'user' / 'likes' ? ('npf' -> true)
		       & (#limit -> 20) & (#offset -> i printString)."
	url := self apiV2 / 'user' / 'likes' ? ('npf' -> true)
	       & (#limit -> 20).
	[ 
	json := self getUrl: url.
	liked := json at: #liked_posts.self halt.
	liked do: [ :like | 
		likedPost := TuTumblrPostNpf from: like.
		all add: likedPost ].
	(json at: #_links) at: #next ifPresent: [ :next | 
		url
			queryRemoveAll;
			queryAddAll: (next at: #query_params) ] ] doWhileTrue: [ 
		(json at: #_links) includesKey: #next ].

	^ all
]

{ #category : #actions }
TuTumblrClient >> postUrl: aUrl [
	| response json |
	response := (self service
		httpPost: aUrl
		with: nil
		using: self accToken) asString.
	json := NeoJSONReader fromString: response.
	((json at: #meta) at: #status) ~= 200
		ifTrue: [ Error signal: 'Failed' ].
	^ json at: #response
]

{ #category : #OAuth1 }
TuTumblrClient >> service [
	^ oauth1Service
		ifNil: [ oauth1Service := ZnOAuth1Service new
				providerAccount: self consumerData;
				yourself ]
]

{ #category : #actions }
TuTumblrClient >> unlike: aPost [

	| url |
	url := self apiV2 / 'user/unlike'.
	url := url ? ('id' -> aPost id) & ('reblog_key' -> aPost reblog_key).
	self postUrl: url.
	^ self
]

{ #category : #actions }
TuTumblrClient >> userInfo [

	| url json user |
	url := self apiV2 / 'user/info'.
	json := self getUrl: url.
	user := TuTumblrUser from: (json at: #user).
	^ user
]
