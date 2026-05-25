CLUE ON HOW TO CHANGE A TEXT DATA TYPE to DATE in MYSQL workBEnch

AFTER IMPORTING THE CSV files...

STEP 1.  CONVERT STRINGor TEXT data to DATE using the ff: Syntax:

UPDATE <tableName> SET <columnToUpdate> = STR_TO_DATE(<columnToUpdate>,<date format>);

valid date formats:
'%m/%d/%Y'
'%Y/%m/%d'
'%y/%m/%d'

* Display Records 'to check if' the records were not deleted.

STEP 2. AFTER CONVERTING Data to string you may now 
ALTER and MODIFY the column using appropriate Data type
ALTER TABLE orders MODIFY OrderDate DATE;
STEP 3. Describe the table to check of DAta Type is changed 
STEP 4. View the data 
