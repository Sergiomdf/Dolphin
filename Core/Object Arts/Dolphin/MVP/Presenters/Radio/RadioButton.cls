"Filed out from Dolphin Smalltalk X6"!

CheckButton subclass: #RadioButton
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
RadioButton guid: (GUID fromString: '{87B4C73B-026E-11D3-9FD7-00A0CC3E4A32}')!
RadioButton comment: 'RadioButton is a <valueView> implementing the Windows "BUTTON" class in a BS_AUTORADIOBUTTON style. The <valueModel> associated with a RadioButton must always yield a <boolean> value once mapped through the installed type converter. RadioButtons will normally be used in a group in conjunction with a <RadioButtonSetPresenter>.

Windows'' standard behaviour for radio buttons is that a among a group of such buttons under the same parent only a single button may be selected at any time (hence the ''radio'' button designation, a reference to old-fashioned radios that used such controls for selection between the different frequence bands, etc). RadioButton itself does not implement this behaviour; although Windows will ensure that only one radio button (with the style BS_AUTORADIOBUTTON) within a parent is selected at any one time, the deselected radio button receives no event to notify it of the change. Therefore we rely on a ''grouping'' presenter to ensure that the models of a group of radio buttons are consistent. <RadioButtonSetPresenter> is one such presenter that performs this task and implements the standard behaviour.
'!
!RadioButton categoriesForClass!MVP-Views! !
!RadioButton methodsFor!

basicWindowStyle
	^BS_AUTORADIOBUTTON! !
!RadioButton categoriesFor: #basicWindowStyle!constants!private! !

!RadioButton class methodsFor!

icon
	"Answers an Icon that can be used to represent this class"

	^##(self) defaultIcon! !
!RadioButton class categoriesFor: #icon!constants!public! !

