"Filed out from Dolphin Smalltalk 7"!

DolphinCollectionTest subclass: #SetTest
	instanceVariableNames: 'primes'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SetTest guid: (GUID fromString: '{2108692A-0EE3-46EA-A9D6-46B3227871C6}')!
SetTest comment: ''!
!SetTest categoriesForClass!Unclassified! !
!SetTest methodsFor!

assertCommutativelyEqual: aSet other: anotherSet
	self assert: aSet equals: anotherSet.
	self assert: anotherSet equals: aSet!

assertIs: copySet shallowCopyOf: sourceSet 
	self assert: copySet ~~ sourceSet.
	self assert: copySet size == sourceSet size.
	sourceSet asArray with: copySet asArray
		do: [:eachSource :eachCopy | self assert: eachSource == eachCopy]!

assertValidSet: aSet 
	| any |
	any := aSet collect: [:each | each].
	any do: [:each | self assert: (aSet includes: each)]!

collectionClass
	^Set!

denyCommutativelyEqual: aSet other: anotherSet
	self deny: aSet = anotherSet.
	self deny: anotherSet = aSet!

elements
	^#(1 'a' #a)!

loadFactor
	^2.0 / 3!

minimumCapacity
	^5!

newEmpty
	^self collectionClass new!

newSet
	| elements |
	elements := self elements.
	^self newSet: elements!

newSet: elements
	| set |
	set := self newEmpty.
	elements do: 
			[:each |
			set add: each.
			self assert: (set includes: each)].
	^set!

setUp
	primes := Integer primesUpTo: 8192 * 2!

testClassSizeFor
	"The capacity algorithm should be a prime that allows for at least 1.5x the size requested. Minimum capacity is 5."

	| actualSlots previousPrime |
	1 to: 1024
		do: 
			[:size |
			| expectedSlots |
			expectedSlots := size / self loadFactor.
			actualSlots := self collectionClass sizeFor: size.
			self assert: expectedSlots <= actualSlots.
			self assert: (primes includes: actualSlots).
			expectedSlots >= self minimumCapacity
				ifTrue: 
					[previousPrime := primes at: (primes indexOf: actualSlots) - 1.
					self assert: previousPrime < expectedSlots]]!

testCopy
	"A copy of a set should be a shallow copy. i.e. it shares the same elements, but is not itself the same object"

	| set copy |
	set := self newSet.
	copy := set copy.
	self assertIs: copy shallowCopyOf: set.
	self assertValidSet: copy!

testDeepCopy
	"#2066"

	| set copy |
	set := self newSet.
	5 timesRepeat: [set add: Object new].
	set shrink.
	set do: [:each | self assert: (set includes: each)].
	copy := set deepCopy.
	self assertIs: copy deepCopyOf: set.
	self assertValidSet: copy!

testEquals
	"Sets and IdentitySets are equal if they have the same elements"

	| set setb |
	set := self newSet.
	"Identical"
	self assert: set equals: set.
	setb := self newSet.
	"Equal"
	self assertCommutativelyEqual: setb other: set.
	setb := setb asIdentitySet.
	self assertCommutativelyEqual: setb other: set.
	"Extra object in one set - not equal"
	setb add: Object new.
	self denyCommutativelyEqual: setb other: set.
	"Same size, but differ by one element"
	setb remove: self elements last.
	self denyCommutativelyEqual: setb other: set.
	"Sets are never equals to arrays"
	self denyCommutativelyEqual: set other: self elements.
	"Empty sets"
	setb := self newEmpty.
	self assert: setb equals: setb.
	self denyCommutativelyEqual: setb other: set.
	"Two empty sets are equal"
	set := self newEmpty.
	self assertCommutativelyEqual: set other: setb.
	"Elements are compared with #=; Integer 1 is equal to Float 1.0"
	set := self newSet: #(1).
	setb := self newSet: #(1.0).
	self assertCommutativelyEqual: set other: setb!

testIncludes
	| set elements |
	set := self newSet.
	elements := self elements.
	elements do: [:each | self assert: (set includes: each)].
	self deny: (set includes: elements second hash).
	self deny: (set includes: nil)!

testMaintainsLoadFactor
	"Verify that slop is maintained as items are added to the Set and it is grown."

	| subject expectedSlots |
	subject := self collectionClass new.
	self assert: 0 equals: subject size.
	self assert: self minimumCapacity equals: subject basicSize.
	expectedSlots := self minimumCapacity.
	(1 to: 1024) keysAndValuesDo: 
			[:expectedSize :each |
			| minimumSlots actualSlots actualSize originalSlots slop minGrownSlots |
			minimumSlots := expectedSize / self loadFactor.
			originalSlots := subject basicSize.
			subject add: each.
			actualSize := subject size.
			actualSlots := subject basicSize.
			self assert: actualSlots >= minimumSlots.
			slop := actualSlots - actualSize.
			self assert: slop > (actualSlots - (actualSlots * self loadFactor)).
			"If growth is needed, should grow to at least double the capacity"
			minGrownSlots := (expectedSize - 1) * 2 / self loadFactor.
			originalSlots < minimumSlots ceiling
				ifTrue: [expectedSlots := primes detect: [:p | p >= minGrownSlots]].
			self assert: expectedSize equals: actualSize.
			self assert: expectedSlots equals: actualSlots]!

testNil
	| set |
	set := self newEmpty.
	self shouldnt: [set add: nil] raise: Error!

testRemove
	| set elements |
	set := self newSet.
	elements := self elements.
	self should: [set remove: elements second hash] raise: NotFoundError.
	self assert: (set remove: elements second) == elements second.
	self should: [set remove: elements second] raise: NotFoundError!

testShallowCopy
	| set copy |
	set := self newSet.
	copy := set shallowCopy.
	self assertIs: copy shallowCopyOf: set.
	self assertValidSet: copy! !
!SetTest categoriesFor: #assertCommutativelyEqual:other:!helpers!private! !
!SetTest categoriesFor: #assertIs:shallowCopyOf:!private!unit tests! !
!SetTest categoriesFor: #assertValidSet:!private!unit tests! !
!SetTest categoriesFor: #collectionClass!helpers!private! !
!SetTest categoriesFor: #denyCommutativelyEqual:other:!helpers!private! !
!SetTest categoriesFor: #elements!public!unit tests! !
!SetTest categoriesFor: #loadFactor!constants!private! !
!SetTest categoriesFor: #minimumCapacity!constants!private! !
!SetTest categoriesFor: #newEmpty!helpers!private! !
!SetTest categoriesFor: #newSet!private!unit tests! !
!SetTest categoriesFor: #newSet:!private!unit tests! !
!SetTest categoriesFor: #setUp!public!Running! !
!SetTest categoriesFor: #testClassSizeFor!public!unit tests! !
!SetTest categoriesFor: #testCopy!public!unit tests! !
!SetTest categoriesFor: #testDeepCopy!public!unit tests! !
!SetTest categoriesFor: #testEquals!public!unit tests! !
!SetTest categoriesFor: #testIncludes!public!unit tests! !
!SetTest categoriesFor: #testMaintainsLoadFactor!public!unit tests! !
!SetTest categoriesFor: #testNil!public!unit tests! !
!SetTest categoriesFor: #testRemove!public!unit tests! !
!SetTest categoriesFor: #testShallowCopy!public!unit tests! !

