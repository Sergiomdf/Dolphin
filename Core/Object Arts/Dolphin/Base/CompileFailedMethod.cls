"Filed out from Dolphin Smalltalk X6"!

CompiledMethod variableSubclass: #CompileFailedMethod
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
CompileFailedMethod guid: (GUID fromString: '{87B4C545-026E-11D3-9FD7-00A0CC3E4A32}')!
CompileFailedMethod comment: 'In certain situations (package loading, method dropping etc) a method compilation will fail and yet a stub CompileFailedMethod is still installed in the class. This stub is useful since it allows the original method source to be accessible via the browsers and allows category information to be maintained for the failed method.

If you want to locate all of these compilation failures remaining in your image siimply evaluate:

SmalltalkSystem current browseCompileFailedMethods'!
!CompileFailedMethod categoriesForClass!Kernel-Methods! !
!CompileFailedMethod methodsFor!

getDebugInfo
	"Private - Invoke the compiler to answer a compilation result containing a 
	recompilation of the receiver, a map between IP ranges and expressions 
	in the source, and a map between IP ranges and an OrderedCollection of 
	Associations between IP positions and temporaries up to that position in 
	the receiver, ordered by IP."

	| answer |
	answer := self compilerClass 
				debugInfoFor: (self class buildSourceForSelector: selector class: methodClass)
				in: self methodClass
				debug: self isDebugMethod.
	^answer!

icon
	"Answers an Icon that can be used to represent this class"

	^self class icon
!

isCompilationFailure
	^true! !
!CompileFailedMethod categoriesFor: #getDebugInfo!development!private! !
!CompileFailedMethod categoriesFor: #icon!constants!public! !
!CompileFailedMethod categoriesFor: #isCompilationFailure!public!testing! !

!CompileFailedMethod class methodsFor!

buildSourceForSelector: aSymbol class: aBehavior 
	"Private - Construct a method with a correct message pattern for the <Symbol>, aSelector, in the
	class, aBehavior, but which, when invoked, raises an exception to the effect that the original 
	method source failed to compile."

	| argc stream |
	stream := String writeStream: 128.
	argc := aSymbol argumentCount.
	argc == 0 
		ifTrue: [stream nextPutAll: aSymbol]
		ifFalse: 
			[(argc == 1 and: [aSymbol isInfix]) 
				ifTrue: 
					["Assume a binary selector"
					stream
						nextPutAll: aSymbol;
						nextPutAll: ' operand']
				ifFalse: 
					[| inUse |
					inUse := Set withAll: aBehavior allInstVarNames.
					aSymbol keywords do: 
							[:keyword | 
							| x argName |
							stream
								nextPutAll: keyword;
								space.
							x := 1.
							
							[argName := 'arg' , (x := x + 1) displayString.
							inUse includes: argName] whileTrue.
							inUse add: argName.
							stream
								nextPutAll: argName;
								space]]].
	stream
		crtab;
		nextPutAll: ' self error: ''This method did not compile'''.
	^stream contents!

icon
	"Answer an Icon representing the receiver."

	^##(self) defaultIcon! !
!CompileFailedMethod class categoriesFor: #buildSourceForSelector:class:!helpers!private! !
!CompileFailedMethod class categoriesFor: #icon!constants!public! !

