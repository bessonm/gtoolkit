Class {
	#name : #GtToolsMenu,
	#superclass : #BlElement,
	#classInstVars : [
		'world',
		'morphicWorld'
	],
	#category : #'GToolkit-World'
}

{ #category : #'system startup' }
GtToolsMenu class >> cleanUp [
	<script: 'self cleanUp'>

	world ifNotNil: [
		world isOpened
			ifTrue: [ world close ].
		world := nil ].

	morphicWorld ifNotNil: [
		morphicWorld isOpened
			ifTrue: [ morphicWorld close ].
		morphicWorld := nil ]
]

{ #category : #'instance creation' }
GtToolsMenu class >> create [
	| aSpace |
	
	aSpace := BlSpace new.
	aSpace title: 'Glamorous Toolkit'.
	aSpace addChild: self new.
	aSpace extent: 260@500.
	^ aSpace
]

{ #category : #'instance creation' }
GtToolsMenu class >> createMorphicWorld [
	| aSpace |

	aSpace := BlSpace new.
	aSpace title: 'Morph World'.
	aSpace extent: 1280@800.
	aSpace root: BlMorphicWorldEmbeddingElement new beMain.
	^ aSpace
]

{ #category : #'instance creation' }
GtToolsMenu class >> open [
	<script: 'self open'>

	(world isNotNil and: [ world isOpened ])
		ifTrue: [ world close ].

	world := self create.

	world isOpened
		ifFalse: [ world show ]
]

{ #category : #'api - tools' }
GtToolsMenu class >> openMorphicWorld [
	<script: 'self openMorphicWorld'>

	morphicWorld
		ifNotNil: [ morphicWorld isOpened
			ifTrue: [ morphicWorld close ] ].

	morphicWorld
		ifNil: [ morphicWorld := self createMorphicWorld ].

	morphicWorld isOpened
		ifFalse: [ morphicWorld show ]
]

{ #category : #initialization }
GtToolsMenu >> initialize [
	super initialize.
	
	self layout: BlLinearLayout vertical.
	self constraintsDo: [ :c |
		c horizontal matchParent.
		c vertical matchParent ].
	self padding: (BlInsets top: 10 bottom: 10).
	self initializeElements
]

{ #category : #initialization }
GtToolsMenu >> initializeElements [

	self removeChildren.
	
	self addChild: (BrButton new
		look: BrGlamorousButtonWithLabelLook new;
		label: 'Tour';
		hMatchParent;
		margin: (BlInsets top: 5 left: 20 bottom: 5 right: 20);
		action: [ self openTour ]).
	
	self addChild: (BrButton new
		look: BrGlamorousButtonWithLabelLook new;
		label: 'Playground';
		hMatchParent;
		margin: (BlInsets top: 5 left: 20 bottom: 5 right: 20);
		action: [ self openPlayground ]).
			
	self addChild: (BrButton new
		look: BrGlamorousButtonWithLabelLook new;
		label: 'Coder';
		hMatchParent;
		margin: (BlInsets top: 5 left: 20 bottom: 5 right: 20);
		action: [ self openCoder ]).
	
	self addChild: (BrButton new
		look: BrGlamorousButtonWithLabelLook new;
		label: 'Transcript';
		hMatchParent;
		margin: (BlInsets top: 5 left: 20 bottom: 5 right: 20);
		action: [ self openTranscript ]).
		
	self addChild: (BrButton new
		look: BrGlamorousButtonWithLabelLook new;
		label: 'Examples';
		hMatchParent;
		margin: (BlInsets top: 5 left: 20 bottom: 5 right: 20);
		action: [ self openExamples ]).
	
	self addChild: (BrButton new
		look: BrGlamorousButtonWithLabelLook new;
		label: 'Monitor';
		hMatchParent;
		margin: (BlInsets top: 5 left: 20 bottom: 5 right: 20);
		action: [ self openMonitor ]).
		
	self addChild: (BrButton new
		look: BrGlamorousButtonWithLabelLook new;
		label: 'Morphic World';
		hMatchParent;
		margin: (BlInsets top: 5 left: 20 bottom: 5 right: 20);
		action: [ self class openMorphicWorld ]).

	self addChild: (BrButton new
		look: BrGlamorousButtonWithLabelLook new;
		label: 'Documentation';
		hMatchParent;
		margin: (BlInsets top: 25 left: 20 bottom: 5 right: 20);
		action: [ self openBaseline ]).
	self addChild: (BrButton new
		look: BrGlamorousButtonWithLabelLook new;
		label: 'Tour';
		hMatchParent;
		margin: (BlInsets top: 5 left: 20 bottom: 5 right: 20);
		action: [ self openTour ]).
	self addChild: (BrButton new
		look: BrGlamorousButtonWithLabelLook new;
		label: 'Pharo 101';
		hMatchParent;
		margin: (BlInsets top: 5 left: 20 bottom: 5 right: 20);
		action: [ self openPharo101 ]).

		
	self addChild: (BlElement new
		layout: (BlLinearLayout horizontal cellSpacing: 10);
		margin: (BlInsets top: 25 left: 10 bottom: 5 right: 10);
		constraintsDo: [ :c |
			c horizontal matchParent.
			c vertical fitContent ];
		addChildren: {
			BrButton new
				look: BrGlamorousButtonWithLabelLook new;
				label: 'Save';
				hMatchParent;
				action: [ Smalltalk snapshot: true andQuit: false ].
				
			BrButton new
				look: (BrGlamorousButtonWithLabelLook new);
				label: 'Quit';
				hMatchParent;
				action: [ Smalltalk snapshot: false andQuit: true ] })
]

{ #category : #'hooks - children' }
GtToolsMenu >> onAddedToSceneGraph [
	super onAddedToSceneGraph.
	
	self initializeElements
]

{ #category : #'api - tools' }
GtToolsMenu >> openBaseline [
	<script: 'self new openBaseline'>
	| inspector aSpace |
			
	inspector := GtInspector createOnPlayBook: (GtDocument forClass: BaselineOfGToolkit).

	aSpace := BlSpace new.
	aSpace title: 'GT Tour'.
	aSpace extent: 1200@600.
	aSpace addChild: inspector.
	aSpace withHalos.
	
	self showSpace: aSpace
]

{ #category : #'api - tools' }
GtToolsMenu >> openCoder [
	<script: 'self new openCoder'>
	| aSpace |

	aSpace := BlSpace new.
	aSpace title: 'Coder'.
	aSpace extent: 1200@600.
	aSpace addChild: GtCoderStencil new create.
	aSpace withHalos.
	
	self showSpace: aSpace
]

{ #category : #'api - tools' }
GtToolsMenu >> openExamples [
	<script: 'self new openExamples'>
	| anExamplesExplorer aSpace |
			
	anExamplesExplorer := GtInspector createOn: GtRlGToolkitExamplesExplorer buildForGToolkitProject.

	aSpace := BlSpace new.
	aSpace title: 'Examples'.
	aSpace extent: 1200@600.
	aSpace addChild: anExamplesExplorer.
	aSpace withHalos.
	
	self showSpace: aSpace
]

{ #category : #'api - tools' }
GtToolsMenu >> openMonitor [
	<script: 'self openMonitor'>
	| aBlocSpacesMonitor aSpace |
			
	aBlocSpacesMonitor := GtInspector createOn: GtMonitoredBlocSpaces new.

	aSpace := BlSpace new.
	aSpace title: 'Monitor'.
	aSpace extent: 1200@600.
	aSpace addChild: aBlocSpacesMonitor.
	aSpace withHalos.
	
	self showSpace: aSpace
]

{ #category : #'api - tools' }
GtToolsMenu >> openPharo101 [
	<script: 'self new openPharo101'>
	| aBlocSpacesMonitor aSpace |
			
	aBlocSpacesMonitor := GtPharo101 new create asElement.

	aSpace := BlSpace new.
	aSpace title: 'Pharo 101'.
	aSpace extent: 1200@600.
	aSpace addChild: aBlocSpacesMonitor.
	aSpace withHalos.
	
	self showSpace: aSpace
]

{ #category : #'api - tools' }
GtToolsMenu >> openPlayground [
	<script: 'self openPlayground'>
	| aPlayground aSpace |

	aPlayground := GtInspector createOnPlayBook: GtPlayBook newDefault.

	aSpace := BlSpace new.
	aSpace title: 'Playground'.
	aSpace extent: 1200@600.
	aSpace addChild: aPlayground.
	aSpace withHalos.
	
	self showSpace: aSpace
]

{ #category : #'api - tools' }
GtToolsMenu >> openTour [
	<script: 'self new openTour'>
	| tour aSpace |
			
	tour := GtTour new create asElement.

	aSpace := BlSpace new.
	aSpace title: 'GT Tour'.
	aSpace extent: 1200@600.
	aSpace addChild: tour.
	aSpace withHalos.
	
	self showSpace: aSpace
]

{ #category : #'api - tools' }
GtToolsMenu >> openTranscript [
	<script: 'self new openTranscript'>
	| aTranscriptElement aSpace |

	aTranscriptElement :=  GtTranscript default asElement.

	aSpace := BlSpace new.
	aSpace title: 'Transcript'.
	aSpace extent: 400@600.
	aSpace addChild: aTranscriptElement.
	aSpace withHalos.

	self showSpace: aSpace
]