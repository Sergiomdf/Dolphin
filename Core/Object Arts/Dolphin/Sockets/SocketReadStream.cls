"Filed out from Dolphin Smalltalk X6.1"!

ReadStream subclass: #SocketReadStream
	instanceVariableNames: 'socket'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SocketReadStream guid: (GUID fromString: '{87B4C6FC-026E-11D3-9FD7-00A0CC3E4A32}')!
SocketReadStream comment: 'This class represents a buffered read stream for receiving data across a Socket connection. The #next call will receive the next element from the stream and will block until there is data available. In order to avoid blocking (when executing on the user interface thread, for example) the #hasInput method may be used to check for the presence of available input before calling #next.'!
!SocketReadStream categoriesForClass!Collections-Streams!Windows Sockets! !
!SocketReadStream methodsFor!

atEnd
	"Answer whether the receiver cannot access any more objects."

	"Implementation Note: If there is any input available in the buffer, which the superclass implementation
	can tell us, then we know we are not at end. Otherwise we need to attempt to read some more input
	from the socket to find out whether it has been closed or not. This could, of course, cause the stream
	to block, but this is correct since we can't truthfully answer whether we are at end until either
	more input arrives, or the socket is closed."

	super atEnd ifFalse: [^false].
	^self socket isOpen not or: 
			[self readPage.
			readLimit = 0]!

contents
	"We don't maintain past history, so we cannot implement this correctly."

	^self shouldNotImplement!

hasInput
	"Answer true if there is data available on the receiver without blocking"

	^super atEnd not or: [self socket hasInput]!

initialize
	"Private - Initialise the new instance."

	super initialize.
	readLimit := 0!

isBinary
	"Answer whether the receiver's data is binary (i.e. consisting of Integers in the range 0..255)."

	^self collection isMemberOf: ByteArray!

isText
	"Answer whether if the receiver's data is characters."

	^self isBinary not!

isText: aBoolean 
	"Set whether the elements of the receiver should be treated as bytes (Integers)
	or characters.."

	collection := aBoolean ifTrue: [collection asString] ifFalse: [collection asByteArray]!

next
	"Answer the receiver's next byte, an Integer.
	Signal an EndOfStream Exception if we are atEnd."

	<primitive: 65>
	self readPage.
	^super next!

next: countInteger into: aSequenceableCollection startingAt: startInteger 
	"Destructively replace the elements of the argument, aSequenceableCollection,
	in the interval (startAt..startAt+count-1) with the next, count, elements of
	the receiver. Answer aSequenceableCollection."

	startInteger to: startInteger + countInteger - 1
		do: [:i | aSequenceableCollection at: i put: self next].
	^aSequenceableCollection!

nextAvailable
	^self atEnd ifFalse: [self next]!

readPage
	"Private - Read ahead, a whole page or as much input as is available, into the buffer."

	readLimit := 
			[socket 
				receiveSome: collection
				count: collection size
				startingAt: 1] 
					on: SocketClosed
					do: [:ex | 0].
	position := 0!

setToEnd
	"The receiver is not positionable."

	^self shouldNotImplement!

size
	"We don't know the number of elements in the past sequence values, only the number
	currently in the buffer, so cannot provide a sensible implementation of this message."

	^self shouldNotImplement!

socket
	"Private - Answers the socket instance variable."

	^socket!

socket: aSocket 
	"Private - Sets the socket instance variable to aSocket."

	socket := aSocket!

upToEnd
	"Answer a collection consisting of the remaining elements in the receiver (i.e. from the current
	position to the end)."

	| remainder |
	remainder := self contentsSpecies writeStream: 128.
	[self atEnd] whileFalse: [remainder nextPut: self next].
	^remainder contents! !
!SocketReadStream categoriesFor: #atEnd!public!testing! !
!SocketReadStream categoriesFor: #contents!accessing!public! !
!SocketReadStream categoriesFor: #hasInput!public!testing! !
!SocketReadStream categoriesFor: #initialize!initializing!private! !
!SocketReadStream categoriesFor: #isBinary!public!testing! !
!SocketReadStream categoriesFor: #isText!public!testing! !
!SocketReadStream categoriesFor: #isText:!modes!public! !
!SocketReadStream categoriesFor: #next!accessing!public! !
!SocketReadStream categoriesFor: #next:into:startingAt:!accessing!public! !
!SocketReadStream categoriesFor: #nextAvailable!public! !
!SocketReadStream categoriesFor: #readPage!operations!private! !
!SocketReadStream categoriesFor: #setToEnd!positioning!public! !
!SocketReadStream categoriesFor: #size!accessing!public! !
!SocketReadStream categoriesFor: #socket!accessing!private! !
!SocketReadStream categoriesFor: #socket:!accessing!private! !
!SocketReadStream categoriesFor: #upToEnd!accessing!public! !

!SocketReadStream class methodsFor!

bufferSize
	"Private - Answer the size of the buffer to be used."

	^4096!

on: aSocket 
	"Answers a new instance of the receiver for communicating with aSocket."

	^self on: aSocket text: false!

on: aSocket text: aBoolean 
	"Answer a new instance of the receiver on the specified <Socket>, to be used for buffered reading
	string or binary data from that socket depending on the value of <boolean> argument."

	^(self basicNew)
		socket: aSocket;
		collection: ((aBoolean ifTrue: [String] ifFalse: [ByteArray]) newFixed: self bufferSize);
		initialize;
		yourself! !
!SocketReadStream class categoriesFor: #bufferSize!constants!private! !
!SocketReadStream class categoriesFor: #on:!instance creation!public! !
!SocketReadStream class categoriesFor: #on:text:!instance creation!public! !

