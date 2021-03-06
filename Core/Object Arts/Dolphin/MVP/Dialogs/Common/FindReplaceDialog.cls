"Filed out from Dolphin Smalltalk X6"!

FindDialog subclass: #FindReplaceDialog
	instanceVariableNames: 'replaceWith'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
FindReplaceDialog guid: (GUID fromString: '{87B4C6B7-026E-11D3-9FD7-00A0CC3E4A32}')!
FindReplaceDialog comment: 'FindReplaceDialog is a <valueDialogPresenter> implementing the Windows ReplaceText common dialog. The dialog must be associated with an owner view capable of responding to the <textFinder> protocol. It will then remain on-screen until dismissed and will forward <FindEvent>s to the owner via its #onFind: event handler. 

Instance Variables:
	replaceWith	<readableString> specifying the replacement text.

'!
!FindReplaceDialog categoriesForClass!MVP-Presenters! !
!FindReplaceDialog methodsFor!

basicShowModal
	"Private - Create and show a new FindReplace dialog."

	^ComDlgLibrary default replaceText: self winStruct asParameter
!

initialize
	"Private - Initialize the state of the receiver."

	super initialize.
	replaceWith := String new: 256.!

prepareStruct
	"Private - Initialize the parameter structure to be passed to the Win32
	API associated with this common dialog, immediately prior to the call
	to that API."

	(self winStruct)
		maskIn: FR_DOWN;
		lpstrFindWhat: self findWhat;
		wFindWhatLen: self findWhat size;
		lpstrReplaceWith: self replaceWith;
		wReplaceWithLen: self replaceWith size!

replaceWith
	"Private - Answer the receievrs replceWith String."

	^replaceWith!

replaceWith: aString
	"Private - Set the receivers replaceWith String to include aString."

	| size |
	size := self replaceWith size min: aString size.
	self replaceWith replaceFrom: 1 to: size with: aString.! !
!FindReplaceDialog categoriesFor: #basicShowModal!private!realizing/unrealizing! !
!FindReplaceDialog categoriesFor: #initialize!initializing!private! !
!FindReplaceDialog categoriesFor: #prepareStruct!helpers!private! !
!FindReplaceDialog categoriesFor: #replaceWith!accessing!private! !
!FindReplaceDialog categoriesFor: #replaceWith:!accessing!private! !

!FindReplaceDialog class methodsFor!

initialize
	"Private - Initialize the receiver's class variables.
		self initialize
	"

	self initializeDefaultHooks!

ownerView: aView findWhat: find replaceWith: replace
	"Create and show a new instance of the receiver with with a aView as the owner."

	^self new
		ownerView: aView;
		findWhat: find;
		replaceWith: replace;
		showModal;
		yourself! !
!FindReplaceDialog class categoriesFor: #initialize!initializing!private! !
!FindReplaceDialog class categoriesFor: #ownerView:findWhat:replaceWith:!constants!instance creation!public! !

