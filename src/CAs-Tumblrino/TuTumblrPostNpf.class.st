Class {
	#name : #TuTumblrPostNpf,
	#superclass : #TuTumblrObject,
	#instVars : [
		'media',
		'blogId',
		'content'
	],
	#category : #'CAs-Tumblrino-Core'
}

{ #category : #'as yet unclassified' }
TuTumblrPostNpf >> blogId [

	^ blogId ifEmpty: [ blogId:=json at: #blog at: #uuid].
]

{ #category : #'as yet unclassified' }
TuTumblrPostNpf >> blogId:anId [

	blogId:=anId 
]

{ #category : #accessing }
TuTumblrPostNpf >> content [

	^ content
]

{ #category : #initialization }
TuTumblrPostNpf >> initialize [
super initialize .
	content := Dictionary new
]

{ #category : #accessing }
TuTumblrPostNpf >> isLoaded [
 
	^ self content isEmpty not
]

{ #category : #initialization }
TuTumblrPostNpf >> load [

	json:=TuTumblrClient default
		getPost: '735400205192675328'
		from: 'henk-heijmans'.self  parseJson 
]

{ #category : #accessing }
TuTumblrPostNpf >> media [
^media
]

{ #category : #initialization }
TuTumblrPostNpf >> parseJson [

	
	super parseJson.
	content := json at: #content
	"tags := self content.
	tags isDictionary ifTrue: [ tags := Array with: tags ].
	media := tags collect: [ :each | TuTumblrImage from: each ]"
]
