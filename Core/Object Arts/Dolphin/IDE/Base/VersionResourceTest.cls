"Filed out from Dolphin Smalltalk 7"!

DolphinTest subclass: #VersionResourceTest
	instanceVariableNames: 'updatePath sourceModule sourceSize sourceBytes'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
VersionResourceTest guid: (GUID fromString: '{A475B032-CEF9-4AA6-AFFE-32B7DC1C4640}')!
VersionResourceTest comment: ''!
!VersionResourceTest categoriesForClass!Unclassified! !
!VersionResourceTest methodsFor!

assertResource: res atVersion: newVersion 
	self assert: res fileVersion = newVersion.
	self assert: res fixedInfo fileVersionString = newVersion.
	self assert: res productVersion = newVersion.
	self assert: res fixedInfo productVersionString = newVersion.
	res stringTables do: 
			[:each | 
			self assert: (each at: 'FileVersion') = newVersion.
			self assert: (each at: 'ProductVersion') = newVersion]!

assertVersionResource: versionResource equalTo: versionResource2 
	| newStrings |
	self assert: versionResource languageId = versionResource2 languageId.
	newStrings := versionResource2 stringTables.
	self assert: (newStrings keys noDifference: versionResource stringTables keys).
	newStrings values with: versionResource stringTables values
		do: [:eachTable1 :eachTable2 | self assert: (eachTable1 associations noDifference: eachTable2 associations)].
	self assert: versionResource pack = versionResource2 pack!

modifyVersionResource: versionResource
	(versionResource stringTables values first)
		at: 'FileDescription' put: 'A test version resource file description';
		at: 'Product Name' put: 'Dolphin SUnit Tests'!

setUp
	| pVer header |
	updatePath := File temporaryFilename.
	File copy: self sourcePath to: updatePath.
	sourceModule := ExternalLibrary open: self sourcePath.
	pVer := VersionResource getVersionResourceOfModule: sourceModule.
	header := VS_VERSION_INFO_HEADER fromAddress: pVer.
	sourceSize := header wLength.
	sourceBytes := pVer copyFrom: 1 to: sourceSize!

sourcePath
	^(FolderRelativeFileLocator basePath: SessionManager current installationDirectory) 
		localFileSpecFor: 'GUIToGo.exe'!

tearDown
	sourceModule close.
	File delete: updatePath!

testRoundTripUnpackPack
	| packedBytes repackedBytes versionResource versionResource2 |
	versionResource := VersionResource new unpack: sourceBytes yourAddress.
	packedBytes := versionResource pack.
	self assert: sourceBytes = packedBytes.
	self modifyVersionResource: versionResource.
	packedBytes := versionResource pack.
	versionResource2 := VersionResource new unpack: packedBytes yourAddress.
	repackedBytes := versionResource2 pack.
	self assert: packedBytes = repackedBytes.
	self assertVersionResource: versionResource equalTo: versionResource2!

testRoundTripUpdate
	| versionResource versionResource2 |
	versionResource := VersionResource new unpack: sourceBytes yourAddress.
	versionResource updateFile: updatePath.
	versionResource2 := VersionResource forPath: updatePath.
	self assert: sourceBytes = versionResource2 pack.
	self assertVersionResource: versionResource2 equalTo: versionResource.
	self modifyVersionResource: versionResource.
	versionResource updateFile: updatePath.
	versionResource2 := VersionResource forPath: updatePath.
	self assertVersionResource: versionResource2 equalTo: versionResource!

testVersionStrings
	"Test minor version incrementer"

	| res originalVersion newVersion |
	#'1598'.
	res := VersionResource forPath: updatePath.
	originalVersion := '1.0.0.1'.
	self assert: res fileVersion = originalVersion.
	newVersion := '101.202.303.404'.
	res fileVersion: newVersion.
	self assert: res fileVersion = newVersion.
	self assert: res fixedInfo fileVersionString = newVersion.
	self assert: res productVersion = originalVersion.
	res productVersion: newVersion.
	self assertResource: res atVersion: newVersion.
	res bumpProductVersion.
	self assertResource: res atVersion: '101.202.304.404'! !
!VersionResourceTest categoriesFor: #assertResource:atVersion:!public!unit tests! !
!VersionResourceTest categoriesFor: #assertVersionResource:equalTo:!private!unit tests! !
!VersionResourceTest categoriesFor: #modifyVersionResource:!public!unit tests! !
!VersionResourceTest categoriesFor: #setUp!private!Running! !
!VersionResourceTest categoriesFor: #sourcePath!constants!private! !
!VersionResourceTest categoriesFor: #tearDown!private!Running! !
!VersionResourceTest categoriesFor: #testRoundTripUnpackPack!public!unit tests! !
!VersionResourceTest categoriesFor: #testRoundTripUpdate!public!unit tests! !
!VersionResourceTest categoriesFor: #testVersionStrings!public!unit tests! !

