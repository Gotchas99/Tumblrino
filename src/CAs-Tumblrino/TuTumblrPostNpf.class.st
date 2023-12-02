Class {
	#name : #TuTumblrPostNpf,
	#superclass : #TuTumblrObject,
	#instVars : [
		'blogId',
		'content'
	],
	#category : #'CAs-Tumblrino-Core'
}

{ #category : #accessing }
TuTumblrPostNpf >> blogId [

	^ blogId ifEmpty: [ blogId:=json at: #blog at: #uuid].
]

{ #category : #accessing }
TuTumblrPostNpf >> blogId:anId [

	blogId:=anId 
]

{ #category : #accessing }
TuTumblrPostNpf >> content [

	^ content
]

{ #category : #initialization }
TuTumblrPostNpf >> initialize [

	super initialize.
	content := OrderedCollection  new
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

{ #category : #initialization }
TuTumblrPostNpf >> parseJson [

	super parseJson.
	content := json at: #content.
	self blogId: (json at: #tumblelog_uuid).
	content := (json at: #content) collect: [ :each | 
		           TuTumblrContent from: each ]
]

{ #category : #accessing }
TuTumblrPostNpf >> summary [

	^ json at: #summary
]

{ #category : #accessing }
TuTumblrPostNpf >> tags [
^json at:#tags
]
