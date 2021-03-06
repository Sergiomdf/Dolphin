"Filed out from Dolphin Smalltalk 7"!

RefactoringTest subclass: #RenameMethodTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
RenameMethodTest guid: (GUID fromString: '{56462B45-7329-483D-AFC5-F1C199753156}')!
RenameMethodTest comment: ''!
!RenameMethodTest categoriesForClass!Refactory-Testing! !
!RenameMethodTest methodsFor!

testExistingSelector
	self shouldFail: (RenameMethodRefactoring 
				renameMethod: #checkClass:
				in: BasicLintRuleTest
				to: #runOnEnvironment:
				permutation: (1 to: 1))!

testMultipleSelectors
	self shouldWarn: (RenameMethodRefactoring 
				renameMethod: #checkClass:
				in: BasicLintRuleTest
				to: #foo:
				permutation: (1 to: 1))!

testRenamePermuteArgs
	| refactoring class |
	refactoring := RenameMethodRefactoring 
				renameMethod: ('rename:' , 'two:') asSymbol
				in: RefactoryTestDataApp
				to: ('rename:' , 'two:') asSymbol
				permutation: #(2 1).
	self executeRefactoring: refactoring.
	class := refactoring model classNamed: #RefactoryTestDataApp.
	self 
		assert: (class parseTreeFor: ('rename:' , 'two:') asSymbol) = (RBParser 
						parseMethod: 'rename: argumentMethod two: this ^self printString, this, argumentMethod').
	self assert: (class parseTreeFor: #exampleCall) 
				= (RBParser parseMethod: 'exampleCall ^self rename: 2 two: 1')!

testRenamePrimitive
	| refactoring count |
	count := 0.
	model allReferencesTo: #basicAt:put: do: [:method | count := count + 1].
	refactoring := RenameMethodRefactoring 
				model: model
				renameMethod: #basicAt:put:
				in: Object
				to: ('at:' , 'bar:') asSymbol
				permutation: (1 to: 2).
	self proceedThroughWarning: [self executeRefactoring: refactoring].
	model allReferencesTo: #basicAt:put:
		do: 
			[:method | 
			count := count - 1.
			self assert: method source isNil].
	model allReferencesTo: ('at:' , 'bar:') asSymbol do: [:method | count := count - 1].
	self assert: count = 0!

testRenameTestMethod
	| refactoring class |
	refactoring := RenameMethodRefactoring 
				renameMethod: ('rename' , 'ThisMethod:') asSymbol
				in: RefactoryTestDataApp
				to: #renameThisMethod2:
				permutation: (1 to: 1).
	self executeRefactoring: refactoring.
	class := refactoring model classNamed: #RefactoryTestDataApp.
	self assert: (class parseTreeFor: #renameThisMethod2:) 
				= (RBParser parseMethod: 'renameThisMethod2: anArg
	^self').
	self assert: (class parseTreeFor: #callMethod) 
				= (RBParser parseMethod: 'callMethod
	^(self renameThisMethod2: 5)').
	self 
		assert: (class parseTreeFor: #symbolReference) = (RBParser 
						parseMethod: 'symbolReference
		^ #(#renameThisMethod2: #(4 #renameThisMethod2:))').
	self deny: (class directlyDefinesMethod: ('rename' , 'ThisMethod:') asSymbol)!

testRenameTestMethod1
	| refactoring class |
	refactoring := RenameMethodRefactoring 
				renameMethod: ('test' , 'Method1') asSymbol
				in: RefactoryTestDataApp
				to: #testMethod2
				permutation: (1 to: 0).
	self executeRefactoring: refactoring.
	class := refactoring model classNamed: #RefactoryTestDataApp.
	self 
		assert: (class parseTreeFor: #testMethod2) = (RBParser 
						parseMethod: 'testMethod2
	^self testMethod2 , ([:each | each testMethod2] value: #(#(#testMethod2) 2 #testMethod2))').
	self 
		assert: ((refactoring model classNamed: #BasicLintRuleTest) parseTreeFor: #classBlock:) 
				= (RBParser parseMethod: 'classBlock: aBlock
	classBlock := aBlock testMethod2').
	self deny: (class directlyDefinesMethod: ('test' , 'Method1') asSymbol)! !
!RenameMethodTest categoriesFor: #testExistingSelector!failure tests!public! !
!RenameMethodTest categoriesFor: #testMultipleSelectors!failure tests!public! !
!RenameMethodTest categoriesFor: #testRenamePermuteArgs!public!tests! !
!RenameMethodTest categoriesFor: #testRenamePrimitive!public!tests! !
!RenameMethodTest categoriesFor: #testRenameTestMethod!public!tests! !
!RenameMethodTest categoriesFor: #testRenameTestMethod1!public!tests! !

