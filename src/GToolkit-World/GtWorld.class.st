Class {
	#name : #GtWorld,
	#superclass : #BlSpace,
	#classInstVars : [
		'defaultId'
	],
	#category : #'GToolkit-World-UI'
}

{ #category : #'instance creation' }
GtWorld class >> buildWithShutdownListener [
	| aSpace |
	aSpace := GtWorld new.
	aSpace title: 'Glamorous Toolkit'.
	aSpace extent: (800*1.6)@800.
	aSpace addEventHandler: BlSpaceShutdownOnCloseListener new.
	^ aSpace
]

{ #category : #accessing }
GtWorld class >> defaultId [
	^ defaultId
]

{ #category : #accessing }
GtWorld class >> defaultId: anId [
	"Set the id of the default space opened initially."
	defaultId := anId
]

{ #category : #'class initialization' }
GtWorld class >> initialize [
	"Register the handler to execute after the default priority that reads preferences."
	SessionManager default
		register: (ClassSessionHandler forClassNamed: self name)
		inCategory: SessionManager default guiCategory  
		atPriority: SessionManager default defaultPriority + 1
]

{ #category : #'class initialization' }
GtWorld class >> notifyDefaultInstance [
	self defaultId ifNil: [ ^ self ].
 	self
		spaceWithId: self defaultId 
		do: [ :aSpace | 
			aSpace enqueueTask: (BlTaskAction new action: [ 
				aSpace refreshContent ]) ] 
]

{ #category : #'instance creation' }
GtWorld class >> open [
	<script: 'self open'>
	| aSpace |
	
	aSpace := GtWorld new.
	aSpace title: 'Glamorous Toolkit'.
	aSpace show
]

{ #category : #'instance creation' }
GtWorld class >> openDefault [
	"Open an instance with shutdown handlers and mark it as default."
	<script: 'self openDefault'>
	| aSpace |
	aSpace := self buildWithShutdownListener.
	aSpace markAsDefault.
	aSpace prepareForRelease.
	aSpace show.
	^ aSpace
]

{ #category : #'instance creation' }
GtWorld class >> openWithShutdownListener [
	<script: 'self openWithShutdownListener'>
	| aSpace |
	aSpace := self buildWithShutdownListener.
	aSpace show.
	^ aSpace
]

{ #category : #'instance creation' }
GtWorld class >> openWithSpaces: aCollectionOfSpaces [
	| aSpace |

	aSpace := GtWorld new.
	aSpace title: 'Glamorous Toolkit'.

	aCollectionOfSpaces do: [ :eachSpace |
		aSpace root showSpace: eachSpace ].

	aSpace show
]

{ #category : #'class initialization' }
GtWorld class >> startUp: resuming [
	"Implement an update mechanism to update the saved world on open."
	resuming
		ifFalse: [ ^ self ]. 
	self notifyDefaultInstance.
]

{ #category : #initialization }
GtWorld >> defaultRoot [
	^ GtWorldElement new
]

{ #category : #actions }
GtWorld >> markAsDefault [
	"Mark this instance as being the one that is saved and automatically opened when
	the image is opened. This instance will refresh it's content on start-up."
	self class defaultId: self id
]

{ #category : #actions }
GtWorld >> prepareForRelease [
	"Prepare this space to be saved as part of the release process."
	self root prepareForRelease
]

{ #category : #actions }
GtWorld >> refreshContent [
	"Refresh the content of the space. Is only called for the default instance on start-up."
	self root refreshContent
]
