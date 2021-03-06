"Filed out from Dolphin Smalltalk 7"!

Object subclass: #SmalllintContext
	instanceVariableNames: 'class selector parseTree literals literalSemaphore literalProcess selectors compiledMethod selfMessages superMessages messages'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SmalllintContext guid: (GUID fromString: '{3CC8C7DB-8970-4652-BFF7-519CDA9CA376}')!
SmalllintContext comment: ''!
!SmalllintContext categoriesForClass!Refactory-Lint! !
!SmalllintContext methodsFor!

addImplementationSpecificLiterals
	#rbFix.	"Dolphin's VM references symbols"
	VMLibrary default registry do: [:each | each isSymbol ifTrue: [literals add: each]]!

buildParseTree
	| tree |
	tree := self selectedClass parseTreeFor: self selector.
	tree isNil ifTrue: [^RBParser parseMethod: 'method'].
	^tree!

checkLiteral: aLiteral 
	aLiteral isSymbol 
		ifTrue: 
			[literals add: aLiteral.
			^self].
	#rbFix.	"In Dolphin X6 and later class refs are stored as constants in the literal frame, rather than variable bindings."
	aLiteral isBehavior 
		ifTrue: 
			[literals add: aLiteral.
			^self].
	aLiteral isVariableBinding 
		ifTrue: 
			[#rbFix.	"An optimization - because we only need to know of literal refs to variables that ref classes, we can
				ignore all other variables. This also avoids the cached literals collection preventing the GC of objects
				referenced from class variables, etc."
			aLiteral value isBehavior ifTrue: [literals add: aLiteral value]]
		ifFalse: [aLiteral class == Array ifTrue: [aLiteral do: [:each | self checkLiteral: each]]]!

compiledMethod
	^compiledMethod notNil
		ifTrue: [compiledMethod]
		ifFalse: [compiledMethod := class compiledMethodAt: selector]!

computeLiterals
	literalSemaphore := Semaphore new.
	literalProcess := [self primitiveComputeLiterals] forkAt: Processor userBackgroundPriority!

computeLiteralsForClass: aClass 
	#rbFix.	"Optimize"
	aClass methodDictionary keysAndValuesDo: 
			[:eachSelector :eachMethod | 
			selectors add: eachSelector.
			eachMethod allLiteralsDo: [:literal | self checkLiteral: literal]]!

computeMessages
	| searcher |
	selfMessages := Set new.
	superMessages := Set new.
	messages := Set new.
	searcher := ParseTreeSearcher new.
	searcher
		matches: 'self `@message: ``@args'
			do: [:aNode :answer | selfMessages add: aNode selector];
		matches: 'super `@message: ``@args'
			do: [:aNode :answer | superMessages add: aNode selector];
		matches: '``@receiver `@message: ``@args'
			do: [:aNode :answer | messages add: aNode selector].
	searcher executeTree: self parseTree initialAnswer: nil!

implements: aSelector 
	^self selectors includes: aSelector!

initialize
	self computeLiterals!

instVarNames
	^self selectedClass allInstVarNames!

isAbstract: aClass 
	^(aClass isMeta 
		or: [(self literals includes: aClass name) or: [self literals includes: aClass]]) not!

lintProtocols
	^self selectedClass whichCategoriesIncludeSelector: self selector!

literals
	literalSemaphore isNil
		ifTrue: 
			[literals isNil ifTrue: 
					[self computeLiterals.
					literalSemaphore wait]]
		ifFalse: [literalSemaphore wait].
	^literals

!

messages
	messages isNil ifTrue: [self computeMessages].
	^messages!

parseTree
	^parseTree isNil
		ifTrue: [parseTree := self buildParseTree]
		ifFalse: [parseTree]!

primitiveComputeLiterals
	"Dolphin's view resources may reference symbols, and so may the VM"

	| semaphore |
	literals := IdentitySet new: 25000.
	literals addAll: self specialSelectors.
	selectors := IdentitySet new: 20000.
	Smalltalk allBehaviorsDo: [:aClass | self computeLiteralsForClass: aClass].
	#rbFix.	"Provide a hook to add extra literals from sources that depend on the host Smalltalk."
	self addImplementationSpecificLiterals.
	semaphore := literalSemaphore.
	literalSemaphore := nil.
	self signalProcesses: semaphore.
	^literalProcess := nil!

protocol
	#rbFix.	"Dolphin support multiple categories for each method"
	^self protocols asSortedCollection first!

protocols
	#rbFix.	"Added"
	^self lintProtocols!

release
	literalProcess notNil ifTrue: [literalProcess terminate].
	super release!

selectedClass
	^class!

selectedClass: anObject 
	class := anObject.
	self selector: nil!

selector
	^selector!

selector: anObject 
	selector := anObject.
	parseTree := compiledMethod := selfMessages := superMessages := messages := nil!

selectors
	literalSemaphore isNil
		ifTrue: 
			[selectors isNil ifTrue: 
					[self computeLiterals.
					literalSemaphore wait]]
		ifFalse: [literalSemaphore wait].
	^selectors!

selfMessages
	selfMessages isNil ifTrue: [self computeMessages].
	^selfMessages!

signalProcesses: aSemaphore 
	aSemaphore isNil ifTrue: [^self].
	[aSemaphore isEmpty] whileFalse: [aSemaphore signal]!

specialSelectors
	#rbFix.
"	^(OpcodePool at: #SpecialSelectorDictionary) keys"
	^VMLibrary default specialSelectors
!

superMessages
	superMessages isNil ifTrue: [self computeMessages].
	^superMessages!

uses: anObject 
	^self literals includes: anObject! !
!SmalllintContext categoriesFor: #addImplementationSpecificLiterals!private! !
!SmalllintContext categoriesFor: #buildParseTree!helpers!private! !
!SmalllintContext categoriesFor: #checkLiteral:!helpers!private! !
!SmalllintContext categoriesFor: #compiledMethod!accessing!public! !
!SmalllintContext categoriesFor: #computeLiterals!helpers!private! !
!SmalllintContext categoriesFor: #computeLiteralsForClass:!helpers!private! !
!SmalllintContext categoriesFor: #computeMessages!helpers!private! !
!SmalllintContext categoriesFor: #implements:!public!testing! !
!SmalllintContext categoriesFor: #initialize!initialize/release!public! !
!SmalllintContext categoriesFor: #instVarNames!accessing!public! !
!SmalllintContext categoriesFor: #isAbstract:!public!testing! !
!SmalllintContext categoriesFor: #lintProtocols!accessing!public! !
!SmalllintContext categoriesFor: #literals!accessing!public! !
!SmalllintContext categoriesFor: #messages!accessing!public! !
!SmalllintContext categoriesFor: #parseTree!accessing!public! !
!SmalllintContext categoriesFor: #primitiveComputeLiterals!helpers!private! !
!SmalllintContext categoriesFor: #protocol!accessing!public! !
!SmalllintContext categoriesFor: #protocols!accessing!public! !
!SmalllintContext categoriesFor: #release!initialize/release!public! !
!SmalllintContext categoriesFor: #selectedClass!accessing!public! !
!SmalllintContext categoriesFor: #selectedClass:!accessing!public! !
!SmalllintContext categoriesFor: #selector!accessing!public! !
!SmalllintContext categoriesFor: #selector:!accessing!public! !
!SmalllintContext categoriesFor: #selectors!accessing!public! !
!SmalllintContext categoriesFor: #selfMessages!accessing!public! !
!SmalllintContext categoriesFor: #signalProcesses:!helpers!private! !
!SmalllintContext categoriesFor: #specialSelectors!helpers!private! !
!SmalllintContext categoriesFor: #superMessages!accessing!public! !
!SmalllintContext categoriesFor: #uses:!public!testing! !

!SmalllintContext class methodsFor!

new
	^(super new)
		initialize;
		yourself!

newNoCache
	^self basicNew! !
!SmalllintContext class categoriesFor: #new!instance creation!public! !
!SmalllintContext class categoriesFor: #newNoCache!instance creation!public! !

