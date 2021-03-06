"Filed out from Dolphin Smalltalk X6"!

IEnumUnknown subclass: #IEnumMoniker
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
IEnumMoniker guid: (IID fromString: '{00000102-0000-0000-C000-000000000046}')!
IEnumMoniker comment: '<IEnumMoniker> is a wrapper class for the custom interface ''OBJIDL.IEnumMoniker'' generated from type information in the ''ObjIDL Library'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface.

WARNING: This comment was automatically generated from the interface''s type information and any changes made here may be overwritten the next time this wrapper class is so generated.'!
!IEnumMoniker categoriesForClass!COM-Interfaces! !
!IEnumMoniker class methodsFor!

defineFunctions
	"Declare the virtual function table for the receiver.
		self defineTemplate
	"

	"This method only present to prevent auto-generation from a type library"!

elementClass
	"Answer the class of element enumerated by the receiver."

	^IMoniker! !
!IEnumMoniker class categoriesFor: #defineFunctions!initializing!public! !
!IEnumMoniker class categoriesFor: #elementClass!constants!public! !

