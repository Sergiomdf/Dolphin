"Filed out from Dolphin Smalltalk X6.1"!

Object subclass: #ScintillaAnnotation
	instanceVariableNames: 'line text styles'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ScintillaAnnotation guid: (GUID fromString: '{2D20C021-0CEF-46F7-BA44-4C4191189DF9}')!
ScintillaAnnotation comment: ''!
!ScintillaAnnotation categoriesForClass!MVP-Views-Support! !
!ScintillaAnnotation methodsFor!

= comparand 
	^comparand class == self class and: [line = comparand line and: [text = comparand text]]!

hash
	^line hash bitXor: text hash!

line
	^line!

printOn: aStream 
	aStream
		basicPrint: self;
		nextPut: $(;
		display: self line;
		nextPutAll: ': ';
		display: self text;
		space;
		display: self styles;
		nextPut: $)!

setLine: anInteger text: aString styles: aRunArrayOfSymbol 
	line := anInteger.
	text := aString.
	styles := aRunArrayOfSymbol!

styles
	^styles!

text
	"Answer the text  of the annotation."

	^text! !
!ScintillaAnnotation categoriesFor: #=!comparing!public! !
!ScintillaAnnotation categoriesFor: #hash!comparing!public! !
!ScintillaAnnotation categoriesFor: #line!public! !
!ScintillaAnnotation categoriesFor: #printOn:!printing!public! !
!ScintillaAnnotation categoriesFor: #setLine:text:styles:!initializing!private! !
!ScintillaAnnotation categoriesFor: #styles!accessing!public! !
!ScintillaAnnotation categoriesFor: #text!accessing!public! !

!ScintillaAnnotation class methodsFor!

icon
	^ScintillaView icon!

line: anInteger text: aString style: aSymbol 
	^self 
		line: anInteger
		text: aString
		styles: (RunArray new: aString size withAll: aSymbol)!

line: anInteger text: aString styles: aSequencedReadableCollectionOfSymbol 
	^(self new)
		setLine: anInteger
			text: aString
			styles: aSequencedReadableCollectionOfSymbol;
		yourself! !
!ScintillaAnnotation class categoriesFor: #icon!constants!development!public! !
!ScintillaAnnotation class categoriesFor: #line:text:style:!public! !
!ScintillaAnnotation class categoriesFor: #line:text:styles:!initializing!private! !

