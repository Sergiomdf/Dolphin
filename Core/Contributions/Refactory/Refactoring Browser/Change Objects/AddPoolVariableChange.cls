"Filed out from Dolphin Smalltalk 2002 release 5.00"!

RefactoryVariableChange subclass: #AddPoolVariableChange
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
AddPoolVariableChange guid: (GUID fromString: '{48291CA4-180F-4A5E-B79E-409203E18930}')!
AddPoolVariableChange comment: ''!
!AddPoolVariableChange categoriesForClass!Refactory-Change Objects! !
!AddPoolVariableChange methodsFor!

asUndoOperation
	^RemovePoolVariableChange remove: variable from: self changeClass!

changeObject
	| dictionary |
	dictionary := variable isString 
				ifTrue: [Smalltalk at: variable asSymbol]
				ifFalse: [variable].
	^dictionary!

changesFileTemplate
	^'<1p> <2s> <3s>'!

changeString
	^'Add pool variable named, <1s>, from <2s>' 
		expandMacrosWith: self variable
		with: self displayClassName!

changeSymbol
	^#addSharedPool:!

printOn: aStream 
	aStream
		nextPutAll: self displayClassName;
		nextPutAll: ' addSharedPool: ';
		nextPutAll: self variable;
		nextPut: $!!!

variable
	^variable isString 
		ifTrue: [variable]
		ifFalse: 
			[Smalltalk keyAtValue: variable ifAbsent: [self error: 'Cannot find value']]! !
!AddPoolVariableChange categoriesFor: #asUndoOperation!converting!public! !
!AddPoolVariableChange categoriesFor: #changeObject!private! !
!AddPoolVariableChange categoriesFor: #changesFileTemplate!constants!private! !
!AddPoolVariableChange categoriesFor: #changeString!printing!public! !
!AddPoolVariableChange categoriesFor: #changeSymbol!private! !
!AddPoolVariableChange categoriesFor: #printOn:!printing!public! !
!AddPoolVariableChange categoriesFor: #variable!private! !

