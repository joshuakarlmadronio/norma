CREATE SCHEMA norma;
SET CURRENT SCHEMA = norma;
/*
.-==WORD==---------------------------------------------------------------------------------------------------------.
| 															                                                       |
| Unique WORD and corresponding WORD_FREQUENCY.					                                                   |
|																												   |
'------------------------------------------------------------------------------------------------------------------'
| COLUMN NAME                      | PK | FK (TABLE) | NULL ALLOWED | DATA TYPE (LENGTH) | DESCRIPTION             |
'----------------------------------'----'------------'--------------'--------------------'-------------------------'
| WORD_ID						   | *  |			 | N			| INT   			 | Integer sequence ID     |
| WORD							   |	|			 | N			| VARCHAR (256)		 | 						   |
| WORD_FREQUENCY				   |    |            | N            | INT 				 | 						   |
'------------------------------------------------------------------------------------------------------------------'
EXAMPLE
.------------------------------------------------------.
| WORD_ID (PK, SEQ) | WORD (NOT NULL) | WORD_FREQUENCY |
'-------------------'-----------------'----------------'
| 00001				| AAMININ		  | 35   		   |
| 04042				| SA			  | 1435		   |
'------------------------------------------------------'
*/
CREATE TABLE word(
		word_id INT NOT NULL GENERATED ALWAYS AS IDENTITY(START WITH 1, INCREMENT BY 1), 
		word VARCHAR(256) NOT NULL, 
		word_frequency INT NOT NULL DEFAULT 1
);
ALTER TABLE word
	ADD CONSTRAINT word_pk PRIMARY KEY(
		word_id
	);
ALTER TABLE word
	ADD CONSTRAINT word_uq UNIQUE(
		word
	);
/*
.-==WORD_RELATION==------------------------------------------------------------------------------------------------.
|																												   |
| Forward relationship of words and corresponding frequency. NEXT_WORD_ID is a candidate next word for WORD_ID	   |
| with frequency WORD_RELATION_FREQUENCY.																		   |
|																												   |
'------------------------------------------------------------------------------------------------------------------'
| COLUMN NAME                      | PK | FK (TABLE) | NULL ALLOWED | DATA TYPE (LENGTH) | DESCRIPTION             |
'----------------------------------'----'------------'--------------'--------------------'-------------------------'
| WORD_RELATION_ID				   | *  | 			 | N   			| INT 				 | Integer sequence ID	   |
| WORD_ID						   |    | * (WORD)   | N            | INT 	 			 | 						   |
| NEXT_WORD_ID					   |    | * (WORD)	 | Y			| INT 				 | 						   |
| WORD_RELATION_FREQUENCY		   | 	| 			 | N			| INT 			     |						   |
'------------------------------------------------------------------------------------------------------------------'
EXAMPLE
.-------------------------------------------------------------------------------------------------------------.
| WORD_RELATION_ID (PK, SEQ) | WORD_ID (FK, NOT NULL) | NEXT_WORD_ID (FK, NULLABLE) | WORD_RELATION_FREQUENCY |
'----------------------------'------------------------'-----------------------------'-------------------------'
| 3445						 | 0001					  | 04042						| 32					  |
'-------------------------------------------------------------------------------------------------------------'
 */
CREATE TABLE word_relation(
	word_relation_id INT NOT NULL GENERATED ALWAYS AS IDENTITY(START WITH 1, INCREMENT BY 1), 
	word_id INT NOT NULL, 
	next_word_id INT, 
	word_relation_frequency INT NOT NULL DEFAULT 0
);
ALTER TABLE word_relation
	ADD CONSTRAINT word_relation_pk PRIMARY KEY(
		word_relation_id
	);
ALTER TABLE word_relation
	ADD CONSTRAINT word_relation_fk_1 FOREIGN KEY(
		word_id
	)
	REFERENCES word(
		word_id
	);
ALTER TABLE word_relation
	ADD CONSTRAINT word_relation_fk_2 FOREIGN KEY(
		next_word_id
	)
	REFERENCES word(
		word_id
	);
ALTER TABLE word_relation
	ADD CONSTRAINT word_relation_uq UNIQUE(
		word_id,
		next_word_id
	);
/*
.-==SOUNDEX==------------------------------------------------------------------------------------------------------.
| 															                                                       |
| Many-to-many mapping of a CHARACTER to a SOUNDEX code, and the SOUNDEX_FREQUENCY. As opposed to table			   |
| SOUNDEX_RULE, SOUNDEX applies to rules derived from noisy words.				                                   |
|																												   |
'------------------------------------------------------------------------------------------------------------------'
| COLUMN NAME                      | PK | FK (TABLE) | NULL ALLOWED | DATA TYPE (LENGTH) | DESCRIPTION             |
'----------------------------------'----'------------'--------------'--------------------'-------------------------'
| SOUNDEX_ID					   | *  |            | N			| INT				 | Integer sequence ID	   |
| MAPPED_CHARACTER				   |	|			 | N			| CHAR (1)			 |						   |
| SOUNDEX						   |	|			 | Y		    | CHAR (32)			 | Hexadecimal			   |
| SOUNDEX_FREQUENCY				   |	|			 | N			| INT				 |						   |
'------------------------------------------------------------------------------------------------------------------'
EXAMPLE
.---------------------------------------------------------------------------------------------------------------.
| SOUNDEX_ID (PK, SEQ) | SOUNDEX (NOT NULL)		| MAPPED_CHARACTER (NOT NULL) 	| SOUNDEX_FREQUENCY (NOT NULL)	|
'----------------------'------------------------'-------------------------------'-------------------------------'
| 031				   | D						| A								| 34							|
| 032				   | D						| a								| 1213							|
| 033				   | D						| @								| 12							|
'---------------------------------------------------------------------------------------------------------------'
*/
CREATE TABLE soundex(
	soundex_id INT NOT NULL GENERATED ALWAYS AS IDENTITY(START WITH 1, INCREMENT BY 1),
	mapped_character VARCHAR(1) NOT NULL,
	soundex CHAR(32),
	soundex_frequency INT NOT NULL DEFAULT 1
);
ALTER TABLE soundex
	ADD CONSTRAINT soundex_pk PRIMARY KEY(
		soundex_id
	);
/*
.-==SOUNDEX_RELATION==-----------------------------------------------------------------------------------------------.
| 		                     								   	                                                     |
| Forward relationship of soundex codes and corresponding frequency. NEXT_SOUNDEX_ID is a candidate next soundex	 |
| for SOUNDEX_ID with frequency SOUNDEX_RELATION_FREQUENCY.														     |
|																												     |
'--------------------------------------------------------------------------------------------------------------------'
| COLUMN NAME                      | PK | FK (TABLE)   | NULL ALLOWED | DATA TYPE (LENGTH) | DESCRIPTION             |
'----------------------------------'----'--------------'--------------'--------------------'-------------------------'
| SOUNDEX_RELATION_ID			   | *	|			   | N			  | INT 			   | Integer sequence ID	 |
| SOUNDEX_ID					   |	| * (SOUNDEX)  | N   		  | INT 			   |						 |
| NEXT_SOUNDEX_ID				   |	| * (SOUNDEX)  | Y			  | INT 			   |						 |
| SOUNDEX_RELATION_FREQUENCY 	   |	|			   | N			  | INT 			   |						 |
'--------------------------------------------------------------------------------------------------------------------'
EXAMPLE
.-----------------------------------------------------------------------------------------------------------------------------.
| SOUNDEX_RELATION_ID (PK, SEQ)  | SOUNDEX_ID (FK, NOT NULL)  | NEXT_SOUNDEX_ID (FK, NULLABLE)  | SOUNDEX_RELATION_FREQUENCY  |
'--------------------------------'----------------------------'---------------------------------'-----------------------------'
| 134							 | 000001					  | 000001							| 55						  |
| 135							 | 000001					  | 133300						    | 20						  |
| 344							 | 133300					  | 135003						    | 2							  |
'-----------------------------------------------------------------------------------------------------------------------------'
*/
CREATE TABLE soundex_relation(
	soundex_relation_id INT NOT NULL GENERATED ALWAYS AS IDENTITY(START WITH 1, INCREMENT BY 1),
	soundex_id INT NOT NULL,
	next_soundex_id INT,
	soundex_relation_frequency INT NOT NULL DEFAULT 0
);
ALTER TABLE soundex_relation
	ADD CONSTRAINT soundex_relation_pk PRIMARY KEY(
		soundex_relation_id
	);
ALTER TABLE soundex_relation
	ADD CONSTRAINT soundex_relation_fk_1 FOREIGN KEY(
		soundex_id
	)
	REFERENCES soundex(
		soundex_id
	);
ALTER TABLE soundex_relation
	ADD CONSTRAINT soundex_relation_fk_2 FOREIGN KEY(
		next_soundex_id
	)
	REFERENCES soundex(
		soundex_id
	);
/*
.-==WORD_SOUNDEX==--------------------------------------------------------------------------------------------------.
| 		                     								   	                                                     |
| SOUNDEX_ID composition of a unique WORD_ID given ORDER.														     |
|																												     |
'--------------------------------------------------------------------------------------------------------------------'
| COLUMN NAME                      | PK | FK (TABLE)   | NULL ALLOWED | DATA TYPE (LENGTH) | DESCRIPTION             |
'----------------------------------'----'--------------'--------------'--------------------'-------------------------'
| WORD_SOUNDEX_ID				   | *	|			   | N			  | INT (32)		   | Integer sequence ID	 |
| WORD_ID						   |	| * (WORD)	   | N			  | INT (32)		   |						 |
| SOUNDEX_ID					   |	| * (SOUNDEX)  | N			  | INT (32)		   |						 |
| SOUNDEX_ORDER					   |	| 			   | N			  | INT (32)		   |						 |
'--------------------------------------------------------------------------------------------------------------------'
EXAMPLE
.--------------------------------------------------------------------------------------------------------------.
| WORD_SOUNDEX_ID  (PK, SEQ) | WORD_ID (FK, NOT NULL) | SOUNDEX_ID (FK, NOT NULL)  | SOUNDEX_ORDER (NOT NULL)  |
'----------------------------'------------------------'----------------------------'---------------------------'
| 77683						 | 00001				  | 000001                     | 0				  		   |
| 77684						 | 00001				  | 000001                     | 1				  		   |
| 77685						 | 00001				  | 133300                     | 2				  		   |
| 77686						 | 00001				  | 135003                     | 3				  		   |
'--------------------------------------------------------------------------------------------------------------'
*/
CREATE TABLE word_soundex(
	word_soundex_id INT NOT NULL GENERATED ALWAYS AS IDENTITY(START WITH 1, INCREMENT BY 1),
	word_id INT NOT NULL,
	soundex_id INT NOT NULL,
	soundex_order INT NOT NULL DEFAULT 1
);
ALTER TABLE word_soundex
	ADD CONSTRAINT word_soundex_pk PRIMARY KEY(
		word_soundex_id
	);
ALTER TABLE word_soundex
	ADD CONSTRAINT word_soundex_fk_1 FOREIGN KEY(
		word_id
	)
	REFERENCES word(
		word_id
	);
ALTER TABLE word_soundex
	ADD CONSTRAINT word_soundex_fk_2 FOREIGN KEY(
		soundex_id
	)
	REFERENCES soundex(
		soundex_id
	);
	
/*
.-==CHAR_TO_SOUNDEX_NORMAL==---------------------------------------------------------------------------------------.
| 															                                                       |
| From a normal word, this table defines how a character maps to a soundex with a one-to-many relationship.		   |
|																												   |
'------------------------------------------------------------------------------------------------------------------'
| COLUMN NAME                      | PK | FK (TABLE) | NULL ALLOWED | DATA TYPE (LENGTH) | DESCRIPTION             |
'----------------------------------'----'------------'--------------'--------------------'-------------------------'
| NORMAL_RULE_ID				   | *  |            | N			| INT				 | Integer sequence ID	   |
| MAPPED_CHARACTER				   |	|			 | N			| CHAR (1)			 |						   |
| SOUNDEX						   |	|			 | N		    | CHAR (1)			 | Hexadecimal			   |
'------------------------------------------------------------------------------------------------------------------'
EXAMPLE
.-----------------------------------------------------------------------------------.
| NORMAL_RULE_ID (PK, SEQ) | SOUNDEX (NOT NULL)		| MAPPED_CHARACTER (NOT NULL) 	|
'--------------------------'------------------------'-------------------------------'
| 031					   | D						| A								|
| 032					   | D						| a								|
| 033					   | D						| @								|
'-----------------------------------------------------------------------------------'
*/
CREATE TABLE char_to_soundex_normal(
	normal_rule_id INT NOT NULL GENERATED ALWAYS AS IDENTITY(START WITH 1, INCREMENT BY 1),
	mapped_character CHAR(1) NOT NULL,
	soundex CHAR(1) NOT NULL
);
ALTER TABLE char_to_soundex_normal
	ADD CONSTRAINT char_to_soundex_normal_pk PRIMARY KEY(
		normal_rule_id
	);
ALTER TABLE char_to_soundex_normal
	ADD CONSTRAINT char_to_soundex_normal_uq UNIQUE(
		mapped_character
	);
	
	
set current schema = app;
/*
.-==CONFIG==-------------------------------------------------------------------------------------------------------.
| 															                                                       |
| Configuration values used by the application.          	   		                                               |
|																												   |
'------------------------------------------------------------------------------------------------------------------'
| COLUMN NAME                      | PK | FK (TABLE) | NULL ALLOWED | DATA TYPE (LENGTH) | DESCRIPTION             |
'----------------------------------'----'------------'--------------'--------------------'-------------------------'
| CONFIG_ID						   | *  |            | N			| INT				 | Integer sequence ID	   |
| CATEGORY_1					   |	|			 | N		    | VARCHAR (32)		 | Category of config	   |
| CATEGORY_2					   |	|			 | Y			| VARCHAR (32)		 | Optional category	   |
| CONFIG_NAME					   |	|			 | N			| VARCHAR (64)		 | 						   |
| CONFIG_TYPE					   |	|			 | N			| VARCHAR (32)		 | Data type			   |
| CONFIG_VALUE					   |	|			 | N			| VARCHAR (256)		 | Store as varchar		   |
| IS_CONSTANT					   |	|			 | N			| BOOLEAN			 | Is value updatable?	   |
'------------------------------------------------------------------------------------------------------------------'
EXAMPLE
.-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------.
| CONFIG_ID (PK, SEQ)   | CATEGORY_1 (NOT NULL) | CATEGORY_2 		| CONFIG_NAME (NOT NULL) 	| CONFIG_TYPE (NOT NULL) 	| CONFIG_VALUE (NOT NULL)   | IS_CONSTANT (NOT NULL)	|
'-----------------------'-----------------------'-------------------'---------------------------'---------------------------'---------------------------'---------------------------'
| 001				    | EXIT_CODE				| FATAL_ERROR		| EXIT_CODE_FATAL_ERROR		| int						| 200						| Y							|
| 002				    | EXIT_CODE				| DB_ERROR			| EXIT_CODE_DB_ERROR		| int						| 199						| Y							|
| 003				    | DATABASE				| NAME				| DATABASE_NAME				| String					| normadb					| Y							|
| 004					| LOG					| PATH				| LOG_PATH					| String					| /logs/					| N							|
'-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------'
 */

CREATE TABLE config(
	config_id INT NOT NULL GENERATED ALWAYS AS IDENTITY(START WITH 1, INCREMENT BY 1),
	category_1 VARCHAR(32) NOT NULL,
	category_2 VARCHAR(32),
	config_name VARCHAR(64) NOT NULL,
	config_type VARCHAR(32) NOT NULL,
	config_value VARCHAR(256) NOT NULL,
	is_constant BOOLEAN NOT NULL
);
ALTER TABLE config
	ADD CONSTRAINT config_pk PRIMARY KEY(
		config_id
	);