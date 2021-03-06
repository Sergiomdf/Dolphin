"Filed out from Dolphin Smalltalk X6.1"!

AXTypeInfoObject subclass: #AXTypeInfoAnalyzer
	instanceVariableNames: 'typeLib globalBinding guid index basicName'
	classVariableNames: 'TypeKindToClassMap VTtoIDLTypeMap'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
AXTypeInfoAnalyzer guid: (GUID fromString: '{C06F3B64-0868-11D3-93AF-00A024CA708A}')!
AXTypeInfoAnalyzer comment: 'AXTypeInfoAnalyzer is a class which wraps an Active-X Automation <ITypeInfo> interface pointer and adds higher level behaviours for analyzing the type information available through that interface.

ITypeInfo itself contains a large number of member functions which allow one to enquire about the structure and attributes of each of the individual elements of a Type Library. Unfortunately it is rather poorly factored in that a single interface is used to describe widely differing objects. We have therefore applied the "Conditional Elimination" refactoring pattern and created a pseudo hierarchy as follows:

- TYPEKIND_ENUM			TKindEnumAnalyzer		an enumerated type
- TYPEKIND_RECORD		TKindRecordAnalyzer	a C-style struct
- TYPEKIND_MODULE		TKindModule			a shared library/DLL of static functions and constants
- TYPEKIND_INTERFACE	TKindInterfaceAnalyzer	a custom COM interface
- TYPEKIND_DISPATCH		TKindDispatchAnalyzer	an Active-X Automation interface
- TYPEKIND_COCLASS		TKindCoclassAnalyzer	an instantiable component class with a CLSID
- TYPEKIND_ALIAS			TKindAliasAnalyzer		a C-style typedef which defines a name for a type
- TYPEKIND_UNION			TKindUnionAnalyzer		a C-style union (struct with overlapping members)

Each subclass contains specific behaviours appropriate for querying relevant information for its particular type kind, and also for generating Smalltalk wrappers for that type.

Instance Variables:
	typeLib 			<AXTypeLibraryAnalyzer>. Owning type library.
	globalBinding	<Association>. The global binding being generated, usually a Class.
	guid			<GUID>. Unique id of type.
	index			<integer> index of the type in the typelib.
	basicName		<readableString> name of the type from the typelib.'!
!AXTypeInfoAnalyzer categoriesForClass!ActiveX Automation! !
!AXTypeInfoAnalyzer methodsFor!

= comparand
	"Answer whether the receiver and the <Object>, comparand, 
	are considered equivalent.
	Implementation Note: Two type analyzers are considered equivalent
	if they have the same GUID, or if they are the same indexed item
	from the same type library (not all type infos have a guid)."

	^self == comparand or: [
		comparand class == self class and: [
			comparand guid = self guid and: [
				self guid notNull or:  [
					comparand typeLib = self typeLib and: [comparand index = self index]]]]]!

asImplType
	"Answer the actual implementing type for the receiver (some are pseuds!!)"

	^self!

baseClass
	"Private - Answer the Dolphin class used to represent superclass of the receiver."

	^self subclassResponsibility.!

basicName
	"Private - Answer a <readableString> name for the receiver, retrieved directly
	from the documentation in the type library."

	basicName isNil ifTrue: [basicName := self nameOfID: MEMBERID_NIL].
	^basicName!

classDesc
	"Private - Answer an <association> between a Dolphin class suitable for representing
	the external type described by the receiver, and the number of indirections
	to the type."

	^(VARIANT classForVT: self vt) -> 0!

constants
	"Answer <sequencedReadableCollection> of VARDESCs describing the 
	member variables of the receiver's structure (assumes it is a structure -
	if it isn't the collection will be empty)."

	^self variables select: [:each | each isSymbolicConstant]!

displayOn: aStream
	"Append the receiver to aStream in a format that a user would want to see"

	aStream nextPutAll: self name!

documentation
	"Answer an <AXTypeLibDocumentation> object containing the documentation for this type."

	^self tlbInterface documentationForMember: MEMBERID_NIL!

environment
	"Answer the namespace into which global representing the receiver type will be/has been generated."

	^self typeLib environment!

fullyQualifiedName
	"Private - Answer the unique name for the receiver (assuming its library name is unique)
	according to the informal COM naming convention."

	^self typeLib name, '.', self name.
!

funcDescAt: subscript 
	"Private - Answer a FUNCDESC for the function in the receiver at the 
	specified one-based <integer> index, subscript."

	^(self tlbInterface funcDescAt: subscript)
		analyzer: self;
		yourself!

functions
	"Answer a <sequencedReadableCollection> of FUNCDESC structures describing the
	methods in the receiver (assumes it is an interface). If the receiver is not of a TYPEKIND
	which holds functions, then the resulting collection will be empty."

	^(1 to: self attributes cFuncs) collect: [:i | self funcDescAt: i]!

functionsByName
	"Answer a <LookupTable> of FUNCDESC structures keyed by function name describing the methods
	in the receiver (assumes it is an interface). If the receiver is not of a TYPEKIND which
	holds functions, then the resulting collection will be empty."

	| answer |
	answer := LookupTable new.
	self functions do: [:each | answer add: each name -> each].
	^answer!

getImplTypeInfoAt: subscript 
	"Answer an <AXInterfaceTypeInfo> describing the interface with the one-based <integer> 
	index, subscript, in the receiver - this will be an implemented interface in the case of a 
	coclass, or an inherited interface in the case of an interface. The index 0 is used as a 
	special case to access the dual interface associated with a dispinterface, if any."

	| implType |
	implType := self class onTypeInfo: (self tlbInterface getImplTypeInfoAt: subscript).
	self assert: [implType == implType asImplType].
	^implType!

getNamesOfMember: memid count: cMaxNames 
	"Private - Answer an array containing the names of the member of the
	receiver identified by the <MEMBERID>, memid."

	^self tlbInterface getNamesOfMember: memid count: cMaxNames!

getRefType: href 
	"Private - Retrieve another ITypeInfo referenced by the receiver as the HREFTYPE, href.
	Implementation Note: Attempts to resolve to the actual implementation type."

	^(self class onTypeInfo: (self tlbInterface getRefTypeInfo: href)) asImplType!

global
	"Answer the global object the receiver has generated/would generate.
	N.B. This will cause the global to be generated, if it hasn't been already!!"

	| binding global |
	binding := self globalBinding.
	(global := binding value) isNil 
		ifTrue: [global := self generateGlobalDefinition: binding key].
	^global!

globalBinding
	"Private - Answer the global binding (or the proposed global binding) for the receiver.
	Notes: 
	1) The global binding is not saved down until actually generated as we want
	to keep in step with any changes in the class library prefix.
	2) If we find that the global binding is outdated (i.e. the global no longer exists), then 
	we must reset."

	globalBinding notNil 
		ifTrue: 
			["Find or clear (if removed) the current binding"

			self globalBinding: (self environment associationAt: globalBinding key
						ifAbsent: [])].
	^globalBinding ifNil: [self suggestedBinding]!

globalBinding: anAssociationOrNil
	globalBinding := anAssociationOrNil!

globalName: globName 
	"Private - Set the global name to be used for the receiver when generated."

	self globalBinding: (self environment associationAt: globName
				ifAbsent: [globName -> nil])!

guid
	"Answer the guid associated with the receiver."

	guid isNil ifTrue: [guid := super guid].
	^guid!

hash
	"Answer the <integer> hash value for the receiver."

	^self guid hash!

idOfName: name ifAbsent: exceptionHandler 
	"Answer the <integer> DISPID of the member named by the <readableString>
	argument, name, in the receiver."

	^self tlbInterface idOfName: name ifAbsent: exceptionHandler!

index
	"Private - Answer the receiver's one-based integer index within its owning type library."

	^index!

isDispatchable
	"Answer whether the receiver is derived directly or indirectly from IDispatch."

	^self attributes isDispatchable

!

isDual
	"Answer whether the receiver is a dual interface."

	^false

!

isGlobalDefined
	"Answer whether a global has already been defined for the receiver."

	^self globalBinding value notNil!

isHidden
	"Answer whether the receiver is describing a type which should
	not be displayed in type library browsers.
	Applicable to all typekinds."

	^self tlbInterface isHidden!

isInstalled
	"Answer whether the receiver has been generated into a class in this image"

	^self isGlobalDefined and: [ | glob |
		glob := self global.
		glob methodDictionary notEmpty or: [glob class methodDictionary notEmpty]]!

isUnion
	"Answer whether the receiver describes a union."

	^false!

nameOfID: memid
	"Answer a <readableString> name for the member of the 
	receiver identified by the <MEMBERID>, memid. Note that this
	differs from ITypeLib, where indices are used to access the elements.
	We can use this as the reverse mapping to GetIDsOfNames."

	^self nameOfID: memid ifAbsent: [self errorNotFound: memid]!

nameOfID: memid ifAbsent: exceptionHandler 
	"Answer a <readableString> name for the member of the 
	receiver identified by the <MEMBERID>, memid, of if there is no
	such member the result of evaluating the niladicValuable, exceptionHandler."

	^self tlbInterface nameOfID: memid ifAbsent: exceptionHandler!

nameSansTag
	"Private - Answer a <readableString> name for the receiver, retrieved from the
	documentation, without any leading underscore/tag prefix
	which probably wasn't present in the original IDL."

	| name |
	name := self basicName.
	^name first = $_ 
		ifTrue: [name allButFirst]
		ifFalse: 
			[(name beginsWith: 'tag') ifTrue: [name allButFirst: 3] ifFalse: [name]]!

realize
	"Private - Load the receiver's ITypeInfo from its owning type library."

	(typeLib isNil or: [index isNil]) ifTrue: [^self error: 'Unable to restore type info.'].
	self setTypeInfo: (typeLib basicTypeInfoAt: index)
!

setTypeInfo: anITypeInfo 
	"Private - Set the value of the receiver's <ITypeInfo> instance variable to the argument."

	anITypeInfo attributes analyzer: self.
	tlbInterface := anITypeInfo!

setTypeInfo: anITypeInfo typeLib: anAXTypeLibraryAnalyzer index: anInteger 
	"Private - Initialize the receiver's identity instance variables."

	self setTypeInfo: anITypeInfo.
	typeLib := anAXTypeLibraryAnalyzer.
	index := anInteger.
!

suggestedBinding
	"Private - Answer an <Association> for the global binding (or the proposed global binding) 
	for the receiver, on the assumption that it doesn't currently have a binding."

	^self typeLib suggestBindingForType: self!

tdesc
	^self attributes tdesc!

typeFlags
	"Answer the receiver's type flags (from the TYPEFLAGS enumeration).
	ITypeInfo and ITypeInfo2 implement this in different ways."

	^self tlbInterface typeFlags!

typekind
	"Answer the Automation TYPEKIND associated with the receiver."
	
	^self class typekind!

typeLib
	"Answer a <AXTypeLibraryAnalyzer> on the receiver's containing type library."

	typeLib isNil ifTrue: [typeLib := AXTypeLibraryAnalyzer onTypeLib: tlbInterface typeLib].
	^typeLib!

typeName
	"Answer the Dolphin external type name for the receiver."

	^self classDesc key typeName!

varDescAt: anInteger 
	"Private - Answer a VARDESC for the member variable of the receiver's structure
	at the specified index."

	^(self tlbInterface varDescAt: anInteger)
		analyzer: self;
		yourself!

variables
	"Answer <sequencedReadableCollection> of VARDESCs describing the 
	member variables of the object described by the receiver. The collection will
	be empty if this message is sent to an inappropriate typekind."

	^(1 to: self attributes cVars) collect: [:i | self varDescAt: i]!

vt
	"Answer a variant type code (a member of VARENUM) which describes the type
	of variant which can be used to represent an object of the type described by
	the receiver."

	^VT_USERDEFINED! !
!AXTypeInfoAnalyzer categoriesFor: #=!comparing!public! !
!AXTypeInfoAnalyzer categoriesFor: #asImplType!converting!public! !
!AXTypeInfoAnalyzer categoriesFor: #baseClass!constants!private! !
!AXTypeInfoAnalyzer categoriesFor: #basicName!accessing!private! !
!AXTypeInfoAnalyzer categoriesFor: #classDesc!constants!private! !
!AXTypeInfoAnalyzer categoriesFor: #constants!enumerating!public! !
!AXTypeInfoAnalyzer categoriesFor: #displayOn:!displaying!public! !
!AXTypeInfoAnalyzer categoriesFor: #documentation!accessing!public! !
!AXTypeInfoAnalyzer categoriesFor: #environment!constants!public! !
!AXTypeInfoAnalyzer categoriesFor: #fullyQualifiedName!constants!private! !
!AXTypeInfoAnalyzer categoriesFor: #funcDescAt:!accessing!private! !
!AXTypeInfoAnalyzer categoriesFor: #functions!enumerating!public! !
!AXTypeInfoAnalyzer categoriesFor: #functionsByName!enumerating!public! !
!AXTypeInfoAnalyzer categoriesFor: #getImplTypeInfoAt:!accessing!public! !
!AXTypeInfoAnalyzer categoriesFor: #getNamesOfMember:count:!accessing!private! !
!AXTypeInfoAnalyzer categoriesFor: #getRefType:!accessing!private! !
!AXTypeInfoAnalyzer categoriesFor: #global!accessing!public! !
!AXTypeInfoAnalyzer categoriesFor: #globalBinding!accessing!private! !
!AXTypeInfoAnalyzer categoriesFor: #globalBinding:!accessing!private! !
!AXTypeInfoAnalyzer categoriesFor: #globalName:!accessing!private! !
!AXTypeInfoAnalyzer categoriesFor: #guid!accessing!public! !
!AXTypeInfoAnalyzer categoriesFor: #hash!comparing!public! !
!AXTypeInfoAnalyzer categoriesFor: #idOfName:ifAbsent:!accessing!public! !
!AXTypeInfoAnalyzer categoriesFor: #index!accessing!private! !
!AXTypeInfoAnalyzer categoriesFor: #isDispatchable!public!testing! !
!AXTypeInfoAnalyzer categoriesFor: #isDual!public!testing! !
!AXTypeInfoAnalyzer categoriesFor: #isGlobalDefined!public!testing! !
!AXTypeInfoAnalyzer categoriesFor: #isHidden!public!testing! !
!AXTypeInfoAnalyzer categoriesFor: #isInstalled!public!testing! !
!AXTypeInfoAnalyzer categoriesFor: #isUnion!public!testing! !
!AXTypeInfoAnalyzer categoriesFor: #nameOfID:!accessing!public! !
!AXTypeInfoAnalyzer categoriesFor: #nameOfID:ifAbsent:!accessing!public! !
!AXTypeInfoAnalyzer categoriesFor: #nameSansTag!accessing!private! !
!AXTypeInfoAnalyzer categoriesFor: #realize!private!realizing/unrealizing! !
!AXTypeInfoAnalyzer categoriesFor: #setTypeInfo:!accessing!private! !
!AXTypeInfoAnalyzer categoriesFor: #setTypeInfo:typeLib:index:!accessing!private! !
!AXTypeInfoAnalyzer categoriesFor: #suggestedBinding!accessing!private! !
!AXTypeInfoAnalyzer categoriesFor: #tdesc!accessing!constants!public! !
!AXTypeInfoAnalyzer categoriesFor: #typeFlags!accessing!public! !
!AXTypeInfoAnalyzer categoriesFor: #typekind!constants!public! !
!AXTypeInfoAnalyzer categoriesFor: #typeLib!accessing!public! !
!AXTypeInfoAnalyzer categoriesFor: #typeName!constants!public! !
!AXTypeInfoAnalyzer categoriesFor: #varDescAt:!accessing!private! !
!AXTypeInfoAnalyzer categoriesFor: #variables!accessing!public! !
!AXTypeInfoAnalyzer categoriesFor: #vt!constants!public! !

!AXTypeInfoAnalyzer class methodsFor!

initialize
	"Private - Initialize class variables of the receiver.
		self initialize
	"

	self initializeVTtoIDLTypeMap.
	TypeKindToClassMap := 
		(Array new: 8)
			at: TKIND_ENUM+1 put: TKindEnumAnalyzer;
			at: TKIND_RECORD+1 put: TKindRecordAnalyzer;
			at: TKIND_MODULE+1 put: TKindModuleAnalyzer;
			at: TKIND_INTERFACE+1 put: TKindInterfaceAnalyzer;
			at: TKIND_DISPATCH+1 put: TKindDispatchAnalyzer;
			at: TKIND_COCLASS+1 put: TKindCoclassAnalyzer;
			at: TKIND_ALIAS+1 put: TKindAliasAnalyzer;
			at: TKIND_UNION+1 put: TKindUnionAnalyzer;
			yourself

!

initializeVTtoIDLTypeMap
	"Private - Initialize the map between VTs and the corresponding IDL type.
		self initializeVTtoIDLTypeMap
	Note that this dictionary only includes variant types which are documented as valid 
	in a TYPEDESC."

	VTtoIDLTypeMap := (IdentityDictionary new)
				at: VT_BOOL put: 'VARIANT_BOOL';
				at: VT_BSTR put: 'BSTR';
				at: VT_CARRAY put: '[]';
				at: VT_CY put: 'CURRENCY';
				at: VT_DATE put: 'DATE';
				at: VT_DECIMAL put: 'DECIMAL';
				at: VT_DISPATCH put: 'IDispatch*';
				at: VT_ERROR put: 'SCODE';
				at: VT_HRESULT put: 'HRESULT';
				at: VT_I1 put: 'CHAR';
				at: VT_I2 put: 'short';
				at: VT_I4 put: 'long';
				at: VT_I8 put: '__int64';
				at: VT_INT put: 'int';
				at: VT_LPSTR put: 'LPSTR';
				at: VT_LPWSTR put: 'LPWSTR';
				at: VT_PTR put: '*';
				at: VT_R4 put: 'float';
				at: VT_R8 put: 'double';
				at: VT_SAFEARRAY put: 'SAFEARRAY*';
				at: VT_UINT put: 'unsigned int';
				at: VT_UI1 put: 'BYTE';
				at: VT_UI2 put: 'unsigned short';
				at: VT_UI4 put: 'unsigned long';
				at: VT_UI8 put: 'unsigned __int64';
				at: VT_UNKNOWN put: 'IUnknown*';
				at: VT_USERDEFINED put: 'typedef';
				at: VT_VARIANT put: 'VARIANT';
				at: VT_VOID put: 'void';
				shrink	"C-style array - but of what?"	"user defined type - TYPEDESC only"!

onTypeInfo: piTypeInfo
	"Answer a sub-instance of the receiver of an appropriate class to wrap
	the <ITypeInfo>, piTypeInfo, referencing the correct unique <AXTypeLibraryAnalyzer>
	instance that represents its containing type library."

	| contain answer lib |
	contain := piTypeInfo libraryAndIndex.
	lib := contain key.
	answer := (AXTypeLibraryAnalyzer onTypeLib: contain key)
				typeAnalyzerAt: contain value.
	lib free.
	^answer
!

onTypeInfo: piTypeInfo typeLib: anAXTypeLibraryAnalyzer 
	"Private - Answer a sub-instance of the receiver of an appropriate class to wrap
	the <ITypeInfo>, piTypeInfo, owned by the <AXTypeLibraryAnalyzer>, typeLib.
	Note: This should only be called from the owning type library - use #onTypeInfo:
	instead."

	^self 
		onTypeInfo: piTypeInfo
		typeLib: anAXTypeLibraryAnalyzer
		index: piTypeInfo index!

onTypeInfo: piTypeInfo typeLib: anAXTypeLibraryAnalyzer index: anInteger 
	"Private - Answer a sub-instance of the receiver of an appropriate class to wrap
	the <ITypeInfo>, piTypeInfo, owned by the <AXTypeLibraryAnalyzer>, typeLib.
	Note: This should only be called from the owning type library - use #onTypeInfo:
	instead."

	^((self typeKindToClassMap at: piTypeInfo typekind + 1) new)
		setTypeInfo: piTypeInfo
			typeLib: anAXTypeLibraryAnalyzer
			index: anInteger;
		yourself!

stbConvertFrom: anSTBClassFormat 
	"Convert from earlier binary filed versions."

	^
	[:data | 
	| converted ver newInstance |
	converted := data.
	ver := anSTBClassFormat version.
	ver < 1 ifTrue: [converted := self stbConvertToVersion1: converted].
	newInstance := self basicNew.
	1 to: converted size do: [:i | newInstance instVarAt: i put: (converted at: i)].
	newInstance]!

stbConvertToVersion1: anArray 
	"Convert from version 0 instance.
	Version 1 refactored to share a common superclass with AXTypeLibraryAnalyzer, and some inst. vars pushed up
	causing some inst. var reordering to take place."

	| answer |
	answer := anArray copy.
	answer at: 2 put: (anArray at: 4).
	answer 
		replaceFrom: 3
		to: 4
		with: anArray
		startingAt: 2.
	^answer!

stbVersion
	^1!

typekind
	"Answer the Automation TYPEKIND associated with the receiver."
	
	^self subclassResponsibility!

typeKindToClassMap
	"Private - Answer a map between TKIND_XXX enumeration members and the appropriate subclass
	to use to wrap an ITypeInfo of that typekind."

	^TypeKindToClassMap!

uninitialize
	"Private - Uninitialize the receiver as it is about to be removed from the system."

	TypeKindToClassMap := nil! !
!AXTypeInfoAnalyzer class categoriesFor: #initialize!initializing!private! !
!AXTypeInfoAnalyzer class categoriesFor: #initializeVTtoIDLTypeMap!initializing!private! !
!AXTypeInfoAnalyzer class categoriesFor: #onTypeInfo:!instance creation!public! !
!AXTypeInfoAnalyzer class categoriesFor: #onTypeInfo:typeLib:!instance creation!private! !
!AXTypeInfoAnalyzer class categoriesFor: #onTypeInfo:typeLib:index:!instance creation!private! !
!AXTypeInfoAnalyzer class categoriesFor: #stbConvertFrom:!binary filing!public! !
!AXTypeInfoAnalyzer class categoriesFor: #stbConvertToVersion1:!binary filing!public! !
!AXTypeInfoAnalyzer class categoriesFor: #stbVersion!binary filing!constants!public! !
!AXTypeInfoAnalyzer class categoriesFor: #typekind!constants!public! !
!AXTypeInfoAnalyzer class categoriesFor: #typeKindToClassMap!constants!private! !
!AXTypeInfoAnalyzer class categoriesFor: #uninitialize!class hierarchy-removing!private! !

