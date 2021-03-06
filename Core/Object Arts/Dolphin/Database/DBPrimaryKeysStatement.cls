"Filed out from Dolphin Smalltalk X6"!

DBSchemaStatement subclass: #DBPrimaryKeysStatement
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
DBPrimaryKeysStatement guid: (GUID fromString: '{7DF04E35-7E59-4700-9155-347CC2E61649}')!
DBPrimaryKeysStatement comment: 'DBPrimaryKeysStatement is a specialized <DBSchemaStatement> for querying about the primary keys of tables in a database.'!
!DBPrimaryKeysStatement categoriesForClass!ODBC Interface! !
!DBPrimaryKeysStatement methodsFor!

executeStatement
	"Private - Execute the database command that the receiver represents.
	Answer the <integer> return code."

	^ODBCLibrary default 
		sqlPrimaryKeys: self allocatedHandle
		catalogName: catalogName
		nameLength1: SQL_NTS
		schemaName: schemaName
		nameLength2: SQL_NTS
		tableName: tableName
		nameLength3: SQL_NTS! !
!DBPrimaryKeysStatement categoriesFor: #executeStatement!operations!private! !

