"Filed out from Dolphin Smalltalk X6"!

IDispatch subclass: #IVBSAXDTDHandler
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'MSXMLConstants'
	classInstanceVariableNames: ''!
IVBSAXDTDHandler guid: (IID fromString: '{24FB3297-302D-4620-BA39-3A732D850558}')!
IVBSAXDTDHandler comment: '<IVBSAXDTDHandler> is a wrapper class for the COM interface ''MSXML2.IVBSAXDTDHandler'' generated from type information in the ''Microsoft XML, v4.0'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains the following helpstring for this interface
	"IVBSAXDTDHandler interface"

Warning: This comment was automatically generated from the interface''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

[
	object, 
	uuid(24FB3297-302D-4620-BA39-3A732D850558), 
	helpstring("IVBSAXDTDHandler interface"), 
	dual, 
	nonextensible
]
interface IVBSAXDTDHandler : IDispatch
 {
	[id(0x00000537), helpstring("Receive notification of a notation declaration event.")]
	HRESULT __stdcall notationDecl(
		[in, out]BSTR* strName,
		[in, out]BSTR* strPublicId,
		[in, out]BSTR* strSystemId);
	[id(0x00000538), helpstring("Receive notification of an unparsed entity declaration event.")]
	HRESULT __stdcall unparsedEntityDecl(
		[in, out]BSTR* strName,
		[in, out]BSTR* strPublicId,
		[in, out]BSTR* strSystemId,
		[in, out]BSTR* strNotationName);
};
'!
!IVBSAXDTDHandler categoriesForClass!COM-Interfaces!MSXML2-Interfaces! !
!IVBSAXDTDHandler methodsFor!

isExtensible
	"Answer whether the receiver may add methods at run-time."

	^false!

isVBCollection
	"Answer whether the receiver is a VB style collection."

	^false!

notationDecl: strName strPublicId: strPublicId strSystemId: strSystemId
	"Invoke the notationDecl() method of the COM object.
	Helpstring: Receive notification of a notation declaration event."

	| answer |
	answer := (Array new: 3)
				basicAt: 1 put: strName asBSTR;
				basicAt: 2 put: strPublicId asBSTR;
				basicAt: 3 put: strSystemId asBSTR;
				yourself.
	self
		NotationDecl: (answer basicAt: 1)
		strPublicId: (answer basicAt: 2)
		strSystemId: (answer basicAt: 3).
	^answer collect: [:each | each asObject]
!

NotationDecl: strName strPublicId: strPublicId strSystemId: strSystemId
	"Private - Invoke the notationDecl() method of the COM object.
	Helpstring: Receive notification of a notation declaration event.

		HRESULT __stdcall notationDecl(
			[in, out]BSTR* strName,
			[in, out]BSTR* strPublicId,
			[in, out]BSTR* strSystemId);"

	<virtual stdcall: hresult 8 bstr* bstr* bstr*>
	^self invalidCall!

unparsedEntityDecl: strName strPublicId: strPublicId strSystemId: strSystemId strNotationName: strNotationName
	"Invoke the unparsedEntityDecl() method of the COM object.
	Helpstring: Receive notification of an unparsed entity declaration event."

	| answer |
	answer := (Array new: 4)
				basicAt: 1 put: strName asBSTR;
				basicAt: 2 put: strPublicId asBSTR;
				basicAt: 3 put: strSystemId asBSTR;
				basicAt: 4 put: strNotationName asBSTR;
				yourself.
	self
		UnparsedEntityDecl: (answer basicAt: 1)
		strPublicId: (answer basicAt: 2)
		strSystemId: (answer basicAt: 3)
		strNotationName: (answer basicAt: 4).
	^answer collect: [:each | each asObject]
!

UnparsedEntityDecl: strName strPublicId: strPublicId strSystemId: strSystemId strNotationName: strNotationName
	"Private - Invoke the unparsedEntityDecl() method of the COM object.
	Helpstring: Receive notification of an unparsed entity declaration event.

		HRESULT __stdcall unparsedEntityDecl(
			[in, out]BSTR* strName,
			[in, out]BSTR* strPublicId,
			[in, out]BSTR* strSystemId,
			[in, out]BSTR* strNotationName);"

	<virtual stdcall: hresult 9 bstr* bstr* bstr* bstr*>
	^self invalidCall! !
!IVBSAXDTDHandler categoriesFor: #isExtensible!**auto generated**!public!testing! !
!IVBSAXDTDHandler categoriesFor: #isVBCollection!**auto generated**!public!testing! !
!IVBSAXDTDHandler categoriesFor: #notationDecl:strPublicId:strSystemId:!**auto generated**!methods!public! !
!IVBSAXDTDHandler categoriesFor: #NotationDecl:strPublicId:strSystemId:!**auto generated**!COM Interfaces-IVBSAXDTDHandler!private! !
!IVBSAXDTDHandler categoriesFor: #unparsedEntityDecl:strPublicId:strSystemId:strNotationName:!**auto generated**!methods!public! !
!IVBSAXDTDHandler categoriesFor: #UnparsedEntityDecl:strPublicId:strSystemId:strNotationName:!**auto generated**!COM Interfaces-IVBSAXDTDHandler!private! !

!IVBSAXDTDHandler class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'MSXML2.IVBSAXDTDHandler'
		IVBSAXDTDHandler defineTemplate"

	self
		defineFunction: #NotationDecl:strPublicId:strSystemId:
			argumentTypes: 'bstr* bstr* bstr*';
		defineFunction: #UnparsedEntityDecl:strPublicId:strSystemId:strNotationName:
			argumentTypes: 'bstr* bstr* bstr* bstr*'
! !
!IVBSAXDTDHandler class categoriesFor: #defineFunctions!**auto generated**!initializing!public! !

