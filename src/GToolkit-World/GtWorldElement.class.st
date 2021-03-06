Class {
	#name : #GtWorldElement,
	#superclass : #BlElement,
	#instVars : [
		'spotterDropdown',
		'subSpaceDropdown',
		'tabs',
		'home'
	],
	#classVars : [
		'WorldSpotterSize'
	],
	#category : #'GToolkit-World-UI'
}

{ #category : #accessing }
GtWorldElement class >> worldSpotterSize [
	^ WorldSpotterSize ifNil: [ WorldSpotterSize := 640@480 ]
]

{ #category : #accessing }
GtWorldElement class >> worldSpotterSize: aPoint [
	WorldSpotterSize := aPoint
]

{ #category : #'instance creation' }
GtWorldElement >> home [
	^ home
]

{ #category : #initialization }
GtWorldElement >> initialize [
	super initialize.
	tabs := BrTabGroup new.
	tabs look: BrGlamorousSpaceTabGroupLook new.
	tabs actionbarStencil: [ self newActionbar ].
	home := GtHome new.
	tabs
		addTab:
			(BrTab new
				vExact: 36;
				look: BrGlamorousSpaceTabWithIconLook;
				icon: BrGlamorousVectorIcons gt;
				label: 'Home';
				stencil: [ home ]).
	self
		addShortcut:
			(BlShortcut new
				repeatable: false;
				combination: BlKeyCombination shiftReturn;
				action: [ spotterDropdown
						ifNotNil: [ spotterDropdown
								dispatchEvent:
									(BrDropdownShowWish new
										anchor: spotterDropdown;
										yourself) ] ]).
	self
		addShortcut:
			(BlShortcut new
				repeatable: false;
				combination: BlKeyCombination primaryT;
				action: [ subSpaceDropdown
						ifNotNil: [ subSpaceDropdown
								dispatchEvent:
									(BrDropdownShowWish new
										anchor: subSpaceDropdown;
										yourself) ] ]).
	self
		when: GtSpawnSpotter
		do: [ :e | 
			e consumed: true.
			spotterDropdown
				ifNotNil: [ spotterDropdown
						dispatchEvent:
							(BrDropdownShowWish new
								anchor: spotterDropdown;
								yourself) ] ].
	self addChild: tabs.
	self
		constraintsDo: [ :c | 
			c horizontal matchParent.
			c vertical matchParent ]
]

{ #category : #'private - instance creation' }
GtWorldElement >> newActionbar [
	| anActionbar |

	anActionbar := BrToolbar new.
	anActionbar look: BrGlamorousToolbarLook new.
	anActionbar addItem: self newSpotterButton.
	anActionbar addItem: self newSubSpaceButton.

	^ anActionbar
]

{ #category : #initialization }
GtWorldElement >> newSpotterButton [
	self 
		assert: [ spotterDropdown isNil ]
		description: [ 'Spotter dropdown is already created!' ].
	
	spotterDropdown :=  GtSpotterDropdownButtonStencil new
		tooltip: 'Search';
		extent: self class worldSpotterSize;
		spotterElementDo: [ :aSpotterElement |
			aSpotterElement 
				when: GtSpotterResizedEvent 
				do: [ :e | self class worldSpotterSize: e target size ] ];
		asElement.
	spotterDropdown look - BrGlamorousButtonExteriorLook.
		
	^ spotterDropdown
]

{ #category : #initialization }
GtWorldElement >> newSubSpaceButton [
	self
		assert: [ subSpaceDropdown isNil ]
		description: [ 'Sub-space dropdown is already created!' ].
	subSpaceDropdown := BrButton new
		look:
			BrGlamorousButtonWithIconLook - BrGlamorousButtonExteriorLook
				+
					(BrGlamorousWithDropdownLook
						handle: [ BrButton new
								look:
									BrGlamorousButtonWithIconLook - BrGlamorousButtonWithLabelTooltipLook
										- BrGlamorousButtonExteriorLook;
								icon: BrGlamorousIcons hamburger;
								label: 'Menu';
								yourself ]
						content: [ GtToolsMenu new
								constraintsDo: [ :c | 
									c vertical fitContent.
									c horizontal exact: 420 ];
								yourself ]);
		icon: BrGlamorousIcons hamburger;
		label: 'Menu';
		yourself.
	^ subSpaceDropdown
]

{ #category : #initialization }
GtWorldElement >> onAddedToSceneGraph [
	super onAddedToSceneGraph.

	SystemAnnouncer uniqueInstance weak
		when: ClassAnnouncement
		send: #update:
		to: self home. 

	SystemAnnouncer uniqueInstance weak
		when: MethodAnnouncement
		send: #update:
		to: self home. 
]

{ #category : #initialization }
GtWorldElement >> onRemovedFromSceneGraph [
	super onRemovedFromSceneGraph.
	SystemAnnouncer uniqueInstance unsubscribe: self home
]

{ #category : #updating }
GtWorldElement >> prepareForRelease [
	home prepareForRelease
]

{ #category : #updating }
GtWorldElement >> refreshContent [
	"Refresh all notifications in the home screen."
	home refreshNotifications
]

{ #category : #'api - opening' }
GtWorldElement >> showSpace: aSpace [
	self showSpace: aSpace select: true
]

{ #category : #accessing }
GtWorldElement >> showSpace: aSpace select: shouldBeSelected [
	| aTab |
	aTab := (BrTab new
		vExact: 36;
		model: aSpace;
		look: BrGlamorousSpaceTabWithLabelLook new;
		label: aSpace title;
		stencil: [ :aTabModel |
			| anActualSpace |
			anActualSpace := aTabModel model.
			anActualSpace root hasParent
				ifTrue: [ anActualSpace root removeFromParent ]
				ifFalse: [ anActualSpace root dispatchRemovedFromSceneGraph ].
			self enqueueTask: (GtWorldReEnqueueTasks new
				previousSpace: anActualSpace).
			anActualSpace root
				constraintsDo: [ :c |
					c horizontal matchParent.
					c vertical matchParent ] ];
		actionbarStencil: [ :aTabModel |			
			BrToolbar new
				look: (BrGlamorousToolbarLook new spacing: 0);
				margin: (BlInsets left: 6);
				addItems: {
					BrButton new
						icon: BrGlamorousIcons maximize;
						exact: 16@16;
						opacity: 0.5;
						look: GtWorldTabToolbarButtonLook;
						model: aTabModel;
						label: 'Open in a new window';
						action: [ :aButtonElement |
							tabs viewModel removeTab: aButtonElement model.
							GtWorld openWithSpaces: { aButtonElement model model } ].
					BrButton new
						icon: BrGlamorousVectorIcons close;
						exact: 16@16;
						opacity: 0.5;
						look: GtWorldTabToolbarButtonLook;
						label: 'Close';
						model: aTabModel;
						action: [ :aButtonElement |
							tabs viewModel removeTab: aButtonElement model ] } ]).
	
	aTab selected: shouldBeSelected.
	tabs addTab: aTab
]

{ #category : #'children accessing' }
GtWorldElement >> topMostParent [
	^ self
]
