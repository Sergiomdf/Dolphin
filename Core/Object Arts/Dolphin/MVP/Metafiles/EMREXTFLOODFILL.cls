"Filed out from Dolphin Smalltalk X6.1"!

ENHMETARECORD subclass: #EMREXTFLOODFILL
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
EMREXTFLOODFILL guid: (GUID fromString: '{BD14CA2B-D9CD-4146-AD72-D15F18031A50}')!
EMREXTFLOODFILL comment: '<EMREXTFLOODFILL> is an <ExternalStructure> class to wrap the struct ''Win32.EMREXTFLOODFILL'' from type information in the ''Win32 API (ANSI). Derived from Bruce McKinney�s Hardcore Visual Basic Type Library'' library.

The type library contains no documentation for this struct

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef [uuid(BD14CA2B-D9CD-4146-AD72-D15F18031A50)]
struct tagEMREXTFLOODFILL {
	EMR EMR;
	POINTL ptlStart;
	COLORREF crColor;
	DWORD iMode;
} EMREXTFLOODFILL;
'!
!EMREXTFLOODFILL categoriesForClass!Win32-Structs! !
!EMREXTFLOODFILL methodsFor!

crColor
	"Answer the receiver's crColor field as a Smalltalk object."

	^bytes dwordAtOffset: ##(self offsetOf: #crColor)!

crColor: anObject 
	"Set the receiver's crColor field to the value of anObject."

	bytes dwordAtOffset: ##(self offsetOf: #crColor) put: anObject!

iMode
	"Answer the receiver's iMode field as a Smalltalk object."

	^bytes dwordAtOffset: ##(self offsetOf: #iMode)!

iMode: anObject 
	"Set the receiver's iMode field to the value of anObject."

	bytes dwordAtOffset: ##(self offsetOf: #iMode) put: anObject!

ptlStart
	"Answer the receiver's ptlStart field as a Smalltalk object."

	^POINTL fromAddress: bytes yourAddress + ##(self offsetOf: #ptlStart)!

ptlStart: anObject 
	"Set the receiver's ptlStart field to the value of anObject."

	anObject 
		replaceBytesOf: bytes
		from: ##((self offsetOf: #ptlStart) + 1)
		to: ##((self offsetOf: #ptlStart) + POINTL basicByteSize)
		startingAt: 1! !
!EMREXTFLOODFILL categoriesFor: #crColor!**compiled accessors**!public! !
!EMREXTFLOODFILL categoriesFor: #crColor:!**compiled accessors**!public! !
!EMREXTFLOODFILL categoriesFor: #iMode!**compiled accessors**!public! !
!EMREXTFLOODFILL categoriesFor: #iMode:!**compiled accessors**!public! !
!EMREXTFLOODFILL categoriesFor: #ptlStart!**compiled accessors**!public! !
!EMREXTFLOODFILL categoriesFor: #ptlStart:!**compiled accessors**!public! !

!EMREXTFLOODFILL class methodsFor!

defineFields
	"Define the fields of the EMREXTFLOODFILL structure.

	EMREXTFLOODFILL  compileDefinition

		typedef [uuid(BD14CA2B-D9CD-4146-AD72-D15F18031A50)]
		struct tagEMREXTFLOODFILL {
			EMR EMR;
			POINTL ptlStart;
			COLORREF crColor;
			DWORD iMode;
		} EMREXTFLOODFILL;
"

	super defineFields.
	self
		defineField: #ptlStart type: (StructureField type: POINTL) offset: 8;
		defineField: #crColor type: DWORDField new offset: 16;
		defineField: #iMode type: DWORDField new offset: 20.
	self byteSize: 24!

iTypes
	"Answer the integer enhanced metafile record type id for this record class."

	^Array with: EMR_EXTFLOODFILL! !
!EMREXTFLOODFILL class categoriesFor: #defineFields!**auto generated**!initializing!public! !
!EMREXTFLOODFILL class categoriesFor: #iTypes!constants!public! !

