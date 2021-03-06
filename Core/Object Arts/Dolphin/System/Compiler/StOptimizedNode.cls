"Filed out from Dolphin Smalltalk X6.1"!

StValueNode subclass: #StOptimizedNode
	instanceVariableNames: 'left right body value methodClass source'
	classVariableNames: 'UnevaluatedCookie'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
StOptimizedNode guid: (GUID fromString: '{D6CA95FA-6DEC-4CED-8780-C36C6450314F}')!
StOptimizedNode comment: 'StOptimizedNode is an parse tree node that represents ##(...) expressions. These expressions are evaluated at compile time and directly inserted into the method.

Instance Variables:
	body	<StSequenceNode> the body of the expression
	left	<Integer>	position of the ##( characters
	right	<Integer>	position of )

'!
!StOptimizedNode categoriesForClass!System-Compiler! !
!StOptimizedNode methodsFor!

= anObject 
	self == anObject ifTrue: [^true].
	self class = anObject class ifFalse: [^false].
	^self body = anObject body!

acceptVisitor: aProgramNodeVisitor 
	^aProgramNodeVisitor acceptOptimizedNode: self!

arguments
	^#()!

body
	^body!

body: stmtsNode 
	body := stmtsNode.
	body parent: self!

childrenDo: aMonadicValuable 
	aMonadicValuable value: body!

equalTo: anObject withMapping: aDictionary 
	^self class = anObject class 
		and: [self body equalTo: anObject body withMapping: aDictionary]!

evaluateStatements
	| s |
	methodClass isNil ifTrue: [^nil].
	^self source 
		ifNotNil: 
			[:s | 
			Compiler 
				evaluate: (s copyFrom: body start to: body stop)
				for: methodClass instanceClass
				logged: false]!

hash
	^self body hash!

initialize
	value := UnevaluatedCookie!

isImmediateNode
	^true!

left: leftInteger body: aSequenceNode right: rightInteger 
	left := leftInteger.
	self body: aSequenceNode.
	right := rightInteger!

methodClass
	^methodClass!

methodClass: anObject
	methodClass := anObject!

needsParenthesis
	^false!

precedence
	^0!

source
	^source ifNil: [super source]!

source: anObject
	source := anObject!

startWithoutParentheses
	^left!

stopWithoutParentheses
	^right!

value
	"Lazily evaluate the expression if the value is required"

	value == UnevaluatedCookie ifTrue: [value := self evaluateStatements].
	^value!

value: anObject
	value := anObject! !
!StOptimizedNode categoriesFor: #=!comparing!public! !
!StOptimizedNode categoriesFor: #acceptVisitor:!public!visitor! !
!StOptimizedNode categoriesFor: #arguments!accessing!public! !
!StOptimizedNode categoriesFor: #body!accessing!public! !
!StOptimizedNode categoriesFor: #body:!accessing!public! !
!StOptimizedNode categoriesFor: #childrenDo:!accessing!public! !
!StOptimizedNode categoriesFor: #equalTo:withMapping:!comparing!public! !
!StOptimizedNode categoriesFor: #evaluateStatements!helpers!private! !
!StOptimizedNode categoriesFor: #hash!comparing!public! !
!StOptimizedNode categoriesFor: #initialize!public! !
!StOptimizedNode categoriesFor: #isImmediateNode!public!testing! !
!StOptimizedNode categoriesFor: #left:body:right:!initializing!public! !
!StOptimizedNode categoriesFor: #methodClass!accessing!private! !
!StOptimizedNode categoriesFor: #methodClass:!accessing!private! !
!StOptimizedNode categoriesFor: #needsParenthesis!public!testing! !
!StOptimizedNode categoriesFor: #precedence!accessing!public! !
!StOptimizedNode categoriesFor: #source!accessing!public! !
!StOptimizedNode categoriesFor: #source:!accessing!private! !
!StOptimizedNode categoriesFor: #startWithoutParentheses!accessing!public! !
!StOptimizedNode categoriesFor: #stopWithoutParentheses!accessing!public! !
!StOptimizedNode categoriesFor: #value!accessing!public! !
!StOptimizedNode categoriesFor: #value:!accessing!public! !

!StOptimizedNode class methodsFor!

body: aSequenceNode 
	^self new body: aSequenceNode!

initialize
	UnevaluatedCookie := Object new!

left: leftInteger body: aSequenceNode right: rightInteger 
	^(self new)
		left: leftInteger
			body: aSequenceNode
			right: rightInteger;
		yourself!

new
	^super new initialize! !
!StOptimizedNode class categoriesFor: #body:!instance creation!public! !
!StOptimizedNode class categoriesFor: #initialize!public! !
!StOptimizedNode class categoriesFor: #left:body:right:!instance creation!public! !
!StOptimizedNode class categoriesFor: #new!instance creation!public! !

