"Filed out from Dolphin Smalltalk X6.1"!

OLECountedArray subclass: #CADWORD
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
CADWORD guid: (GUID fromString: '{60F684DC-B3E2-4700-8E9C-D1A18764ED84}')!
CADWORD comment: '<CADWORD> is an <ExternalStructure> class to wrap the struct ''OCIDL.CADWORD'' from type information in the ''OCIDL Library'' library.

CADWORD is a counted array of 32-bit unsigned integers. For an example usage see IPerPropertyBrowsing.'!
!CADWORD categoriesForClass!OCIDL-Structs! !
!CADWORD methodsFor!

getElements
	^DWORDArray fromAddress: self pElems length: self cElems! !
!CADWORD categoriesFor: #getElements!accessing!private! !

!CADWORD class methodsFor!

defineFields
	"Define the fields of the CADWORD structure.
		CADWORD compileDefinition
	
		typedef 		struct tagCADWORD {
			unsigned long cElems;
			unsigned long* pElems;
		} CADWORD;

	"

	"Nothing more to add to superclass template"
	super defineFields.

!

elementClass
	"Answer the class of <ExternalStructure> used to represent elements of the receiver."

	^DWORD
! !
!CADWORD class categoriesFor: #defineFields!initializing!public! !
!CADWORD class categoriesFor: #elementClass!constants!public! !

