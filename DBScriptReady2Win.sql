USE [Ready2Enjoy]
GO
/****** Object:  User [abdulrub08_SQLLogin_1]    Script Date: 9/2/2022 8:53:11 PM ******/
CREATE USER [abdulrub08_SQLLogin_1] FOR LOGIN [abdulrub08_SQLLogin_1] WITH DEFAULT_SCHEMA=[dbo]
GO
ALTER ROLE [db_owner] ADD MEMBER [abdulrub08_SQLLogin_1]
GO
/****** Object:  Schema [abdulrub08_SQLLogin_1]    Script Date: 9/2/2022 8:53:12 PM ******/
CREATE SCHEMA [abdulrub08_SQLLogin_1]
GO
/****** Object:  StoredProcedure [dbo].[InsertProductInfo]    Script Date: 9/2/2022 8:53:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create Proc [dbo].[InsertProductInfo]
@ProductID int,
@ProductType varchar(30),
@Code varchar(30),
@Name varchar(30),
@Brand varchar(30),
@Description varchar(max),
@CostPrice varchar(30),
@RetailPrice varchar(30),
@SalePrice varchar(30),
@CalculatedPrice varchar(30),
@FixedShippingPrice varchar(30),
@FreeShipping bit,
@AllowPurchases bit,
@ProductVisible bit,
@ProductAvailability bit,
@ProductInventoried bit,
@StockLevel varchar(30),
@LowStockLevel varchar(30),
@CategoryDetails varchar(500),
@Images varchar(500),
@PageTitle varchar(50),
@METAKeywords varchar(500),
@METADescription varchar(500),
@ProductCondition varchar(30),
@ProductURL varchar(500),
@RedirectOldURL varchar(500),
@ProductTaxCode varchar(30),
@ProductCustomFields varchar(30)

--@Code int output,
--@Message varchar(max) output
As
Begin

insert into [dbo].[Product] 
values(@ProductID,
@ProductType,
@Code,
@Name,
@Brand,
@Description,
@CostPrice,
@RetailPrice,
@SalePrice,
@CalculatedPrice,
@FixedShippingPrice,
@FreeShipping,
@AllowPurchases,
@ProductVisible,
@ProductAvailability,
@ProductInventoried,
@StockLevel,
@LowStockLevel,
@CategoryDetails,
@Images,
@PageTitle,
@METAKeywords,
@METADescription,
@ProductCondition,
@ProductURL,
@RedirectOldURL,
@ProductTaxCode,
@ProductCustomFields)
End
GO
/****** Object:  StoredProcedure [dbo].[InsertVendorInfo]    Script Date: 9/2/2022 8:53:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

Create Proc [dbo].[InsertVendorInfo]
@VendorName varchar(50),
@Address varchar(200),
@City varchar(30),
@State varchar(30),
@Zip varchar(10),
@ContactName varchar(50),
@ContactNumber varchar(12),
@ContactEmail varchar(100),
@PartTypeCategory varchar(100),
@PaymentTermsOffered varchar(100),
@ShippingNotes varchar(100)

--@Code int output,
--@Message varchar(max) output
As
Begin

insert into [dbo].[Vendor] (VendorName,
VAddress,
City,
VState,
Zip,
ContactName,
ContactNumber,
ContactEmail,
PartTypeCategory,
PaymentTermsOffered,
ShippingNotes)
values(@VendorName,
@Address,
@City,
@State,
@Zip,
@ContactName,
@ContactNumber,
@ContactEmail,
@PartTypeCategory,
@PaymentTermsOffered,
@ShippingNotes)
End
GO
/****** Object:  StoredProcedure [dbo].[sp_generate_inserts]    Script Date: 9/2/2022 8:53:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE  PROC [dbo].[sp_generate_inserts]            
(            
 @table_name varchar(776),    -- The table for which the INSERT statements will be generated using the existing data            
 @target_table varchar(776) = NULL,  -- Use this parameter to specify a different table name into which the data will be inserted            
 @include_column_list bit = 1,  -- Use this parameter to include/ommit column list in the generated INSERT statement            
 @from varchar(2000) = NULL,   -- Use this parameter to filter the rows based on a filter condition (using WHERE)            
 @include_timestamp bit = 0,   -- Specify 1 for this parameter, if you want to include the TIMESTAMP/ROWVERSION column's data in the INSERT statement            
 @debug_mode bit = 0,   -- If @debug_mode is set to 1, the SQL statements constructed by this procedure will be printed for later examination            
 @owner varchar(64) = NULL,  -- Use this parameter if you are not the owner of the table            
 @ommit_images bit = 0,   -- Use this parameter to generate INSERT statements by omitting the 'image' columns            
 @ommit_identity bit = 0,  -- Use this parameter to ommit the identity columns            
 @top int = NULL,   -- Use this parameter to generate INSERT statements only for the TOP n rows            
 @cols_to_include varchar(8000) = NULL, -- List of columns to be included in the INSERT statement            
 @cols_to_exclude varchar(8000) = NULL -- List of columns to be excluded from the INSERT statement            
)            
AS            
BEGIN            
            
/***********************************************************************************************************            
Procedure: sp_generate_inserts               
            
                                                      
Purpose: To generate INSERT statements from existing data.             
  These INSERTS can be executed to regenerate the data at some other location.            
  This procedure is also useful to create a database setup, where in you can             
  script your data along with your table definitions.            
            
NOTE:  This procedure may not work with tables with too many columns.            
  Results can be unpredictable with huge text columns or SQL Server 2000's sql_variant data types            
  IMPORTANT: Whenever possible, Use @include_column_list parameter to ommit column list in the INSERT statement, for better results            
            
Example 1: To generate INSERT statements for table 'titles':            
              
  EXEC sp_generate_inserts 'titles'            
            
Example 2:  To ommit the column list in the INSERT statement: (Column list is included by default)            
  IMPORTANT: If you have too many columns, you are advised to ommit column list, as shown below,            
  to avoid erroneous results            
              
  EXEC sp_generate_inserts 'titles', @include_column_list = 0            
            
Example 3: To generate INSERT statements for 'titlesCopy' table from 'titles' table:            
            
  EXEC sp_generate_inserts 'titles', 'titlesCopy'            
            
Example 4: To generate INSERT statements for 'titles' table for only those titles             
  which contain the word 'Computer' in them:            
  NOTE: Do not complicate the FROM or WHERE clause here. It's assumed that you are good with T-SQL if you are using this parameter            
            
  EXEC sp_generate_inserts 'titles', @from = "from titles where title like '%Computer%'"            
            
Example 5:  To specify that you want to include TIMESTAMP column's data as well in the INSERT statement:            
  (By default TIMESTAMP column's data is not scripted)            
            
  EXEC sp_generate_inserts 'titles', @include_timestamp = 1            
            
Example 6: To print the debug information:            
              
  EXEC sp_generate_inserts 'titles', @debug_mode = 1            
       
Example 7:  If you are not the owner of the table, use @owner parameter to specify the owner name            
  To use this option, you must have SELECT permissions on that table            
            
  EXEC sp_generate_inserts Nickstable, @owner = 'Nick'            
            
Example 8:  To generate INSERT statements for the rest of the columns excluding images            
  When using this otion, DO NOT set @include_column_list parameter to 0.            
            
  EXEC sp_generate_inserts imgtable, @ommit_images = 1            
            
Example 9:  To generate INSERT statements excluding (ommiting) IDENTITY columns:            
  (By default IDENTITY columns are included in the INSERT statement)            
            
  EXEC sp_generate_inserts mytable, @ommit_identity = 1            
            
Example 10:  To generate INSERT statements for the TOP 10 rows in the table:            
              
  EXEC sp_generate_inserts mytable, @top = 10            
            
Example 11:  To generate INSERT statements with only those columns you want:            
              
  EXEC sp_generate_inserts titles, @cols_to_include = "'title','title_id','au_id'"            
            
Example 12:  To generate INSERT statements by omitting certain columns:            
              
  EXEC sp_generate_inserts titles, @cols_to_exclude = "'title','title_id','au_id'"            
***********************************************************************************************************/            
            
SET NOCOUNT ON            
            
--Making sure user only uses either @cols_to_include or @cols_to_exclude            
IF ((@cols_to_include IS NOT NULL) AND (@cols_to_exclude IS NOT NULL))            
 BEGIN            
  RAISERROR('Use either @cols_to_include or @cols_to_exclude. Do not specify both',16,1)            
  RETURN -1 --Failure. Reason: Both @cols_to_include and @cols_to_exclude parameters are specified            
 END            
            
--Making sure the @cols_to_include and @cols_to_exclude parameters are receiving values in proper format            
IF ((@cols_to_include IS NOT NULL) AND (PATINDEX('''%''',@cols_to_include) = 0))            
 BEGIN            
  RAISERROR('Invalid use of @cols_to_include property',16,1)            
  PRINT 'Specify column names surrounded by single quotes and separated by commas'            
  PRINT 'Eg: EXEC sp_generate_inserts titles, @cols_to_include = "''title_id'',''title''"'            
  RETURN -1 --Failure. Reason: Invalid use of @cols_to_include property            
 END            
            
IF ((@cols_to_exclude IS NOT NULL) AND (PATINDEX('''%''',@cols_to_exclude) = 0))            
 BEGIN            
  RAISERROR('Invalid use of @cols_to_exclude property',16,1)            
  PRINT 'Specify column names surrounded by single quotes and separated by commas'            
  PRINT 'Eg: EXEC sp_generate_inserts titles, @cols_to_exclude = "''title_id'',''title''"'            
  RETURN -1 --Failure. Reason: Invalid use of @cols_to_exclude property            
 END            
            
            
--Checking to see if the database name is specified along wih the table name            
--Your database context should be local to the table for which you want to generate INSERT statements            
--specifying the database name is now allowed            
IF (parsename(@table_name,3)) IS NOT NULL            
 BEGIN            
  RAISERROR('Do not specify the database name. Be in the required database and just specify the table name.',16,1)            
  RETURN -1 --Failure. Reason: Database name is specified along with the table name, which is not allowed            
 END            
            
--Checking for the existence of 'user table'            
--This procedure is not written to work on system tables            
            
IF @owner IS NULL            
 BEGIN            
  IF (OBJECT_ID(@table_name,'U') IS NULL)             
   BEGIN            
    RAISERROR('User table not found.',16,1)                PRINT 'You may see this error, if you are not the owner of this table. In that case use @owner parameter to specify the owner name.'            
    PRINT 'Make sure you have SELECT permission on that table.'            
    RETURN -1 --Failure. Reason: There is no user table with this name            
   END            
 END            
ELSE            
 BEGIN            
  IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = @table_name AND TABLE_TYPE = 'BASE TABLE' AND TABLE_SCHEMA = @owner)            
   BEGIN            
    RAISERROR('User table not found.',16,1)            
    PRINT 'You may see this error, if you are not the owner of this table. In that case use @owner parameter to specify the owner name.'            
    PRINT 'Make sure you have SELECT permission on that table.'            
    RETURN -1 --Failure. Reason: There is no user table with this name              
   END            
 END            
            
--Variable declarations            
DECLARE @Column_ID int,               
  @Column_List varchar(8000),             
  @Column_Name varchar(128),             
  @Start_Insert varchar(786),             
  @Data_Type varchar(128),             
  @Actual_Values varchar(8000), --This is the string that will be finally executed to generate INSERT statements            
  @IDN varchar(128)    --Will contain the IDENTITY column's name in the table            
            
--Variable Initialization            
SET @IDN = ''            
SET @Column_ID = 0            
SET @Column_Name = 0            
SET @Column_List = ''            
SET @Actual_Values = ''            
IF @owner IS NULL             
 BEGIN            
  SET @Start_Insert = 'INSERT INTO ' + RTRIM(COALESCE(@target_table,@table_name))               
 END            
ELSE            
 BEGIN            
  SET @Start_Insert = 'INSERT ' + LTRIM(RTRIM(@owner)) + '.' + RTRIM(COALESCE(@target_table,@table_name))             
 END            
            
            
--To get the first column's ID            
IF @owner IS NULL            
 BEGIN            
  SELECT @Column_ID = MIN(ORDINAL_POSITION)              
  FROM INFORMATION_SCHEMA.COLUMNS (NOLOCK)             
  WHERE  TABLE_NAME = @table_name            
 END            
ELSE            
 BEGIN            
  SELECT @Column_ID = MIN(ORDINAL_POSITION)              
  FROM INFORMATION_SCHEMA.COLUMNS (NOLOCK)             
  WHERE  TABLE_NAME = @table_name AND            
   TABLE_SCHEMA = @owner              
 END            
            
            
--Loop through all the columns of the table, to get the column names and their data types            
WHILE @Column_ID IS NOT NULL            
 BEGIN            
  IF @owner IS NULL            
   BEGIN            
    SELECT  @Column_Name = COLUMN_NAME,             
    @Data_Type = DATA_TYPE             
    FROM  INFORMATION_SCHEMA.COLUMNS (NOLOCK)             
    WHERE  ORDINAL_POSITION = @Column_ID AND             
    TABLE_NAME = @table_name            
   END            
  ELSE            
   BEGIN            
    SELECT  @Column_Name = COLUMN_NAME,             
    @Data_Type = DATA_TYPE             
    FROM  INFORMATION_SCHEMA.COLUMNS (NOLOCK)             
    WHERE  ORDINAL_POSITION = @Column_ID AND             
    TABLE_NAME = @table_name AND            
    TABLE_SCHEMA = @owner            
   END            
            
  IF @cols_to_include IS NOT NULL --Selecting only user specified columns            
  BEGIN            
   IF CHARINDEX( '''' + SUBSTRING(@Column_Name,2,LEN(@Column_Name)-2) + '''',@cols_to_include) = 0             
   BEGIN            
    GOTO SKIP_LOOP            
   END            
  END            
            
  IF @cols_to_exclude IS NOT NULL --Selecting only user specified columns            
  BEGIN            
   IF CHARINDEX( '''' + SUBSTRING(@Column_Name,2,LEN(@Column_Name)-2) + '''',@cols_to_exclude) <> 0             
   BEGIN            
    GOTO SKIP_LOOP            
   END            
  END            
  --Making sure to output SET IDENTITY_INSERT ON/OFF in case the table has an IDENTITY column            
  IF (SELECT COLUMNPROPERTY( OBJECT_ID(@table_name),SUBSTRING(@Column_Name,2,LEN(@Column_Name) - 2),'IsIdentity')) = 1             
  BEGIN            
   IF @ommit_identity = 0 --Determing whether to include or exclude the IDENTITY column            
    SET @IDN = @Column_Name            
   ELSE            
    GOTO SKIP_LOOP               
  END            
            
            
              
  --Tables with columns of IMAGE data type are not supported for obvious reasons            
  IF(@Data_Type in ('image'))            
   BEGIN            
    IF (@ommit_images = 0)            
     BEGIN            
      RAISERROR('Tables with image columns are not supported.',16,1)            
      PRINT 'Use @ommit_images = 1 parameter to generate INSERTs for the rest of the columns.'            
      PRINT 'DO NOT ommit Column List in the INSERT statements. If you ommit column list using @include_column_list=0, the generated INSERTs will fail.'            
      RETURN -1 --Failure. Reason: There is a column with image data type            
     END            
    ELSE            
     BEGIN            
     GOTO SKIP_LOOP            
     END            
   END            
            
  --Determining the data type of the column and depending on the data type, the VALUES part of            
  --the INSERT statement is generated. Care is taken to handle columns with NULL values. Also            
  --making sure, not to lose any data from flot, real, money, smallmomey, datetime columns            
  SET @Actual_Values = @Actual_Values  +            
  CASE             
   WHEN @Data_Type IN ('char','varchar','nchar','nvarchar')             
    THEN             
     ''''''''' + '+'COALESCE(REPLACE(RTRIM(' + @Column_Name + '),'''''''',''''''''''''),''nvkonc'')' + ' + '''''''''             
   WHEN @Data_Type IN ('datetime','smalldatetime')             
    THEN             
     ''''''''' + '+'COALESCE(RTRIM(CONVERT(char,' + @Column_Name + ',109)),''nvkonc'')' + ' + '''''''''             
   WHEN @Data_Type IN ('uniqueidentifier')             
    THEN              
''''''''' + '+'COALESCE(REPLACE(CONVERT(char(255),RTRIM(' + @Column_Name + ')),'''''''',''''''''''''),''NULL'')' + ' + '''''''''             
   WHEN @Data_Type IN ('text','ntext')             
    THEN              
     ''''''''' + '+'COALESCE(REPLACE(CONVERT(char,' + @Column_Name + '),'''''''',''''''''''''),''NULL'')' + ' + '''''''''             
   WHEN @Data_Type IN ('binary','varbinary')             
    THEN              
     'COALESCE(RTRIM(CONVERT(char,' + 'CONVERT(int,' + @Column_Name + '))),''NULL'')'              
   WHEN @Data_Type IN ('timestamp','rowversion')             
    THEN              
     CASE              
      WHEN @include_timestamp = 0             
       THEN             
        '''DEFAULT'''             
       ELSE             
        'COALESCE(RTRIM(CONVERT(char,' + 'CONVERT(int,' + @Column_Name + '))),''NULL'')'              
     END            
   WHEN @Data_Type IN ('float','real','money','smallmoney')            
    THEN            
     'COALESCE(LTRIM(RTRIM(' + 'CONVERT(char, ' +  @Column_Name  + ',2)' + ')),''NULL'')'             
   ELSE             
    'COALESCE(LTRIM(RTRIM(' + 'CONVERT(char, ' +  @Column_Name  + ')' + ')),''NULL'')'             
  END   + '+' +  ''',''' + ' + '            
              
  --Generating the column list for the INSERT statement            
  SET @Column_List = @Column_List +  @Column_Name + ','             
            
  SKIP_LOOP: --The label used in GOTO            
            
  IF @owner IS NULL            
   BEGIN            
    SELECT  @Column_ID = MIN(ORDINAL_POSITION)             
    FROM  INFORMATION_SCHEMA.COLUMNS (NOLOCK)             
    WHERE  TABLE_NAME = @table_name AND             
    ORDINAL_POSITION > @Column_ID            
   END            
  ELSE            
   BEGIN            
    SELECT  @Column_ID = MIN(ORDINAL_POSITION)             
    FROM  INFORMATION_SCHEMA.COLUMNS (NOLOCK)             
    WHERE  TABLE_NAME = @table_name AND             
    ORDINAL_POSITION > @Column_ID AND            
    TABLE_SCHEMA = @owner            
   END            
 --Loop ends here!            
 END            
            
--To get rid of the extra characters that got concatened during the last run through the loop            
SET @Column_List = LEFT(@Column_List,len(@Column_List) - 1)            
SET @Actual_Values = LEFT(@Actual_Values,len(@Actual_Values) - 6)            
            
--Forming the final string that will be executed, to output the INSERT statements            
IF (@include_column_list <> 0)            
 BEGIN            
  SET @Actual_Values =             
   'SELECT ' +              
   CASE WHEN @top IS NULL OR @top < 0 THEN '' ELSE ' TOP ' + LTRIM(STR(@top)) + ' ' END +             
   '''' + RTRIM(@Start_Insert) +             
   ' ''+' + '''(' + RTRIM(@Column_List) +  '''+' + ''')''' +             
   ' +''VALUES(''+ ' +  'REPLACE(' + @Actual_Values + ',''''''nvkonc'''''',''NULL'')'  + '+'')''' + ' ' +             
   COALESCE(@from,' FROM ' + CASE WHEN @owner IS NULL THEN '' ELSE LTRIM(RTRIM(@owner)) + '.' END + rtrim(@table_name) + '(NOLOCK)')            
 END            
ELSE IF (@include_column_list = 0)            
 BEGIN            
  SET @Actual_Values =             
   'SELECT ' +             
   CASE WHEN @top IS NULL OR @top < 0 THEN '' ELSE ' TOP ' + LTRIM(STR(@top)) + ' ' END +             
   '''' + RTRIM(@Start_Insert) +             
   ' '' +''VALUES(''+ ' +  'REPLACE(' + @Actual_Values + ',''''''nvkonc'''''',''NULL'')'  + '+'')''' + ' ' +             
   COALESCE(@from,' FROM ' + CASE WHEN @owner IS NULL THEN '' ELSE + LTRIM(RTRIM(@owner)) + '.' END + rtrim(@table_name) + '(NOLOCK)')            
 END             
            
--Determining whether to ouput any debug information            
IF @debug_mode =1            
 BEGIN            
  PRINT '/*****START OF DEBUG INFORMATION*****'            
  PRINT 'Beginning of the INSERT statement:'            
  PRINT @Start_Insert            
  PRINT ''            
PRINT 'The column list:'            
  PRINT @Column_List            
  PRINT ''            
  PRINT 'The SELECT statement executed to generate the INSERTs'            
  PRINT @Actual_Values            
  PRINT ''            
  PRINT '*****END OF DEBUG INFORMATION*****/'            
  PRINT ''            
 END            
              
PRINT 'SET NOCOUNT ON'            
            
--Determining whether to print IDENTITY_INSERT or not            
IF (@IDN <> '')            
 BEGIN            
  PRINT 'SET IDENTITY_INSERT ' + RTRIM(COALESCE(@target_table,@table_name)) + ']' + ' ON'            
  PRINT 'GO'            
 END            
            
PRINT 'PRINT ''Inserting values into ' + '[' + RTRIM(COALESCE(@target_table,@table_name)) + ']' + ''''            
            
--All the hard work pays off here!!! You'll get your INSERT statements, when the next line executes!            
EXEC (@Actual_Values)            
            
PRINT 'PRINT ''Done'''            
            
IF (@IDN <> '')            
 BEGIN            
  PRINT 'SET IDENTITY_INSERT ' + '[' + RTRIM(COALESCE(@target_table,@table_name)) + ']' + ' OFF'            
  PRINT 'GO'            
 END            
            
PRINT 'SET NOCOUNT OFF'            
            
SET NOCOUNT OFF            
RETURN 0 --Success. We are done!            
END








GO
/****** Object:  StoredProcedure [dbo].[usp_change_password]    Script Date: 9/2/2022 8:53:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE proc [dbo].[usp_change_password]
@UserId varchar(50),
@Password varchar(255),
@ConfirmPassword varchar(255),
@UpdatedBy varchar(100),
@Code int output,
@Message varchar(max) output
as
begin
	if exists(select * from dbo.tbl_user where [user_id] = @UserId and [password]=@Password)
	begin
		update [dbo].[tbl_user]
		set [password] = @ConfirmPassword,
		updated_by = @UpdatedBy
		where [user_id] = @UserId 
		set @Code = 210
		set @Message = 'Password changed.' 
	end
	else
	begin
		set @Code = 201
		set @Message = 'User not found.' 
	end
end
GO
/****** Object:  StoredProcedure [dbo].[usp_delete_module]    Script Date: 9/2/2022 8:53:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[usp_delete_module]
@Id bigint,
@UpdatedBy varchar(200),
@Code int output,
@Message varchar(max) output
as
begin
	if exists(select * from [dbo].[tbl_module] where module_id = @id)
	begin
		update [dbo].[tbl_module]
		set is_deleted = 1,
		is_active = 0
		where module_id = @Id

		set @Code = 207
		set @message = 'Module deleted.'
	end
	else
	begin
		set @Code = 201
		set @message = 'Module does not exists'
	end
end







GO
/****** Object:  StoredProcedure [dbo].[usp_delete_user]    Script Date: 9/2/2022 8:53:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[usp_delete_user]
@UserId varchar(200),
@DeletedBy varchar(200),
@Code int output,
@Message varchar(max) output
as
begin
	if exists(select * from [dbo].[tbl_user] where [user_id] = @UserId)
	begin
		update [dbo].[tbl_user]
		set is_deleted = 1,
		updated_date = GETDATE(),
		updated_by = @DeletedBy
		where [user_id] = @UserId
		and is_active = 1
		AND is_deleted = 0

		set @Code = 207
		set @message = 'User deleted'
	end
	else
	begin		
		set @Code = 201
		set @message = 'User does not exists'
	end
end







GO
/****** Object:  StoredProcedure [dbo].[usp_export_users]    Script Date: 9/2/2022 8:53:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*
	exec usp_export_users
*/

CREATE PROCEDURE [dbo].[usp_export_users]
AS 
BEGIN
	SELECT [user_id],
		first_name + ' '+ last_name as [name],
		email,
		department_name = (select [name] from [dbo].[tbl_department] where id = department_id),
		mobile,
		roles 
	FROM tbl_user 
	where Is_Active = 1 
	and Is_Deleted = 0
	order by id asc
END







GO
/****** Object:  StoredProcedure [dbo].[usp_insert_module]    Script Date: 9/2/2022 8:53:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[usp_insert_module]
@Name varchar(200),
@CreatedBy varchar(200),
@Code int output,
@Message varchar(max) output
as
begin
	if exists(select * from [dbo].[tbl_module] where module_name = ltrim(rtrim((@Name))))
	begin
		set @Code = 204
		set @message = 'Module already exists.'
	end
	else
	begin
		insert into [dbo].[tbl_module](module_name,Created_Date,Created_By)
		values(@Name, getdate(), @CreatedBy)
		set @Code = 202
		set @message = 'Module created.'
	end
end







GO
/****** Object:  StoredProcedure [dbo].[usp_insert_token]    Script Date: 9/2/2022 8:53:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[usp_insert_token]
@UserId varchar(20),
@Token varchar(max)
as
begin
	insert into [dbo].[tbl_user_token]([user_id], Token, Created_Date, Created_By)
	values(@UserId, @Token, getdate(), @UserId)
end








GO
/****** Object:  StoredProcedure [dbo].[usp_insert_user]    Script Date: 9/2/2022 8:53:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[usp_insert_user]
--@UserId varchar(200),
@UserName varchar(100),
@Password varchar(200),
@Email varchar(200),
@Mobile varchar(10),
@City varchar(50),
@IPAdress varchar(50),
--@CreateBy varchar(200),
@Code int output,
@Message varchar(max) output
as
begin
	if exists(select * from [dbo].[tbl_user] where [user_id] = @Mobile)
	begin
		set @Code = 204
		set @message = 'UserId already exists.'
	end
	else
	begin
		insert into [dbo].[tbl_user]([user_id],user_name,Password,Email,Mobile,Roles,Created_Date,Created_By,city,IPAdress)
		values(@Mobile,@UserName, @Password, @Email, @Mobile, '2', getdate(), @Mobile,@City,@IPAdress)
		set @Code = 202
		set @message = 'User created'
	end
end






GO
/****** Object:  StoredProcedure [dbo].[usp_logoff]    Script Date: 9/2/2022 8:53:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[usp_logoff]
@UserId varchar(50),
@Code int output,
@Message varchar(max) output
as
begin
	update [dbo].[tbl_user_token]
	set is_deleted = 1
	where [user_id] = @UserId
	set @Code =  210
	set @Message = 'Logoff'
end







GO
/****** Object:  StoredProcedure [dbo].[usp_reset_password]    Script Date: 9/2/2022 8:53:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[usp_reset_password]
@UserId varchar(50),
@Password varchar(255),
@ResetToken varchar(255),
@UpdatedBy varchar(100),
@Code int output,
@Message varchar(max) output
as
begin
	if exists(select * from dbo.tbl_user where [user_id] = @UserId)
		begin
		update [dbo].[tbl_user]
		set [password] = @Password,
		updated_by = @UpdatedBy
		where [user_id] = @UserId 

		set @Code = 210
		set @Message = 'Password reset.' 
	end
	else
	begin
		set @Code = 201
		set @Message = 'User not found.' 
	end
end







GO
/****** Object:  StoredProcedure [dbo].[usp_select_gamecatbyid]    Script Date: 9/2/2022 8:53:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create proc [dbo].[usp_select_gamecatbyid]
@GameTypeId bigint
as
begin
	Select * from tblGameCategory where GameTypeId=@GameTypeId
end
GO
/****** Object:  StoredProcedure [dbo].[usp_select_GameSubCategorybyId]    Script Date: 9/2/2022 8:53:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create proc [dbo].[usp_select_GameSubCategorybyId]
@GameCategoryId bigint
as
begin
	Select * from tblGameSubCategory where GameCategeryId=@GameCategoryId
end
GO
/****** Object:  StoredProcedure [dbo].[usp_select_gametype]    Script Date: 9/2/2022 8:53:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create proc [dbo].[usp_select_gametype]
as
begin
	select *
	from tblGameType where isactive=1
end
GO
/****** Object:  StoredProcedure [dbo].[usp_select_grid]    Script Date: 9/2/2022 8:53:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*	
exec usp_select_grid 
22, 
10, 
1, 
' where product in (''Reinstate Audit report'') and policy_status in (''open'')  ',
' order by id desc'
*/

CREATE proc [dbo].[usp_select_grid]
@TemplateId int,
@PageSize int,
@CurrentPage int,
@WhereClause varchar(max) = null,
@OrderByClause varchar(max)
--@output_query varchar(max) output
as
begin
	set nocount on;	
	--declare @TemplateId int
	--declare @PageSize int
	--declare @CurrentPage int
	--declare @WhereClause varchar(max) = null
	--declare @OrderByClause varchar(max)

	--set @TemplateId = 22
	--set @PageSize = 10
	--set @CurrentPage =  1
	--set @WhereClause ='  where product in (''Reinstate Audit report'') and policy_status in (''open'') '
	--set @OrderByClause = ' order by id desc'

	if @WhereClause is null set @WhereClause = ''

	-- get table by template id	
	declare @associated_table varchar(255)
	select @associated_table = associated_table 
	from tbl_report_templates  
	where template_id = @TemplateId

	-- get records after filter
	declare @query nvarchar(max)
	set @query = 'select top '+ cast(@PageSize as varchar(255))+' * from '
	+ @associated_table +''+ @WhereClause +'' +@OrderByClause
	--set @output_query = @query
	exec(@query)
	
	----get row count after filter
	declare @output int
	declare @ParmDefinition nvarchar(500);
	set @query = N'select @out = count(*) from dbo.tbl_report_mortality' + @WhereClause
	SET @ParmDefinition = N'@out int OUTPUT'
	exec sp_executesql @query, @ParmDefinition , @out = @output OUTPUT;
	select @output as [RowCount]

	---- get current page
	select CEILING(@output/cast(@PageSize as DECIMAL (18,3))) as [PageCount]
	select @CurrentPage [CurrentPage]
end


--declare @query1 nvarchar(max)

--declare @WhereClause nvarchar(max)
--set @WhereClause = ' where product in (''Reinstate Audit report'') and policy_status in (''open'')'

--declare @OrderByClause nvarchar(max)
--set @OrderByClause = ' order by id desc'

--set @query1 = 'select top 100 * from dbo.tbl_report_mortality' + '' + @WhereClause + '' + @OrderByClause
--print(@query1)











GO
/****** Object:  StoredProcedure [dbo].[usp_select_modules]    Script Date: 9/2/2022 8:53:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[usp_select_modules]
as
begin
	select module_id, module_name from dbo.tbl_module
	where is_active = 1
	and is_deleted = 0
end







GO
/****** Object:  StoredProcedure [dbo].[usp_select_onlineuser]    Script Date: 9/2/2022 8:53:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[usp_select_onlineuser]
as
begin
	select count(*) as [count] from [dbo].[tbl_user_token]
end







GO
/****** Object:  StoredProcedure [dbo].[usp_select_rolebyuserid]    Script Date: 9/2/2022 8:53:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[usp_select_rolebyuserid]
@UserId varchar(200)
as
begin
	select r.Name as RoleName 
	from [dbo].[tbl_user_roles] ur
	inner join [dbo].[tbl_roles] r on ur.Role_Id = r.Id
	where ur.[user_id] = @UserId
end
GO
/****** Object:  StoredProcedure [dbo].[usp_select_tokenbyuserid]    Script Date: 9/2/2022 8:53:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[usp_select_tokenbyuserid]
@UserId varchar(20)
as
begin
	if exists(select * from [dbo].[tbl_user_token] where [user_id] = @UserId and Is_Active = 1)
	begin
		select Token from [dbo].[tbl_user_token] where [user_id] = @UserId and Is_Active = 1
	end
	else 
	begin
		select ''
	end
end









GO
/****** Object:  StoredProcedure [dbo].[usp_select_user]    Script Date: 9/2/2022 8:53:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*
	exec usp_select_user null, 0, 10, null, null

*/


CREATE PROCEDURE [dbo].[usp_select_user]
(
	@SearchValue NVARCHAR(50) = NULL,
	@PageNo INT = 1,
	@PageSize INT = 10,
	@SortColumn NVARCHAR(20) = 'user_id',
	@SortOrder NVARCHAR(20) = 'ASC'
)
 AS 
 BEGIN
 
 SET NOCOUNT ON;

	if  @PageNo <= 0 set @PageNo  = 1

	if @PageSize <= 0 set @PageSize = 10

 SET @SearchValue = LTRIM(RTRIM(@SearchValue))

 ; WITH CTE_Results AS 
(
	SELECT [user_id],
		first_name + ' '+ last_name as [name],
		email,
		department_name = (select [name] from [dbo].[tbl_department] where id = department_id),
		mobile,
		roles 
	FROM tbl_user 
	where Is_Active = 1 
	and Is_Deleted = 0
	and (@SearchValue IS NULL OR [user_id] LIKE '%' + @SearchValue + '%') 
	ORDER BY
   		CASE WHEN (@SortColumn = 'user_id' AND @SortOrder='ASC') 
			THEN [user_id]
        END ASC,
        CASE WHEN (@SortColumn = 'user_id' AND @SortOrder='DESC')
			THEN [user_id]
		END DESC,
		CASE WHEN (@SortColumn = 'email' AND @SortOrder='ASC')
			THEN [email]
        END ASC,
        CASE WHEN (@SortColumn = 'email' AND @SortOrder='DESC')
			THEN [email]
		END DESC 

      OFFSET @PageSize * (@PageNo - 1) ROWS
      FETCH NEXT @PageSize ROWS ONLY
	)

   Select t.* from CTE_Results as t
      
   select count(*) as [count]
	FROM tbl_user 
	where Is_Active = 1 
	and Is_Deleted = 0 


   OPTION (RECOMPILE)
   END







GO
/****** Object:  StoredProcedure [dbo].[usp_select_userbyuserid]    Script Date: 9/2/2022 8:53:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*
	exec usp_select_userbyuserid 'dfsdfsdf', '1'
*/

CREATE PROCEDURE [dbo].[usp_select_userbyuserid]
	@UserId nvarchar(50),
	@Password nvarchar(max)
AS
BEGIN
	SET NOCOUNT ON;

	SELECT * FROM tbl_User
	WHERE [user_id] = @UserId
	and Password = @Password
	and Is_Active = 1
	and Is_Deleted = 0

	SELECT m.id, m.display_name, 
	replace(concat('/', m.controller,'/', m.action), '//','') as url, 
	m.parent_id
	FROM [dbo].[tbl_user_roles] ur
	inner join [dbo].[tbl_role_menu] rm on ur.role_id = rm.role_id
	inner join [dbo].[tbl_menu] m on m.id = rm.menu_id
	where ur.[user_id] = @UserId
END










GO
/****** Object:  StoredProcedure [dbo].[usp_update_module]    Script Date: 9/2/2022 8:53:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[usp_update_module]
@Id bigint,
@Name varchar(200),
@UpdatedBy varchar(200),
@Code int output,
@Message varchar(max) output
as
begin
	if exists(select * from [dbo].[tbl_module] where module_id = @Id)
	begin
		update [dbo].[tbl_module]
		set module_name = @Name
		where module_id = @Id
		set @Code = 205
		set @message = 'Module updated.'
	end
	else
	begin
		set @Code = 201
		set @message = 'Module does not exists.'
	end
end







GO
/****** Object:  StoredProcedure [dbo].[usp_update_user]    Script Date: 9/2/2022 8:53:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[usp_update_user]
@Id bigint,
@EmailID varchar(200),
@Name varchar(200),
@UpdateBy varchar(100),
@Code int output,
@Message varchar(max) output
as
begin
	if exists(select * from [dbo].[tbl_user] where id = @Id)
	begin
		update [dbo].[tbl_user]
		set user_name = @Name,email=@EmailID,updated_by=@UpdateBy,updated_date=getdate()
		where id = @Id
		set @Code = 205
		set @message = 'User updated.'
	end
	else
	begin
		set @Code = 201
		set @message = 'User does not exists.'
	end
end
GO
/****** Object:  StoredProcedure [dbo].[usp_user_deposit_amount]    Script Date: 9/2/2022 8:53:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[usp_user_deposit_amount]
@Id bigint = NULL,
@UserId varchar(200) = NULL,
@DepositAmount money = NULL,
@PaymentScreenShot varchar(200) = NULL,
@PaymentModeId int = NULL,
@Status varchar(50)= NULL,
@ApprovedAmount money= NULL,
@Remarks varchar(500)= NULL,
@isActive bit = NULL,
@isDeleted bit = NULL,
@StatementType NVARCHAR(20) = '',
@Code int output,
@Message varchar(max) output
AS
BEGIN
	IF @StatementType = 'Insert'
		BEGIN
			insert into [dbo].[tblUserAmountDeposit]([UserId],DepositAmount,PaymentScreenShot,PaymentModeId,[Status],ApprovedAmount,Remarks, isActive,isDeleted, CreatedDate,CreatedBy,UpdatedDate, UpdatedBy)
			values(@UserId, @DepositAmount, Convert(varbinary(max), @PaymentScreenShot), @PaymentModeId, @Status, @ApprovedAmount, @Remarks, @isActive, @isDeleted, getdate(), @UserId, getdate(), @UserId)
			set @Code = 202
			set @message = 'User Amount Deposited'
		END
	 IF @StatementType = 'Select'
        BEGIN
            SELECT Id, UserId, (Select userName from tblUserMaster where userId = @UserId) as UserName, DepositAmount, PaymentScreenShot, PaymentModeId,			
			PaymentModeId = (select payment_name from [dbo].[tbl_payment_mode] where id = @PaymentModeId),
			[Status],ApprovedAmount,Remarks, isActive,isDeleted, CreatedDate,
			CreatedBy =  (select userName from [dbo].[tblUserMaster] where userId = @UserId),
			UpdatedDate, 
			UpdatedBy =(select [userName] from [dbo].[tblUserMaster] where userId = @UserId)
            FROM  tblUserAmountDeposit 
        END
		IF @StatementType = 'Recent'
        BEGIN
            SELECT Top 5 Id, UserId, (Select userName from tblUserMaster where userId = @UserId) as UserName, DepositAmount, PaymentScreenShot, PaymentModeId,			
			--PaymentModeId = (select payment_name from [dbo].[tbl_payment_mode] where id = @PaymentModeId),
			[Status],ApprovedAmount,Remarks, isActive,isDeleted, CreatedDate,
			CreatedBy =  (select userName from [dbo].[tblUserMaster] where userId = @UserId),
			UpdatedDate, 
			UpdatedBy =(select [userName] from [dbo].[tblUserMaster] where userId = @UserId)
            FROM  tblUserAmountDeposit order by CreatedDate desc
        END
		IF @StatementType = 'Select By UserId'
        BEGIN
            SELECT Id, UserId,  UserName = (Select userName from tblUserMaster where userId = @UserId), DepositAmount, PaymentScreenShot, PaymentModeId,			
			PaymentModeId = (select payment_name from [dbo].[tbl_payment_mode] where id = @PaymentModeId),
			[Status],ApprovedAmount,Remarks, isActive,isDeleted, CreatedDate,
			CreatedBy =  (select userName from [dbo].[tblUserMaster] where userId = @UserId),
			UpdatedDate, 
			UpdatedBy =(select [userName] from [dbo].[tblUserMaster] where userId = @UserId)
            FROM  tblUserAmountDeposit where UserId = @UserId order by CreatedDate desc
        END
		IF @StatementType = 'Select By RecordId'
        BEGIN
            SELECT Id, UserId,  UserName = (Select userName from tblUserMaster where userId = @UserId), DepositAmount, PaymentScreenShot, PaymentModeId,			
			PaymentModeId = (select payment_name from [dbo].[tbl_payment_mode] where id = @PaymentModeId),
			[Status],ApprovedAmount,Remarks, isActive,isDeleted, CreatedDate,
			CreatedBy =  (select userName from [dbo].[tblUserMaster] where userId = @UserId),
			UpdatedDate, 
			UpdatedBy =(select [userName] from [dbo].[tblUserMaster] where userId = @UserId)
            FROM  tblUserAmountDeposit where Id = @Id
        END
	IF @StatementType = 'Update'
        BEGIN
			IF exists(select * from [dbo].[tblUserAmountDeposit] where Id = @Id and isApproved = 0)
				BEGIN
					UPDATE tblUserAmountDeposit
					SET    DepositAmount = @DepositAmount,
						   PaymentScreenShot = Convert(varbinary(max), @PaymentScreenShot),
						   PaymentModeId = @PaymentModeId,
						   [Status] = @Status,
						   ApprovedAmount = @ApprovedAmount,
						   Remarks = @Remarks,
						   isActive = @isActive,       
						   isDeleted = @isDeleted,
						   UpdatedDate = getdate(),
						   UpdatedBy= @UserId
					WHERE  Id = @Id					
					set @Code = 205
					set @message = 'Deposit Amount Module updated.'
				END
			ELSE
				BEGIN
					set @Code = 201
					set @message = 'Module does not exists.'
				END
        END
     ELSE IF @StatementType = 'Delete'
        BEGIN
            DELETE FROM tblUserAmountDeposit
            WHERE  Id = @Id

			set @Code = 207
			set @message = 'User Deposit Amount deleted'
        END
	
END






GO
/****** Object:  StoredProcedure [dbo].[usp_user_game_selection_submit]    Script Date: 9/2/2022 8:53:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_user_game_selection_submit] 
	-- Add the parameters for the stored procedure here
	@UserId as bigint,
	@GameTypeId as bigint, 
	@GameTypeName as varchar(50),
	@GameCategoryId as bigint,
	@CategoryName as varchar(50),
    @GameSubCategoryId  as bigint, 
	@GameSubCategoryName as varchar(50),  
	@NumberType as varchar(50), 
	@Amount as money, 
	@BetNumbers as varchar(200),
	@BetAmounts as varchar(200) 
AS
BEGIN
	INSERT INTO [dbo].[tblGameSelectionDetails]
        ([UserId],[GameTypeId],[GameTypeName],[GameCategoryId],[CategoryName]
        ,[GameSubCategoryId],[GameSubCategoryName],[NumberType],[Amount],[BetNumbers]
		,[BetAmounts],[isActive],[isDeleted],[CreatedDate],[CreatedBy],[UpdatedDate],[UpdatedBy])
	VALUES (@UserId, @GameTypeId, @GameTypeName, @GameCategoryId, @CategoryName, @GameSubCategoryId, @GameSubCategoryName, @NumberType, @Amount
		, @BetNumbers, @BetAmounts, 1, 0, getdate(), @UserId, getdate(), @UserId)

	DECLARE @LASTID as bigint

	Set @LASTID = @@IDENTITY

	INSERT INTO [dbo].[tblBettingDetails]
		([BetNumber],[BetAmount],[GameSelectionId],[UserId],[isActive],[isDeleted],[CreatedDate],[CreatedBy],[UpdatedDate],[UpdatedBy])
	SELECT  distinct b.Item as  BetNumber , c.Item as BetAmount,a.GameSelectionId,  a.UserId, 1, 0, getdate(), a.UserId, getdate(), a.UserId
	FROM tblGameSelectionDetails a
	CROSS APPLY dbo.SplitString(a.BetNumbers,',' ) b  
	CROSS APPLY dbo.SplitString(a.BetAmounts,',' ) c
	Where a.GameSelectionId = @LASTID


END



GO
/****** Object:  StoredProcedure [dbo].[usp_user_withdraw_amount]    Script Date: 9/2/2022 8:53:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create proc [dbo].[usp_user_withdraw_amount]
@Id bigint = NULL,
@UserId varchar(200) = NULL,
@RequestedAmount money = NULL,
@Status varchar(50)= NULL,
@ApprovedAmount money= NULL,
@PaymentModeId int = NULL,
@GameTypeId bigint =NULL,
@GameSubTypeId bigint = NULL,
@Remarks varchar(500)= NULL,
@isActive bit = NULL,
@isDeleted bit = NULL,
@StatementType NVARCHAR(20) = '',
@Code int output,
@Message varchar(max) output
AS
BEGIN
	IF @StatementType = 'Insert'
		BEGIN
			insert into [dbo].[tblUserWithdrawDetails](UserId, RequestedAmount, [Status], PaymentModeId, GameTypeId,  GameSubTypeId, Remarks, isActive,isDeleted, CreatedDate,CreatedBy,UpdatedDate, UpdatedBy)
			values (@UserId, @RequestedAmount, @Status , @PaymentModeId, @GameTypeId, @GameSubTypeId, '', @isActive, @isDeleted, getdate(), @UserId, getdate(), @UserId)
			set @Code = 202
			set @message = 'User Withdraw Amount Request'
		END
	 IF @StatementType = 'Select'
        BEGIN
            SELECT Id, UserId, RequestedAmount, PaymentModeId,			
			PaymentModeId = (select payment_name from [dbo].[tbl_payment_mode] where id = @PaymentModeId),
			[Status],ApprovedAmount,Remarks, isActive,isDeleted, CreatedDate,
			CreatedBy =  (select [user_name] from [dbo].[tbl_user] where id = @UserId),
			UpdatedDate, 
			UpdatedBy =(select [user_name] from [dbo].[tbl_user] where id = @UserId)
            FROM  tblUserWithdrawDetails
        END
	IF @StatementType = 'Update'
        BEGIN
			IF exists(select * from [dbo].[tblUserWithdrawDetails] where Id = @Id)
				BEGIN
					UPDATE tblUserWithdrawDetails
					SET    RequestedAmount = @RequestedAmount,
						   ApprovedAmount = @ApprovedAmount,
						   PaymentModeId = @PaymentModeId,
						   GameTypeId = @GameTypeId,
						   GameSubTypeId = @GameSubTypeId,
						   [Status] = @Status,						   
						   Remarks = @Remarks,
						   isActive = @isActive,       
						   isDeleted = @isDeleted,
						   UpdatedDate = getdate(),
						   UpdatedBy= @UserId
					WHERE  Id = @Id
					set @Code = 205
					set @message = 'Withdraw Amount Module updated.'
				END
			ELSE
				BEGIN
					set @Code = 201
					set @message = 'Module does not exists.'
				END
        END
     ELSE IF @StatementType = 'Delete'
        BEGIN
            DELETE FROM tblUserWithdrawDetails
            WHERE  Id = @Id

			set @Code = 207
			set @message = 'User Deposit Amount deleted'
        END
	
END


 







GO
/****** Object:  StoredProcedure [dbo].[usp_verify_policy]    Script Date: 9/2/2022 8:53:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

	--drop proc [dbo].[usp_update_policy_status]

create proc [dbo].[usp_verify_policy]
@PolicyIds varchar(max),
@Status int,
@Remarks varchar(max),
@DepartmentId bigint,
@UpdatedBy	varchar(200),
@Code int output,
@Message varchar(max) output
as
set nocount on;
set	xact_abort on;	
begin try
	begin transaction
	insert into [dbo].[tbl_report_mortality_history]
	select * from [dbo].[tbl_report_mortality]
	where [policy] in (SELECT [value] FROM dbo.SplitString(@PolicyIds,','))
	 
	update [dbo].[tbl_report_mortality]
	set policy_status = @Status,
	remarks = @Remarks,
	department_id = @DepartmentId,
	updated_date = GETDATE(),
	updated_by = @UpdatedBy
	where [policy] in (SELECT [value] FROM dbo.SplitString(@PolicyIds,''))

	set @code = 205
	set @Message = 'Policy updated.'
	commit transaction;
end try
begin catch
	if @@TRANCOUNT > 0
	begin
		rollback transaction;
	end
	set @Code = 500
	set @message = error_message()
end catch







GO
/****** Object:  UserDefinedFunction [dbo].[SplitString]    Script Date: 9/2/2022 8:53:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[SplitString]
(    
    @Input NVARCHAR(MAX),
    @Character CHAR(1)
)
RETURNS @Output TABLE (
    Item NVARCHAR(1000)
)
AS
BEGIN
    DECLARE @StartIndex INT, @EndIndex INT
 
    SET @StartIndex = 1
    IF SUBSTRING(@Input, LEN(@Input) - 1, LEN(@Input)) <> @Character
    BEGIN
        SET @Input = @Input + @Character
    END
 
    WHILE CHARINDEX(@Character, @Input) > 0
    BEGIN
        SET @EndIndex = CHARINDEX(@Character, @Input)
         
        INSERT INTO @Output(Item)
        SELECT SUBSTRING(@Input, @StartIndex, @EndIndex - 1)
         
        SET @Input = SUBSTRING(@Input, @EndIndex + 1, LEN(@Input))
    END
 
    RETURN
END



GO
/****** Object:  Table [dbo].[Product]    Script Date: 9/2/2022 8:53:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Product](
	[ProductID] [int] NOT NULL,
	[ProductType] [varchar](30) NULL,
	[Code] [varchar](30) NULL,
	[Name] [varchar](30) NULL,
	[Brand] [varchar](30) NULL,
	[Description] [varchar](max) NULL,
	[CostPrice] [varchar](30) NULL,
	[RetailPrice] [varchar](30) NULL,
	[SalePrice] [varchar](30) NULL,
	[CalculatedPrice] [varchar](30) NULL,
	[FixedShippingPrice] [varchar](30) NULL,
	[FreeShipping] [bit] NULL,
	[AllowPurchases] [bit] NULL,
	[ProductVisible] [bit] NULL,
	[ProductAvailability] [bit] NULL,
	[ProductInventoried] [bit] NULL,
	[StockLevel] [varchar](30) NULL,
	[LowStockLevel] [varchar](30) NULL,
	[CategoryDetails] [varchar](500) NULL,
	[Images] [varchar](500) NULL,
	[PageTitle] [varchar](50) NULL,
	[METAKeywords] [varchar](500) NULL,
	[METADescription] [varchar](500) NULL,
	[ProductCondition] [varchar](30) NULL,
	[ProductURL] [varchar](500) NULL,
	[RedirectOldURL] [varchar](500) NULL,
	[ProductTaxCode] [varchar](30) NULL,
	[ProductCustomFields] [varchar](30) NULL,
 CONSTRAINT [PK_Product] PRIMARY KEY CLUSTERED 
(
	[ProductID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tbl_menu]    Script Date: 9/2/2022 8:53:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tbl_menu](
	[id] [bigint] IDENTITY(1,1) NOT NULL,
	[display_name] [varchar](255) NOT NULL,
	[url] [varchar](max) NULL,
	[controller] [varchar](100) NULL,
	[action] [varchar](100) NULL,
	[parent_id] [bigint] NULL,
	[created_date] [datetime] NOT NULL,
	[created_by] [varchar](200) NOT NULL,
	[updated_date] [datetime] NULL,
	[updated_by] [varchar](200) NULL,
	[is_active] [bit] NOT NULL,
	[is_deleted] [bit] NOT NULL,
 CONSTRAINT [PK_tbl_menu] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tbl_module]    Script Date: 9/2/2022 8:53:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tbl_module](
	[module_id] [bigint] IDENTITY(1,1) NOT NULL,
	[module_name] [varchar](200) NULL,
	[created_date] [datetime] NOT NULL,
	[created_by] [varchar](200) NOT NULL,
	[updated_date] [datetime] NULL,
	[updated_by] [varchar](200) NULL,
	[is_active] [bit] NOT NULL,
	[is_deleted] [bit] NOT NULL,
 CONSTRAINT [PK_tbl_module] PRIMARY KEY CLUSTERED 
(
	[module_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tbl_payment_mode]    Script Date: 9/2/2022 8:53:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tbl_payment_mode](
	[id] [bigint] IDENTITY(1,1) NOT NULL,
	[payment_name] [varchar](50) NULL,
	[created_date] [datetime] NOT NULL,
	[created_by] [varchar](200) NOT NULL,
	[updated_date] [datetime] NULL,
	[updated_by] [varchar](200) NULL,
	[is_active] [bit] NOT NULL,
	[is_deleted] [bit] NOT NULL,
 CONSTRAINT [PK_payment_mode] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tbl_role_menu]    Script Date: 9/2/2022 8:53:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tbl_role_menu](
	[id] [bigint] IDENTITY(1,1) NOT NULL,
	[role_id] [bigint] NOT NULL,
	[menu_id] [bigint] NOT NULL,
	[created_date] [datetime] NOT NULL,
	[created_by] [varchar](200) NOT NULL,
	[updated_date] [datetime] NULL,
	[updated_by] [varchar](200) NULL,
	[is_active] [bit] NOT NULL,
	[is_deleted] [bit] NOT NULL,
 CONSTRAINT [PK_tbl_role_menu] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tbl_roles]    Script Date: 9/2/2022 8:53:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tbl_roles](
	[id] [bigint] IDENTITY(1,1) NOT NULL,
	[name] [varchar](50) NOT NULL,
	[created_date] [datetime] NOT NULL,
	[created_by] [varchar](200) NOT NULL,
	[updated_date] [datetime] NULL,
	[updated_by] [varchar](200) NULL,
	[is_active] [bit] NOT NULL,
	[is_deleted] [bit] NOT NULL,
 CONSTRAINT [PK__tbl_Role__3214EC07637325BE] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tbl_user]    Script Date: 9/2/2022 8:53:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tbl_user](
	[id] [bigint] IDENTITY(1,1) NOT NULL,
	[user_id] [varchar](200) NOT NULL,
	[user_name] [varchar](200) NULL,
	[password] [varchar](200) NOT NULL,
	[email] [varchar](30) NULL,
	[mobile] [varchar](10) NOT NULL,
	[roles] [varchar](255) NOT NULL,
	[created_date] [datetime] NOT NULL,
	[created_by] [varchar](200) NOT NULL,
	[updated_date] [datetime] NULL,
	[updated_by] [varchar](200) NULL,
	[is_active] [bit] NOT NULL,
	[is_deleted] [bit] NOT NULL,
	[city] [varchar](50) NULL,
	[IPAdress] [varchar](50) NULL,
 CONSTRAINT [PK__tbl_User__3214EC07CC0B1483] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tbl_user_roles]    Script Date: 9/2/2022 8:53:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tbl_user_roles](
	[user_role_id] [bigint] IDENTITY(1,1) NOT NULL,
	[user_id] [varchar](50) NOT NULL,
	[role_id] [bigint] NOT NULL,
	[created_date] [datetime] NOT NULL,
	[created_by] [varchar](200) NOT NULL,
	[updated_date] [datetime] NULL,
	[updated_by] [varchar](200) NULL,
	[is_active] [bit] NOT NULL,
	[is_deleted] [bit] NOT NULL,
 CONSTRAINT [PK_UserRoles] PRIMARY KEY CLUSTERED 
(
	[user_role_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tbl_user_token]    Script Date: 9/2/2022 8:53:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tbl_user_token](
	[id] [bigint] IDENTITY(1,1) NOT NULL,
	[user_id] [varchar](200) NULL,
	[token] [varchar](max) NULL,
	[created_date] [datetime] NOT NULL,
	[created_by] [varchar](200) NULL,
	[update_date] [datetime] NULL,
	[updated_by] [varchar](200) NULL,
	[is_active] [bit] NOT NULL,
	[is_deleted] [bit] NOT NULL,
 CONSTRAINT [PK_tbl_Token] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblBettingDetails]    Script Date: 9/2/2022 8:53:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblBettingDetails](
	[GameBettingId] [bigint] IDENTITY(1,1) NOT NULL,
	[GameSelectionId] [bigint] NULL,
	[UserId] [bigint] NULL,
	[BetNumber] [int] NULL,
	[BetAmount] [money] NULL,
	[isActive] [bit] NULL,
	[isDeleted] [bit] NULL,
	[CreatedDate] [datetime] NULL,
	[CreatedBy] [bigint] NULL,
	[UpdatedDate] [datetime] NULL,
	[UpdatedBy] [bigint] NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[tblGameCategory]    Script Date: 9/2/2022 8:53:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblGameCategory](
	[GameCategoryId] [bigint] IDENTITY(1,1) NOT NULL,
	[GameTypeId] [bigint] NOT NULL,
	[CategoryName] [varchar](50) NULL,
	[bidRate] [int] NOT NULL,
	[isActive] [bit] NULL,
	[CreatedBy] [varchar](50) NULL,
	[UpdatedBy] [varchar](50) NULL,
	[UpdatedDate] [datetime] NULL,
	[CreatedDate] [datetime] NULL,
 CONSTRAINT [PK_tblGameCategory] PRIMARY KEY CLUSTERED 
(
	[GameCategoryId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblGameSelectionDetails]    Script Date: 9/2/2022 8:53:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblGameSelectionDetails](
	[GameSelectionId] [bigint] IDENTITY(1,1) NOT NULL,
	[UserId] [bigint] NULL,
	[GameTypeId] [bigint] NULL,
	[GameTypeName] [varchar](50) NULL,
	[GameCategoryId] [bigint] NULL,
	[CategoryName] [varchar](50) NULL,
	[GameSubCategoryId] [bigint] NULL,
	[GameSubCategoryName] [varchar](50) NULL,
	[NumberType] [varchar](50) NULL,
	[Amount] [money] NULL,
	[BetNumbers] [varchar](50) NULL,
	[BetAmounts] [varchar](50) NULL,
	[isActive] [bit] NULL,
	[isDeleted] [bit] NULL,
	[CreatedDate] [datetime] NULL,
	[CreatedBy] [bigint] NULL,
	[UpdatedDate] [datetime] NULL,
	[UpdatedBy] [bigint] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblGameSubCategory]    Script Date: 9/2/2022 8:53:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblGameSubCategory](
	[GameSubCategoryId] [bigint] IDENTITY(1,1) NOT NULL,
	[GameCategeryId] [bigint] NOT NULL,
	[SubCategoryName] [varchar](50) NULL,
	[bidRate] [int] NOT NULL,
	[isActive] [bit] NULL,
 CONSTRAINT [PK_tblGameSubCategory] PRIMARY KEY CLUSTERED 
(
	[GameSubCategoryId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblGameType]    Script Date: 9/2/2022 8:53:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblGameType](
	[GameTypeId] [bigint] IDENTITY(1,1) NOT NULL,
	[GameName] [varchar](50) NULL,
	[StartDate] [datetime] NULL,
	[EndDate] [datetime] NULL,
	[isActive] [bit] NULL,
	[CreatedBy] [varchar](50) NULL,
	[UpdatedBy] [varchar](50) NULL,
	[CreatedDate] [datetime] NULL,
	[updatedDate] [datetime] NULL,
 CONSTRAINT [PK_tblGameType] PRIMARY KEY CLUSTERED 
(
	[GameTypeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblUserAmountDeposit]    Script Date: 9/2/2022 8:53:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblUserAmountDeposit](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[UserId] [bigint] NOT NULL,
	[DepositAmount] [money] NULL,
	[PaymentScreenShot] [varbinary](max) NULL,
	[PaymentModeId] [bigint] NULL,
	[Status] [varchar](50) NULL,
	[ApprovedAmount] [money] NULL,
	[isApproved] [bit] NOT NULL,
	[Remarks] [varchar](500) NULL,
	[isActive] [bit] NULL,
	[isDeleted] [bit] NULL,
	[CreatedDate] [datetime] NULL,
	[CreatedBy] [bigint] NULL,
	[UpdatedDate] [datetime] NULL,
	[UpdatedBy] [bigint] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblUserMaster]    Script Date: 9/2/2022 8:53:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblUserMaster](
	[userId] [bigint] IDENTITY(1,1) NOT NULL,
	[userName] [varchar](50) NULL,
	[userEmailId] [varchar](50) NULL,
	[userMobileNo] [varchar](10) NOT NULL,
	[Password] [varchar](50) NOT NULL,
	[userCity] [varchar](25) NULL,
	[userState] [varchar](50) NULL,
	[isActive] [bit] NULL,
	[UserType] [varchar](10) NULL,
	[createdDate] [datetime] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblUserWithdrawDetails]    Script Date: 9/2/2022 8:53:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblUserWithdrawDetails](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[UserId] [bigint] NULL,
	[RequestedAmount] [money] NULL,
	[Status] [varchar](10) NULL,
	[ApprovedAmount] [money] NULL,
	[PaymentModeId] [bigint] NULL,
	[GameTypeId] [bigint] NULL,
	[GameSubTypeId] [bigint] NULL,
	[Remarks] [varchar](500) NULL,
	[isActive] [bit] NULL,
	[isDeleted] [bit] NULL,
	[CreatedDate] [datetime] NULL,
	[CreatedBy] [bigint] NULL,
	[UpdatedDate] [datetime] NULL,
	[UpdatedBy] [bigint] NULL,
 CONSTRAINT [PK_tblUserWithdrawDetails] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Vendor]    Script Date: 9/2/2022 8:53:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Vendor](
	[VendorID] [int] IDENTITY(1,1) NOT NULL,
	[VendorName] [varchar](50) NULL,
	[VAddress] [varchar](200) NULL,
	[City] [varchar](30) NULL,
	[VState] [varchar](30) NULL,
	[Zip] [varchar](10) NULL,
	[ContactName] [varchar](50) NULL,
	[ContactNumber] [varchar](12) NULL,
	[ContactEmail] [varchar](100) NULL,
	[PartTypeCategory] [varchar](100) NULL,
	[PaymentTermsOffered] [varchar](100) NULL,
	[ShippingNotes] [varchar](100) NULL,
 CONSTRAINT [PK_Vendor] PRIMARY KEY CLUSTERED 
(
	[VendorID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
INSERT [dbo].[Product] ([ProductID], [ProductType], [Code], [Name], [Brand], [Description], [CostPrice], [RetailPrice], [SalePrice], [CalculatedPrice], [FixedShippingPrice], [FreeShipping], [AllowPurchases], [ProductVisible], [ProductAvailability], [ProductInventoried], [StockLevel], [LowStockLevel], [CategoryDetails], [Images], [PageTitle], [METAKeywords], [METADescription], [ProductCondition], [ProductURL], [RedirectOldURL], [ProductTaxCode], [ProductCustomFields]) VALUES (1719, N'D', N'', N'Elevator Belt Template', N'', N'Picture is representative of product. Add this product to the cart to download. Fill out template Email completed form to sales@durableblastparts.com', N'0', N'0', N'0', N'0', N'0', 0, 1, 1, 0, 0, N'0', N'0', N'Category Name: Elevator Belt , Category Path: Abrasive Reclaim/Abrasive Reclaim Templates/Elevator Belt', N'Product Image File: Elevator_belt_assy_on_pallet__49286.jpg, Product Image URL: http://durableblastparts.com/product_images/r/417/Elevator_belt_assy_on_pallet__49286.jpg', N'Head Pulley & Boot Pulley Template', N'Head Pulley Drive Shaft Template,<ol> <li>Add this product to the cart to download.</li> <li>Fill out template</li> <li>Email completed form to sales@durableblastparts.com&nbsp;</li> </ol>', N'<ol> <li>Add this product to the cart to download.</li> <li>Fill out template</li> <li>Email completed form to sales@durableblastparts.com&nbsp;</li> </ol>', N'New', N'/elevator-belt-template/', N'', N'', N'Vendor=sales@durableblastparts')
INSERT [dbo].[Product] ([ProductID], [ProductType], [Code], [Name], [Brand], [Description], [CostPrice], [RetailPrice], [SalePrice], [CalculatedPrice], [FixedShippingPrice], [FreeShipping], [AllowPurchases], [ProductVisible], [ProductAvailability], [ProductInventoried], [StockLevel], [LowStockLevel], [CategoryDetails], [Images], [PageTitle], [METAKeywords], [METADescription], [ProductCondition], [ProductURL], [RedirectOldURL], [ProductTaxCode], [ProductCustomFields]) VALUES (1721, N'P', N'DBP-1000004-F', N'DBP-1000004-F | Tune up kit', N'Pangborn', N'Picture is representative of product. Tune Up Kit Part Numbers in Kits: Blade set 6-000024-8 Control cage 6-000029 Impeller 6-010000 Lock washer 7003108 Impeller bolt 7003914 Spout seal 3060152 Felt seal 3060151 Impeller bolt 7004114 Hi collar lock washer 600962 Wheel MODEL: 15" Rim Loc DIA OF WHEEL: 15.00" Blades / VANES: 8 Blades ROTATION: Bidirectional Machine Mfg: Pangborn', N'0', N'0', N'0', N'0', N'0', 0, 1, 1, 0, 0, N'0', N'0', N'Category Name: Tune Up Kits, Category Path: Wheel Parts/Wheel Internals/Tune Up Kits', N'Product Image File: Rimlocblade__98331.1595262094.1280.1280__52181.jpg, Product Image URL: http://durableblastparts.com/product_images/e/634/Rimlocblade__98331.1595262094.1280.1280__52181.jpg', N'Pangborn,DBP-1000004-F | Tune Up Kit', N'Pangborn,DBP-1000006-C | Blade Set,,Blade Set,Wheel MODEL: 140-2RI,DIA OF WHEEL: 14.00",Blades / VANES: 8 Blades ,ROTATION: Bidirectional,Machine Mfg: Pangborn', N',Tune Up Kit ,Wheel MODEL:15" Rim Loc,DIA OF WHEEL: 15.00",Blades / VANES: 8 Blades ,ROTATION: Bidirectional,Machine Mfg: Pangborn', N'New', N'/dbp-1000004-f-tune-up-kit/', N'', N'', N'Vendor=jackie@astechblast.com;')
INSERT [dbo].[Product] ([ProductID], [ProductType], [Code], [Name], [Brand], [Description], [CostPrice], [RetailPrice], [SalePrice], [CalculatedPrice], [FixedShippingPrice], [FreeShipping], [AllowPurchases], [ProductVisible], [ProductAvailability], [ProductInventoried], [StockLevel], [LowStockLevel], [CategoryDetails], [Images], [PageTitle], [METAKeywords], [METADescription], [ProductCondition], [ProductURL], [RedirectOldURL], [ProductTaxCode], [ProductCustomFields]) VALUES (1723, N'P', N'DBP-477609-1', N'DBP-477609 | 48" Urethane Fing', N'BCT Metcast;Wheelabrator', N'Picture is representative of product. 4" x 48" Urethane Finger Seal, 80 - 90 Duro w/ Spring Steel Insert', N'0', N'0', N'0', N'0', N'0', 0, 1, 1, 0, 0, N'0', N'0', N'Category Name: Cabinet Seals, Category Path: Cabinet & Material Handling/Cabinet Seals', N'Product Image File: Spring_Steel_Polyurethane_Fingers__48932.png, Product Image URL: http://durableblastparts.com/product_images/g/274/Spring_Steel_Polyurethane_Fingers__48932.png|Product Image File: DBP-FingerSeal__56295.1595262195.1280.1280__90502.jpg, Product Image URL: http://durableblastparts.com/product_images/h/149/DBP-FingerSeal__56295.1595262195.1280.1280__90502.jpg', N'BCT Metcast;Wheelabrator,DBP-477609 | 48" Urethane', N'BCT Metcast;Wheelabrator,DBP-680472 | 48" Urethane Finger Seal,4" x 48" Urethane Finger Seal, 80 - 90 Duro', N'4" x 48" Urethane Finger Seal, 80 - 90 Duro w/ spring steel insert', N'New', N'/dbp-477609-48-urethane-finger-seal-w-insert/', N'', N'', N'Vendor= sales@beltservice.com')
INSERT [dbo].[Product] ([ProductID], [ProductType], [Code], [Name], [Brand], [Description], [CostPrice], [RetailPrice], [SalePrice], [CalculatedPrice], [FixedShippingPrice], [FreeShipping], [AllowPurchases], [ProductVisible], [ProductAvailability], [ProductInventoried], [StockLevel], [LowStockLevel], [CategoryDetails], [Images], [PageTitle], [METAKeywords], [METADescription], [ProductCondition], [ProductURL], [RedirectOldURL], [ProductTaxCode], [ProductCustomFields]) VALUES (1724, N'P', N'DBP-5000838', N'Goff, Base Plate 25/30', N'Goff', N'Goff Wheel Housing Base Plate, 25/30 HP Foot Mounted Motors', N'0', N'0', N'0', N'0', N'0', 0, 1, 1, 0, 0, N'0', N'0', N'Category Name: Housing, Category Path: Wheel Parts/Housing|Category Name: Wheel Parts Fast Finder, Category Path: Wheel Parts/Wheel Parts Fast Finder', N'Product Image File: Blast-Wheel_Assy__10298.jpg, Product Image URL: http://durableblastparts.com/product_images/k/130/Blast-Wheel_Assy__10298.jpg', N'Goff, Base Plate 25/30', N'', N'Buy now online,  Low Cost Goff Wheel Base Plate, 5000838, Blast Wheel Base Plate,', N'New', N'/goff-base-plate-25-30/', N'', N'', N'Vendor=accounting@planbtulsa.c')
INSERT [dbo].[Product] ([ProductID], [ProductType], [Code], [Name], [Brand], [Description], [CostPrice], [RetailPrice], [SalePrice], [CalculatedPrice], [FixedShippingPrice], [FreeShipping], [AllowPurchases], [ProductVisible], [ProductAvailability], [ProductInventoried], [StockLevel], [LowStockLevel], [CategoryDetails], [Images], [PageTitle], [METAKeywords], [METADescription], [ProductCondition], [ProductURL], [RedirectOldURL], [ProductTaxCode], [ProductCustomFields]) VALUES (1725, N'P', N'DBP-52-0000268', N'Retainer, Cage, Inner, 12" Bla', N'Goff', N'52-0000268, Retainer, Cage Cage, Inner, 12" Blast Wheel, Goff Style', N'0', N'0', N'0', N'0', N'0', 0, 1, 1, 0, 0, N'0', N'0', N'Category Name: Housing, Category Path: Wheel Parts/Housing|Category Name: Wheel Parts Fast Finder, Category Path: Wheel Parts/Wheel Parts Fast Finder', N'Product Image File: 0000268__62749.jpg, Product Image URL: http://durableblastparts.com/product_images/a/389/0000268__62749.jpg', N'52-0000268, Retainer, Cage Cage, Inner, 12" Blast ', N'', N'Buy now online, 52-0000268, Retainer, Cage Cage, Inner, 12" Blast Wheel, Goff Style', N'New', N'/retainer-cage-inner-12-blast-wheel-goff-style/', N'', N'', N'Vendor=accounting@planbtulsa.c')
INSERT [dbo].[Product] ([ProductID], [ProductType], [Code], [Name], [Brand], [Description], [CostPrice], [RetailPrice], [SalePrice], [CalculatedPrice], [FixedShippingPrice], [FreeShipping], [AllowPurchases], [ProductVisible], [ProductAvailability], [ProductInventoried], [StockLevel], [LowStockLevel], [CategoryDetails], [Images], [PageTitle], [METAKeywords], [METADescription], [ProductCondition], [ProductURL], [RedirectOldURL], [ProductTaxCode], [ProductCustomFields]) VALUES (1726, N'P', N'DBP-52-0000268-HT', N'Retainer, Cage, Inner, HT, 12"', N'Goff', N'52-0000268, Retainer, Cage Cage, Inner, Heat Treated, 12" Blast Wheel, Goff Style', N'0', N'0', N'0', N'0', N'0', 0, 1, 1, 0, 0, N'0', N'0', N'Category Name: Housing, Category Path: Wheel Parts/Housing|Category Name: Wheel Parts Fast Finder, Category Path: Wheel Parts/Wheel Parts Fast Finder', N'Product Image File: 0000268__62749.1607444282.1280.1280__25346.jpg, Product Image URL: http://durableblastparts.com/product_images/q/323/0000268__62749.1607444282.1280.1280__25346.jpg', N'52-0000268-HT, Retainer, Cage Cage, Inner, Heat Tr', N'', N'Buy now online, 52-0000268-HT, Retainer, Cage Cage, Inner, Heat Treated, 12" Blast Wheel, Goff Style', N'New', N'/retainer-cage-inner-ht-12-blast-wheel-goff-style/', N'', N'', N'Vendor=accounting@planbtulsa.c')
INSERT [dbo].[Product] ([ProductID], [ProductType], [Code], [Name], [Brand], [Description], [CostPrice], [RetailPrice], [SalePrice], [CalculatedPrice], [FixedShippingPrice], [FreeShipping], [AllowPurchases], [ProductVisible], [ProductAvailability], [ProductInventoried], [StockLevel], [LowStockLevel], [CategoryDetails], [Images], [PageTitle], [METAKeywords], [METADescription], [ProductCondition], [ProductURL], [RedirectOldURL], [ProductTaxCode], [ProductCustomFields]) VALUES (1727, N'P', N'DBP-55-5000136', N'Impeller, 7 Position, 12" Blas', N'Goff', N'55-5000136, Impeller, 7 Position, 12" Blast Wheel, Goff Style', N'0', N'0', N'0', N'0', N'0', 0, 1, 1, 0, 0, N'0', N'0', N'Category Name: Wheel Internals, Category Path: Wheel Parts/Wheel Internals|Category Name: Wheel Parts Fast Finder, Category Path: Wheel Parts/Wheel Parts Fast Finder', N'Product Image File: 5000136_C__95681.jpg, Product Image URL: http://durableblastparts.com/product_images/m/129/5000136_C__95681.jpg', N'55-5000136, Impeller, 7 Position, 12" Blast Wheel,', N'', N'Buy now online, 55-5000136, Impeller, 7 Position, 12" Blast Wheel, Goff Style', N'New', N'/impeller-7-position-12-blast-wheel-goff-style/', N'', N'', N'Vendor=accounting@planbtulsa.c')
INSERT [dbo].[Product] ([ProductID], [ProductType], [Code], [Name], [Brand], [Description], [CostPrice], [RetailPrice], [SalePrice], [CalculatedPrice], [FixedShippingPrice], [FreeShipping], [AllowPurchases], [ProductVisible], [ProductAvailability], [ProductInventoried], [StockLevel], [LowStockLevel], [CategoryDetails], [Images], [PageTitle], [METAKeywords], [METADescription], [ProductCondition], [ProductURL], [RedirectOldURL], [ProductTaxCode], [ProductCustomFields]) VALUES (1728, N'P', N'DBP-55-5000137', N'Centering Plate, 12'''' Blast Wh', N'Goff', N'55-5000137, Centering Plate, 12'''' Blast Wheel, Goff Style', N'0', N'0', N'0', N'0', N'0', 0, 1, 1, 0, 0, N'0', N'0', N'Category Name: Wheel Internals, Category Path: Wheel Parts/Wheel Internals|Category Name: Wheel Parts Fast Finder, Category Path: Wheel Parts/Wheel Parts Fast Finder', N'Product Image File: 5000137_C__79057.jpg, Product Image URL: http://durableblastparts.com/product_images/c/230/5000137_C__79057.jpg', N'55-5000137, Centering Plate, 12'''' Blast Wheel, Gof', N'', N'Buy now online, 55-5000137, Centering Plate, 12'''' Blast Wheel, Goff Style', N'New', N'/centering-plate-12-blast-wheel-goff-style/', N'', N'', N'Vendor=accounting@planbtulsa.c')
INSERT [dbo].[Product] ([ProductID], [ProductType], [Code], [Name], [Brand], [Description], [CostPrice], [RetailPrice], [SalePrice], [CalculatedPrice], [FixedShippingPrice], [FreeShipping], [AllowPurchases], [ProductVisible], [ProductAvailability], [ProductInventoried], [StockLevel], [LowStockLevel], [CategoryDetails], [Images], [PageTitle], [METAKeywords], [METADescription], [ProductCondition], [ProductURL], [RedirectOldURL], [ProductTaxCode], [ProductCustomFields]) VALUES (1729, N'P', N'DBP-55-5000138', N'Cage, Control, 40 Deg., 12" Bl', N'Goff', N'55-5000138, Cage, Control, 40 Deg., 12" Blast Wheel, Goff Style', N'0', N'0', N'0', N'0', N'0', 0, 1, 1, 0, 0, N'0', N'0', N'Category Name: Wheel Internals, Category Path: Wheel Parts/Wheel Internals|Category Name: Wheel Parts Fast Finder, Category Path: Wheel Parts/Wheel Parts Fast Finder', N'Product Image File: 5000138_B__41699.jpg, Product Image URL: http://durableblastparts.com/product_images/d/879/5000138_B__41699.jpg', N'55-5000138, Cage, Control, 40 Deg., 12" Blast Whee', N'', N'Buy now online, 55-5000138, Cage, Control, 40 Deg., 12" Blast Wheel, Goff Style', N'New', N'/cage-control-40-deg-12-blast-wheel-goff-style/', N'', N'', N'Vendor=accounting@planbtulsa.c')
INSERT [dbo].[Product] ([ProductID], [ProductType], [Code], [Name], [Brand], [Description], [CostPrice], [RetailPrice], [SalePrice], [CalculatedPrice], [FixedShippingPrice], [FreeShipping], [AllowPurchases], [ProductVisible], [ProductAvailability], [ProductInventoried], [StockLevel], [LowStockLevel], [CategoryDetails], [Images], [PageTitle], [METAKeywords], [METADescription], [ProductCondition], [ProductURL], [RedirectOldURL], [ProductTaxCode], [ProductCustomFields]) VALUES (1730, N'P', N'DBP-55-5000303', N'Spout, 90 Deg., 12" Blast Whee', N'Goff', N'55-5000303, Spout, 90 Deg., 12" Blast Wheel, Goff/RimLoc Style', N'0', N'0', N'0', N'0', N'0', 0, 1, 1, 0, 0, N'0', N'0', N'Category Name: Housing, Category Path: Wheel Parts/Housing|Category Name: Wheel Parts Fast Finder, Category Path: Wheel Parts/Wheel Parts Fast Finder', N'Product Image File: 5000303__35764.jpg, Product Image URL: http://durableblastparts.com/product_images/m/769/5000303__35764.jpg', N'55-5000303, Spout, 90 Deg., 12" Blast Wheel, Goff,', N'', N'Buy now online, 55-5000303, Spout, 90 Deg., 12" Blast Wheel, Goff, RimLoc', N'New', N'/spout-90-deg-12-blast-wheel-goff-rimloc-style/', N'', N'', N'Vendor=accounting@planbtulsa.c')
INSERT [dbo].[Product] ([ProductID], [ProductType], [Code], [Name], [Brand], [Description], [CostPrice], [RetailPrice], [SalePrice], [CalculatedPrice], [FixedShippingPrice], [FreeShipping], [AllowPurchases], [ProductVisible], [ProductAvailability], [ProductInventoried], [StockLevel], [LowStockLevel], [CategoryDetails], [Images], [PageTitle], [METAKeywords], [METADescription], [ProductCondition], [ProductURL], [RedirectOldURL], [ProductTaxCode], [ProductCustomFields]) VALUES (1731, N'P', N'DBP-55-5001936', N'Liner, Top, 12" Blast Wheel, G', N'Goff', N'55-5001936, Liner, Top, 12" Blast Wheel, Goff Style', N'0', N'0', N'0', N'0', N'0', 0, 1, 1, 0, 0, N'0', N'0', N'Category Name: Housing, Category Path: Wheel Parts/Housing|Category Name: Wheel Parts Fast Finder, Category Path: Wheel Parts/Wheel Parts Fast Finder', N'Product Image File: 5001936_1__83730.jpg, Product Image URL: http://durableblastparts.com/product_images/h/628/5001936_1__83730.jpg', N'55-5001936, Liner, Top, 12" Blast Wheel, Goff Styl', N'', N'Buy now online, 55-5001936, Liner, Top, 12" Blast Wheel, Goff Style', N'New', N'/liner-top-12-blast-wheel-goff-style/', N'', N'', N'Vendor=accounting@planbtulsa.c')
INSERT [dbo].[Product] ([ProductID], [ProductType], [Code], [Name], [Brand], [Description], [CostPrice], [RetailPrice], [SalePrice], [CalculatedPrice], [FixedShippingPrice], [FreeShipping], [AllowPurchases], [ProductVisible], [ProductAvailability], [ProductInventoried], [StockLevel], [LowStockLevel], [CategoryDetails], [Images], [PageTitle], [METAKeywords], [METADescription], [ProductCondition], [ProductURL], [RedirectOldURL], [ProductTaxCode], [ProductCustomFields]) VALUES (1732, N'P', N'DBP-55-5001937', N'Liner, End, Short, 12" Blast W', N'Goff', N'55-5001937, Liner, End, Short, 12" Blast Wheel, Goff Style', N'0', N'0', N'0', N'0', N'0', 0, 1, 1, 0, 0, N'0', N'0', N'Category Name: Housing, Category Path: Wheel Parts/Housing|Category Name: Wheel Parts Fast Finder, Category Path: Wheel Parts/Wheel Parts Fast Finder', N'Product Image File: 55-5001937__87473.jpg, Product Image URL: http://durableblastparts.com/product_images/k/768/55-5001937__87473.jpg', N'55-5001937, Liner, End, Short, 12" Blast Wheel, Go', N'', N'Buy now online,55-5001937, Liner, End, Short, 12" Blast Wheel, Goff Style', N'New', N'/liner-end-short-12-blast-wheel-goff-style/', N'', N'', N'Vendor=accounting@planbtulsa.c')
INSERT [dbo].[Product] ([ProductID], [ProductType], [Code], [Name], [Brand], [Description], [CostPrice], [RetailPrice], [SalePrice], [CalculatedPrice], [FixedShippingPrice], [FreeShipping], [AllowPurchases], [ProductVisible], [ProductAvailability], [ProductInventoried], [StockLevel], [LowStockLevel], [CategoryDetails], [Images], [PageTitle], [METAKeywords], [METADescription], [ProductCondition], [ProductURL], [RedirectOldURL], [ProductTaxCode], [ProductCustomFields]) VALUES (1733, N'P', N'DBP-55-5001938', N'Liner, Side, Rear, 12" Blast W', N'Goff', N'55-5001938, Liner, Side, Rear, 12" Blast Wheel, Goff Style', N'0', N'0', N'0', N'0', N'0', 0, 1, 1, 0, 0, N'0', N'0', N'Category Name: Housing, Category Path: Wheel Parts/Housing|Category Name: Wheel Parts Fast Finder, Category Path: Wheel Parts/Wheel Parts Fast Finder', N'Product Image File: 5001938_1__83835.jpg, Product Image URL: http://durableblastparts.com/product_images/q/783/5001938_1__83835.jpg', N'55-5001938, Liner, Side, Rear, 12" Blast Wheel, Go', N'', N'Buy now online,55-5001938, Liner, Side, Rear, 12" Blast Wheel, Goff Style', N'New', N'/liner-side-rear-12-blast-wheel-goff-style/', N'', N'', N'Vendor=accounting@planbtulsa.c')
INSERT [dbo].[Product] ([ProductID], [ProductType], [Code], [Name], [Brand], [Description], [CostPrice], [RetailPrice], [SalePrice], [CalculatedPrice], [FixedShippingPrice], [FreeShipping], [AllowPurchases], [ProductVisible], [ProductAvailability], [ProductInventoried], [StockLevel], [LowStockLevel], [CategoryDetails], [Images], [PageTitle], [METAKeywords], [METADescription], [ProductCondition], [ProductURL], [RedirectOldURL], [ProductTaxCode], [ProductCustomFields]) VALUES (1734, N'P', N'DBP-55-5001939', N'Liner, Side, Front, 12" Blast ', N'Goff', N'55-5001939, Liner, Side, Front, 12" Blast Wheel, Goff Style', N'0', N'0', N'0', N'0', N'0', 0, 1, 1, 0, 0, N'0', N'0', N'Category Name: Housing, Category Path: Wheel Parts/Housing|Category Name: Wheel Parts Fast Finder, Category Path: Wheel Parts/Wheel Parts Fast Finder', N'Product Image File: 5001939__10143.jpg, Product Image URL: http://durableblastparts.com/product_images/r/340/5001939__10143.jpg', N'55-5001939, Liner, Side, Front, 12" Blast Wheel, G', N'', N'Buy now online,55-5001939, Liner, Side, Front, 12" Blast Wheel, Goff Style', N'New', N'/liner-side-front-12-blast-wheel-goff-style/', N'', N'', N'Vendor=accounting@planbtulsa.c')
INSERT [dbo].[Product] ([ProductID], [ProductType], [Code], [Name], [Brand], [Description], [CostPrice], [RetailPrice], [SalePrice], [CalculatedPrice], [FixedShippingPrice], [FreeShipping], [AllowPurchases], [ProductVisible], [ProductAvailability], [ProductInventoried], [StockLevel], [LowStockLevel], [CategoryDetails], [Images], [PageTitle], [METAKeywords], [METADescription], [ProductCondition], [ProductURL], [RedirectOldURL], [ProductTaxCode], [ProductCustomFields]) VALUES (1735, N'P', N'DBP-55-5002308', N'Liner, End, Long, 12" Blast Wh', N'Goff', N'55-5002308, Liner, End, Long, 12" Blast Wheel, Goff Style', N'0', N'0', N'0', N'0', N'0', 0, 1, 1, 0, 0, N'0', N'0', N'Category Name: Housing, Category Path: Wheel Parts/Housing|Category Name: Wheel Parts Fast Finder, Category Path: Wheel Parts/Wheel Parts Fast Finder', N'Product Image File: 5002308__70283.jpg, Product Image URL: http://durableblastparts.com/product_images/e/044/5002308__70283.jpg', N'55-5002308, Liner, End, Long, 12" Blast Wheel, Gof', N'', N'Buy now online,55-5002308, Liner, End, Long, 12" Blast Wheel, Goff Style', N'New', N'/liner-end-long-12-blast-wheel-goff-style/', N'', N'', N'Vendor=accounting@planbtulsa.c')
INSERT [dbo].[Product] ([ProductID], [ProductType], [Code], [Name], [Brand], [Description], [CostPrice], [RetailPrice], [SalePrice], [CalculatedPrice], [FixedShippingPrice], [FreeShipping], [AllowPurchases], [ProductVisible], [ProductAvailability], [ProductInventoried], [StockLevel], [LowStockLevel], [CategoryDetails], [Images], [PageTitle], [METAKeywords], [METADescription], [ProductCondition], [ProductURL], [RedirectOldURL], [ProductTaxCode], [ProductCustomFields]) VALUES (1736, N'P', N'DBP-55-5100116', N'Block, CW, 12" Blast Wheel, Go', N'Goff', N'55-5100116, Block, CW, 12" Blast Wheel, Goff Style, Set of 7', N'0', N'0', N'0', N'0', N'0', 0, 1, 1, 0, 0, N'0', N'0', N'Category Name: Wheel Internals, Category Path: Wheel Parts/Wheel Internals|Category Name: Wheel Parts Fast Finder, Category Path: Wheel Parts/Wheel Parts Fast Finder', N'Product Image File: 55-5100116__36206.jpg, Product Image URL: http://durableblastparts.com/product_images/o/741/55-5100116__36206.jpg', N'55-5100116, Block, CW, 12" Blast Wheel, Goff Style', N'', N'Buy now online,55-5100116, Block, CW, 12" Blast Wheel, Goff Style, Set of 7', N'New', N'/block-cw-12-blast-wheel-goff-style-set-of-7/', N'', N'', N'Vendor=accounting@planbtulsa.c')
INSERT [dbo].[Product] ([ProductID], [ProductType], [Code], [Name], [Brand], [Description], [CostPrice], [RetailPrice], [SalePrice], [CalculatedPrice], [FixedShippingPrice], [FreeShipping], [AllowPurchases], [ProductVisible], [ProductAvailability], [ProductInventoried], [StockLevel], [LowStockLevel], [CategoryDetails], [Images], [PageTitle], [METAKeywords], [METADescription], [ProductCondition], [ProductURL], [RedirectOldURL], [ProductTaxCode], [ProductCustomFields]) VALUES (1737, N'P', N'DBP-55-5100117', N'Block, CCW, 12" Blast Wheel, G', N'Goff', N'55-5100117, Block, CCW, 12" Blast Wheel, Goff Style, Set of 7', N'0', N'0', N'0', N'0', N'0', 0, 1, 1, 0, 0, N'0', N'0', N'Category Name: Wheel Internals, Category Path: Wheel Parts/Wheel Internals|Category Name: Wheel Parts Fast Finder, Category Path: Wheel Parts/Wheel Parts Fast Finder', N'Product Image File: 5100117_5__05608.jpg, Product Image URL: http://durableblastparts.com/product_images/n/601/5100117_5__05608.jpg', N'55-5100117, Block, CCW, 12" Blast Wheel, Goff Styl', N'', N'Buy now online,55-5100117, Block, CCW, 12" Blast Wheel, Goff Style, Set of 7', N'New', N'/block-ccw-12-blast-wheel-goff-style-set-of-7/', N'', N'', N'Vendor=accounting@planbtulsa.c')
INSERT [dbo].[Product] ([ProductID], [ProductType], [Code], [Name], [Brand], [Description], [CostPrice], [RetailPrice], [SalePrice], [CalculatedPrice], [FixedShippingPrice], [FreeShipping], [AllowPurchases], [ProductVisible], [ProductAvailability], [ProductInventoried], [StockLevel], [LowStockLevel], [CategoryDetails], [Images], [PageTitle], [METAKeywords], [METADescription], [ProductCondition], [ProductURL], [RedirectOldURL], [ProductTaxCode], [ProductCustomFields]) VALUES (1738, N'P', N'DBP-55-5102064', N'Blade Set, 12", Goff Style, Se', N'Goff', N'55-5102064, Blade Set, 12", Goff Style, Set of 7', N'0', N'0', N'0', N'0', N'0', 0, 1, 1, 0, 0, N'0', N'0', N'Category Name: Wheel Internals, Category Path: Wheel Parts/Wheel Internals|Category Name: Wheel Parts Fast Finder, Category Path: Wheel Parts/Wheel Parts Fast Finder', N'Product Image File: Goff_12_Blades__53500.jpg, Product Image URL: http://durableblastparts.com/product_images/p/618/Goff_12_Blades__53500.jpg', N'55-5102064, Blade Set, 12", Goff Style, Set of 7', N'', N'Buy now online,55-5102064, Blade Set, 12", Goff Style, Set of 7', N'New', N'/blade-set-12-goff-style-set-of-7/', N'', N'', N'Vendor=accounting@planbtulsa.c')
INSERT [dbo].[Product] ([ProductID], [ProductType], [Code], [Name], [Brand], [Description], [CostPrice], [RetailPrice], [SalePrice], [CalculatedPrice], [FixedShippingPrice], [FreeShipping], [AllowPurchases], [ProductVisible], [ProductAvailability], [ProductInventoried], [StockLevel], [LowStockLevel], [CategoryDetails], [Images], [PageTitle], [METAKeywords], [METADescription], [ProductCondition], [ProductURL], [RedirectOldURL], [ProductTaxCode], [ProductCustomFields]) VALUES (1739, N'P', N'DBP-55-5102063', N'Blade Set, 13.5", Goff Style, ', N'Goff', N'55-5102063, Blade Set, 13.5", Goff Style, Set of 7', N'0', N'0', N'0', N'0', N'0', 0, 1, 1, 0, 0, N'0', N'0', N'Category Name: Wheel Internals, Category Path: Wheel Parts/Wheel Internals|Category Name: Wheel Parts Fast Finder, Category Path: Wheel Parts/Wheel Parts Fast Finder', N'Product Image File: Goff_13.5_Blades___66695.jpg, Product Image URL: http://durableblastparts.com/product_images/g/647/Goff_13.5_Blades___66695.jpg', N'55-5102063, Blade Set, 13.5", Goff Style, Set of 7', N'', N'Buy now online, 55-5102063, Blade Set, 13.5", Goff Style, Set of 7', N'New', N'/blade-set-13-5-goff-style-set-of-7/', N'', N'', N'Vendor=accounting@planbtulsa.c')
INSERT [dbo].[Product] ([ProductID], [ProductType], [Code], [Name], [Brand], [Description], [CostPrice], [RetailPrice], [SalePrice], [CalculatedPrice], [FixedShippingPrice], [FreeShipping], [AllowPurchases], [ProductVisible], [ProductAvailability], [ProductInventoried], [StockLevel], [LowStockLevel], [CategoryDetails], [Images], [PageTitle], [METAKeywords], [METADescription], [ProductCondition], [ProductURL], [RedirectOldURL], [ProductTaxCode], [ProductCustomFields]) VALUES (1740, N'P', N'DBP-55-5101366', N'Blade Set, 15", Goff Style, Se', N'Goff', N'55-5101366, Blade Set, 15", Goff Style, Set of 7', N'0', N'0', N'0', N'0', N'0', 0, 1, 1, 0, 0, N'0', N'0', N'Category Name: Wheel Parts, Category Path: Wheel Parts|Category Name: Wheel Internals, Category Path: Wheel Parts/Wheel Internals|Category Name: Wheel Parts Fast Finder, Category Path: Wheel Parts/Wheel Parts Fast Finder', N'Product Image File: Goff_15_Blades_2___34622.jpg, Product Image URL: http://durableblastparts.com/product_images/t/550/Goff_15_Blades_2___34622.jpg', N'55-5101366, Blade Set, 15", Goff Style, Set of 7', N'', N'Buy now online, 55-5101366, Blade Set, 15", Goff Style, Set of 7', N'New', N'/blade-set-15-goff-style-set-of-7/', N'', N'', N'Vendor=accounting@planbtulsa.c')
INSERT [dbo].[Product] ([ProductID], [ProductType], [Code], [Name], [Brand], [Description], [CostPrice], [RetailPrice], [SalePrice], [CalculatedPrice], [FixedShippingPrice], [FreeShipping], [AllowPurchases], [ProductVisible], [ProductAvailability], [ProductInventoried], [StockLevel], [LowStockLevel], [CategoryDetails], [Images], [PageTitle], [METAKeywords], [METADescription], [ProductCondition], [ProductURL], [RedirectOldURL], [ProductTaxCode], [ProductCustomFields]) VALUES (1741, N'P', N'DBP-55-5101542', N'Blade Set, 15", Goff Style, Se', N'Goff', N'55-5101542, Blade Set, 15", Goff Style, Set of 8', N'0', N'0', N'0', N'0', N'0', 0, 1, 1, 0, 0, N'0', N'0', N'Category Name: Wheel Parts, Category Path: Wheel Parts|Category Name: Wheel Internals, Category Path: Wheel Parts/Wheel Internals|Category Name: Wheel Parts Fast Finder, Category Path: Wheel Parts/Wheel Parts Fast Finder', N'Product Image File: Goff_15_Blades_2___29994.jpg, Product Image URL: http://durableblastparts.com/product_images/e/731/Goff_15_Blades_2___29994.jpg', N'55-5101542, Blade Set, 15", Goff Style, Set of 8', N'', N'Buy now online,55-5101542, Blade Set, 15", Goff Style, Set of 8', N'New', N'/blade-set-15-goff-style-set-of-8/', N'', N'', N'Vendor=accounting@planbtulsa.c')
INSERT [dbo].[Product] ([ProductID], [ProductType], [Code], [Name], [Brand], [Description], [CostPrice], [RetailPrice], [SalePrice], [CalculatedPrice], [FixedShippingPrice], [FreeShipping], [AllowPurchases], [ProductVisible], [ProductAvailability], [ProductInventoried], [StockLevel], [LowStockLevel], [CategoryDetails], [Images], [PageTitle], [METAKeywords], [METADescription], [ProductCondition], [ProductURL], [RedirectOldURL], [ProductTaxCode], [ProductCustomFields]) VALUES (1742, N'P', N'DBP-55-5101541', N'Blade Set, 13.5", Goff Style, ', N'Goff', N'55-5101541, Blade Set, 13.5", Goff Style, Set of 8', N'0', N'0', N'0', N'0', N'0', 0, 1, 1, 0, 0, N'0', N'0', N'Category Name: Wheel Parts, Category Path: Wheel Parts|Category Name: Wheel Internals, Category Path: Wheel Parts/Wheel Internals|Category Name: Wheel Parts Fast Finder, Category Path: Wheel Parts/Wheel Parts Fast Finder', N'Product Image File: Goff_13.5_Blades___47151.jpg, Product Image URL: http://durableblastparts.com/product_images/h/680/Goff_13.5_Blades___47151.jpg', N'55-5101541, Blade Set, 13.5", Goff Style, Set of 8', N'', N'Buy now online,-55-5101541, Blade Set, 13.5", Goff Style, Set of 8', N'New', N'/blade-set-13-5-goff-style-set-of-8/', N'', N'', N'Vendor=accounting@planbtulsa.c')
INSERT [dbo].[Product] ([ProductID], [ProductType], [Code], [Name], [Brand], [Description], [CostPrice], [RetailPrice], [SalePrice], [CalculatedPrice], [FixedShippingPrice], [FreeShipping], [AllowPurchases], [ProductVisible], [ProductAvailability], [ProductInventoried], [StockLevel], [LowStockLevel], [CategoryDetails], [Images], [PageTitle], [METAKeywords], [METADescription], [ProductCondition], [ProductURL], [RedirectOldURL], [ProductTaxCode], [ProductCustomFields]) VALUES (1743, N'P', N'DBP-55-5101540-8', N'Blade Set, 12", Goff Style, Se', N'Goff', N'55-5101540-8, Blade Set, 12", Goff Style, Set of 8', N'0', N'0', N'0', N'0', N'0', 0, 1, 1, 0, 0, N'0', N'0', N'Category Name: Wheel Internals, Category Path: Wheel Parts/Wheel Internals|Category Name: Wheel Parts Fast Finder, Category Path: Wheel Parts/Wheel Parts Fast Finder', N'Product Image File: Goff_12_Blades___13223.jpg, Product Image URL: http://durableblastparts.com/product_images/r/215/Goff_12_Blades___13223.jpg', N'55-5101540-8, Blade Set, 12", Goff Style, Set of 8', N'', N'Buy now online,55-5101540-8, Blade Set, 12", Goff Style, Set of 8', N'New', N'/blade-set-12-goff-style-set-of-8/', N'', N'', N'Vendor=accounting@planbtulsa.c')
INSERT [dbo].[Product] ([ProductID], [ProductType], [Code], [Name], [Brand], [Description], [CostPrice], [RetailPrice], [SalePrice], [CalculatedPrice], [FixedShippingPrice], [FreeShipping], [AllowPurchases], [ProductVisible], [ProductAvailability], [ProductInventoried], [StockLevel], [LowStockLevel], [CategoryDetails], [Images], [PageTitle], [METAKeywords], [METADescription], [ProductCondition], [ProductURL], [RedirectOldURL], [ProductTaxCode], [ProductCustomFields]) VALUES (1744, N'P', N'DBP-55-5100292', N'Seal, Hub, Casting, 12" Blast ', N'Goff', N'55-5100292, Seal, Hub, Casting, 12" Blast Wheel, Goff Style', N'0', N'0', N'0', N'0', N'0', 0, 1, 1, 0, 0, N'0', N'0', N'Category Name: Housing, Category Path: Wheel Parts/Housing|Category Name: Wheel Parts Fast Finder, Category Path: Wheel Parts/Wheel Parts Fast Finder', N'Product Image File: 55-5100292__67415.jpg, Product Image URL: http://durableblastparts.com/product_images/s/855/55-5100292__67415.jpg', N'Seal, Hub, Casting, 12" Blast Wheel, Goff Style', N'', N'Buy now online, Seal, Hub, Casting, 12" Blast Wheel, Goff Style', N'New', N'/seal-hub-casting-12-blast-wheel-goff-style/', N'', N'', N'Vendor=accounting@planbtulsa.c')
INSERT [dbo].[Product] ([ProductID], [ProductType], [Code], [Name], [Brand], [Description], [CostPrice], [RetailPrice], [SalePrice], [CalculatedPrice], [FixedShippingPrice], [FreeShipping], [AllowPurchases], [ProductVisible], [ProductAvailability], [ProductInventoried], [StockLevel], [LowStockLevel], [CategoryDetails], [Images], [PageTitle], [METAKeywords], [METADescription], [ProductCondition], [ProductURL], [RedirectOldURL], [ProductTaxCode], [ProductCustomFields]) VALUES (1745, N'P', N'DBP-55-5100292HT', N'Seal, Hub, Casting, Heat Treat', N'Goff', N'55-5100292HT, Seal, Hub, Casting, Heat Treated, 12" Blast Wheel, Goff Style', N'0', N'0', N'0', N'0', N'0', 0, 1, 1, 0, 0, N'0', N'0', N'Category Name: Housing, Category Path: Wheel Parts/Housing|Category Name: Wheel Parts Fast Finder, Category Path: Wheel Parts/Wheel Parts Fast Finder', N'Product Image File: 55-5100292__67415.1607461101.1280.1280__26565.jpg, Product Image URL: http://durableblastparts.com/product_images/x/210/55-5100292__67415.1607461101.1280.1280__26565.jpg', N'Seal, Hub, Casting, Heat Treated, 12" Blast Wheel,', N'', N'Buy now online, Seal, Hub, Heat Treated, Casting, 12" Blast Wheel, Goff Style', N'New', N'/seal-hub-casting-heat-treated-12-blast-wheel-goff-style/', N'', N'', N'Vendor=accounting@planbtulsa.c')
INSERT [dbo].[Product] ([ProductID], [ProductType], [Code], [Name], [Brand], [Description], [CostPrice], [RetailPrice], [SalePrice], [CalculatedPrice], [FixedShippingPrice], [FreeShipping], [AllowPurchases], [ProductVisible], [ProductAvailability], [ProductInventoried], [StockLevel], [LowStockLevel], [CategoryDetails], [Images], [PageTitle], [METAKeywords], [METADescription], [ProductCondition], [ProductURL], [RedirectOldURL], [ProductTaxCode], [ProductCustomFields]) VALUES (1746, N'P', N'DBP-55-5004420', N'Liner, Segment, Outer 6BB, Gof', N'Goff', N'55-5004420, Liner, Segment, Outer 6BB, Goff Style', N'0', N'0', N'0', N'0', N'0', 0, 1, 1, 0, 0, N'0', N'0', N'Category Name: Tumblast Mill Components, Category Path: Cabinet & Material Handling/Tumblast Mill Components', N'Product Image File: 55-5004420__34718.jpg, Product Image URL: http://durableblastparts.com/product_images/h/348/55-5004420__34718.jpg', N'55-5004420, Liner, Segment, Outer 6BB, Goff Style', N'', N'Buy now online,55-5004420, Liner, Segment, Outer 6BB, Goff Style', N'New', N'/liner-segment-outer-6bb-goff-style/', N'', N'', N'Vendor=accounting@planbtulsa.c')
INSERT [dbo].[Product] ([ProductID], [ProductType], [Code], [Name], [Brand], [Description], [CostPrice], [RetailPrice], [SalePrice], [CalculatedPrice], [FixedShippingPrice], [FreeShipping], [AllowPurchases], [ProductVisible], [ProductAvailability], [ProductInventoried], [StockLevel], [LowStockLevel], [CategoryDetails], [Images], [PageTitle], [METAKeywords], [METADescription], [ProductCondition], [ProductURL], [RedirectOldURL], [ProductTaxCode], [ProductCustomFields]) VALUES (1747, N'P', N'DBP-56-0000293', N'Seal, Felt, Hub, 5/8" x 3/4" x', N'Goff', N'56-0000293, Seal, Felt, Hub, 5/8" x 3/4" x 72", 12" Blast Wheel, Goff Style', N'0', N'0', N'0', N'0', N'0', 0, 1, 1, 0, 0, N'0', N'0', N'Category Name: Housing, Category Path: Wheel Parts/Housing|Category Name: Wheel Parts Fast Finder, Category Path: Wheel Parts/Wheel Parts Fast Finder', N'Product Image File: 0000293_1__76516.jpg, Product Image URL: http://durableblastparts.com/product_images/h/703/0000293_1__76516.jpg', N'Seal, Felt, Hub, 5/8" x 3/4" x 72", 12" Blast Whee', N'', N'Buy now online, 56-0000293, Seal, Felt, Hub, 5/8" x 3/4" x 72", 12" Blast Wheel, Goff Style', N'New', N'/seal-felt-hub-5-8-x-3-4-x-72-12-blast-wheel-goff-style/', N'', N'', N'Vendor=accounting@planbtulsa.c')
INSERT [dbo].[Product] ([ProductID], [ProductType], [Code], [Name], [Brand], [Description], [CostPrice], [RetailPrice], [SalePrice], [CalculatedPrice], [FixedShippingPrice], [FreeShipping], [AllowPurchases], [ProductVisible], [ProductAvailability], [ProductInventoried], [StockLevel], [LowStockLevel], [CategoryDetails], [Images], [PageTitle], [METAKeywords], [METADescription], [ProductCondition], [ProductURL], [RedirectOldURL], [ProductTaxCode], [ProductCustomFields]) VALUES (1748, N'P', N'DBP-55-5004421', N'Liner, Barrel Head, Center, Go', N'Goff', N'55-5004421, Liner, Barrel Head, Center, Goff Style', N'0', N'0', N'0', N'0', N'0', 0, 1, 1, 0, 0, N'0', N'0', N'Category Name: Tumblast Mill Components, Category Path: Cabinet & Material Handling/Tumblast Mill Components', N'Product Image File: 55-5004421__04768.jpg, Product Image URL: http://durableblastparts.com/product_images/j/917/55-5004421__04768.jpg', N'55-5004421, Liner, Barrel Head, Center, Goff Style', N'', N'Buy now online,555-5004421, Liner, Barrel Head, Center, Goff Style', N'New', N'/liner-barrel-head-center-goff-style/', N'', N'', N'Vendor=accounting@planbtulsa.c')
INSERT [dbo].[Product] ([ProductID], [ProductType], [Code], [Name], [Brand], [Description], [CostPrice], [RetailPrice], [SalePrice], [CalculatedPrice], [FixedShippingPrice], [FreeShipping], [AllowPurchases], [ProductVisible], [ProductAvailability], [ProductInventoried], [StockLevel], [LowStockLevel], [CategoryDetails], [Images], [PageTitle], [METAKeywords], [METADescription], [ProductCondition], [ProductURL], [RedirectOldURL], [ProductTaxCode], [ProductCustomFields]) VALUES (1749, N'P', N'DBP-55-5004422', N'Liner, Segment, Outer 3BB, Gof', N'Goff', N'55-5004422, Liner, Segment, Outer 3BB, Goff Style', N'0', N'0', N'0', N'0', N'0', 0, 1, 1, 0, 0, N'0', N'0', N'Category Name: Tumblast Mill Components, Category Path: Cabinet & Material Handling/Tumblast Mill Components', N'Product Image File: 5004422__81136.jpg, Product Image URL: http://durableblastparts.com/product_images/p/445/5004422__81136.jpg', N'55-5004422, Liner, Segment, Outer 3BB, Goff Style', N'', N'Buy now online,55-5004422, Liner, Segment, Outer 3BB, Goff Style', N'New', N'/liner-segment-outer-3bb-goff-style/', N'', N'', N'Vendor=accounting@planbtulsa.c')
INSERT [dbo].[Product] ([ProductID], [ProductType], [Code], [Name], [Brand], [Description], [CostPrice], [RetailPrice], [SalePrice], [CalculatedPrice], [FixedShippingPrice], [FreeShipping], [AllowPurchases], [ProductVisible], [ProductAvailability], [ProductInventoried], [StockLevel], [LowStockLevel], [CategoryDetails], [Images], [PageTitle], [METAKeywords], [METADescription], [ProductCondition], [ProductURL], [RedirectOldURL], [ProductTaxCode], [ProductCustomFields]) VALUES (1750, N'P', N'DBP-59-0103091', N'Goff, Base Plate 7.5/10 HP', N'Goff', N'59-0103091, Goff Wheel Housing Base Plate 7.5/10 HP Foot Mounted Motors', N'0', N'0', N'0', N'0', N'0', 0, 1, 1, 0, 0, N'0', N'0', N'Category Name: Housing, Category Path: Wheel Parts/Housing|Category Name: Wheel Parts Fast Finder, Category Path: Wheel Parts/Wheel Parts Fast Finder', N'Product Image File: Blast-Wheel_Assy__10298.1607442407.1280.1280__26260.jpg, Product Image URL: http://durableblastparts.com/product_images/b/712/Blast-Wheel_Assy__10298.1607442407.1280.1280__26260.jpg', N'59-0103091, Goff Wheel Housing Base Plate 7.5/10 H', N'', N'Buy now online,  59-0103091, Goff Wheel Housing Base Plate 7.5/10 HP Foot Mounted Motors', N'New', N'/goff-base-plate-7-5-10-hp/', N'', N'', N'Vendor=accounting@planbtulsa.c')
INSERT [dbo].[Product] ([ProductID], [ProductType], [Code], [Name], [Brand], [Description], [CostPrice], [RetailPrice], [SalePrice], [CalculatedPrice], [FixedShippingPrice], [FreeShipping], [AllowPurchases], [ProductVisible], [ProductAvailability], [ProductInventoried], [StockLevel], [LowStockLevel], [CategoryDetails], [Images], [PageTitle], [METAKeywords], [METADescription], [ProductCondition], [ProductURL], [RedirectOldURL], [ProductTaxCode], [ProductCustomFields]) VALUES (1751, N'P', N'DBP-59-0142300', N'Goff, Base Plate 15/20 HP', N'Goff', N'59-0142300, Goff Wheel Housing Base Plate 15/20 HP Foot Mounted Motors', N'0', N'0', N'0', N'0', N'0', 0, 1, 1, 0, 0, N'0', N'0', N'Category Name: Housing, Category Path: Wheel Parts/Housing|Category Name: Wheel Parts Fast Finder, Category Path: Wheel Parts/Wheel Parts Fast Finder', N'Product Image File: Blast-Wheel_Assy__10298.1607442407.1280.1280__26260.1607463955.1280.1280__27025.jpg, Product Image URL: http://durableblastparts.com/product_images/w/071/Blast-Wheel_Assy__10298.1607442407.1280.1280__26260.1607463955.1280.1280__27025.jpg', N'59-0142300, Goff Wheel Housing Base Plate 15/20 HP', N'', N'Buy now online,  59-0142300, Goff Wheel Housing Base Plate 15/20 HP Foot Mounted Motors', N'New', N'/copy-of-goff-base-plate-15-20-hp/', N'', N'', N'Vendor=accounting@planbtulsa.c')
INSERT [dbo].[Product] ([ProductID], [ProductType], [Code], [Name], [Brand], [Description], [CostPrice], [RetailPrice], [SalePrice], [CalculatedPrice], [FixedShippingPrice], [FreeShipping], [AllowPurchases], [ProductVisible], [ProductAvailability], [ProductInventoried], [StockLevel], [LowStockLevel], [CategoryDetails], [Images], [PageTitle], [METAKeywords], [METADescription], [ProductCondition], [ProductURL], [RedirectOldURL], [ProductTaxCode], [ProductCustomFields]) VALUES (1752, N'P', N'DBP-56-0002046', N'Liner, Lid, 12" Blast Wheel, G', N'Goff', N'56-0002046, Liner, Lid, 12" Blast Wheel, Goff Style', N'0', N'0', N'0', N'0', N'0', 0, 1, 1, 0, 0, N'0', N'0', N'Category Name: Wheel Parts, Category Path: Wheel Parts|Category Name: Tumblast Mill Components, Category Path: Cabinet & Material Handling/Tumblast Mill Components|Category Name: Housing, Category Path: Wheel Parts/Housing|Category Name: Wheel Parts Fast Finder, Category Path: Wheel Parts/Wheel Parts Fast Finder', N'', N'56-0002046, Liner, Lid, 12" Blast Wheel, Goff Styl', N'', N'Buy now online,56-0002046, Liner, Lid, 12" Blast Wheel, Goff Style', N'New', N'/liner-lid-12-blast-wheel-goff-style/', N'', N'', N'Vendor=accounting@planbtulsa.c')
INSERT [dbo].[Product] ([ProductID], [ProductType], [Code], [Name], [Brand], [Description], [CostPrice], [RetailPrice], [SalePrice], [CalculatedPrice], [FixedShippingPrice], [FreeShipping], [AllowPurchases], [ProductVisible], [ProductAvailability], [ProductInventoried], [StockLevel], [LowStockLevel], [CategoryDetails], [Images], [PageTitle], [METAKeywords], [METADescription], [ProductCondition], [ProductURL], [RedirectOldURL], [ProductTaxCode], [ProductCustomFields]) VALUES (1753, N'P', N'DBP-59-0102041', N'Lid Assembly, 12" Goff Style B', N'Goff', N'59-0102041, Lid Assembly, 12" Goff Style Blast Wheel Housing', N'0', N'0', N'0', N'0', N'0', 0, 1, 1, 0, 0, N'0', N'0', N'Category Name: Housing, Category Path: Wheel Parts/Housing|Category Name: Wheel Parts Fast Finder, Category Path: Wheel Parts/Wheel Parts Fast Finder', N'Product Image File: 1607464146.1280.1280__72157.jpg, Product Image URL: http://durableblastparts.com/product_images/l/755/1607464146.1280.1280__72157.jpg|Product Image File: 59-0102041__22847.jpg, Product Image URL: http://durableblastparts.com/product_images/r/551/59-0102041__22847.jpg', N'59-0102041, Lid Assembly, 12" Goff Style Blast Whe', N'', N'Buy now online,  59-0102041, Lid Assembly, 12" Goff Style Blast Wheel Housing', N'New', N'/lid-assembly-12-goff-style-blast-wheel-housing/', N'', N'', N'Vendor=accounting@planbtulsa.c')
INSERT [dbo].[Product] ([ProductID], [ProductType], [Code], [Name], [Brand], [Description], [CostPrice], [RetailPrice], [SalePrice], [CalculatedPrice], [FixedShippingPrice], [FreeShipping], [AllowPurchases], [ProductVisible], [ProductAvailability], [ProductInventoried], [StockLevel], [LowStockLevel], [CategoryDetails], [Images], [PageTitle], [METAKeywords], [METADescription], [ProductCondition], [ProductURL], [RedirectOldURL], [ProductTaxCode], [ProductCustomFields]) VALUES (1754, N'P', N'DBP-59-0102045', N'Housing, 12" Blast Wheel, Goff', N'Goff', N'59-0102045, Housing, 12" Blast Wheel, Goff Style', N'0', N'0', N'0', N'0', N'0', 0, 1, 1, 0, 0, N'0', N'0', N'Category Name: Housing, Category Path: Wheel Parts/Housing|Category Name: Wheel Parts Fast Finder, Category Path: Wheel Parts/Wheel Parts Fast Finder', N'Product Image File: 1607464146.1280.1280__72157.1607464709.1280.1280__43008.jpg, Product Image URL: http://durableblastparts.com/product_images/l/432/1607464146.1280.1280__72157.1607464709.1280.1280__43008.jpg|Product Image File: 59-0102045__44410.jpg, Product Image URL: http://durableblastparts.com/product_images/u/987/59-0102045__44410.jpg', N'59-0102045, Housing, 12" Blast Wheel, Goff Style', N'', N'Buy now online,  59-0102045, Housing, 12" Blast Wheel, Goff Style', N'New', N'/housing-12-blast-wheel-goff-style/', N'', N'', N'Vendor=accounting@planbtulsa.c')
INSERT [dbo].[Product] ([ProductID], [ProductType], [Code], [Name], [Brand], [Description], [CostPrice], [RetailPrice], [SalePrice], [CalculatedPrice], [FixedShippingPrice], [FreeShipping], [AllowPurchases], [ProductVisible], [ProductAvailability], [ProductInventoried], [StockLevel], [LowStockLevel], [CategoryDetails], [Images], [PageTitle], [METAKeywords], [METADescription], [ProductCondition], [ProductURL], [RedirectOldURL], [ProductTaxCode], [ProductCustomFields]) VALUES (1755, N'P', N'DBP-56-5000302NS', N'Seal, Spout, 12" Blast Wheel, ', N'Goff', N'56-5000302NS, Seal, Spout, Hub, 12" Blast Wheel, Goff Style', N'0', N'0', N'0', N'0', N'0', 0, 1, 1, 0, 0, N'0', N'0', N'Category Name: Housing, Category Path: Wheel Parts/Housing|Category Name: Wheel Parts Fast Finder, Category Path: Wheel Parts/Wheel Parts Fast Finder', N'Product Image File: 56-5000302__70605.jpg, Product Image URL: http://durableblastparts.com/product_images/s/919/56-5000302__70605.jpg', N'Seal, Spout, 12" Blast Wheel, Goff Style', N'', N'Buy now online, 56-5000302NS, Seal, Spout, Hub, 12" Blast Wheel, Goff Style', N'New', N'/seal-spout-12-blast-wheel-goff-style/', N'', N'', N'Vendor=accounting@planbtulsa.c')
INSERT [dbo].[Product] ([ProductID], [ProductType], [Code], [Name], [Brand], [Description], [CostPrice], [RetailPrice], [SalePrice], [CalculatedPrice], [FixedShippingPrice], [FreeShipping], [AllowPurchases], [ProductVisible], [ProductAvailability], [ProductInventoried], [StockLevel], [LowStockLevel], [CategoryDetails], [Images], [PageTitle], [METAKeywords], [METADescription], [ProductCondition], [ProductURL], [RedirectOldURL], [ProductTaxCode], [ProductCustomFields]) VALUES (1756, N'P', N'DBP-59-0102045-AR', N'Housing, 12, Goff/RimLoc Style', N'Goff', N'59-0102045-AR, Housing, 12, Goff/RimLoc Style, AR Steel', N'0', N'0', N'0', N'0', N'0', 0, 1, 1, 0, 0, N'0', N'0', N'Category Name: Housing, Category Path: Wheel Parts/Housing|Category Name: Wheel Parts Fast Finder, Category Path: Wheel Parts/Wheel Parts Fast Finder', N'Product Image File: 1607464984.1280.1280__15582.jpg, Product Image URL: http://durableblastparts.com/product_images/j/785/1607464984.1280.1280__15582.jpg|Product Image File: 59-0102045__44410.1607464985.1280.1280__01289.jpg, Product Image URL: http://durableblastparts.com/product_images/y/820/59-0102045__44410.1607464985.1280.1280__01289.jpg', N'59-0102045-AR, Housing, 12, Goff/RimLoc Style, AR ', N'', N'Buy now online,  59-0102045-AR, Housing, 12, Goff/RimLoc Style, AR Steel', N'New', N'/housing-12-goff-rimloc-style-ar-steel/', N'', N'', N'Vendor=accounting@planbtulsa.c')
INSERT [dbo].[Product] ([ProductID], [ProductType], [Code], [Name], [Brand], [Description], [CostPrice], [RetailPrice], [SalePrice], [CalculatedPrice], [FixedShippingPrice], [FreeShipping], [AllowPurchases], [ProductVisible], [ProductAvailability], [ProductInventoried], [StockLevel], [LowStockLevel], [CategoryDetails], [Images], [PageTitle], [METAKeywords], [METADescription], [ProductCondition], [ProductURL], [RedirectOldURL], [ProductTaxCode], [ProductCustomFields]) VALUES (1757, N'P', N'DBP-59-1000154', N'Clamp, Blast Plate', N'Goff', N'59-1000154, Clamp, Blast Plate', N'0', N'0', N'0', N'0', N'0', 0, 1, 1, 0, 0, N'0', N'0', N'Category Name: Housing, Category Path: Wheel Parts/Housing|Category Name: Wheel Parts Fast Finder, Category Path: Wheel Parts/Wheel Parts Fast Finder', N'Product Image File: 1607464984.1280.1280__15582.1607465241.1280.1280__88576.jpg, Product Image URL: http://durableblastparts.com/product_images/j/280/1607464984.1280.1280__15582.1607465241.1280.1280__88576.jpg|Product Image File: 59-1000154__97103.jpg, Product Image URL: http://durableblastparts.com/product_images/g/894/59-1000154__97103.jpg', N'59-1000154, Clamp, Blast Plate', N'', N'Buy now online,  59-1000154, Clamp, Blast Plate', N'New', N'/clamp-blast-plate/', N'', N'', N'Vendor=accounting@planbtulsa.c')
INSERT [dbo].[Product] ([ProductID], [ProductType], [Code], [Name], [Brand], [Description], [CostPrice], [RetailPrice], [SalePrice], [CalculatedPrice], [FixedShippingPrice], [FreeShipping], [AllowPurchases], [ProductVisible], [ProductAvailability], [ProductInventoried], [StockLevel], [LowStockLevel], [CategoryDetails], [Images], [PageTitle], [METAKeywords], [METADescription], [ProductCondition], [ProductURL], [RedirectOldURL], [ProductTaxCode], [ProductCustomFields]) VALUES (1758, N'P', N'DBP-58-6000857', N'Bushing, Taper Lock, 2517 x 1-', N'Goff', N'58-6000857, Bushing, Taper Lock, 2517 x 1-3/8"', N'0', N'0', N'0', N'0', N'0', 0, 1, 1, 0, 0, N'0', N'0', N'Category Name: Drive Components, Category Path: Wheel Parts/Drive Components|Category Name: Wheel Parts Fast Finder, Category Path: Wheel Parts/Wheel Parts Fast Finder', N'Product Image File: Taper_lock_bushing_2517__1_point_375__87869.jpg, Product Image URL: http://durableblastparts.com/product_images/k/843/Taper_lock_bushing_2517__1_point_375__87869.jpg', N'Bushing, Taper Lock, 2517 x 1-3/8"', N'', N'Buy now online, 58-6000857, Bushing, Taper Lock, 2517 x 1-3/8"', N'New', N'/bushing-taper-lock-2517-x-1-3-8/', N'', N'', N'Vendor=accounting@planbtulsa.c')
INSERT [dbo].[Product] ([ProductID], [ProductType], [Code], [Name], [Brand], [Description], [CostPrice], [RetailPrice], [SalePrice], [CalculatedPrice], [FixedShippingPrice], [FreeShipping], [AllowPurchases], [ProductVisible], [ProductAvailability], [ProductInventoried], [StockLevel], [LowStockLevel], [CategoryDetails], [Images], [PageTitle], [METAKeywords], [METADescription], [ProductCondition], [ProductURL], [RedirectOldURL], [ProductTaxCode], [ProductCustomFields]) VALUES (1759, N'P', N'DBP-59-5100301', N'Adapter, Cage, Outer, 12" Blas', N'Goff', N'59-5100301, Adapter, Cage, Outer, 12" Blast Wheel, Goff Style', N'0', N'0', N'0', N'0', N'0', 0, 1, 1, 0, 0, N'0', N'0', N'Category Name: Housing, Category Path: Wheel Parts/Housing|Category Name: Wheel Parts Fast Finder, Category Path: Wheel Parts/Wheel Parts Fast Finder', N'Product Image File: 5100301_2__60377.jpg, Product Image URL: http://durableblastparts.com/product_images/z/865/5100301_2__60377.jpg', N'59-5100301, Adapter, Cage, Outer, 12" Blast Wheel,', N'', N'Buy now online, 59-5100301, Adapter, Cage, Outer, 12" Blast Wheel, Goff Style', N'New', N'/adapter-cage-outer-12-blast-wheel-goff-style/', N'', N'', N'Vendor=accounting@planbtulsa.c')
INSERT [dbo].[Product] ([ProductID], [ProductType], [Code], [Name], [Brand], [Description], [CostPrice], [RetailPrice], [SalePrice], [CalculatedPrice], [FixedShippingPrice], [FreeShipping], [AllowPurchases], [ProductVisible], [ProductAvailability], [ProductInventoried], [StockLevel], [LowStockLevel], [CategoryDetails], [Images], [PageTitle], [METAKeywords], [METADescription], [ProductCondition], [ProductURL], [RedirectOldURL], [ProductTaxCode], [ProductCustomFields]) VALUES (1760, N'P', N'DBP-58-6000956', N'Bushing, Taper Lock, 2517 x 1-', N'Goff', N'58-6000956, Bushing, Taper Lock, 2517 x 1-5/8"', N'0', N'0', N'0', N'0', N'0', 0, 1, 1, 0, 0, N'0', N'0', N'Category Name: Drive Components, Category Path: Wheel Parts/Drive Components|Category Name: Wheel Parts Fast Finder, Category Path: Wheel Parts/Wheel Parts Fast Finder', N'Product Image File: Taper_lock_bushing_2517__1_point_375__87869.1607466125.1280.1280__10059.jpg, Product Image URL: http://durableblastparts.com/product_images/y/695/Taper_lock_bushing_2517__1_point_375__87869.1607466125.1280.1280__10059.jpg', N'Bushing, Taper Lock, 2517 x 1-5/8"', N'', N'Buy now online, 58-6000956, Bushing, Taper Lock, 2517 x 1-5/8"', N'New', N'/bushing-taper-lock-2517-x-1-5-8/', N'', N'', N'Vendor=accounting@planbtulsa.c')
INSERT [dbo].[Product] ([ProductID], [ProductType], [Code], [Name], [Brand], [Description], [CostPrice], [RetailPrice], [SalePrice], [CalculatedPrice], [FixedShippingPrice], [FreeShipping], [AllowPurchases], [ProductVisible], [ProductAvailability], [ProductInventoried], [StockLevel], [LowStockLevel], [CategoryDetails], [Images], [PageTitle], [METAKeywords], [METADescription], [ProductCondition], [ProductURL], [RedirectOldURL], [ProductTaxCode], [ProductCustomFields]) VALUES (1761, N'P', N'DBP-59-5200013', N'Wheel, Bare, 7 Blade, HT, 12" ', N'Goff', N'59-5200013, Wheel, Bare, 7 Blade, HT, 12" Blast Wheel, Goff Style', N'0', N'0', N'0', N'0', N'0', 0, 1, 1, 0, 0, N'0', N'0', N'Category Name: Wheel Parts, Category Path: Wheel Parts|Category Name: Wheel Internals, Category Path: Wheel Parts/Wheel Internals|Category Name: Wheel Parts Fast Finder, Category Path: Wheel Parts/Wheel Parts Fast Finder', N'Product Image File: 59-520013__57105.jpg, Product Image URL: http://durableblastparts.com/product_images/l/547/59-520013__57105.jpg', N'59-5200013, Wheel, Bare, 7 Blade, HT, 12" Blast Wh', N'', N'Buy now online, 59-5200013, Wheel, Bare, 7 Blade, HT, 12" Blast Wheel, Goff Style', N'New', N'/wheel-bare-7-blade-ht-12-blast-wheel-goff-style/', N'', N'', N'Vendor=accounting@planbtulsa.c')
INSERT [dbo].[Product] ([ProductID], [ProductType], [Code], [Name], [Brand], [Description], [CostPrice], [RetailPrice], [SalePrice], [CalculatedPrice], [FixedShippingPrice], [FreeShipping], [AllowPurchases], [ProductVisible], [ProductAvailability], [ProductInventoried], [StockLevel], [LowStockLevel], [CategoryDetails], [Images], [PageTitle], [METAKeywords], [METADescription], [ProductCondition], [ProductURL], [RedirectOldURL], [ProductTaxCode], [ProductCustomFields]) VALUES (1762, N'P', N'DBP-5800254', N'Adapter, Taper Lock', N'Goff', N'5800254, Adapter, Taper Lock', N'0', N'0', N'0', N'0', N'0', 0, 1, 1, 0, 0, N'0', N'0', N'Category Name: Drive Components, Category Path: Wheel Parts/Drive Components|Category Name: Wheel Parts Fast Finder, Category Path: Wheel Parts/Wheel Parts Fast Finder', N'Product Image File: Taper_lock_bushing_2517__1_point_375__09360.jpg, Product Image URL: http://durableblastparts.com/product_images/r/544/Taper_lock_bushing_2517__1_point_375__09360.jpg', N'5800254, Adapter, Taper Lock', N'', N'Buy now online, 5800254, Adapter, Taper Lock', N'New', N'/adapter-taper-lock/', N'', N'', N'Vendor=accounting@planbtulsa.c')
INSERT [dbo].[Product] ([ProductID], [ProductType], [Code], [Name], [Brand], [Description], [CostPrice], [RetailPrice], [SalePrice], [CalculatedPrice], [FixedShippingPrice], [FreeShipping], [AllowPurchases], [ProductVisible], [ProductAvailability], [ProductInventoried], [StockLevel], [LowStockLevel], [CategoryDetails], [Images], [PageTitle], [METAKeywords], [METADescription], [ProductCondition], [ProductURL], [RedirectOldURL], [ProductTaxCode], [ProductCustomFields]) VALUES (1763, N'P', N'DBP-41868', N'DBP-41868 | Hub Assembly-"Q" W', N'Wheelabrator', N'Picture is representative of product. Hub Assembly-"Q" Wheel - Wheel MODEL: Q Wheel Machine Mfg: Wheelabrator Addtional Details: Wheel Hub is 2.5" I.D. x 11" O.D. with Bare Wheel Insert Dia. 10.875.  8" Dia. - Center Line Bolt Parttern (8-bolts) (8) 1/2" x 1-1/4" long Hex Hd bolts (are not included)', N'0', N'0', N'0', N'0', N'0', 0, 1, 1, 1, 0, N'0', N'0', N'Category Name: Wheel Internals, Category Path: Wheel Parts/Wheel Internals', N'Product Image File: generichub__31919.1595424024.1280.1280__98929.jpg, Product Image URL: http://durableblastparts.com/product_images/z/408/generichub__31919.1595424024.1280.1280__98929.jpg', N'Wheelabrator,DBP-41868 | Hub Assembly-"Q"', N'Wheelabrator,DBP-164677 | Hub Assembly-"M"&"RLM" With T.L.-Special Lngth,,Hub Assembly-"M"&"RLM" With T.L.-Special Lngth,Wheel MODEL: M Wheel,,Machine Mfg: Wheelabrator', N',Hub Assembly-"Q" ,Wheel MODEL: Q Wheel,,Machine Mfg: Wheelabrator', N'New', N'/dbp-41868-hub-assembly-q-wheel/', N'', N'', N'Vendor=jackie@astechblast.com;')
INSERT [dbo].[Product] ([ProductID], [ProductType], [Code], [Name], [Brand], [Description], [CostPrice], [RetailPrice], [SalePrice], [CalculatedPrice], [FixedShippingPrice], [FreeShipping], [AllowPurchases], [ProductVisible], [ProductAvailability], [ProductInventoried], [StockLevel], [LowStockLevel], [CategoryDetails], [Images], [PageTitle], [METAKeywords], [METADescription], [ProductCondition], [ProductURL], [RedirectOldURL], [ProductTaxCode], [ProductCustomFields]) VALUES (1764, N'P', N'DBP-59-8100029', N'Motor, 7.5HP Blast Wheel', N'Goff', N'59-8100029, Motor, 7.5HP Blast Wheel', N'0', N'0', N'0', N'0', N'0', 0, 1, 1, 0, 0, N'0', N'0', N'Category Name: Drive Components, Category Path: Wheel Parts/Drive Components|Category Name: Wheel Parts Fast Finder, Category Path: Wheel Parts/Wheel Parts Fast Finder', N'Product Image File: m_mtcp27p53bd18__75313.jpg, Product Image URL: http://durableblastparts.com/product_images/j/923/m_mtcp27p53bd18__75313.jpg', N'59-8100029, Motor, 7.5HP Blast Wheel', N'', N'Buy now online, 59-8100029, Motor, 7.5HP Blast Wheel', N'New', N'/DBP-59-8100029/', N'', N'', N'Vendor=accounting@planbtulsa.c')
INSERT [dbo].[Product] ([ProductID], [ProductType], [Code], [Name], [Brand], [Description], [CostPrice], [RetailPrice], [SalePrice], [CalculatedPrice], [FixedShippingPrice], [FreeShipping], [AllowPurchases], [ProductVisible], [ProductAvailability], [ProductInventoried], [StockLevel], [LowStockLevel], [CategoryDetails], [Images], [PageTitle], [METAKeywords], [METADescription], [ProductCondition], [ProductURL], [RedirectOldURL], [ProductTaxCode], [ProductCustomFields]) VALUES (1765, N'P', N'DBP-59-8100546', N'Motor, 10HP Blast Wheel', N'Goff', N'59-8100546, Motor, 10HP Blast Wheel', N'0', N'0', N'0', N'0', N'0', 0, 1, 1, 0, 0, N'0', N'0', N'Category Name: Wheel Parts, Category Path: Wheel Parts|Category Name: Drive Components, Category Path: Wheel Parts/Drive Components|Category Name: Wheel Parts Fast Finder, Category Path: Wheel Parts/Wheel Parts Fast Finder', N'Product Image File: m_mtcp27p53bd18__75313.1610999211.1280.1280__00786.jpg, Product Image URL: http://durableblastparts.com/product_images/d/623/m_mtcp27p53bd18__75313.1610999211.1280.1280__00786.jpg', N'59-8100546, Motor, 10HP Blast Wheel', N'', N'Buy now online, 59-8100029, Motor, 7.5HP Blast Wheel', N'New', N'/motor-10hp-blast-wheel/', N'', N'', N'Vendor=accounting@planbtulsa.c')
INSERT [dbo].[Product] ([ProductID], [ProductType], [Code], [Name], [Brand], [Description], [CostPrice], [RetailPrice], [SalePrice], [CalculatedPrice], [FixedShippingPrice], [FreeShipping], [AllowPurchases], [ProductVisible], [ProductAvailability], [ProductInventoried], [StockLevel], [LowStockLevel], [CategoryDetails], [Images], [PageTitle], [METAKeywords], [METADescription], [ProductCondition], [ProductURL], [RedirectOldURL], [ProductTaxCode], [ProductCustomFields]) VALUES (1766, N'P', N'DBP-59-8101030', N'Motor, 15HP Blast Wheel', N'Goff', N'59-8101030, Motor, 15HP Blast Wheel', N'0', N'0', N'0', N'0', N'0', 0, 1, 1, 0, 0, N'0', N'0', N'Category Name: Wheel Parts, Category Path: Wheel Parts|Category Name: Drive Components, Category Path: Wheel Parts/Drive Components|Category Name: Wheel Parts Fast Finder, Category Path: Wheel Parts/Wheel Parts Fast Finder', N'Product Image File: 15_HP__57074.jpg, Product Image URL: http://durableblastparts.com/product_images/p/976/15_HP__57074.jpg', N'59-8101030, Motor, 15HP Blast Wheel', N'', N'Buy now online,59-8101030, Motor, 15HP Blast Wheel', N'New', N'/motor-15hp-blast-wheel/', N'', N'', N'Vendor=accounting@planbtulsa.c')
INSERT [dbo].[Product] ([ProductID], [ProductType], [Code], [Name], [Brand], [Description], [CostPrice], [RetailPrice], [SalePrice], [CalculatedPrice], [FixedShippingPrice], [FreeShipping], [AllowPurchases], [ProductVisible], [ProductAvailability], [ProductInventoried], [StockLevel], [LowStockLevel], [CategoryDetails], [Images], [PageTitle], [METAKeywords], [METADescription], [ProductCondition], [ProductURL], [RedirectOldURL], [ProductTaxCode], [ProductCustomFields]) VALUES (1767, N'P', N'DBP-59-0105763-A', N'Valve, Abrasive, 2-1/4''''  Assy', N'Goff', N'59-0105763-A Abrasive Control Valve, Goff Style 2-1/4'''' Assy Complete w/Air Cylinder', N'0', N'0', N'0', N'0', N'0', 0, 1, 1, 0, 0, N'0', N'0', N'Category Name: Wheel Parts, Category Path: Wheel Parts|Category Name: Abrasive Feed Valves & Hoses, Category Path: Wheel Parts/Abrasive Feed Valves & Hoses', N'Product Image File: 59-0105763-A__92485.jpg, Product Image URL: http://durableblastparts.com/product_images/w/020/59-0105763-A__92485.jpg', N'Valve, Abrasive, 2-1/4''''  Assy Complete w/Air Cyli', N'', N'By now online, 59-0105763-A, Valve, Abrasive, 2-1/4''''  Assy Complete w/Air Cylinder, Goff Style', N'New', N'/valve-abrasive-2-1-4-assy-complete-w-air-cylinder-goff-style/', N'', N'', N'Vendor=accounting@planbtulsa.c')
INSERT [dbo].[Product] ([ProductID], [ProductType], [Code], [Name], [Brand], [Description], [CostPrice], [RetailPrice], [SalePrice], [CalculatedPrice], [FixedShippingPrice], [FreeShipping], [AllowPurchases], [ProductVisible], [ProductAvailability], [ProductInventoried], [StockLevel], [LowStockLevel], [CategoryDetails], [Images], [PageTitle], [METAKeywords], [METADescription], [ProductCondition], [ProductURL], [RedirectOldURL], [ProductTaxCode], [ProductCustomFields]) VALUES (1768, N'P', N'DBP-59-0106040', N'Valve, Abrasive, 3''''  Assy Com', N'Goff', N'59-0106040 Abrasive Control Valve, Goff Style 3'''' Assy Complete w/Air Cylinder', N'0', N'0', N'0', N'0', N'0', 0, 1, 1, 0, 0, N'0', N'0', N'Category Name: Wheel Parts, Category Path: Wheel Parts|Category Name: Abrasive Feed Valves & Hoses, Category Path: Wheel Parts/Abrasive Feed Valves & Hoses', N'Product Image File: 59-0105763-A__92485.1611001474.1280.1280__02540.jpg, Product Image URL: http://durableblastparts.com/product_images/n/072/59-0105763-A__92485.1611001474.1280.1280__02540.jpg', N'59-0106040, Valve, Abrasive, 3''''  Assy Complete w/', N'', N'By now online, 59-0106040, Valve, Abrasive, 3''''  Assy Complete w/Air Cylinder, Goff Style', N'New', N'/valve-abrasive-3-assy-complete-w-air-cylinder-goff-style/', N'', N'', N'Vendor=accounting@planbtulsa.c')
INSERT [dbo].[Product] ([ProductID], [ProductType], [Code], [Name], [Brand], [Description], [CostPrice], [RetailPrice], [SalePrice], [CalculatedPrice], [FixedShippingPrice], [FreeShipping], [AllowPurchases], [ProductVisible], [ProductAvailability], [ProductInventoried], [StockLevel], [LowStockLevel], [CategoryDetails], [Images], [PageTitle], [METAKeywords], [METADescription], [ProductCondition], [ProductURL], [RedirectOldURL], [ProductTaxCode], [ProductCustomFields]) VALUES (1769, N'P', N'DBP-52-5000294', N'Ring, Shear, Ring, Shear, 12",', N'Goff', N'52-5000294 Ring, Shear, 12", 10" & 9" Blast Wheels Goff Style', N'0', N'0', N'0', N'0', N'0', 0, 1, 1, 0, 0, N'0', N'0', N'Category Name: Wheel Parts, Category Path: Wheel Parts|Category Name: Drive Components, Category Path: Wheel Parts/Drive Components', N'Product Image File: 52-5000294__22157.jpg, Product Image URL: http://durableblastparts.com/product_images/l/489/52-5000294__22157.jpg', N'52-5000294, Ring, Shear, 12", 10" & 9" Blast Wheel', N'', N'By now online, 52-5000294, Ring, Shear, 12", 10" & 9" Blast Wheels, Goff Style', N'New', N'/ring-shear-ring-shear-12-10-9-blast-wheels-goff-style/', N'', N'', N'Vendor=accounting@planbtulsa.c')
INSERT [dbo].[Product] ([ProductID], [ProductType], [Code], [Name], [Brand], [Description], [CostPrice], [RetailPrice], [SalePrice], [CalculatedPrice], [FixedShippingPrice], [FreeShipping], [AllowPurchases], [ProductVisible], [ProductAvailability], [ProductInventoried], [StockLevel], [LowStockLevel], [CategoryDetails], [Images], [PageTitle], [METAKeywords], [METADescription], [ProductCondition], [ProductURL], [RedirectOldURL], [ProductTaxCode], [ProductCustomFields]) VALUES (1770, N'P', N'DBP-58-6000531', N'Pin, Roll 1/4 x 7/8', N'Goff', N'58-6000531 Pin, Roll 1/4 x 7/8', N'0', N'0', N'0', N'0', N'0', 0, 1, 1, 0, 0, N'0', N'0', N'Category Name: Wheel Parts, Category Path: Wheel Parts|Category Name: Drive Components, Category Path: Wheel Parts/Drive Components', N'Product Image File: roll_pin__74464.PNG, Product Image URL: http://durableblastparts.com/product_images/a/774/roll_pin__74464.PNG', N'58-6000531, Pin, Roll 1/4 x 7/8, Goff Style', N'', N'By now online, 58-6000531, Pin, Roll 1/4 x 7/8, Goff Style', N'New', N'/pin-roll-1-4-x-7-8/', N'', N'', N'Vendor=accounting@planbtulsa.c')
INSERT [dbo].[Product] ([ProductID], [ProductType], [Code], [Name], [Brand], [Description], [CostPrice], [RetailPrice], [SalePrice], [CalculatedPrice], [FixedShippingPrice], [FreeShipping], [AllowPurchases], [ProductVisible], [ProductAvailability], [ProductInventoried], [StockLevel], [LowStockLevel], [CategoryDetails], [Images], [PageTitle], [METAKeywords], [METADescription], [ProductCondition], [ProductURL], [RedirectOldURL], [ProductTaxCode], [ProductCustomFields]) VALUES (1771, N'P', N'DBP-58-6000962', N'Washer, Lock, Hi-Collar, 5/8"', N'Goff', N'58-6000962 Washer, Lock, Hi-Collar, 5/8"', N'0', N'0', N'0', N'0', N'0', 0, 1, 1, 0, 0, N'0', N'0', N'Category Name: Wheel Parts, Category Path: Wheel Parts|Category Name: Drive Components, Category Path: Wheel Parts/Drive Components', N'Product Image File: Hi_Collar_Lock_Washer__59546.PNG, Product Image URL: http://durableblastparts.com/product_images/j/117/Hi_Collar_Lock_Washer__59546.PNG', N'58-6000962, Washer, Lock, Hi-Collar, 5/8"', N'', N'By now online, 58-6000962, Washer, Lock, Hi-Collar, 5/8"', N'New', N'/washer-lock-hi-collar-5-8/', N'', N'', N'')
INSERT [dbo].[Product] ([ProductID], [ProductType], [Code], [Name], [Brand], [Description], [CostPrice], [RetailPrice], [SalePrice], [CalculatedPrice], [FixedShippingPrice], [FreeShipping], [AllowPurchases], [ProductVisible], [ProductAvailability], [ProductInventoried], [StockLevel], [LowStockLevel], [CategoryDetails], [Images], [PageTitle], [METAKeywords], [METADescription], [ProductCondition], [ProductURL], [RedirectOldURL], [ProductTaxCode], [ProductCustomFields]) VALUES (1772, N'P', N'DBP-58-6101159', N'Clevis, Yoke End, 1/2'''' Post', N'Goff', N'58-6101159 Abrasive Control Valve, Goff Style Clevis, Yoke End, 1/2'''' Post', N'0', N'0', N'0', N'0', N'0', 0, 1, 1, 0, 0, N'0', N'0', N'Category Name: Wheel Parts, Category Path: Wheel Parts|Category Name: Housing, Category Path: Wheel Parts/Housing', N'Product Image File: 58-6101159__52620.jpg, Product Image URL: http://durableblastparts.com/product_images/s/661/58-6101159__52620.jpg', N'58-6101159, Clevis, Yoke End, 1/2'''' Post, Goff Sty', N'', N'By now online, 58-6101159, Clevis, Yoke End, 1/2'''' Post', N'New', N'/clevis-yoke-end-1-2-post/', N'', N'', N'Vendor=accounting@planbtulsa.c')
INSERT [dbo].[Product] ([ProductID], [ProductType], [Code], [Name], [Brand], [Description], [CostPrice], [RetailPrice], [SalePrice], [CalculatedPrice], [FixedShippingPrice], [FreeShipping], [AllowPurchases], [ProductVisible], [ProductAvailability], [ProductInventoried], [StockLevel], [LowStockLevel], [CategoryDetails], [Images], [PageTitle], [METAKeywords], [METADescription], [ProductCondition], [ProductURL], [RedirectOldURL], [ProductTaxCode], [ProductCustomFields]) VALUES (1773, N'P', N'DBP-58-7003910', N'Bolt, Blade Block, 1/2"-13 x 1', N'Goff', N'58-7003910 Bolt, Blade Block, 1/2"-13 x 1" 12" Blast Wheel, Goff Style', N'0', N'0', N'0', N'0', N'0', 0, 1, 1, 0, 0, N'0', N'0', N'Category Name: Wheel Parts, Category Path: Wheel Parts|Category Name: Wheel Internals, Category Path: Wheel Parts/Wheel Internals|Category Name: Wheel Parts Fast Finder, Category Path: Wheel Parts/Wheel Parts Fast Finder', N'Product Image File: 1__blade_block_bolt__19771.PNG, Product Image URL: http://durableblastparts.com/product_images/q/328/1__blade_block_bolt__19771.PNG', N'58-7003910, Bolt, Blade Block, 1/2"-13 x 1", 12" B', N'', N'Buy now online, 58-7003910, Bolt, Blade Block, 1/2"-13 x 1", 12" Blast Wheel, Goff Style', N'New', N'/bolt-blade-block-1-2-13-x-1-12-blast-wheel-goff-style/', N'', N'', N'Vendor=accounting@planbtulsa.c')
INSERT [dbo].[Product] ([ProductID], [ProductType], [Code], [Name], [Brand], [Description], [CostPrice], [RetailPrice], [SalePrice], [CalculatedPrice], [FixedShippingPrice], [FreeShipping], [AllowPurchases], [ProductVisible], [ProductAvailability], [ProductInventoried], [StockLevel], [LowStockLevel], [CategoryDetails], [Images], [PageTitle], [METAKeywords], [METADescription], [ProductCondition], [ProductURL], [RedirectOldURL], [ProductTaxCode], [ProductCustomFields]) VALUES (1774, N'P', N'DBP-58-7003920', N'Bolt, Blade Block, 1/2"-13 x 2', N'Goff', N'58-7003920 Bolt, Blade Block, 1/2"-13 x 2" 12" Blast Wheel, Goff Style', N'0', N'0', N'0', N'0', N'0', 0, 1, 1, 0, 0, N'0', N'0', N'Category Name: Wheel Parts, Category Path: Wheel Parts|Category Name: Wheel Internals, Category Path: Wheel Parts/Wheel Internals|Category Name: Wheel Parts Fast Finder, Category Path: Wheel Parts/Wheel Parts Fast Finder', N'Product Image File: 1__blade_block_bolt__19771.1611004868.1280.1280__32040.jpg, Product Image URL: http://durableblastparts.com/product_images/k/838/1__blade_block_bolt__19771.1611004868.1280.1280__32040.jpg', N'58-7003920, Bolt, Blade Block, 1/2"-13 x 2", 12" B', N'', N'Buy now online, 58-7003920, Bolt, Blade Block, 1/2"-13 x 2", 12" Blast Wheel, Goff Style', N'New', N'/bolt-blade-block-1-2-13-x-2-12-blast-wheel-goff-style/', N'', N'', N'Vendor=accounting@planbtulsa.c')
INSERT [dbo].[Product] ([ProductID], [ProductType], [Code], [Name], [Brand], [Description], [CostPrice], [RetailPrice], [SalePrice], [CalculatedPrice], [FixedShippingPrice], [FreeShipping], [AllowPurchases], [ProductVisible], [ProductAvailability], [ProductInventoried], [StockLevel], [LowStockLevel], [CategoryDetails], [Images], [PageTitle], [METAKeywords], [METADescription], [ProductCondition], [ProductURL], [RedirectOldURL], [ProductTaxCode], [ProductCustomFields]) VALUES (1775, N'P', N'DBP-58-7004114', N'Bolt, Impeller, 5/8"-11 x 1-1/', N'Goff', N'58-7004114 Bolt, Impeller, 5/8"-11 x 1-1/2" 12" Blast Wheel, Goff Style', N'0', N'0', N'0', N'0', N'0', 0, 1, 1, 0, 0, N'0', N'0', N'Category Name: Wheel Parts, Category Path: Wheel Parts|Category Name: Wheel Internals, Category Path: Wheel Parts/Wheel Internals|Category Name: Wheel Parts Fast Finder, Category Path: Wheel Parts/Wheel Parts Fast Finder', N'Product Image File: 7004114__42534.jpg, Product Image URL: http://durableblastparts.com/product_images/a/090/7004114__42534.jpg', N'58-7004114, Bolt, Impeller, 5/8"-11 x 1-1/2", 12" ', N'', N'Buy now online, 58-7004114, Bolt, Impeller, 5/8"-11 x 1-1/2", 12" Blast Wheel, Goff Style', N'New', N'/bolt-impeller-5-8-11-x-1-1-2-12-blast-wheel-goff-style/', N'', N'', N'Vendor=accounting@planbtulsa.c')
INSERT [dbo].[Product] ([ProductID], [ProductType], [Code], [Name], [Brand], [Description], [CostPrice], [RetailPrice], [SalePrice], [CalculatedPrice], [FixedShippingPrice], [FreeShipping], [AllowPurchases], [ProductVisible], [ProductAvailability], [ProductInventoried], [StockLevel], [LowStockLevel], [CategoryDetails], [Images], [PageTitle], [METAKeywords], [METADescription], [ProductCondition], [ProductURL], [RedirectOldURL], [ProductTaxCode], [ProductCustomFields]) VALUES (1776, N'P', N'DBP-58-7009523', N'Stud, Support, 3/8"-16 x 2-1/2', N'Goff', N'58-7009523 Stud, Support 3/8"-16 x 2-1/2''''', N'0', N'0', N'0', N'0', N'0', 0, 1, 1, 0, 0, N'0', N'0', N'Category Name: Housing, Category Path: Wheel Parts/Housing|Category Name: Wheel Parts Fast Finder, Category Path: Wheel Parts/Wheel Parts Fast Finder', N'Product Image File: bolt__97665.PNG, Product Image URL: http://durableblastparts.com/product_images/z/104/bolt__97665.PNG', N'58-7009523, Stud, Support, 3/8"-16 x 2-1/2''''', N'', N'Buy now online,  58-7009523, Stud, Support, 3/8"-16 x 2-1/2''''', N'New', N'/stud-support-3-8-16-x-2-1-2/', N'', N'', N'Vendor=accounting@planbtulsa.c')
INSERT [dbo].[Product] ([ProductID], [ProductType], [Code], [Name], [Brand], [Description], [CostPrice], [RetailPrice], [SalePrice], [CalculatedPrice], [FixedShippingPrice], [FreeShipping], [AllowPurchases], [ProductVisible], [ProductAvailability], [ProductInventoried], [StockLevel], [LowStockLevel], [CategoryDetails], [Images], [PageTitle], [METAKeywords], [METADescription], [ProductCondition], [ProductURL], [RedirectOldURL], [ProductTaxCode], [ProductCustomFields]) VALUES (1777, N'P', N'DBP-BT070D', N'DBP-BT070D | Seal, Graphite', N'Blastec', N'Picture is representative of product. Seal, Graphite Wheel MODEL: 24" Blastech DIA OF WHEEL: 24.00" Blades / VANES: 8 Blades Machine Mfg: Blastec', N'0', N'0', N'0', N'0', N'0', 0, 1, 1, 0, 0, N'0', N'0', N'Category Name: Wheel Internals, Category Path: Wheel Parts/Wheel Internals|Category Name: Wheel Parts Fast Finder, Category Path: Wheel Parts/Wheel Parts Fast Finder', N'Product Image File: BlastecGeneric__15974.1595424043.1280.1280__58501.jpg, Product Image URL: http://durableblastparts.com/product_images/d/263/BlastecGeneric__15974.1595424043.1280.1280__58501.jpg|Product Image File: BlastecGeneric2__71446.1595424043.1280.1280__43220.jpg, Product Image URL: http://durableblastparts.com/product_images/a/377/BlastecGeneric2__71446.1595424043.1280.1280__43220.jpg', N'Blastec,DBP-BT070D Seal, Graphite', N'Blastec,DBP-BT70C-1 | Seal, Hub Poly Felt (3pc),,Seal, Hub Poly Felt (3pc),Wheel MODEL: 24" Blastech,DIA OF WHEEL: 24.00",Blades / VANES: 8 Blades,,Machine Mfg: Blastec', N',Durable Blast Parts,DBP-BT070D Seal, Graphite,Wheel MODEL: 24" Blastech,DIA OF WHEEL: 24.00",Blades / VANES: 8 Blades,,Machine Mfg: Blastec', N'New', N'/dbp-bt070d-seal-graphite/', N'', N'', N'Vendor=contact@blastec.com;"Wh')
INSERT [dbo].[Product] ([ProductID], [ProductType], [Code], [Name], [Brand], [Description], [CostPrice], [RetailPrice], [SalePrice], [CalculatedPrice], [FixedShippingPrice], [FreeShipping], [AllowPurchases], [ProductVisible], [ProductAvailability], [ProductInventoried], [StockLevel], [LowStockLevel], [CategoryDetails], [Images], [PageTitle], [METAKeywords], [METADescription], [ProductCondition], [ProductURL], [RedirectOldURL], [ProductTaxCode], [ProductCustomFields]) VALUES (1778, N'P', N'DBP-BT15TL45', N'DBP-BT15TL45 | Runner Head Hub', N'Blastec', N'Picture is representative of product. Runner Head Hub CW/CCW, 40 - 50HP Wheel MODEL: 24" Blastech DIA OF WHEEL: 24.00" Blades / VANES: 8 Blades ROTATION: Bidirectional Machine Mfg: Blastec', N'0', N'0', N'0', N'0', N'0', 0, 1, 1, 0, 0, N'0', N'0', N'Category Name: Wheel Internals, Category Path: Wheel Parts/Wheel Internals', N'Product Image File: BlastecGeneric__43902.1611265095.1280.1280__10104.jpg, Product Image URL: http://durableblastparts.com/product_images/d/283/BlastecGeneric__43902.1611265095.1280.1280__10104.jpg|Product Image File: BlastecGeneric2__34419.1611265095.1280.1280__78084.jpg, Product Image URL: http://durableblastparts.com/product_images/y/909/BlastecGeneric2__34419.1611265095.1280.1280__78084.jpg', N'Blastec,DBP-BT15TL45 | Runner Head Hub CW/CCW', N'Blastec,DBP-BT15TL | Runner Head Hub CW/CCW,,Runner Head Hub CW/CCW ,Wheel MODEL: 24" Blastech,DIA OF WHEEL: 24.00",Blades / VANES: 8 Blades,ROTATION: Bidirectional,Machine Mfg: Blastec', N',Runner Head Hub CW/CCW ,Wheel MODEL: 24" Blastech,DIA OF WHEEL: 24.00",Blades / VANES: 8 Blades,ROTATION: Bidirectional,Machine Mfg: Blastec', N'New', N'/dbp-bt15tl45-runner-head-hub-cw-ccw-40-50hp/', N'', N'', N'Vendor=contact@blastec.com;"Wh')
INSERT [dbo].[Product] ([ProductID], [ProductType], [Code], [Name], [Brand], [Description], [CostPrice], [RetailPrice], [SalePrice], [CalculatedPrice], [FixedShippingPrice], [FreeShipping], [AllowPurchases], [ProductVisible], [ProductAvailability], [ProductInventoried], [StockLevel], [LowStockLevel], [CategoryDetails], [Images], [PageTitle], [METAKeywords], [METADescription], [ProductCondition], [ProductURL], [RedirectOldURL], [ProductTaxCode], [ProductCustomFields]) VALUES (1779, N'P', N'DBP-BT15TL67', N'DBP-BT15TL67 | Runner Head Hub', N'Blastec', N'Picture is representative of product. Runner Head Hub CW/CCW, 60 - 75HP Wheel MODEL: 24" Blastech DIA OF WHEEL: 24.00" Blades / VANES: 8 Blades ROTATION: Bidirectional Machine Mfg: Blastec', N'0', N'0', N'0', N'0', N'0', 0, 1, 1, 0, 0, N'0', N'0', N'Category Name: Wheel Internals, Category Path: Wheel Parts/Wheel Internals', N'Product Image File: BlastecGeneric__43902.1611265095.1280.1280__10104.1611265388.1280.1280__87832.jpg, Product Image URL: http://durableblastparts.com/product_images/c/440/BlastecGeneric__43902.1611265095.1280.1280__10104.1611265388.1280.1280__87832.jpg|Product Image File: BlastecGeneric2__34419.1611265095.1280.1280__78084.1611265388.1280.1280__97622.jpg, Product Image URL: http://durableblastparts.com/product_images/h/028/BlastecGeneric2__34419.1611265095.1280.1280__78084.1611265388.1280.1280__', N'Blastec,DBP-BT15TL67 | Runner Head Hub CW/CCW', N'Blastec,DBP-BT15TL | Runner Head Hub CW/CCW,,Runner Head Hub CW/CCW ,Wheel MODEL: 24" Blastech,DIA OF WHEEL: 24.00",Blades / VANES: 8 Blades,ROTATION: Bidirectional,Machine Mfg: Blastec', N',Runner Head Hub CW/CCW ,Wheel MODEL: 24" Blastech,DIA OF WHEEL: 24.00",Blades / VANES: 8 Blades,ROTATION: Bidirectional,Machine Mfg: Blastec', N'New', N'/dbp-bt15tl67-runner-head-hub-cw-ccw-60-75hp/', N'', N'', N'Vendor=contact@blastec.com;"Wh')
INSERT [dbo].[Product] ([ProductID], [ProductType], [Code], [Name], [Brand], [Description], [CostPrice], [RetailPrice], [SalePrice], [CalculatedPrice], [FixedShippingPrice], [FreeShipping], [AllowPurchases], [ProductVisible], [ProductAvailability], [ProductInventoried], [StockLevel], [LowStockLevel], [CategoryDetails], [Images], [PageTitle], [METAKeywords], [METADescription], [ProductCondition], [ProductURL], [RedirectOldURL], [ProductTaxCode], [ProductCustomFields]) VALUES (1780, N'P', N'DBP-BT15TL100', N'DBP-BT15TL100 | Runner Head Hu', N'Blastec', N'Picture is representative of product. Runner Head Hub CW/CCW, 100HP Wheel MODEL: 24" Blastech DIA OF WHEEL: 24.00" Blades / VANES: 8 Blades ROTATION: Bidirectional Machine Mfg: Blastec', N'0', N'0', N'0', N'0', N'0', 0, 1, 1, 0, 0, N'0', N'0', N'Category Name: Wheel Internals, Category Path: Wheel Parts/Wheel Internals', N'Product Image File: BlastecGeneric2__34419.1611265095.1280.1280__78084.1611265388.1280.1280__72363.jpg, Product Image URL: http://durableblastparts.com/product_images/c/769/BlastecGeneric2__34419.1611265095.1280.1280__78084.1611265388.1280.1280__72363.jpg|Product Image File: BlastecGeneric__43902.1611265095.1280.1280__10104.1611265388.1280.1280__45751.jpg, Product Image URL: http://durableblastparts.com/product_images/x/807/BlastecGeneric__43902.1611265095.1280.1280__10104.1611265388.1280.1280__', N'Blastec,DBP-BT15TL100 | Runner Head Hub CW/CCW', N'Blastec,DBP-BT15TL | Runner Head Hub CW/CCW,,Runner Head Hub CW/CCW ,Wheel MODEL: 24" Blastech,DIA OF WHEEL: 24.00",Blades / VANES: 8 Blades,ROTATION: Bidirectional,Machine Mfg: Blastec', N',Runner Head Hub CW/CCW ,Wheel MODEL: 24" Blastech,DIA OF WHEEL: 24.00",Blades / VANES: 8 Blades,ROTATION: Bidirectional,Machine Mfg: Blastec', N'New', N'/dbp-bt15tl100-runner-head-hub-cw-ccw-100hp/', N'', N'', N'Vendor=contact@blastec.com;"Wh')
INSERT [dbo].[Product] ([ProductID], [ProductType], [Code], [Name], [Brand], [Description], [CostPrice], [RetailPrice], [SalePrice], [CalculatedPrice], [FixedShippingPrice], [FreeShipping], [AllowPurchases], [ProductVisible], [ProductAvailability], [ProductInventoried], [StockLevel], [LowStockLevel], [CategoryDetails], [Images], [PageTitle], [METAKeywords], [METADescription], [ProductCondition], [ProductURL], [RedirectOldURL], [ProductTaxCode], [ProductCustomFields]) VALUES (1781, N'P', N'DBP-BT15TLD23', N'DBP-BT15TLD23 | Runner Head Hu', N'Blastec', N'Picture is representative of product. Runner Head Hub CW/CCW, 20-30HP Wheel MODEL: 24" Blastech DIA OF WHEEL: 24.00" Blades / VANES: 8 Blades ROTATION: Bidirectional Machine Mfg: Blastec', N'0', N'0', N'0', N'0', N'0', 0, 1, 1, 0, 0, N'0', N'0', N'Category Name: Wheel Internals, Category Path: Wheel Parts/Wheel Internals|Category Name: Wheel Parts Fast Finder, Category Path: Wheel Parts/Wheel Parts Fast Finder', N'Product Image File: BlastecGeneric2__34419.1611265095.1280.1280__60292.jpg, Product Image URL: http://durableblastparts.com/product_images/r/676/BlastecGeneric2__34419.1611265095.1280.1280__60292.jpg|Product Image File: BlastecGeneric__43902.1611265095.1280.1280__86104.jpg, Product Image URL: http://durableblastparts.com/product_images/d/121/BlastecGeneric__43902.1611265095.1280.1280__86104.jpg', N'Blastec,DBP-BT15TLD23 | Runner Head Hub CW/CCW', N'Blastec,DBP-BT15TL | Runner Head Hub CW/CCW,,Runner Head Hub CW/CCW ,Wheel MODEL: 24" Blastech,DIA OF WHEEL: 24.00",Blades / VANES: 8 Blades,ROTATION: Bidirectional,Machine Mfg: Blastec', N',Runner Head Hub CW/CCW ,Wheel MODEL: 24" Blastech,DIA OF WHEEL: 24.00",Blades / VANES: 8 Blades,ROTATION: Bidirectional,Machine Mfg: Blastec', N'New', N'/dbp-bt15tld23-runner-head-hub-cw-ccw-20-30hp/', N'', N'', N'Vendor=contact@blastec.com;"Wh')
INSERT [dbo].[Product] ([ProductID], [ProductType], [Code], [Name], [Brand], [Description], [CostPrice], [RetailPrice], [SalePrice], [CalculatedPrice], [FixedShippingPrice], [FreeShipping], [AllowPurchases], [ProductVisible], [ProductAvailability], [ProductInventoried], [StockLevel], [LowStockLevel], [CategoryDetails], [Images], [PageTitle], [METAKeywords], [METADescription], [ProductCondition], [ProductURL], [RedirectOldURL], [ProductTaxCode], [ProductCustomFields]) VALUES (1782, N'P', N'DBP-BT15TLD45', N'DBP-BT15TLD45 | Runner Head Hu', N'Blastec', N'Picture is representative of product. Runner Head Hub CW/CCW, 40 - 50HP Wheel MODEL: 24" Blastech DIA OF WHEEL: 24.00" Blades / VANES: 8 Blades ROTATION: Bidirectional Machine Mfg: Blastec', N'0', N'0', N'0', N'0', N'0', 0, 1, 1, 0, 0, N'0', N'0', N'Category Name: Wheel Internals, Category Path: Wheel Parts/Wheel Internals|Category Name: Wheel Parts Fast Finder, Category Path: Wheel Parts/Wheel Parts Fast Finder', N'Product Image File: BlastecGeneric2__34419.1611265095.1280.1280__78084.1611265388.1280.1280__29933.jpg, Product Image URL: http://durableblastparts.com/product_images/n/561/BlastecGeneric2__34419.1611265095.1280.1280__78084.1611265388.1280.1280__29933.jpg|Product Image File: BlastecGeneric__43902.1611265095.1280.1280__10104.1611265388.1280.1280__33162.jpg, Product Image URL: http://durableblastparts.com/product_images/w/603/BlastecGeneric__43902.1611265095.1280.1280__10104.1611265388.1280.1280__', N'Blastec,DBP-BT15TLD45 | Runner Head Hub CW/CCW', N'Blastec,DBP-BT15TL | Runner Head Hub CW/CCW,,Runner Head Hub CW/CCW ,Wheel MODEL: 24" Blastech,DIA OF WHEEL: 24.00",Blades / VANES: 8 Blades,ROTATION: Bidirectional,Machine Mfg: Blastec', N',Runner Head Hub CW/CCW ,Wheel MODEL: 24" Blastech,DIA OF WHEEL: 24.00",Blades / VANES: 8 Blades,ROTATION: Bidirectional,Machine Mfg: Blastec', N'New', N'/dbp-bt15tld45-runner-head-hub-cw-ccw-40-50hp/', N'', N'', N'Vendor=contact@blastec.com;"Wh')
INSERT [dbo].[Product] ([ProductID], [ProductType], [Code], [Name], [Brand], [Description], [CostPrice], [RetailPrice], [SalePrice], [CalculatedPrice], [FixedShippingPrice], [FreeShipping], [AllowPurchases], [ProductVisible], [ProductAvailability], [ProductInventoried], [StockLevel], [LowStockLevel], [CategoryDetails], [Images], [PageTitle], [METAKeywords], [METADescription], [ProductCondition], [ProductURL], [RedirectOldURL], [ProductTaxCode], [ProductCustomFields]) VALUES (1783, N'P', N'DBP-BT15TLD67', N'DBP-BT15TLD67 | Runner Head Hu', N'Blastec', N'Picture is representative of product. Runner Head Hub CW/CCW, 60 - 75HP Wheel MODEL: 24" Blastech DIA OF WHEEL: 24.00" Blades / VANES: 8 Blades ROTATION: Bidirectional Machine Mfg: Blastec', N'0', N'0', N'0', N'0', N'0', 0, 1, 1, 0, 0, N'0', N'0', N'Category Name: Wheel Internals, Category Path: Wheel Parts/Wheel Internals|Category Name: Wheel Parts Fast Finder, Category Path: Wheel Parts/Wheel Parts Fast Finder', N'Product Image File: 1611265643.1280.1280__06824.jpg, Product Image URL: http://durableblastparts.com/product_images/j/451/1611265643.1280.1280__06824.jpg|Product Image File: 1611265643.1280.1280__33845.jpg, Product Image URL: http://durableblastparts.com/product_images/r/963/1611265643.1280.1280__33845.jpg', N'Blastec,DBP-BT15TLD67 | Runner Head Hub CW/CCW', N'Blastec,DBP-BT15TL | Runner Head Hub CW/CCW,,Runner Head Hub CW/CCW ,Wheel MODEL: 24" Blastech,DIA OF WHEEL: 24.00",Blades / VANES: 8 Blades,ROTATION: Bidirectional,Machine Mfg: Blastec', N',Runner Head Hub CW/CCW ,Wheel MODEL: 24" Blastech,DIA OF WHEEL: 24.00",Blades / VANES: 8 Blades,ROTATION: Bidirectional,Machine Mfg: Blastec', N'New', N'/dbp-bt15tld67-runner-head-hub-cw-ccw-60-75hp/', N'', N'', N'Vendor=contact@blastec.com;"Wh')
INSERT [dbo].[Product] ([ProductID], [ProductType], [Code], [Name], [Brand], [Description], [CostPrice], [RetailPrice], [SalePrice], [CalculatedPrice], [FixedShippingPrice], [FreeShipping], [AllowPurchases], [ProductVisible], [ProductAvailability], [ProductInventoried], [StockLevel], [LowStockLevel], [CategoryDetails], [Images], [PageTitle], [METAKeywords], [METADescription], [ProductCondition], [ProductURL], [RedirectOldURL], [ProductTaxCode], [ProductCustomFields]) VALUES (1784, N'P', N'DBP-BT15TLD100', N'DBP-BT15TLD100 | Runner Head H', N'Blastec', N'Picture is representative of product. Runner Head Hub CW/CCW, 100HP Wheel MODEL: 24" Blastech DIA OF WHEEL: 24.00" Blades / VANES: 8 Blades ROTATION: Bidirectional Machine Mfg: Blastec', N'0', N'0', N'0', N'0', N'0', 0, 1, 1, 0, 0, N'0', N'0', N'Category Name: Wheel Internals, Category Path: Wheel Parts/Wheel Internals|Category Name: Wheel Parts Fast Finder, Category Path: Wheel Parts/Wheel Parts Fast Finder', N'Product Image File: 1611265855.1280.1280__51896.jpg, Product Image URL: http://durableblastparts.com/product_images/a/609/1611265855.1280.1280__51896.jpg|Product Image File: 1611265855.1280.1280__18941.jpg, Product Image URL: http://durableblastparts.com/product_images/d/032/1611265855.1280.1280__18941.jpg', N'Blastec,DBP-BT15TLD100 | Runner Head Hub CW/CCW', N'Blastec,DBP-BT15TL | Runner Head Hub CW/CCW,,Runner Head Hub CW/CCW ,Wheel MODEL: 24" Blastech,DIA OF WHEEL: 24.00",Blades / VANES: 8 Blades,ROTATION: Bidirectional,Machine Mfg: Blastec', N',Runner Head Hub CW/CCW ,Wheel MODEL: 24" Blastech,DIA OF WHEEL: 24.00",Blades / VANES: 8 Blades,ROTATION: Bidirectional,Machine Mfg: Blastec', N'New', N'/dbp-bt15tld100-runner-head-hub-cw-ccw-100hp/', N'', N'', N'Vendor=contact@blastec.com;"Wh')
INSERT [dbo].[Product] ([ProductID], [ProductType], [Code], [Name], [Brand], [Description], [CostPrice], [RetailPrice], [SalePrice], [CalculatedPrice], [FixedShippingPrice], [FreeShipping], [AllowPurchases], [ProductVisible], [ProductAvailability], [ProductInventoried], [StockLevel], [LowStockLevel], [CategoryDetails], [Images], [PageTitle], [METAKeywords], [METADescription], [ProductCondition], [ProductURL], [RedirectOldURL], [ProductTaxCode], [ProductCustomFields]) VALUES (1785, N'P', N'DBP-BT225-2.5', N'DBP-BT225-2.5 | Control Cage T', N'Blastec', N'Picture is representative of product. 2.5" Control Cage  Tune Up Kit Wheel MODEL: 24" Blastech DIA OF WHEEL: 24.00" Blades / VANES: 8 Blades Machine Mfg: Blastec', N'0', N'0', N'0', N'0', N'0', 0, 1, 1, 0, 0, N'0', N'0', N'Category Name: Wheel Internals, Category Path: Wheel Parts/Wheel Internals|Category Name: Wheel Parts Fast Finder, Category Path: Wheel Parts/Wheel Parts Fast Finder', N'Product Image File: BlastecGeneric2__21987.1595424042.1280.1280__88479.jpg, Product Image URL: http://durableblastparts.com/product_images/j/486/BlastecGeneric2__21987.1595424042.1280.1280__88479.jpg|Product Image File: BlastecGeneric__36993.1595424042.1280.1280__83927.jpg, Product Image URL: http://durableblastparts.com/product_images/s/467/BlastecGeneric__36993.1595424042.1280.1280__83927.jpg', N'Blastec,DBP-BT225-2.5 | Cage 2-1/2" Opening', N'Blastec,DBP-BT2-2.5 | Cage 2-1/2" Opening  BT2401,,Cage 2-1/2" Opening  BT2401,Wheel MODEL: 24" Blastech,DIA OF WHEEL: 24.00",Blades / VANES: 8 Blades,,Machine Mfg: Blastec', N',Cage 2-1/2" Opening  BT2401,Wheel MODEL: 24" Blastech,DIA OF WHEEL: 24.00",Blades / VANES: 8 Blades,,Machine Mfg: Blastec', N'New', N'/dbp-bt225-2-5-control-cage-tune-up-kit/', N'', N'', N'Vendor=contact@blastec.com;"Wh')
INSERT [dbo].[Product] ([ProductID], [ProductType], [Code], [Name], [Brand], [Description], [CostPrice], [RetailPrice], [SalePrice], [CalculatedPrice], [FixedShippingPrice], [FreeShipping], [AllowPurchases], [ProductVisible], [ProductAvailability], [ProductInventoried], [StockLevel], [LowStockLevel], [CategoryDetails], [Images], [PageTitle], [METAKeywords], [METADescription], [ProductCondition], [ProductURL], [RedirectOldURL], [ProductTaxCode], [ProductCustomFields]) VALUES (1786, N'P', N'DBP-BT339MN-38', N'DBP-BT339MN-38 I Wheel Housing', N'Blastec', N'Picture is representative of product. Housing Assembly 3/8" Manganese Wheel MODEL: 24" Blastech DIA OF WHEEL: 24.00" Blades / VANES: 8 Blades Machine Mfg: Blastec', N'0', N'0', N'0', N'0', N'0', 0, 1, 1, 0, 0, N'0', N'0', N'Category Name: Housing, Category Path: Wheel Parts/Housing|Category Name: Wheel Parts Fast Finder, Category Path: Wheel Parts/Wheel Parts Fast Finder', N'', N'Blastec,DBP-BT339MN-38 | Lid, BW Housing  BT2400', N'Blastec,DBP-BT031A-1 | Lid, BW Housing  BT2400,,Lid, BW Housing  BT2400,Wheel MODEL: 24" Blastech,DIA OF WHEEL: 24.00",Blades / VANES: 8 Blades,,Machine Mfg: Blastec', N',Lid, BW Housing  BT2400,Wheel MODEL: 24" Blastech,DIA OF WHEEL: 24.00",Blades / VANES: 8 Blades,,Machine Mfg: Blastec', N'New', N'/dbp-bt339mn-38-i-wheel-housing-assembly-3-8-mn/', N'', N'', N'Vendor=contact@blastec.com;"Wh')
INSERT [dbo].[Product] ([ProductID], [ProductType], [Code], [Name], [Brand], [Description], [CostPrice], [RetailPrice], [SalePrice], [CalculatedPrice], [FixedShippingPrice], [FreeShipping], [AllowPurchases], [ProductVisible], [ProductAvailability], [ProductInventoried], [StockLevel], [LowStockLevel], [CategoryDetails], [Images], [PageTitle], [METAKeywords], [METADescription], [ProductCondition], [ProductURL], [RedirectOldURL], [ProductTaxCode], [ProductCustomFields]) VALUES (1787, N'P', N'DBP-BT0503A', N'DBP-BT0503A |End Liner (Long)', N'Blastec', N'Picture is representative of product. End Liner (Long) Wheel MODEL: 24" Blastech DIA OF WHEEL: 24.00" Blades / VANES: 8 Blades Machine Mfg: Blastec', N'0', N'0', N'0', N'0', N'0', 0, 1, 1, 0, 0, N'0', N'0', N'Category Name: Wheel Parts Fast Finder, Category Path: Wheel Parts/Wheel Parts Fast Finder|Category Name: Liners, Category Path: Wheel Parts/Housing/Liners', N'Product Image File: BlastecLiners__44712.1611316234.1280.1280__71896.jpg, Product Image URL: http://durableblastparts.com/product_images/z/103/BlastecLiners__44712.1611316234.1280.1280__71896.jpg', N'Blastec,DBP-BT0503A | End Liner (Long)', N'Blastec,DBP-BT91 | End Liner,,End Liner  ,Wheel MODEL: 24" Blastech,DIA OF WHEEL: 24.00",Blades / VANES: 8 Blades,,Machine Mfg: Blastec', N',Long End Liner  ,Wheel MODEL: 24" Blastech,DIA OF WHEEL: 24.00",Blades / VANES: 8 Blades,,Machine Mfg: Blastec', N'New', N'/dbp-bt0503a-end-liner-long/', N'', N'', N'Vendor=contact@blastec.com;"Wh')
INSERT [dbo].[Product] ([ProductID], [ProductType], [Code], [Name], [Brand], [Description], [CostPrice], [RetailPrice], [SalePrice], [CalculatedPrice], [FixedShippingPrice], [FreeShipping], [AllowPurchases], [ProductVisible], [ProductAvailability], [ProductInventoried], [StockLevel], [LowStockLevel], [CategoryDetails], [Images], [PageTitle], [METAKeywords], [METADescription], [ProductCondition], [ProductURL], [RedirectOldURL], [ProductTaxCode], [ProductCustomFields]) VALUES (1788, N'P', N'DBP-BT0503B', N'DBP-BT0503B |End Liner (Short)', N'Blastec', N'Picture is representative of product. End Liner (Short) Wheel MODEL: 24" Blastech DIA OF WHEEL: 24.00" Blades / VANES: 8 Blades Machine Mfg: Blastec', N'0', N'0', N'0', N'0', N'0', 0, 1, 1, 0, 0, N'0', N'0', N'Category Name: Wheel Parts Fast Finder, Category Path: Wheel Parts/Wheel Parts Fast Finder|Category Name: Liners, Category Path: Wheel Parts/Housing/Liners', N'Product Image File: BlastecLiners__44712.1611316234.1280.1280__71896.1611317510.1280.1280__33607.jpg, Product Image URL: http://durableblastparts.com/product_images/h/841/BlastecLiners__44712.1611316234.1280.1280__71896.1611317510.1280.1280__33607.jpg', N'Blastec,DBP-BT0503B | End Liner (Short)', N'Blastec,DBP-BT91 | End Liner,,End Liner  ,Wheel MODEL: 24" Blastech,DIA OF WHEEL: 24.00",Blades / VANES: 8 Blades,,Machine Mfg: Blastec', N',Long End Liner  ,Wheel MODEL: 24" Blastech,DIA OF WHEEL: 24.00",Blades / VANES: 8 Blades,,Machine Mfg: Blastec', N'New', N'/dbp-bt0503b-end-liner-short/', N'', N'', N'Vendor=contact@blastec.com;"Wh')
INSERT [dbo].[Product] ([ProductID], [ProductType], [Code], [Name], [Brand], [Description], [CostPrice], [RetailPrice], [SalePrice], [CalculatedPrice], [FixedShippingPrice], [FreeShipping], [AllowPurchases], [ProductVisible], [ProductAvailability], [ProductInventoried], [StockLevel], [LowStockLevel], [CategoryDetails], [Images], [PageTitle], [METAKeywords], [METADescription], [ProductCondition], [ProductURL], [RedirectOldURL], [ProductTaxCode], [ProductCustomFields]) VALUES (1789, N'P', N'DBP-BT054', N'DBP-BT054 | Top Liner', N'Blastec', N'Picture is representative of product. Top Liner Wheel MODEL: 24" Blastech DIA OF WHEEL: 24.00" Blades / VANES: 8 Blades Machine Mfg: Blastec', N'0', N'0', N'0', N'0', N'0', 0, 1, 1, 0, 0, N'0', N'0', N'Category Name: Wheel Parts Fast Finder, Category Path: Wheel Parts/Wheel Parts Fast Finder|Category Name: Liners, Category Path: Wheel Parts/Housing/Liners', N'Product Image File: 1611318202.1280.1280__63578.jpg, Product Image URL: http://durableblastparts.com/product_images/d/903/1611318202.1280.1280__63578.jpg', N'Blastec,DBP-BT054 | Top Liner', N'Blastec,DBP-BT91 | End Liner,,End Liner  ,Wheel MODEL: 24" Blastech,DIA OF WHEEL: 24.00",Blades / VANES: 8 Blades,,Machine Mfg: Blastec', N',Top Liner  ,Wheel MODEL: 24" Blastech,DIA OF WHEEL: 24.00",Blades / VANES: 8 Blades,,Machine Mfg: Blastec', N'New', N'/dbp-bt054-top-liner/', N'', N'', N'Vendor=contact@blastec.com;"Wh')
INSERT [dbo].[Product] ([ProductID], [ProductType], [Code], [Name], [Brand], [Description], [CostPrice], [RetailPrice], [SalePrice], [CalculatedPrice], [FixedShippingPrice], [FreeShipping], [AllowPurchases], [ProductVisible], [ProductAvailability], [ProductInventoried], [StockLevel], [LowStockLevel], [CategoryDetails], [Images], [PageTitle], [METAKeywords], [METADescription], [ProductCondition], [ProductURL], [RedirectOldURL], [ProductTaxCode], [ProductCustomFields]) VALUES (1790, N'P', N'DBP-BT051', N'DBP-BT051 | Side Liner, Top LH', N'Blastec', N'Picture is representative of product. Side Liner, Top LH Wheel MODEL: 24" Blastech DIA OF WHEEL: 24.00" Blades / VANES: 8 Blades Machine Mfg: Blastec', N'0', N'0', N'0', N'0', N'0', 0, 1, 1, 0, 0, N'0', N'0', N'Category Name: Wheel Parts Fast Finder, Category Path: Wheel Parts/Wheel Parts Fast Finder|Category Name: Liners, Category Path: Wheel Parts/Housing/Liners', N'Product Image File: 1611318202.1280.1280__63578.1611318445.1280.1280__14121.jpg, Product Image URL: http://durableblastparts.com/product_images/m/919/1611318202.1280.1280__63578.1611318445.1280.1280__14121.jpg', N'Blastec,DBP-BT051 | Side Liner, Top LH', N'Blastec,DBP-BT91 | End Liner,,End Liner  ,Wheel MODEL: 24" Blastech,DIA OF WHEEL: 24.00",Blades / VANES: 8 Blades,,Machine Mfg: Blastec', N',BT051 | Side Liner, Top LH ,Wheel MODEL: 24" Blastech,DIA OF WHEEL: 24.00",Blades / VANES: 8 Blades,,Machine Mfg: Blastec', N'New', N'/dbp-bt051-side-liner-top-lh/', N'', N'', N'Vendor=contact@blastec.com;"Wh')
INSERT [dbo].[Product] ([ProductID], [ProductType], [Code], [Name], [Brand], [Description], [CostPrice], [RetailPrice], [SalePrice], [CalculatedPrice], [FixedShippingPrice], [FreeShipping], [AllowPurchases], [ProductVisible], [ProductAvailability], [ProductInventoried], [StockLevel], [LowStockLevel], [CategoryDetails], [Images], [PageTitle], [METAKeywords], [METADescription], [ProductCondition], [ProductURL], [RedirectOldURL], [ProductTaxCode], [ProductCustomFields]) VALUES (1791, N'P', N'DBP-BT048', N'DBP-BT048 | Side Liner, Lower ', N'Blastec', N'Picture is representative of product. Side Liner, Lower LH Wheel MODEL: 24" Blastech DIA OF WHEEL: 24.00" Blades / VANES: 8 Blades Machine Mfg: Blastec', N'0', N'0', N'0', N'0', N'0', 0, 1, 1, 0, 0, N'0', N'0', N'Category Name: Wheel Parts Fast Finder, Category Path: Wheel Parts/Wheel Parts Fast Finder|Category Name: Liners, Category Path: Wheel Parts/Housing/Liners', N'Product Image File: 1611318688.1280.1280__18493.jpg, Product Image URL: http://durableblastparts.com/product_images/q/386/1611318688.1280.1280__18493.jpg', N'Blastec,DBP-BT048 | Side Liner, Lower LH', N'Blastec,DBP-BT91 | End Liner,,End Liner  ,Wheel MODEL: 24" Blastech,DIA OF WHEEL: 24.00",Blades / VANES: 8 Blades,,Machine Mfg: Blastec', N',DBP-BT048 | Side Liner, Lower LH,Wheel MODEL: 24" Blastech,DIA OF WHEEL: 24.00",Blades / VANES: 8 Blades,,Machine Mfg: Blastec', N'New', N'/dbp-bt048-side-liner-lower-lh/', N'', N'', N'Vendor=contact@blastec.com;"Wh')
INSERT [dbo].[Product] ([ProductID], [ProductType], [Code], [Name], [Brand], [Description], [CostPrice], [RetailPrice], [SalePrice], [CalculatedPrice], [FixedShippingPrice], [FreeShipping], [AllowPurchases], [ProductVisible], [ProductAvailability], [ProductInventoried], [StockLevel], [LowStockLevel], [CategoryDetails], [Images], [PageTitle], [METAKeywords], [METADescription], [ProductCondition], [ProductURL], [RedirectOldURL], [ProductTaxCode], [ProductCustomFields]) VALUES (1792, N'P', N'DBP-BT047', N'DBP-BT047 | Side Liner, Lower ', N'Blastec', N'Picture is representative of product. Side Liner, Lower RH Wheel MODEL: 24" Blastech DIA OF WHEEL: 24.00" Blades / VANES: 8 Blades Machine Mfg: Blastec', N'0', N'0', N'0', N'0', N'0', 0, 1, 1, 0, 0, N'0', N'0', N'Category Name: Wheel Parts Fast Finder, Category Path: Wheel Parts/Wheel Parts Fast Finder|Category Name: Liners, Category Path: Wheel Parts/Housing/Liners', N'Product Image File: 1611318688.1280.1280__18493.1611318887.1280.1280__81836.jpg, Product Image URL: http://durableblastparts.com/product_images/h/604/1611318688.1280.1280__18493.1611318887.1280.1280__81836.jpg', N'Blastec,DBP-BT047 | Side Liner, Lower RH', N'Blastec,DBP-BT91 | End Liner,,End Liner  ,Wheel MODEL: 24" Blastech,DIA OF WHEEL: 24.00",Blades / VANES: 8 Blades,,Machine Mfg: Blastec', N',DBP-BT047 | Side Liner, Lower RH,Wheel MODEL: 24" Blastech,DIA OF WHEEL: 24.00",Blades / VANES: 8 Blades,,Machine Mfg: Blastec', N'New', N'/dbp-bt047-side-liner-lower-rh/', N'', N'', N'Vendor=contact@blastec.com;"Wh')
INSERT [dbo].[Product] ([ProductID], [ProductType], [Code], [Name], [Brand], [Description], [CostPrice], [RetailPrice], [SalePrice], [CalculatedPrice], [FixedShippingPrice], [FreeShipping], [AllowPurchases], [ProductVisible], [ProductAvailability], [ProductInventoried], [StockLevel], [LowStockLevel], [CategoryDetails], [Images], [PageTitle], [METAKeywords], [METADescription], [ProductCondition], [ProductURL], [RedirectOldURL], [ProductTaxCode], [ProductCustomFields]) VALUES (1793, N'P', N'DBP-BT045', N'DBP-BT045 | Side Liner, Top RH', N'Blastec', N'Picture is representative of product. Side Liner, Top RH Wheel MODEL: 24" Blastech DIA OF WHEEL: 24.00" Blades / VANES: 8 Blades Machine Mfg: Blastec', N'0', N'0', N'0', N'0', N'0', 0, 1, 1, 0, 0, N'0', N'0', N'Category Name: Wheel Parts Fast Finder, Category Path: Wheel Parts/Wheel Parts Fast Finder|Category Name: Liners, Category Path: Wheel Parts/Housing/Liners', N'Product Image File: 1611318688.1280.1280__53893.jpg, Product Image URL: http://durableblastparts.com/product_images/z/589/1611318688.1280.1280__53893.jpg', N'Blastec,DBP-BT045 | Side Liner, Top RH', N'Blastec,DBP-BT91 | End Liner,,End Liner  ,Wheel MODEL: 24" Blastech,DIA OF WHEEL: 24.00",Blades / VANES: 8 Blades,,Machine Mfg: Blastec', N',DBP-BT045 | Side Liner, Top RH ,Wheel MODEL: 24" Blastech,DIA OF WHEEL: 24.00",Blades / VANES: 8 Blades,,Machine Mfg: Blastec', N'New', N'/dbp-bt045-side-liner-top-rh/', N'', N'', N'Vendor=contact@blastec.com;"Wh')
INSERT [dbo].[Product] ([ProductID], [ProductType], [Code], [Name], [Brand], [Description], [CostPrice], [RetailPrice], [SalePrice], [CalculatedPrice], [FixedShippingPrice], [FreeShipping], [AllowPurchases], [ProductVisible], [ProductAvailability], [ProductInventoried], [StockLevel], [LowStockLevel], [CategoryDetails], [Images], [PageTitle], [METAKeywords], [METADescription], [ProductCondition], [ProductURL], [RedirectOldURL], [ProductTaxCode], [ProductCustomFields]) VALUES (1794, N'P', N'DBP-BT066A', N'DBP-BT066A | Torque Lock 25/30', N'Blastec', N'Picture is representative of product. Torque Lock 25/30 Wheel MODEL: 24" Blastech DIA OF WHEEL: 24.00" Blades / VANES: 8 Blades ROTATION: Bidirectional Machine Mfg: Blastec', N'0', N'0', N'0', N'0', N'0', 0, 1, 1, 0, 0, N'0', N'0', N'Category Name: Wheel Internals, Category Path: Wheel Parts/Wheel Internals|Category Name: Wheel Parts Fast Finder, Category Path: Wheel Parts/Wheel Parts Fast Finder', N'Product Image File: BlastecGeneric__43902.1611265095.1280.1280__86104.1611269371.1280.1280__99163.jpg, Product Image URL: http://durableblastparts.com/product_images/x/459/BlastecGeneric__43902.1611265095.1280.1280__86104.1611269371.1280.1280__99163.jpg|Product Image File: TORQLOC__16418.PNG, Product Image URL: http://durableblastparts.com/product_images/l/884/TORQLOC__16418.PNG', N'Blastec,DBP-BT066A | Torque Lock 25/30', N'Blastec,DBP-BT15TL | Runner Head Hub CW/CCW,,Runner Head Hub CW/CCW ,Wheel MODEL: 24" Blastech,DIA OF WHEEL: 24.00",Blades / VANES: 8 Blades,ROTATION: Bidirectional,Machine Mfg: Blastec', N',Torque Lock 25/30 ,Wheel MODEL: 24" Blastech,DIA OF WHEEL: 24.00",Blades / VANES: 8 Blades,ROTATION: Bidirectional,Machine Mfg: Blastec', N'New', N'/dbp-bt066a-torque-lock-25-30/', N'', N'', N'Vendor=contact@blastec.com;"Wh')
INSERT [dbo].[Product] ([ProductID], [ProductType], [Code], [Name], [Brand], [Description], [CostPrice], [RetailPrice], [SalePrice], [CalculatedPrice], [FixedShippingPrice], [FreeShipping], [AllowPurchases], [ProductVisible], [ProductAvailability], [ProductInventoried], [StockLevel], [LowStockLevel], [CategoryDetails], [Images], [PageTitle], [METAKeywords], [METADescription], [ProductCondition], [ProductURL], [RedirectOldURL], [ProductTaxCode], [ProductCustomFields]) VALUES (1795, N'P', N'DBP-BT021A', N'DBP-BT021A | Torque Lock 40/50', N'Blastec', N'Picture is representative of product. Torque Lock 40/50 Wheel MODEL: 24" Blastech DIA OF WHEEL: 24.00" Blades / VANES: 8 Blades ROTATION: Bidirectional Machine Mfg: Blastec', N'0', N'0', N'0', N'0', N'0', 0, 1, 1, 0, 0, N'0', N'0', N'Category Name: Wheel Internals, Category Path: Wheel Parts/Wheel Internals|Category Name: Wheel Parts Fast Finder, Category Path: Wheel Parts/Wheel Parts Fast Finder', N'Product Image File: 1611329057.1280.1280__16350.jpg, Product Image URL: http://durableblastparts.com/product_images/w/005/1611329057.1280.1280__16350.jpg|Product Image File: TORQLOC__16418.1611329057.1280.1280__87481.jpg, Product Image URL: http://durableblastparts.com/product_images/d/112/TORQLOC__16418.1611329057.1280.1280__87481.jpg', N'Blastec,DBP-BT021A | Torque Lock 40/50', N'Blastec,DBP-BT15TL | Runner Head Hub CW/CCW,,Runner Head Hub CW/CCW ,Wheel MODEL: 24" Blastech,DIA OF WHEEL: 24.00",Blades / VANES: 8 Blades,ROTATION: Bidirectional,Machine Mfg: Blastec', N',DBP-BT021A | Torque Lock 40/50 ,Wheel MODEL: 24" Blastech,DIA OF WHEEL: 24.00",Blades / VANES: 8 Blades,ROTATION: Bidirectional,Machine Mfg: Blastec', N'New', N'/dbp-bt021a-torque-lock-40-50/', N'', N'', N'Vendor=contact@blastec.com;"Wh')
INSERT [dbo].[Product] ([ProductID], [ProductType], [Code], [Name], [Brand], [Description], [CostPrice], [RetailPrice], [SalePrice], [CalculatedPrice], [FixedShippingPrice], [FreeShipping], [AllowPurchases], [ProductVisible], [ProductAvailability], [ProductInventoried], [StockLevel], [LowStockLevel], [CategoryDetails], [Images], [PageTitle], [METAKeywords], [METADescription], [ProductCondition], [ProductURL], [RedirectOldURL], [ProductTaxCode], [ProductCustomFields]) VALUES (1796, N'P', N'DBP-BT084A', N'DBP-BT084A | Torque Lock 60/75', N'Blastec', N'Picture is representative of product. Torque Lock 60/75 Wheel MODEL: 24" Blastech DIA OF WHEEL: 24.00" Blades / VANES: 8 Blades ROTATION: Bidirectional Machine Mfg: Blastec', N'0', N'0', N'0', N'0', N'0', 0, 1, 1, 0, 0, N'0', N'0', N'Category Name: Wheel Internals, Category Path: Wheel Parts/Wheel Internals|Category Name: Wheel Parts Fast Finder, Category Path: Wheel Parts/Wheel Parts Fast Finder', N'Product Image File: 1611329057.1280.1280__16350.1611329290.1280.1280__69692.jpg, Product Image URL: http://durableblastparts.com/product_images/g/124/1611329057.1280.1280__16350.1611329290.1280.1280__69692.jpg|Product Image File: TORQLOC__16418.1611329057.1280.1280__87481.1611329290.1280.1280__73325.jpg, Product Image URL: http://durableblastparts.com/product_images/m/366/TORQLOC__16418.1611329057.1280.1280__87481.1611329290.1280.1280__73325.jpg', N'Blastec,DBP-BT084A | Torque Lock 60/75', N'Blastec,DBP-BT15TL | Runner Head Hub CW/CCW,,Runner Head Hub CW/CCW ,Wheel MODEL: 24" Blastech,DIA OF WHEEL: 24.00",Blades / VANES: 8 Blades,ROTATION: Bidirectional,Machine Mfg: Blastec', N',DBP-BT084A | Torque Lock 60/75 ,Wheel MODEL: 24" Blastech,DIA OF WHEEL: 24.00",Blades / VANES: 8 Blades,ROTATION: Bidirectional,Machine Mfg: Blastec', N'New', N'/dbp-bt084a-torque-lock-60-75/', N'', N'', N'Vendor=contact@blastec.com;"Wh')
INSERT [dbo].[Product] ([ProductID], [ProductType], [Code], [Name], [Brand], [Description], [CostPrice], [RetailPrice], [SalePrice], [CalculatedPrice], [FixedShippingPrice], [FreeShipping], [AllowPurchases], [ProductVisible], [ProductAvailability], [ProductInventoried], [StockLevel], [LowStockLevel], [CategoryDetails], [Images], [PageTitle], [METAKeywords], [METADescription], [ProductCondition], [ProductURL], [RedirectOldURL], [ProductTaxCode], [ProductCustomFields]) VALUES (1797, N'P', N'DBP-BT085', N'DBP-BT085 | Torque Lock 100', N'Blastec', N'Picture is representative of product. Torque Lock 100 Wheel MODEL: 24" Blastech DIA OF WHEEL: 24.00" Blades / VANES: 8 Blades ROTATION: Bidirectional Machine Mfg: Blastec', N'0', N'0', N'0', N'0', N'0', 0, 1, 1, 0, 0, N'0', N'0', N'Category Name: Wheel Internals, Category Path: Wheel Parts/Wheel Internals|Category Name: Wheel Parts Fast Finder, Category Path: Wheel Parts/Wheel Parts Fast Finder', N'Product Image File: 1611329499.1280.1280__04630.jpg, Product Image URL: http://durableblastparts.com/product_images/j/971/1611329499.1280.1280__04630.jpg|Product Image File: 1611329499.1280.1280__15886.jpg, Product Image URL: http://durableblastparts.com/product_images/e/957/1611329499.1280.1280__15886.jpg', N'Blastec,DBP-BT085 | Torque Lock 100', N'Blastec,DBP-BT15TL | Runner Head Hub CW/CCW,,Runner Head Hub CW/CCW ,Wheel MODEL: 24" Blastech,DIA OF WHEEL: 24.00",Blades / VANES: 8 Blades,ROTATION: Bidirectional,Machine Mfg: Blastec', N',DBP-BT085 | Torque Lock 100 ,Wheel MODEL: 24" Blastech,DIA OF WHEEL: 24.00",Blades / VANES: 8 Blades,ROTATION: Bidirectional,Machine Mfg: Blastec', N'New', N'/dbp-bt085-torque-lock-100/', N'', N'', N'Vendor=contact@blastec.com;"Wh')
INSERT [dbo].[Product] ([ProductID], [ProductType], [Code], [Name], [Brand], [Description], [CostPrice], [RetailPrice], [SalePrice], [CalculatedPrice], [FixedShippingPrice], [FreeShipping], [AllowPurchases], [ProductVisible], [ProductAvailability], [ProductInventoried], [StockLevel], [LowStockLevel], [CategoryDetails], [Images], [PageTitle], [METAKeywords], [METADescription], [ProductCondition], [ProductURL], [RedirectOldURL], [ProductTaxCode], [ProductCustomFields]) VALUES (1798, N'P', N'DBP-C32505', N'Manganese Cabinet Roll C32505', N'BCP / Wheelabrator', N'OEM Part Number C32505 6 5/8" Diameter x 4'' Lg Maganese Roll Assembly with shaft 8 - 10 week Lead Time', N'0', N'0', N'0', N'0', N'0', 0, 1, 1, 1, 0, N'0', N'0', N'Category Name: Cabinet & Material Handling, Category Path: Cabinet & Material Handling|Category Name: Roll Conveyor, Category Path: Cabinet & Material Handling/Material Handling Templates/Roll Conveyor', N'Product Image File: MAgnaese_Roll__92991.PNG, Product Image URL: http://durableblastparts.com/product_images/z/490/MAgnaese_Roll__92991.PNG|Product Image File: Roll_Conveyor_Template__36184.PNG, Product Image URL: http://durableblastparts.com/product_images/j/966/Roll_Conveyor_Template__36184.PNG', N'Manganese Cabinet Roll C32505', N'', N'Manganese Cabinet Roll C32505', N'New', N'/manganese-cabinet-c32505/', N'', N'', N'Vendor=sales@durableblastparts')
INSERT [dbo].[Product] ([ProductID], [ProductType], [Code], [Name], [Brand], [Description], [CostPrice], [RetailPrice], [SalePrice], [CalculatedPrice], [FixedShippingPrice], [FreeShipping], [AllowPurchases], [ProductVisible], [ProductAvailability], [ProductInventoried], [StockLevel], [LowStockLevel], [CategoryDetails], [Images], [PageTitle], [METAKeywords], [METADescription], [ProductCondition], [ProductURL], [RedirectOldURL], [ProductTaxCode], [ProductCustomFields]) VALUES (1799, N'P', N'DBP-697789', N'34 Super Tumblast Link Hardwar', N'BCT Metcast;Wheelabrator', N'Set included Four (4) of each.     680991   Plow Bolt, 3/4"-10UNC  Grd 8 (also 291252)         500064   Nut, 3/4 Hex         500118   Lock Washers, 3/4"', N'0', N'0', N'0', N'0', N'0', 0, 1, 1, 0, 0, N'0', N'0', N'Category Name: Cabinet & Material Handling, Category Path: Cabinet & Material Handling|Category Name: Steel Mill, Category Path: Cabinet & Material Handling/Tumblast Mill Components/Steel Mill', N'Product Image File: plow_bolt__64491.PNG, Product Image URL: http://durableblastparts.com/product_images/i/014/plow_bolt__64491.PNG', N'34 Super Tumblast Link Hardware Set, Plow Bolts, N', N'', N'Wheelabrator Tumblast Link Hardware Set, Plow Bolts, Nots and Washers', N'New', N'/34-super-tumblast-link-hardware-set-plow-bolts-nuts-and-washers/', N'', N'', N'Vendor=jackie@astechblast.com')
INSERT [dbo].[Product] ([ProductID], [ProductType], [Code], [Name], [Brand], [Description], [CostPrice], [RetailPrice], [SalePrice], [CalculatedPrice], [FixedShippingPrice], [FreeShipping], [AllowPurchases], [ProductVisible], [ProductAvailability], [ProductInventoried], [StockLevel], [LowStockLevel], [CategoryDetails], [Images], [PageTitle], [METAKeywords], [METADescription], [ProductCondition], [ProductURL], [RedirectOldURL], [ProductTaxCode], [ProductCustomFields]) VALUES (1800, N'P', N'DBP-7204901', N'60" CFS Separator Replacement ', N'BCT Metcast;Wheelabrator', N'Replacement Screen Mesh for a 60" LG. Wheelabrator Style Rotary Screen SeperatorMesh (Square), 0.1870" x 0.1870" Opening (Square),', N'0', N'0', N'0', N'0', N'0', 0, 1, 1, 0, 0, N'0', N'0', N'Category Name: Abrasive Reclaim, Category Path: Abrasive Reclaim|Category Name: Separator Components, Category Path: Abrasive Reclaim/Separator Components', N'Product Image File: Rotary_Screen_Mesh__18872.jpg, Product Image URL: http://durableblastparts.com/product_images/n/437/Rotary_Screen_Mesh__18872.jpg', N'60" CFS Separator Replacement Screen', N'', N'Wheelabrator, 60" CFS Separator Replacement Screen', N'New', N'/60-cfs-separator-replacement-screen/', N'', N'', N'Vendor=joe.craig@blastservices')
INSERT [dbo].[Product] ([ProductID], [ProductType], [Code], [Name], [Brand], [Description], [CostPrice], [RetailPrice], [SalePrice], [CalculatedPrice], [FixedShippingPrice], [FreeShipping], [AllowPurchases], [ProductVisible], [ProductAvailability], [ProductInventoried], [StockLevel], [LowStockLevel], [CategoryDetails], [Images], [PageTitle], [METAKeywords], [METADescription], [ProductCondition], [ProductURL], [RedirectOldURL], [ProductTaxCode], [ProductCustomFields]) VALUES (1801, N'P', N'DBP-7204900', N'40" CFS Separator Replacement ', N'BCT Metcast;Wheelabrator', N'Replacement Screen Mesh for a 40" LG. Wheelabrator Style Rotary Screen SeperatorMesh (Square), 0.1870" x 0.1870" Opening (Square),', N'0', N'0', N'0', N'0', N'0', 0, 1, 1, 0, 0, N'0', N'0', N'Category Name: Abrasive Reclaim, Category Path: Abrasive Reclaim|Category Name: Separator Components, Category Path: Abrasive Reclaim/Separator Components', N'Product Image File: Rotary_Screen_Mesh__18872.1613053870.1280.1280__39371.jpg, Product Image URL: http://durableblastparts.com/product_images/l/056/Rotary_Screen_Mesh__18872.1613053870.1280.1280__39371.jpg', N'40" CFS Separator Replacement Screen', N'', N'Wheelabrator, 40" CFS Separator Replacement Screen', N'New', N'/40-cfs-separator-replacement-screen-1/', N'', N'', N'Vendor=joe.craig@blastservices')
INSERT [dbo].[Product] ([ProductID], [ProductType], [Code], [Name], [Brand], [Description], [CostPrice], [RetailPrice], [SalePrice], [CalculatedPrice], [FixedShippingPrice], [FreeShipping], [AllowPurchases], [ProductVisible], [ProductAvailability], [ProductInventoried], [StockLevel], [LowStockLevel], [CategoryDetails], [Images], [PageTitle], [METAKeywords], [METADescription], [ProductCondition], [ProductURL], [RedirectOldURL], [ProductTaxCode], [ProductCustomFields]) VALUES (1802, N'P', N'DBP-10X30X24EBK_1', N'DBP-10X30X24EBK Elevator Belt ', N'Wheelabrator', N'Kit includes the following shipped loose:  4 Ply 440 Elevator Belt for a 10 x 30 x 24'' Tall Elevator (24''-0") Lg Belt 53 Cast Ductile Iron Buckets Super Grip Belt Splice All Harware    Assembly can be provided upon request.   Dont see your exact belt?  Contact us or download our Elevator Belt Template for a custom quote.', N'0', N'0', N'0', N'0', N'0', 0, 1, 1, 1, 0, N'0', N'0', N'Category Name: Elevator Belt Kits / Assemblies, Category Path: Abrasive Reclaim/Elevator/Elevator Belt Kits \/ Assemblies', N'Product Image File: s-l1600__97275.1595768778.1280.1280__69550.jpg, Product Image URL: http://durableblastparts.com/product_images/j/868/s-l1600__97275.1595768778.1280.1280__69550.jpg|Product Image File: Rolled_Belt__63345.1595799144.1280.1280__24110.jpg, Product Image URL: http://durableblastparts.com/product_images/r/155/Rolled_Belt__63345.1595799144.1280.1280__24110.jpg|Product Image File: Buckets__95566.1595799144.1280.1280__36379.jpg, Product Image URL: http://durableblastparts.com/product_', N'10x30x24 Elevator Belt Kit', N'', N'Wheelabrator, BCT. Pangborn, Blastec, Metcast, Metfin, Elevator Belt Assemblies', N'New', N'/dbp-10x30x24ebk-elevator-belt-kit/', N'', N'', N'Vendor=efranke@bistaterubber.c')
INSERT [dbo].[Product] ([ProductID], [ProductType], [Code], [Name], [Brand], [Description], [CostPrice], [RetailPrice], [SalePrice], [CalculatedPrice], [FixedShippingPrice], [FreeShipping], [AllowPurchases], [ProductVisible], [ProductAvailability], [ProductInventoried], [StockLevel], [LowStockLevel], [CategoryDetails], [Images], [PageTitle], [METAKeywords], [METADescription], [ProductCondition], [ProductURL], [RedirectOldURL], [ProductTaxCode], [ProductCustomFields]) VALUES (1803, N'P', N'DBP-444082-8', N'DBP-444082-8 | Tune Up Kit min', N'Wheelabrator', N'Picture is representative of product. Tune Up Kit Part Numbers in Kits: 444903, 414371, 414370, 158063, 165790, 448253 Wheel MODEL: 25RLM195 DIA OF WHEEL: 19.50" Kit does not include Blades / VANES: 8 Blades CONTROL CAGE: 70 ROTATION: Bidirectional Machine Mfg: Wheelabrator', N'0', N'0', N'0', N'0', N'0', 0, 1, 1, 0, 0, N'0', N'0', N'Category Name: Tune Up Kits, Category Path: Wheel Parts/Wheel Internals/Tune Up Kits', N'Product Image File: RLMKIT__92598.1595424028.1280.1280__26422.jpg, Product Image URL: http://durableblastparts.com/product_images/z/939/RLMKIT__92598.1595424028.1280.1280__26422.jpg', N'Wheelabrator,DBP-444082 | Tune Up Kit', N'Wheelabrator,DBP-444082 | Tune Up Kit,,Tune Up Kit ,Part Numbers in Kits: 444903, 414371, 414370, 158063, 165790, 448253,Wheel MODEL: 25RLM195,DIA OF WHEEL: 19.50",Blades / VANES: 8 Blades,CONTROL CAGE: 70,ROTATION: Bidirectional,Machine Mfg: Wheelabrator', N',Tune Up Kit ,Part Numbers in Kits: 444903, 414371, 414370, 158063, 165790, 448253,Wheel MODEL: 25RLM195,DIA OF WHEEL: 19.50",Blades / VANES: 8 Blades,CONTROL CAGE: 70,ROTATION: Bidirectional,Machine Mfg: Wheelabrator', N'New', N'/copy-of-dbp-444082-tune-up-kit-minus-blades/', N'', N'', N'Vendor=jackie@astechblast.com;')
INSERT [dbo].[Product] ([ProductID], [ProductType], [Code], [Name], [Brand], [Description], [CostPrice], [RetailPrice], [SalePrice], [CalculatedPrice], [FixedShippingPrice], [FreeShipping], [AllowPurchases], [ProductVisible], [ProductAvailability], [ProductInventoried], [StockLevel], [LowStockLevel], [CategoryDetails], [Images], [PageTitle], [METAKeywords], [METADescription], [ProductCondition], [ProductURL], [RedirectOldURL], [ProductTaxCode], [ProductCustomFields]) VALUES (1804, N'P', N'DBP-SSDS-', N'Double Screen Shot Saver', N'Blast Guru', N'Double Screen Shot Saver There are multiple applications for Double Screen Shot Saver 1. Peening media classifiction for shot peening applications 2. Top screen can be used as a trash screen in a foundry duty sand surge application. 3. Can be used as a separator on an airblast room with the top screen being a trash removal screen. 4. Can also classify two sizes of abrasive feeding two air-blast blast pots from the same reclaim system 5. Abrasive reclaim module design to clean up pit and floor sweepings. All screens should be sized based off of desired media take-out size or classifcation and the bottom screen should always be a higher mesh number than the top screen. Note: Inlet hose, outlet discharge hoses & 2-bolt clamps are not included. Please purchase as required from related products below for your specific application. Patent Pending + Blastguru Trademarks', N'0', N'0', N'0', N'0', N'0', 0, 1, 1, 1, 0, N'0', N'0', N'Category Name: Shot Saver / Media Classifier, Category Path: Abrasive Reclaim/Shot Saver \/ Media Classifier', N'Product Image File: screens__76802.PNG, Product Image URL: http://durableblastparts.com/product_images/u/366/screens__76802.PNG|Product Image File: Screen_Selection__68151.1613917786.1280.1280__62434.png, Product Image URL: http://durableblastparts.com/product_images/s/086/Screen_Selection__68151.1613917786.1280.1280__62434.png|Product Image File: IMG_9539__10411.jpg, Product Image URL: http://durableblastparts.com/product_images/f/973/IMG_9539__10411.jpg|Product Image File: IMG_9591__33978.jpg,', N'Double Screen Shot Saver', N'', N'Abrasive Savings, Peening Media Classifier, Ervin Abrasive, Metaltec Abrasive, W Abrasives, Separator, Double Screen Shot Saver, Shot Peening', N'New', N'/double-screen-shot-saver/', N'', N'', N'Vendor=contact@blastec.com')
INSERT [dbo].[Product] ([ProductID], [ProductType], [Code], [Name], [Brand], [Description], [CostPrice], [RetailPrice], [SalePrice], [CalculatedPrice], [FixedShippingPrice], [FreeShipping], [AllowPurchases], [ProductVisible], [ProductAvailability], [ProductInventoried], [StockLevel], [LowStockLevel], [CategoryDetails], [Images], [PageTitle], [METAKeywords], [METADescription], [ProductCondition], [ProductURL], [RedirectOldURL], [ProductTaxCode], [ProductCustomFields]) VALUES (1805, N'P', N'DBP-SSXL', N'Shot Saver XL', N'Blast Guru', N'Shot Saver XL A great choice for foundry duty seperator fines discharges with a rotary screen separator and or heavey grit structural steel applications. Metal Construction with internal liner Vibratory Motor or Pnuematic Vibarator    There are multiple uses for Shot Saver XL 1. Peening media classifiction. 2. Screen can be used to prevent abrasive waste in a sand surge application. 3. Can be used as a separator on an airblast room. 4. Abrasive reclaim module design to clean up pit and floor sweepings. All screens should be sized based off of desired media take-out size or classifcation.   Note: Inlet hose, outlet discharge hoses & 2-bolt clamps are not included. Please purchase as required from related products below for your specific application.', N'0', N'0', N'0', N'0', N'0', 0, 1, 1, 1, 0, N'0', N'0', N'Category Name: Shot Saver / Media Classifier, Category Path: Abrasive Reclaim/Shot Saver \/ Media Classifier', N'Product Image File: IMG_0044__99908.jpg, Product Image URL: http://durableblastparts.com/product_images/m/348/IMG_0044__99908.jpg|Product Image File: Screen_Selection__68151.1613917786.1280.1280__62434.1613920527.1280.1280__37239.png, Product Image URL: http://durableblastparts.com/product_images/p/932/Screen_Selection__68151.1613917786.1280.1280__62434.1613920527.1280.1280__37239.png|Product Image File: IMG_0047__02785.jpg, Product Image URL: http://durableblastparts.com/product_images/t/085/IM', N'Double Screen Shot Saver', N'', N'Abrasive Savings, Media Classifier, Ervin Abrasive, Metaltec Abrasive, W Abrasives, Separator, Double Screen Shot Saver', N'New', N'/shot-saver-xl/', N'', N'', N'Vendor=contact@blastec.com')
INSERT [dbo].[Product] ([ProductID], [ProductType], [Code], [Name], [Brand], [Description], [CostPrice], [RetailPrice], [SalePrice], [CalculatedPrice], [FixedShippingPrice], [FreeShipping], [AllowPurchases], [ProductVisible], [ProductAvailability], [ProductInventoried], [StockLevel], [LowStockLevel], [CategoryDetails], [Images], [PageTitle], [METAKeywords], [METADescription], [ProductCondition], [ProductURL], [RedirectOldURL], [ProductTaxCode], [ProductCustomFields]) VALUES (1806, N'P', N'DBP-255459', N'DBP-255459 2" I.D. x 3" O.D. A', N'Pangborn;BCT Metcast;Wheelabra', N'Raw Material Part # I.D. O.D. Discription   DBP-255459 2.00" 3.00" Abrasive Resistance Rubber Hose    In Stock: Default Length is 10''   Great for abrasive feed hose on small HP blast wheels and or abrasive fines discharge hose from seperators.', N'0', N'0', N'0', N'0', N'0', 0, 1, 1, 0, 0, N'0', N'0', N'Category Name: Miscellaneous Components, Category Path: E-Learning Courses/Miscellaneous Components', N'Product Image File: 2_hose__09278.png, Product Image URL: http://durableblastparts.com/product_images/c/170/2_hose__09278.png', N'DBP-255459 2" I.D. x 3" O.D. Abrasive Hose', N'', N'Hose RH22 2.00ID x 3.00OD Sand Conveyor Hose Abrasive Resistance Rubber Sleeve Duro-60A BI Fabruc, Wheelabrator separator2"', N'New', N'/dbp-255459-2-i-d-x-3-o-d-abrasive-hose/', N'', N'', N'Vendor= bhughes@ushoseco.com')
INSERT [dbo].[Product] ([ProductID], [ProductType], [Code], [Name], [Brand], [Description], [CostPrice], [RetailPrice], [SalePrice], [CalculatedPrice], [FixedShippingPrice], [FreeShipping], [AllowPurchases], [ProductVisible], [ProductAvailability], [ProductInventoried], [StockLevel], [LowStockLevel], [CategoryDetails], [Images], [PageTitle], [METAKeywords], [METADescription], [ProductCondition], [ProductURL], [RedirectOldURL], [ProductTaxCode], [ProductCustomFields]) VALUES (1807, N'P', N'DBP-255460', N'DBP-255460 2.50" I.D. x 3.50" ', N'Pangborn;BCT Metcast;Wheelabra', N'Raw Material Part # I.D. O.D. Discription   DBP-255460 2.50" 3.50" Abrasive Resistance Rubber Hose    In Stock: Default Length is 10''   Great for abrasive feed hose on small HP blast wheels and or abrasive fines discharge hose from seperators.', N'0', N'0', N'0', N'0', N'0', 0, 1, 1, 0, 0, N'0', N'0', N'Category Name: Shot Saver / Media Classifier, Category Path: Abrasive Reclaim/Shot Saver \/ Media Classifier|Category Name: Abrasive Feed Valves & Hoses, Category Path: Wheel Parts/Abrasive Feed Valves & Hoses|Category Name: Miscellaneous Components, Category Path: E-Learning Courses/Miscellaneous Components', N'Product Image File: 2_hose__09278.1616710520.1280.1280__71414.png, Product Image URL: http://durableblastparts.com/product_images/p/875/2_hose__09278.1616710520.1280.1280__71414.png', N'DBP-255460 2.50" I.D. x 3.50" O.D. Abrasive Hose', N'', N'Hose RH31 2.50ID x 3.50OD Sand Conveyor Hose Abrasive Resistance Rubber Sleeve Duro-60A NO Fabric Wheelabrator', N'New', N'/dbp-255460-2-50-i-d-x-3-50-o-d-abrasive-hose/', N'', N'', N'Vendor= bhughes@ushoseco.com')
INSERT [dbo].[Product] ([ProductID], [ProductType], [Code], [Name], [Brand], [Description], [CostPrice], [RetailPrice], [SalePrice], [CalculatedPrice], [FixedShippingPrice], [FreeShipping], [AllowPurchases], [ProductVisible], [ProductAvailability], [ProductInventoried], [StockLevel], [LowStockLevel], [CategoryDetails], [Images], [PageTitle], [METAKeywords], [METADescription], [ProductCondition], [ProductURL], [RedirectOldURL], [ProductTaxCode], [ProductCustomFields]) VALUES (1808, N'P', N'DBP-C88680', N'DBP-C88680 3.00" I.D. x 3.86" ', N'Pangborn;BCT Metcast;Wheelabra', N'Raw Material Part # I.D. O.D. Discription   DBP-C88680 3.00" 3.86" Abrasive Resistance Rubber Hose    In Stock: Default length is 10''.    Great for abrasive feed hose on small HP blast wheels and or abrasive fines discharge hose from seperators and or Shot Saver Devices.', N'0', N'0', N'0', N'0', N'0', 0, 1, 1, 0, 0, N'0', N'0', N'Category Name: Abrasive Reclaim, Category Path: Abrasive Reclaim|Category Name: Shot Saver / Media Classifier, Category Path: Abrasive Reclaim/Shot Saver \/ Media Classifier|Category Name: Abrasive Feed Valves & Hoses, Category Path: Wheel Parts/Abrasive Feed Valves & Hoses|Category Name: Miscellaneous Components, Category Path: E-Learning Courses/Miscellaneous Components', N'Product Image File: gunite__66537.jpg, Product Image URL: http://durableblastparts.com/product_images/j/072/gunite__66537.jpg', N'DBP-C88680 Hose / 3.00"ID x  3.860"OD Gunite G3 Ab', N'', N'DBP-C88680 Hose RH31 3.00ID x 3.86OD Gunite G3 Abrasive Hose', N'New', N'/dbp-c88680-3-00-i-d-x-3-86-o-d-abrasive-hose/', N'', N'', N'Vendor= bhughes@ushoseco.com')
INSERT [dbo].[Product] ([ProductID], [ProductType], [Code], [Name], [Brand], [Description], [CostPrice], [RetailPrice], [SalePrice], [CalculatedPrice], [FixedShippingPrice], [FreeShipping], [AllowPurchases], [ProductVisible], [ProductAvailability], [ProductInventoried], [StockLevel], [LowStockLevel], [CategoryDetails], [Images], [PageTitle], [METAKeywords], [METADescription], [ProductCondition], [ProductURL], [RedirectOldURL], [ProductTaxCode], [ProductCustomFields]) VALUES (1809, N'P', N'DBP-255462', N'DBP-255462 3.50" I.D. x 4.5" O', N'Pangborn;BCT Metcast;Wheelabra', N'Raw Material Part # I.D. O.D. Discription   DBP-255462 3.50" 4.50" Abrasive Resistance Rubber Hose    In Stock: Sold by the Ft.   Great for abrasive feed hose on 25 - 40 HP blast wheels and or abrasive fines discharge hose from seperators.', N'0', N'0', N'0', N'0', N'0', 0, 1, 1, 0, 0, N'0', N'0', N'Category Name: Shot Saver / Media Classifier, Category Path: Abrasive Reclaim/Shot Saver \/ Media Classifier|Category Name: Abrasive Feed Valves & Hoses, Category Path: Wheel Parts/Abrasive Feed Valves & Hoses|Category Name: Miscellaneous Components, Category Path: E-Learning Courses/Miscellaneous Components', N'Product Image File: 2_hose__43156.png, Product Image URL: http://durableblastparts.com/product_images/m/807/2_hose__43156.png', N'DBP-255462 Hose / 3.50"ID x  4.5"OD', N'', N'DBP-255462 Hose / 3.50"ID x  4.5"OD', N'New', N'/dbp-255462-3-50-i-d-x-4-5-o-d-abrasive-hose/', N'', N'', N'Vendor= bhughes@ushoseco.com')
INSERT [dbo].[Product] ([ProductID], [ProductType], [Code], [Name], [Brand], [Description], [CostPrice], [RetailPrice], [SalePrice], [CalculatedPrice], [FixedShippingPrice], [FreeShipping], [AllowPurchases], [ProductVisible], [ProductAvailability], [ProductInventoried], [StockLevel], [LowStockLevel], [CategoryDetails], [Images], [PageTitle], [METAKeywords], [METADescription], [ProductCondition], [ProductURL], [RedirectOldURL], [ProductTaxCode], [ProductCustomFields]) VALUES (1810, N'P', N'DBP-692280', N'DBP-692280 10" x 30" Elevator ', N'Wheelabrator', N'The Assembly includes the following details:  4 Ply 440 Elevator Belt for a 10 x 30 x 16''-9" Tall Elevator (32''-0") Lg Belt 38 Cast Ductile Iron Buckets Super Grip Belt Splice All Harware    Dont see your exact belt?  Contact us or download our Elevator Belt Template for a custom quote.', N'0', N'0', N'0', N'0', N'0', 0, 1, 1, 1, 0, N'0', N'0', N'Category Name: Elevator Belt Kits / Assemblies, Category Path: Abrasive Reclaim/Elevator/Elevator Belt Kits \/ Assemblies', N'Product Image File: s-l1600__97275.1595768778.1280.1280__69550.1613159329.1280.1280__73255.jpg, Product Image URL: http://durableblastparts.com/product_images/k/614/s-l1600__97275.1595768778.1280.1280__69550.1613159329.1280.1280__73255.jpg|Product Image File: Rolled_Belt__63345.1595799144.1280.1280__24110.1613159329.1280.1280__21115.jpg, Product Image URL: http://durableblastparts.com/product_images/w/876/Rolled_Belt__63345.1595799144.1280.1280__24110.1613159329.1280.1280__21115.jpg|Product Imag', N'10x30x16_9 Elevator Belt Kit', N'', N'Wheelabrator, BCT. Pangborn, Blastec, Metcast, Metfin, Elevator Belt Assemblies', N'New', N'/dbp-692280-elevator-belt-kit/', N'', N'', N'Vendor=efranke@bistaterubber.c')
INSERT [dbo].[Product] ([ProductID], [ProductType], [Code], [Name], [Brand], [Description], [CostPrice], [RetailPrice], [SalePrice], [CalculatedPrice], [FixedShippingPrice], [FreeShipping], [AllowPurchases], [ProductVisible], [ProductAvailability], [ProductInventoried], [StockLevel], [LowStockLevel], [CategoryDetails], [Images], [PageTitle], [METAKeywords], [METADescription], [ProductCondition], [ProductURL], [RedirectOldURL], [ProductTaxCode], [ProductCustomFields]) VALUES (1812, N'P', N'DBP-4X12INSERT', N'DBP-4X12INSERT | 4" x 12" Ship', N'Wheelabrator', N'Picture is representative of product.6" x 12" Shiplap Liner w/insert', N'0', N'0', N'0', N'0', N'0', 0, 1, 1, 0, 0, N'0', N'0', N'Category Name: Cabinet Liners, Category Path: Cabinet & Material Handling/Cabinet Liners', N'Product Image File: DBP-6X12INSERT_1__94222.1595424062.1280.1280__78712.jpg, Product Image URL: http://durableblastparts.com/product_images/m/494/DBP-6X12INSERT_1__94222.1595424062.1280.1280__78712.jpg', N'Wheelabrator,DBP-4X12INSERT | 4" x 12" Shiplap Lin', N'Wheelabrator,DBP-6X12INSERT | 6" x 12" Shiplap Liner w/insert,6" x 12" Shiplap Liner w/insert', N'4" x 12" Shiplap Liner w/insert', N'New', N'/dbp-4x12insert-4-x-12-shiplap-liner-w-insert/', N'', N'', N'Vendor=jackie@astechblast.com')
INSERT [dbo].[Product] ([ProductID], [ProductType], [Code], [Name], [Brand], [Description], [CostPrice], [RetailPrice], [SalePrice], [CalculatedPrice], [FixedShippingPrice], [FreeShipping], [AllowPurchases], [ProductVisible], [ProductAvailability], [ProductInventoried], [StockLevel], [LowStockLevel], [CategoryDetails], [Images], [PageTitle], [METAKeywords], [METADescription], [ProductCondition], [ProductURL], [RedirectOldURL], [ProductTaxCode], [ProductCustomFields]) VALUES (1813, N'P', N'DBP-150574', N'DBP-150574 | 6" x 4" Liner Bar', N'Pangborn;Wheelabrator', N'Picture is representative of product. 6" x 4" Liner Bar w/ Holes', N'0', N'0', N'0', N'0', N'0', 0, 1, 1, 0, 0, N'0', N'0', N'Category Name: Cabinet Liners, Category Path: Cabinet & Material Handling/Cabinet Liners', N'Product Image File: 6x4_Liner_w_hole__49021.PNG, Product Image URL: http://durableblastparts.com/product_images/j/956/6x4_Liner_w_hole__49021.PNG', N'Wheelabrator DBP-150574 | 6" x 4" Liner Bar w/ Hol', N'Pangborn;Wheelabrator,DBP-10X12WH | 10" x 12" Shiplap Liner,10" x 12" Shiplap Liner', N'Wheelabrator DBP-150574 | 6" x 4" Liner Bar w/ Holes', N'New', N'/dbp-150574-6-x-4-liner-bar-w-holes/', N'', N'', N'Vendor=jackie@astechblast.com')
INSERT [dbo].[Product] ([ProductID], [ProductType], [Code], [Name], [Brand], [Description], [CostPrice], [RetailPrice], [SalePrice], [CalculatedPrice], [FixedShippingPrice], [FreeShipping], [AllowPurchases], [ProductVisible], [ProductAvailability], [ProductInventoried], [StockLevel], [LowStockLevel], [CategoryDetails], [Images], [PageTitle], [METAKeywords], [METADescription], [ProductCondition], [ProductURL], [RedirectOldURL], [ProductTaxCode], [ProductCustomFields]) VALUES (1814, N'P', N'DBP-150574 NH', N'DBP-150574 NH | 6" x 4" Liner ', N'Pangborn;Wheelabrator', N'Picture is representative of product. 6" x 4" Liner Bar w/o Holes', N'285', N'0', N'0', N'350', N'0', 0, 1, 1, 0, 0, N'0', N'0', N'Category Name: Cabinet Liners, Category Path: Cabinet & Material Handling/Cabinet Liners', N'Product Image File: 6x4_Liner_wo_hole__21338.PNG, Product Image URL: http://durableblastparts.com/product_images/i/129/6x4_Liner_wo_hole__21338.PNG', N'Wheelabrator DBP-150574 | 6" x 4" Liner Bar w/o Ho', N'Pangborn;Wheelabrator,DBP-10X12WH | 10" x 12" Shiplap Liner,10" x 12" Shiplap Liner', N'Wheelabrator DBP-150574 | 6" x 4" Liner Bar w/o Holes', N'New', N'/dbp-150574-nh-6-x-4-liner-bar-w-o-holes/', N'', N'', N'Vendor=jackie@astechblast.com')
INSERT [dbo].[Product] ([ProductID], [ProductType], [Code], [Name], [Brand], [Description], [CostPrice], [RetailPrice], [SalePrice], [CalculatedPrice], [FixedShippingPrice], [FreeShipping], [AllowPurchases], [ProductVisible], [ProductAvailability], [ProductInventoried], [StockLevel], [LowStockLevel], [CategoryDetails], [Images], [PageTitle], [METAKeywords], [METADescription], [ProductCondition], [ProductURL], [RedirectOldURL], [ProductTaxCode], [ProductCustomFields]) VALUES (1815, N'P', N'DBP-20x30Door', N'20 x 30 Door Assembly', N'', N'1/4" Maganese Plate Door Assembly Cast Long-Life Liners Door Hinge and Latch Assembly Lambrinth Door Seal', N'0', N'0', N'0', N'0', N'0', 0, 1, 1, 0, 0, N'0', N'0', N'Category Name: Miscellaneous Components, Category Path: E-Learning Courses/Miscellaneous Components', N'', N'20 x 30 Door Assembly', N'', N'', N'New', N'/20-x-30-door-assembly/', N'', N'', N'Vendor=sales@durableblastparts')
INSERT [dbo].[Product] ([ProductID], [ProductType], [Code], [Name], [Brand], [Description], [CostPrice], [RetailPrice], [SalePrice], [CalculatedPrice], [FixedShippingPrice], [FreeShipping], [AllowPurchases], [ProductVisible], [ProductAvailability], [ProductInventoried], [StockLevel], [LowStockLevel], [CategoryDetails], [Images], [PageTitle], [METAKeywords], [METADescription], [ProductCondition], [ProductURL], [RedirectOldURL], [ProductTaxCode], [ProductCustomFields]) VALUES (1818, N'P', N'DBP-FA67/G DRN90L4  - C116009', N'DBP-FA67/G DRN90L4 | Gearmotor', N'SEW-Eurodrive', N'Picture is representative of product. 2 HP Gearmotor, 35 RPM Output, 1.50" Dia. Bore, 460/60/3 Ref. Wheelabrator Part # C116009', N'0', N'0', N'0', N'0', N'0', 0, 1, 1, 0, 0, N'0', N'0', N'Category Name: Abrasive Reclaim, Category Path: Abrasive Reclaim|Category Name: Lower Screw Gearmotors, Category Path: Abrasive Reclaim/Lower Screw Gearmotors', N'Product Image File: sew_gbox_parahelical_f__72086.1595424045.1280.1280__77037.jpg, Product Image URL: http://durableblastparts.com/product_images/m/496/sew_gbox_parahelical_f__72086.1595424045.1280.1280__77037.jpg', N'SEW-Eurodrive,DBP-FA57DRN90L4 | Gearmotor', N'SEW-Eurodrive,DBP-FA57DRN90L4 | Gearmotor,2 HP Gearmotor, 59 RPM Output, 1.50" Dia. Bore, 460/60/3', N'2 HP Gearmotor, 59 RPM Output, 1.50" Dia. Bore, 460/60/3', N'New', N'/dbp-fa67-g-drn90l4-gearmotor/', N'', N'', N'Vendor=team4@bdindustrialteam4')
INSERT [dbo].[Product] ([ProductID], [ProductType], [Code], [Name], [Brand], [Description], [CostPrice], [RetailPrice], [SalePrice], [CalculatedPrice], [FixedShippingPrice], [FreeShipping], [AllowPurchases], [ProductVisible], [ProductAvailability], [ProductInventoried], [StockLevel], [LowStockLevel], [CategoryDetails], [Images], [PageTitle], [METAKeywords], [METADescription], [ProductCondition], [ProductURL], [RedirectOldURL], [ProductTaxCode], [ProductCustomFields]) VALUES (1819, N'P', N'DBP-DBP-C136441', N'DBP-C136441 I Hanger Bearing S', N'Pangborn;BCT Metcast;Wheelabra', N'Picture is representative of product. Hanger Bearing Mounting Bracket Assembly C136441 Contact us for Hanger Bearing Alignment Instructions to ensure improved life!', N'0', N'0', N'0', N'0', N'0', 0, 1, 1, 0, 0, N'0', N'0', N'Category Name: Hanger Bearings , Category Path: Abrasive Reclaim/Hanger Bearings', N'Product Image File: Bracket__28018.1619646603.1280.1280__58034.jpg, Product Image URL: http://durableblastparts.com/product_images/n/531/Bracket__28018.1619646603.1280.1280__58034.jpg', N'DBP-C136441 I Hanger Bearing Support Bracket Assem', N'', N'BCT, Wheelabrator, Pangborn, Hoffman, Metfin, Blastec, ABS, Hanger Bearings, Blast Rooms, Blast Machines, Abrasive Recovery, Abrasive Reclaim', N'New', N'/dbp-c136441-i-hanger-bearing-support-bracket-assembly/', N'', N'', N'jean@circlerindustries.com')
INSERT [dbo].[Product] ([ProductID], [ProductType], [Code], [Name], [Brand], [Description], [CostPrice], [RetailPrice], [SalePrice], [CalculatedPrice], [FixedShippingPrice], [FreeShipping], [AllowPurchases], [ProductVisible], [ProductAvailability], [ProductInventoried], [StockLevel], [LowStockLevel], [CategoryDetails], [Images], [PageTitle], [METAKeywords], [METADescription], [ProductCondition], [ProductURL], [RedirectOldURL], [ProductTaxCode], [ProductCustomFields]) VALUES (1820, N'P', N'DBP-DBP-C136442', N'DBP-C136442 I Hanger Bearing S', N'Pangborn;BCT Metcast;Wheelabra', N'Picture is representative of product. Hanger Bearing Mounting Bracket C136442 Contact us for Hanger Bearing Alignment Instructions to ensure improved life!', N'0', N'0', N'0', N'0', N'0', 0, 1, 1, 0, 0, N'0', N'0', N'Category Name: Hanger Bearings , Category Path: Abrasive Reclaim/Hanger Bearings', N'Product Image File: C136442_Bracket_Top__75394.PNG, Product Image URL: http://durableblastparts.com/product_images/b/123/C136442_Bracket_Top__75394.PNG', N'DBP-C136442 I Hanger Bearing Support Bracket', N'', N'BCT, Wheelabrator, Pangborn, Hoffman, Metfin, Blastec, ABS, Hanger Bearings, Blast Rooms, Blast Machines, Abrasive Recovery, Abrasive Reclaim', N'New', N'/dbp-c136442-i-hanger-bearing-support-bracket/', N'', N'', N'jean@circlerindustries.com')
INSERT [dbo].[Product] ([ProductID], [ProductType], [Code], [Name], [Brand], [Description], [CostPrice], [RetailPrice], [SalePrice], [CalculatedPrice], [FixedShippingPrice], [FreeShipping], [AllowPurchases], [ProductVisible], [ProductAvailability], [ProductInventoried], [StockLevel], [LowStockLevel], [CategoryDetails], [Images], [PageTitle], [METAKeywords], [METADescription], [ProductCondition], [ProductURL], [RedirectOldURL], [ProductTaxCode], [ProductCustomFields]) VALUES (1821, N'P', N'DBP-BALCEM3559T', N'Motor, 3HP Fan Motor', N'OEM Brand', N'BALCEM3559T, Motor, 3HP Fan Motor', N'0', N'0', N'0', N'0', N'0', 0, 1, 1, 0, 0, N'0', N'0', N'Category Name: Dust Collector, Category Path: Dust Collector|Category Name: Fan Motors, Category Path: Dust Collector/Fan Motors', N'Product Image File: Picture1__83807.jpg, Product Image URL: http://durableblastparts.com/product_images/a/689/Picture1__83807.jpg', N'BALCEM3559T, Motor, 3HP Fan Motor', N'', N'Buy now online, BALCEM3559T, Motor, 3HP Fan Motor', N'New', N'/motor-3hp-fan-motor/', N'', N'', N'Vendor=sales@durableblastparts')
INSERT [dbo].[Product] ([ProductID], [ProductType], [Code], [Name], [Brand], [Description], [CostPrice], [RetailPrice], [SalePrice], [CalculatedPrice], [FixedShippingPrice], [FreeShipping], [AllowPurchases], [ProductVisible], [ProductAvailability], [ProductInventoried], [StockLevel], [LowStockLevel], [CategoryDetails], [Images], [PageTitle], [METAKeywords], [METADescription], [ProductCondition], [ProductURL], [RedirectOldURL], [ProductTaxCode], [ProductCustomFields]) VALUES (1822, N'P', N'DBP-G-FMS-200', N'DBP-G-FMS-200 2.0" I.D. x 2.75', N'Pangborn;BCT Metcast;Wheelabra', N'Raw Material Part # I.D. O.D. Discription   DBP-G-FMS-200 2.0" 2.75" Abrasive Resistance Rubber Hose    In Stock: Default Length is 10''   Great for abrasive feed hose on small HP blast wheels and or abrasive fines discharge hose from seperators.', N'0', N'0', N'0', N'0', N'0', 0, 1, 1, 0, 0, N'0', N'0', N'Category Name: Shot Saver, Category Path: Abrasive Reclaim/Shot Saver|Category Name: Shot Saver / Media Classifier, Category Path: Abrasive Reclaim/Shot Saver \/ Media Classifier|Category Name: Abrasive Feed Valves & Hoses, Category Path: Wheel Parts/Abrasive Feed Valves & Hoses', N'Product Image File: 2_hose__09278.1616710520.1280.1280__71414.1617305596.1280.1280__07918.png, Product Image URL: http://durableblastparts.com/product_images/s/659/2_hose__09278.1616710520.1280.1280__71414.1617305596.1280.1280__07918.png', N'DBP-G-FMS-200 2.0" I.D. x 2.75" O.D. Abrasive Hose', N'', N'Hose RH31 2.00ID x 2.75OD Sand Conveyor Hose Abrasive Resistance Rubber Sleeve Duro-60A NO Fabric Wheelabrator', N'New', N'/dbp-g-fms-200-1-5-i-d-x-2-0-o-d-abrasive-hose/', N'', N'', N'Vendor= bhughes@ushoseco.com')
INSERT [dbo].[Product] ([ProductID], [ProductType], [Code], [Name], [Brand], [Description], [CostPrice], [RetailPrice], [SalePrice], [CalculatedPrice], [FixedShippingPrice], [FreeShipping], [AllowPurchases], [ProductVisible], [ProductAvailability], [ProductInventoried], [StockLevel], [LowStockLevel], [CategoryDetails], [Images], [PageTitle], [METAKeywords], [METADescription], [ProductCondition], [ProductURL], [RedirectOldURL], [ProductTaxCode], [ProductCustomFields]) VALUES (1823, N'P', N'DBP-G-FMS-300-1', N'DBP-G-FMS-300 3.0" I.D. x 3.88', N'Pangborn;BCT Metcast;Wheelabra', N'Raw Material Part # I.D. O.D. Discription   DBP-G-FMS-300 3.00" 3.88" Abrasive Resistance Rubber Hose    In Stock: Default Length is 10''   Great for abrasive feed hose on small HP blast wheels and or abrasive fines discharge hose from seperators.', N'0', N'0', N'0', N'0', N'0', 0, 1, 1, 0, 0, N'0', N'0', N'Category Name: Shot Saver, Category Path: Abrasive Reclaim/Shot Saver|Category Name: Shot Saver / Media Classifier, Category Path: Abrasive Reclaim/Shot Saver \/ Media Classifier|Category Name: Abrasive Feed Valves & Hoses, Category Path: Wheel Parts/Abrasive Feed Valves & Hoses', N'Product Image File: 1620225538.1280.1280__13770.png, Product Image URL: http://durableblastparts.com/product_images/x/741/1620225538.1280.1280__13770.png', N'DBP-G-FMS-300 3.0" I.D. x 3.88" O.D. Abrasive Hose', N'', N'Hose RH31 2.50ID x 3.50OD Sand Conveyor Hose Abrasive Resistance Rubber Sleeve Duro-60A NO Fabric Wheelabrator', N'New', N'/dbp-g-fms-300-1-5-i-d-x-2-0-o-d-abrasive-hose/', N'', N'', N'Vendor= bhughes@ushoseco.com')
GO
INSERT [dbo].[Product] ([ProductID], [ProductType], [Code], [Name], [Brand], [Description], [CostPrice], [RetailPrice], [SalePrice], [CalculatedPrice], [FixedShippingPrice], [FreeShipping], [AllowPurchases], [ProductVisible], [ProductAvailability], [ProductInventoried], [StockLevel], [LowStockLevel], [CategoryDetails], [Images], [PageTitle], [METAKeywords], [METADescription], [ProductCondition], [ProductURL], [RedirectOldURL], [ProductTaxCode], [ProductCustomFields]) VALUES (1824, N'P', N'DBP-G-FMS-400-1', N'DBP-G-FMS-400 4.0" I.D. x 4.88', N'Pangborn;BCT Metcast;Wheelabra', N'Raw Material Part # I.D. O.D. Discription   DBP-G-FMS-400 4.0" 4.88" Abrasive Resistance Rubber Hose    In Stock: Default Length is 10''   Great for abrasive feed hose on small HP blast wheels and or abrasive fines discharge hose from seperators.', N'0', N'0', N'0', N'0', N'0', 0, 1, 1, 0, 0, N'0', N'0', N'Category Name: Shot Saver, Category Path: Abrasive Reclaim/Shot Saver|Category Name: Shot Saver / Media Classifier, Category Path: Abrasive Reclaim/Shot Saver \/ Media Classifier|Category Name: Abrasive Feed Valves & Hoses, Category Path: Wheel Parts/Abrasive Feed Valves & Hoses', N'Product Image File: 1621281986.1280.1280__59052.png, Product Image URL: http://durableblastparts.com/product_images/f/311/1621281986.1280.1280__59052.png', N'DBP-G-FMS-400 4.0" I.D. x 4.88" O.D. Abrasive Hose', N'', N'Hose RH31 4.00ID x 4.88OD Sand Conveyor Hose Abrasive Resistance Rubber Sleeve Duro-60A NO Fabric Wheelabrator', N'New', N'/dbp-g-fms-400-4-0-i-d-x-4-88-o-d-abrasive-hose/', N'', N'', N'Vendor= bhughes@ushoseco.com')
INSERT [dbo].[Product] ([ProductID], [ProductType], [Code], [Name], [Brand], [Description], [CostPrice], [RetailPrice], [SalePrice], [CalculatedPrice], [FixedShippingPrice], [FreeShipping], [AllowPurchases], [ProductVisible], [ProductAvailability], [ProductInventoried], [StockLevel], [LowStockLevel], [CategoryDetails], [Images], [PageTitle], [METAKeywords], [METADescription], [ProductCondition], [ProductURL], [RedirectOldURL], [ProductTaxCode], [ProductCustomFields]) VALUES (1825, N'P', N'DBP-G-FMS-500-1-1', N'DBP-G-FMS-500 5.0" I.D. x 5.88', N'Pangborn;BCT Metcast;Wheelabra', N'Raw Material Part # I.D. O.D. Discription   DBP-G-FMS-500 5.0" 5.88" Abrasive Resistance Rubber Hose    In Stock: Default Length is 10''   Great for abrasive feed hose on small HP blast wheels and or abrasive fines discharge hose from seperators.', N'0', N'0', N'0', N'0', N'0', 0, 1, 1, 0, 0, N'0', N'0', N'Category Name: Shot Saver, Category Path: Abrasive Reclaim/Shot Saver|Category Name: Shot Saver / Media Classifier, Category Path: Abrasive Reclaim/Shot Saver \/ Media Classifier|Category Name: Abrasive Feed Valves & Hoses, Category Path: Wheel Parts/Abrasive Feed Valves & Hoses', N'Product Image File: 1621281986.1280.1280__59052.1621282608.1280.1280__52453.png, Product Image URL: http://durableblastparts.com/product_images/y/125/1621281986.1280.1280__59052.1621282608.1280.1280__52453.png', N'DBP-G-FMS-500 5.0" I.D. x 5.88" O.D. Abrasive Hose', N'', N'Hose RH31 5.00ID x 5.88OD Sand Conveyor Hose Abrasive Resistance Rubber Sleeve Duro-60A NO Fabric Wheelabrator', N'New', N'/dbp-g-fms-500-5-0-i-d-x-5-88-o-d-abrasive-hose/', N'', N'', N'Vendor= bhughes@ushoseco.com')
INSERT [dbo].[Product] ([ProductID], [ProductType], [Code], [Name], [Brand], [Description], [CostPrice], [RetailPrice], [SalePrice], [CalculatedPrice], [FixedShippingPrice], [FreeShipping], [AllowPurchases], [ProductVisible], [ProductAvailability], [ProductInventoried], [StockLevel], [LowStockLevel], [CategoryDetails], [Images], [PageTitle], [METAKeywords], [METADescription], [ProductCondition], [ProductURL], [RedirectOldURL], [ProductTaxCode], [ProductCustomFields]) VALUES (1826, N'P', N'DBP-G-FMS-600-1-1', N'DBP-G-FMS-600 6.0" I.D. x 6.88', N'Pangborn;BCT Metcast;Wheelabra', N'Raw Material Part # I.D. O.D. Discription   DBP-G-FMS-600 6.0" 6.88" Abrasive Resistance Rubber Hose    In Stock: Default Length is 10''   Great for abrasive feed hose on small HP blast wheels and or abrasive fines discharge hose from seperators.', N'0', N'0', N'0', N'0', N'0', 0, 1, 1, 0, 0, N'0', N'0', N'Category Name: Shot Saver, Category Path: Abrasive Reclaim/Shot Saver|Category Name: Shot Saver / Media Classifier, Category Path: Abrasive Reclaim/Shot Saver \/ Media Classifier|Category Name: Abrasive Feed Valves & Hoses, Category Path: Wheel Parts/Abrasive Feed Valves & Hoses', N'Product Image File: 1621281986.1280.1280__59052.1621282608.1280.1280__96755.png, Product Image URL: http://durableblastparts.com/product_images/i/835/1621281986.1280.1280__59052.1621282608.1280.1280__96755.png', N'DBP-G-FMS-600 6.0" I.D. x 6.88" O.D. Abrasive Hose', N'', N'Hose RH31 4.00ID x 4.88OD Sand Conveyor Hose Abrasive Resistance Rubber Sleeve Duro-60A NO Fabric Wheelabrator', N'New', N'/dbp-g-fms-600-6-0-i-d-x-6-88-o-d-abrasive-hose/', N'', N'', N'Vendor= bhughes@ushoseco.com')
INSERT [dbo].[Product] ([ProductID], [ProductType], [Code], [Name], [Brand], [Description], [CostPrice], [RetailPrice], [SalePrice], [CalculatedPrice], [FixedShippingPrice], [FreeShipping], [AllowPurchases], [ProductVisible], [ProductAvailability], [ProductInventoried], [StockLevel], [LowStockLevel], [CategoryDetails], [Images], [PageTitle], [METAKeywords], [METADescription], [ProductCondition], [ProductURL], [RedirectOldURL], [ProductTaxCode], [ProductCustomFields]) VALUES (1827, N'P', N'DBP-P-6010000', N'DBP-P-6010000 | Impeller', N'Pangborn', N'Picture is representative of product. Impeller Wheel MODEL: 14" Rim Loc DIA OF WHEEL: 14.00" Blades / VANES: 8 Blades Machine Mfg: Pangborn', N'0', N'0', N'0', N'0', N'0', 0, 1, 1, 0, 0, N'0', N'0', N'Category Name: Wheel Internals, Category Path: Wheel Parts/Wheel Internals', N'Product Image File: rimloc_impeller__15506.jpg, Product Image URL: http://durableblastparts.com/product_images/a/315/rimloc_impeller__15506.jpg', N'Pangborn,DBP-6010000 | Blade Set', N'Pangborn,DBP-P-6000024-8 | Blade Set,,Blade Set,Wheel MODEL: 14" Rim Loc,DIA OF WHEEL: 14.00",Blades / VANES: 8 Blades,,Machine Mfg: Pangborn', N',Blade Set,Wheel MODEL: 14" Rim Loc,DIA OF WHEEL: 14.00",Blades / VANES: 8 Blades,,Machine Mfg: Pangborn', N'New', N'/dbp-p-6010000-impeller/', N'', N'', N'Vendor=jackie@astechblast.com;')
INSERT [dbo].[Product] ([ProductID], [ProductType], [Code], [Name], [Brand], [Description], [CostPrice], [RetailPrice], [SalePrice], [CalculatedPrice], [FixedShippingPrice], [FreeShipping], [AllowPurchases], [ProductVisible], [ProductAvailability], [ProductInventoried], [StockLevel], [LowStockLevel], [CategoryDetails], [Images], [PageTitle], [METAKeywords], [METADescription], [ProductCondition], [ProductURL], [RedirectOldURL], [ProductTaxCode], [ProductCustomFields]) VALUES (1828, N'P', N'DBP-P-6050014', N'DBP-P-6050014  | Control Cage', N'Pangborn', N'Picture is representative of product. 40 Deg Control Cage Rim Loc Machine Mfg: Pangborn', N'0', N'0', N'0', N'0', N'0', 0, 1, 1, 0, 0, N'0', N'0', N'Category Name: Wheel Internals, Category Path: Wheel Parts/Wheel Internals', N'Product Image File: rimloc_control_cage__46082.jpg, Product Image URL: http://durableblastparts.com/product_images/i/279/rimloc_control_cage__46082.jpg', N'Pangborn,DBP-P-6050014 | Control Cage', N'Pangborn,DBP-P-6000024-8 | Blade Set,,Blade Set,Wheel MODEL: 14" Rim Loc,DIA OF WHEEL: 14.00",Blades / VANES: 8 Blades,,Machine Mfg: Pangborn', N',P-6050014, Control Cage ,Wheel MODEL: 14" Rim Loc,DIA OF WHEEL: 14.00",Blades / VANES: 8 Blades,,Machine Mfg: Pangborn', N'New', N'/dbp-p-6050014-control-cage/', N'', N'', N'Vendor=jackie@astechblast.com;')
INSERT [dbo].[Product] ([ProductID], [ProductType], [Code], [Name], [Brand], [Description], [CostPrice], [RetailPrice], [SalePrice], [CalculatedPrice], [FixedShippingPrice], [FreeShipping], [AllowPurchases], [ProductVisible], [ProductAvailability], [ProductInventoried], [StockLevel], [LowStockLevel], [CategoryDetails], [Images], [PageTitle], [METAKeywords], [METADescription], [ProductCondition], [ProductURL], [RedirectOldURL], [ProductTaxCode], [ProductCustomFields]) VALUES (1829, N'P', N'DBP-5100651', N'DBP-5100651 | Blade Spring Set', N'Pangborn', N'Picture is representative of product. RimLoc Spring Set Only for 8 - Blades Machine Mfg: Pangborn', N'0', N'0', N'0', N'0', N'0', 0, 1, 1, 0, 0, N'0', N'0', N'Category Name: Wheel Internals, Category Path: Wheel Parts/Wheel Internals', N'Product Image File: Rimlocblade__68659.jpg, Product Image URL: http://durableblastparts.com/product_images/d/927/Rimlocblade__68659.jpg', N'Pangborn,DBP-5100651-blade-spring-set', N'Pangborn,DBP-P-6000024-8 | Blade Set,,Blade Set,Wheel MODEL: 14" Rim Loc,DIA OF WHEEL: 14.00",Blades / VANES: 8 Blades,,Machine Mfg: Pangborn', N',5100651-blade-spring-set ,Wheel MODEL: 14" Rim Loc,DIA OF WHEEL: 14.00",Blades / VANES: 8 Blades,,Machine Mfg: Pangborn', N'New', N'/dbp-5100651-blade-spring-set/', N'', N'', N'Vendor=jackie@astechblast.com;')
INSERT [dbo].[Product] ([ProductID], [ProductType], [Code], [Name], [Brand], [Description], [CostPrice], [RetailPrice], [SalePrice], [CalculatedPrice], [FixedShippingPrice], [FreeShipping], [AllowPurchases], [ProductVisible], [ProductAvailability], [ProductInventoried], [StockLevel], [LowStockLevel], [CategoryDetails], [Images], [PageTitle], [METAKeywords], [METADescription], [ProductCondition], [ProductURL], [RedirectOldURL], [ProductTaxCode], [ProductCustomFields]) VALUES (1830, N'P', N'DBP-151428', N'34 Super II Tumblast Mill Shaf', N'BCT Metcast;Wheelabrator', N'Spherical roller bearings for Mill Shafts 22, 28 & 34 Super II Tumblast', N'0', N'0', N'0', N'0', N'0', 0, 1, 1, 0, 0, N'0', N'0', N'Category Name: Cabinet & Material Handling, Category Path: Cabinet & Material Handling|Category Name: Steel Mill, Category Path: Cabinet & Material Handling/Tumblast Mill Components/Steel Mill', N'Product Image File: 81p2bYWzjsL._SX342___50717.jpg, Product Image URL: http://durableblastparts.com/product_images/w/715/81p2bYWzjsL._SX342___50717.jpg', N'34 Super II Tumblast Mill Shaft Bearings', N'', N'Wheelabrator Tumblast Mill Shaft Bearings', N'New', N'/34-super-ii-tumblast-mill-shaft-bearings/', N'', N'', N'Vendor=sales@durableblastparts')
INSERT [dbo].[Product] ([ProductID], [ProductType], [Code], [Name], [Brand], [Description], [CostPrice], [RetailPrice], [SalePrice], [CalculatedPrice], [FixedShippingPrice], [FreeShipping], [AllowPurchases], [ProductVisible], [ProductAvailability], [ProductInventoried], [StockLevel], [LowStockLevel], [CategoryDetails], [Images], [PageTitle], [METAKeywords], [METADescription], [ProductCondition], [ProductURL], [RedirectOldURL], [ProductTaxCode], [ProductCustomFields]) VALUES (1831, N'P', N'DBP-151970', N'34 Super II Tumblast Mill Shaf', N'BCT Metcast;Wheelabrator', N'Rubber Bearing Seal for Mill Shafts 22, 28 & 34 Super II Tumblast', N'0', N'0', N'0', N'0', N'0', 0, 1, 1, 0, 0, N'0', N'0', N'Category Name: Cabinet & Material Handling, Category Path: Cabinet & Material Handling|Category Name: Steel Mill, Category Path: Cabinet & Material Handling/Tumblast Mill Components/Steel Mill', N'Product Image File: Rubber_Bearing_Seal__51222.JPG, Product Image URL: http://durableblastparts.com/product_images/l/230/Rubber_Bearing_Seal__51222.JPG', N'34 Super II Tumblast Mill Shaft Bearings Rubber Se', N'', N'Wheelabrator Tumblast Mill Shaft Bearing Seal', N'New', N'/34-super-ii-tumblast-mill-shaft-bearings-rubber-seal/', N'', N'', N'Vendor=sales@durableblastparts')
INSERT [dbo].[Product] ([ProductID], [ProductType], [Code], [Name], [Brand], [Description], [CostPrice], [RetailPrice], [SalePrice], [CalculatedPrice], [FixedShippingPrice], [FreeShipping], [AllowPurchases], [ProductVisible], [ProductAvailability], [ProductInventoried], [StockLevel], [LowStockLevel], [CategoryDetails], [Images], [PageTitle], [METAKeywords], [METADescription], [ProductCondition], [ProductURL], [RedirectOldURL], [ProductTaxCode], [ProductCustomFields]) VALUES (1832, N'P', N'DBP-151971', N'34 Super II Tumblast Mill Shaf', N'BCT Metcast;Wheelabrator', N'Rubber Bearing Seal for Mill Shafts 22, 28 & 34 Super II Tumblast', N'0', N'0', N'0', N'0', N'0', 0, 1, 1, 0, 0, N'0', N'0', N'Category Name: Cabinet & Material Handling, Category Path: Cabinet & Material Handling|Category Name: Steel Mill, Category Path: Cabinet & Material Handling/Tumblast Mill Components/Steel Mill', N'Product Image File: Felt_Seal__89474.jpg, Product Image URL: http://durableblastparts.com/product_images/l/851/Felt_Seal__89474.jpg', N'34 Super II Tumblast Mill Shaft Bearings Felt Seal', N'', N'Wheelabrator Tumblast Mill Shaft Bearing Seal', N'New', N'/34-super-ii-tumblast-mill-shaft-bearings-felt-seal/', N'', N'', N'Vendor=sales@durableblastparts')
INSERT [dbo].[Product] ([ProductID], [ProductType], [Code], [Name], [Brand], [Description], [CostPrice], [RetailPrice], [SalePrice], [CalculatedPrice], [FixedShippingPrice], [FreeShipping], [AllowPurchases], [ProductVisible], [ProductAvailability], [ProductInventoried], [StockLevel], [LowStockLevel], [CategoryDetails], [Images], [PageTitle], [METAKeywords], [METADescription], [ProductCondition], [ProductURL], [RedirectOldURL], [ProductTaxCode], [ProductCustomFields]) VALUES (1833, N'P', N'DBP-H100623', N'Skirt board Seal', N'', N'H160023 - Custom Seal per drawing provided.', N'0', N'0', N'0', N'0', N'0', 0, 1, 1, 0, 0, N'0', N'0', N'Category Name: Tumblast Mill Components, Category Path: Cabinet & Material Handling/Tumblast Mill Components|Category Name: Rubber Mill, Category Path: Cabinet & Material Handling/Tumblast Mill Components/Rubber Mill', N'', N'Skirt board Seal', N'', N'', N'New', N'/skirt-board-seal/', N'', N'', N'Vendor=efranke@bistaterubber.c')
INSERT [dbo].[Product] ([ProductID], [ProductType], [Code], [Name], [Brand], [Description], [CostPrice], [RetailPrice], [SalePrice], [CalculatedPrice], [FixedShippingPrice], [FreeShipping], [AllowPurchases], [ProductVisible], [ProductAvailability], [ProductInventoried], [StockLevel], [LowStockLevel], [CategoryDetails], [Images], [PageTitle], [METAKeywords], [METADescription], [ProductCondition], [ProductURL], [RedirectOldURL], [ProductTaxCode], [ProductCustomFields]) VALUES (1834, N'P', N'DBP-7403150', N'DBP-7403150 | Tune Up Kit', N'Wheelabrator', N'Picture is representative of product. Tune Up Kit Part Numbers in Kits: C104905, 737719, 737648, 682988, 683487, 736807 Wheel MODEL: 25EZ270 DIA OF WHEEL: 27.00" Blades / VANES: 12 Blades CONTROL CAGE: 70 ROTATION: Bidirectional Machine Mfg: Wheelabrator', N'0', N'0', N'0', N'0', N'0', 0, 1, 1, 0, 0, N'0', N'0', N'Category Name: Tune Up Kits, Category Path: Wheel Parts/Wheel Internals/Tune Up Kits', N'Product Image File: TuneupKit_25EZFITs__51895.1595424040.1280.1280__64167.jpg, Product Image URL: http://durableblastparts.com/product_images/w/962/TuneupKit_25EZFITs__51895.1595424040.1280.1280__64167.jpg', N'Wheelabrator,DBP-7403150| Tune Up Kit', N'Wheelabrator,DBP-740301 | Tune Up Kit,,Tune Up Kit,Part Numbers in Kits: C113321, 737717, 737648, 682988, 683487, 736807,Wheel MODEL: 25EZ270,DIA OF WHEEL: 27.00",Blades / VANES: 8 Blades,CONTROL CAGE: 30,ROTATION: Bidirectional,Machine Mfg: Wheelabrator', N',Tune Up Kit,Part Numbers in Kits: C104905, 737719, 737648, 682988, 683487, 736807,Wheel MODEL: 25EZ270,DIA OF WHEEL: 27.00",Blades / VANES: 12 Blades,CONTROL CAGE: 70,ROTATION: Bidirectional,Machine Mfg: Wheelabrator', N'New', N'/dbp-7403150-tune-up-kit/', N'', N'', N'Vendor=jackie@astechblast.com;')
INSERT [dbo].[Product] ([ProductID], [ProductType], [Code], [Name], [Brand], [Description], [CostPrice], [RetailPrice], [SalePrice], [CalculatedPrice], [FixedShippingPrice], [FreeShipping], [AllowPurchases], [ProductVisible], [ProductAvailability], [ProductInventoried], [StockLevel], [LowStockLevel], [CategoryDetails], [Images], [PageTitle], [METAKeywords], [METADescription], [ProductCondition], [ProductURL], [RedirectOldURL], [ProductTaxCode], [ProductCustomFields]) VALUES (1835, N'P', N'DBP-6742200', N'DBP-6742200 | Tune Up Kit', N'Wheelabrator', N'Picture is representative of product. Tune Up Kit Part Numbers in Kits: 672075, 684136, 675421, 682988, 683487, 682231 Wheel MODEL: 25BD250 DIA OF WHEEL: 25.00" Blades / VANES: 8 Blades CONTROL CAGE: 70 ROTATION: Bidirectional Machine Mfg: Wheelabrator', N'0', N'0', N'0', N'0', N'0', 0, 1, 1, 0, 0, N'0', N'0', N'Category Name: Tune Up Kits, Category Path: Wheel Parts/Wheel Internals/Tune Up Kits', N'Product Image File: 697538_1__63765.1595424036.1280.1280__54475.jpg, Product Image URL: http://durableblastparts.com/product_images/x/634/697538_1__63765.1595424036.1280.1280__54475.jpg', N'Wheelabrator,DBP-674220 | Tune Up Kit', N'Wheelabrator,DBP-697538 | Tune Up Kit,,Tune Up Kit,Part Numbers in Kits: 672075, 684136, 675420, 682988, 683487, 682231,Wheel MODEL: 25BD250,DIA OF WHEEL: 25.00",Blades / VANES: 8 Blades,CONTROL CAGE: 30,ROTATION: Bidirectional,Machine Mfg: Wheelabrator', N',Tune Up Kit,Part Numbers in Kits: 672075, 684136, 675421, 682988, 683487, 682231,Wheel MODEL: 25BD250,DIA OF WHEEL: 25.00",Blades / VANES: 8 Blades,CONTROL CAGE: 30,ROTATION: Bidirectional,Machine Mfg: Wheelabrator', N'New', N'/dbp-6742200-tune-up-kit/', N'', N'', N'Vendor=jackie@astechblast.com;')
INSERT [dbo].[Product] ([ProductID], [ProductType], [Code], [Name], [Brand], [Description], [CostPrice], [RetailPrice], [SalePrice], [CalculatedPrice], [FixedShippingPrice], [FreeShipping], [AllowPurchases], [ProductVisible], [ProductAvailability], [ProductInventoried], [StockLevel], [LowStockLevel], [CategoryDetails], [Images], [PageTitle], [METAKeywords], [METADescription], [ProductCondition], [ProductURL], [RedirectOldURL], [ProductTaxCode], [ProductCustomFields]) VALUES (1836, N'P', N'DBP-6742190', N'DBP-674219 | Tune Up Kit', N'Wheelabrator', N'Picture is representative of product. Tune Up Kit Part Numbers in Kits: 672075, 684136, 675422, 682988, 683487, 682231 Wheel MODEL: 25BD250 DIA OF WHEEL: 25.00" Blades / VANES: 8 Blades CONTROL CAGE:  ROTATION: Bidirectional Machine Mfg: Wheelabrator', N'0', N'0', N'0', N'0', N'0', 0, 1, 1, 0, 0, N'0', N'0', N'Category Name: Tune Up Kits, Category Path: Wheel Parts/Wheel Internals/Tune Up Kits', N'Product Image File: 697538_1__63765.1595424036.1280.1280__54475.1633655257.1280.1280__50850.jpg, Product Image URL: http://durableblastparts.com/product_images/a/371/697538_1__63765.1595424036.1280.1280__54475.1633655257.1280.1280__50850.jpg', N'Wheelabrator,DBP-6742190 | Tune Up Kit', N'Wheelabrator,DBP-697538 | Tune Up Kit,,Tune Up Kit,Part Numbers in Kits: 672075, 684136, 675420, 682988, 683487, 682231,Wheel MODEL: 25BD250,DIA OF WHEEL: 25.00",Blades / VANES: 8 Blades,CONTROL CAGE: 30,ROTATION: Bidirectional,Machine Mfg: Wheelabrator', N',Tune Up Kit,Part Numbers in Kits: 672075, 684136, 675422, 682988, 683487, 682231,Wheel MODEL: 25BD250,DIA OF WHEEL: 25.00",Blades / VANES: 8 Blades,CONTROL CAGE: 49,ROTATION: Bidirectional,Machine Mfg: Wheelabrator', N'New', N'/dbp-674219-tune-up-kit/', N'', N'', N'Vendor=jackie@astechblast.com;')
INSERT [dbo].[Product] ([ProductID], [ProductType], [Code], [Name], [Brand], [Description], [CostPrice], [RetailPrice], [SalePrice], [CalculatedPrice], [FixedShippingPrice], [FreeShipping], [AllowPurchases], [ProductVisible], [ProductAvailability], [ProductInventoried], [StockLevel], [LowStockLevel], [CategoryDetails], [Images], [PageTitle], [METAKeywords], [METADescription], [ProductCondition], [ProductURL], [RedirectOldURL], [ProductTaxCode], [ProductCustomFields]) VALUES (1837, N'P', N'DBP-476985', N'DBP-476985| 36" Urethane Finge', N'BCT Metcast;Wheelabrator', N'Picture is representative of product. 4" x 36" Urethane Finger Seal, 80 - 90 Duro w/ Spring Steel Insert', N'0', N'0', N'0', N'0', N'0', 0, 1, 1, 1, 0, N'0', N'0', N'Category Name: Cabinet Seals, Category Path: Cabinet & Material Handling/Cabinet Seals', N'Product Image File: Spring_Steel_Polyurethane_Fingers__48932.1602201765.1280.1280__96801.png, Product Image URL: http://durableblastparts.com/product_images/f/170/Spring_Steel_Polyurethane_Fingers__48932.1602201765.1280.1280__96801.png|Product Image File: DBP-FingerSeal__56295.1595262195.1280.1280__90502.1602201766.1280.1280__37393.jpg, Product Image URL: http://durableblastparts.com/product_images/c/663/DBP-FingerSeal__56295.1595262195.1280.1280__90502.1602201766.1280.1280__37393.jpg', N'BCT Metcast;Wheelabrator,DBP-476985 | 36" Urethane', N'BCT Metcast;Wheelabrator,DBP-680472 | 48" Urethane Finger Seal,4" x 48" Urethane Finger Seal, 80 - 90 Duro', N'4" x 36" Urethane Finger Seal, 80 - 90 Duro w/ spring steel insert', N'New', N'/dbp-476985-36-urethane-finger-seal-w-insert/', N'', N'', N'Vendor= sales@beltservice.com')
INSERT [dbo].[Product] ([ProductID], [ProductType], [Code], [Name], [Brand], [Description], [CostPrice], [RetailPrice], [SalePrice], [CalculatedPrice], [FixedShippingPrice], [FreeShipping], [AllowPurchases], [ProductVisible], [ProductAvailability], [ProductInventoried], [StockLevel], [LowStockLevel], [CategoryDetails], [Images], [PageTitle], [METAKeywords], [METADescription], [ProductCondition], [ProductURL], [RedirectOldURL], [ProductTaxCode], [ProductCustomFields]) VALUES (1838, N'P', N'DBP-731245A', N'DBP-731245A | Control Cage/35E', N'Wheelabrator', N'Picture is representative of product. Control Cage/35EZE 49 Deg Wheel MODEL: 35EZ DIA OF WHEEL: 26.00" CONTROL CAGE: 49 Machine Mfg: Wheelabrator', N'0', N'0', N'0', N'0', N'0', 0, 1, 1, 0, 0, N'0', N'0', N'Category Name: Wheel Internals, Category Path: Wheel Parts/Wheel Internals', N'Product Image File: 25EZControlCageGeneric_1__95915.1595424038.1280.1280__95209.jpg, Product Image URL: http://durableblastparts.com/product_images/w/551/25EZControlCageGeneric_1__95915.1595424038.1280.1280__95209.jpg|Product Image File: 25EZControlCageGeneric_2__90548.1595424038.1280.1280__81551.jpg, Product Image URL: http://durableblastparts.com/product_images/i/732/25EZControlCageGeneric_2__90548.1595424038.1280.1280__81551.jpg', N'Wheelabrator,DBP-731245A | Control Cage/35EZE 49 D', N'Wheelabrator,DBP-737718A | Control Cage/25EZE 49 Deg,,Control Cage/25EZE 49 Deg,Wheel MODEL: 25EZ,DIA OF WHEEL: 25.00",,CONTROL CAGE: 49,,Machine Mfg: Wheelabrator', N',Control Cage/35EZE 49 Deg,Wheel MODEL: 35EZ,DIA OF WHEEL: 26.00",,CONTROL CAGE: 49,,Machine Mfg: Wheelabrator', N'New', N'/dbp-731245a-control-cage-35eze-49-deg/', N'', N'', N'Vendor=jackie@astechblast.com;')
INSERT [dbo].[Product] ([ProductID], [ProductType], [Code], [Name], [Brand], [Description], [CostPrice], [RetailPrice], [SalePrice], [CalculatedPrice], [FixedShippingPrice], [FreeShipping], [AllowPurchases], [ProductVisible], [ProductAvailability], [ProductInventoried], [StockLevel], [LowStockLevel], [CategoryDetails], [Images], [PageTitle], [METAKeywords], [METADescription], [ProductCondition], [ProductURL], [RedirectOldURL], [ProductTaxCode], [ProductCustomFields]) VALUES (1839, N'P', N'DBP-427073', N'DBP-427073 | Tune Up Kit', N'Wheelabrator', N'Picture is representative of product. Tune Up Kit Part Numbers in Kits: 153260, 200900, 408000 Also (153877), 158063, 165790,045558 Wheel MODEL: 25M195 DIA OF WHEEL: 19.50" Blades / VANES: 8 Blades CONTROL CAGE: 70 ROTATION: BD Machine Mfg: Wheelabrator', N'310.5', N'0', N'0', N'388.5', N'0', 0, 1, 1, 0, 0, N'0', N'0', N'Category Name: Tune Up Kits, Category Path: Wheel Parts/Wheel Internals/Tune Up Kits', N'Product Image File: IMG_7811__48655.jpg, Product Image URL: http://durableblastparts.com/product_images/x/992/IMG_7811__48655.jpg', N'Wheelabrator,DBP-427073 | Tune Up Kit', N'Wheelabrator,DBP-449506 | Tune Up Kit,,Tune Up Kit ,Part Numbers in Kits: 444903, 444472, 414370, 158063, 165790, 448251,Wheel MODEL: 25RLM195,DIA OF WHEEL: 19.50",Blades / VANES: 8 Blades,CONTROL CAGE: 100,ROTATION: Clockwise,Machine Mfg: Wheelabrator', N'Wheelabrator,DBP-427073 | Tune Up Kit,,Tune Up Kit ,Part Numbers in Kits: 153260, 200900, 408000,153877,158063, 165790,045558,Wheel MODEL: 25M195,DIA OF WHEEL: 19.50",Blades / VANES: 8 Blades,CONTROL CAGE: 70,ROTATION: BD,Machine Mfg: Wheelabrator', N'New', N'/dbp-427073-tune-up-kit/', N'', N'', N'Vendor=jackie@astechblast.com;')
INSERT [dbo].[Product] ([ProductID], [ProductType], [Code], [Name], [Brand], [Description], [CostPrice], [RetailPrice], [SalePrice], [CalculatedPrice], [FixedShippingPrice], [FreeShipping], [AllowPurchases], [ProductVisible], [ProductAvailability], [ProductInventoried], [StockLevel], [LowStockLevel], [CategoryDetails], [Images], [PageTitle], [METAKeywords], [METADescription], [ProductCondition], [ProductURL], [RedirectOldURL], [ProductTaxCode], [ProductCustomFields]) VALUES (1840, N'P', N'DBP-408000', N'DBP- 408000| IMPELLER - M WHEE', N'Wheelabrator', N'Picture is representative of product. Complete M Wheel Tune Up Kit 408000 Also (153877) Wheel MODEL: 25M195 DIA OF WHEEL: 19.50" Blades / VANES: 8 Blades CONTROL CAGE: 70 ROTATION: BD Machine Mfg: Wheelabrator', N'0', N'0', N'0', N'0', N'0', 0, 1, 1, 0, 0, N'0', N'0', N'Category Name: Tune Up Kits, Category Path: Wheel Parts/Wheel Internals/Tune Up Kits', N'Product Image File: IMG_7822__44084.jpg, Product Image URL: http://durableblastparts.com/product_images/u/896/IMG_7822__44084.jpg|Product Image File: IMG_7811__96401.jpg, Product Image URL: http://durableblastparts.com/product_images/y/339/IMG_7811__96401.jpg', N'Wheelabrator,DBP-408000 Also (153877)', N'Wheelabrator,DBP-449506 | Tune Up Kit,,Tune Up Kit ,Part Numbers in Kits: 444903, 444472, 414370, 158063, 165790, 448251,Wheel MODEL: 25RLM195,DIA OF WHEEL: 19.50",Blades / VANES: 8 Blades,CONTROL CAGE: 100,ROTATION: Clockwise,Machine Mfg: Wheelabrator', N'Wheelabrator,DBP-408000 Also (153877) ,Part Numbers in Kits: 153260, 200900, 408000,153877,158063, 165790,045558,Wheel MODEL: 25M195,DIA OF WHEEL: 19.50",Blades / VANES: 8 Blades,CONTROL CAGE: 70,ROTATION: BD,Machine Mfg: Wheelabrator', N'New', N'/dbp-408000-impeller-m-wheel-also-153877/', N'', N'', N'Vendor=jackie@astechblast.com;')
INSERT [dbo].[Product] ([ProductID], [ProductType], [Code], [Name], [Brand], [Description], [CostPrice], [RetailPrice], [SalePrice], [CalculatedPrice], [FixedShippingPrice], [FreeShipping], [AllowPurchases], [ProductVisible], [ProductAvailability], [ProductInventoried], [StockLevel], [LowStockLevel], [CategoryDetails], [Images], [PageTitle], [METAKeywords], [METADescription], [ProductCondition], [ProductURL], [RedirectOldURL], [ProductTaxCode], [ProductCustomFields]) VALUES (1841, N'P', N'DBP-200900', N'DBP- 200900| CONTROL CAGE - M ', N'Wheelabrator', N'Picture is representative of product. Complete M Wheel Tune Up Kit Wheel MODEL: 25M195 DIA OF WHEEL: 19.50" Blades / VANES: 8 Blades CONTROL CAGE: 70 Deg Part #200900 ROTATION: BD Machine Mfg: Wheelabrator', N'0', N'0', N'0', N'0', N'0', 0, 1, 1, 0, 0, N'0', N'0', N'Category Name: Tune Up Kits, Category Path: Wheel Parts/Wheel Internals/Tune Up Kits', N'Product Image File: IMG_7811__59670.jpg, Product Image URL: http://durableblastparts.com/product_images/b/405/IMG_7811__59670.jpg|Product Image File: IMG_7821__92184.jpg, Product Image URL: http://durableblastparts.com/product_images/j/629/IMG_7821__92184.jpg', N'Wheelabrator DBP- 200900 | CONTROL CAGE - M WHEEL ', N'Wheelabrator,DBP-449506 | Tune Up Kit,,Tune Up Kit ,Part Numbers in Kits: 444903, 444472, 414370, 158063, 165790, 448251,Wheel MODEL: 25RLM195,DIA OF WHEEL: 19.50",Blades / VANES: 8 Blades,CONTROL CAGE: 100,ROTATION: Clockwise,Machine Mfg: Wheelabrator', N'Wheelabrator,DBP-408000 Also (153877) ,Part Numbers in Kits: 153260, 200900, 408000,153877,158063, 165790,045558,Wheel MODEL: 25M195,DIA OF WHEEL: 19.50",Blades / VANES: 8 Blades,CONTROL CAGE: 70,ROTATION: BD,Machine Mfg: Wheelabrator', N'New', N'/dbp-200900-control-cage-m-wheel-70-deg-sq-bd/', N'', N'', N'Vendor=jackie@astechblast.com;')
INSERT [dbo].[Product] ([ProductID], [ProductType], [Code], [Name], [Brand], [Description], [CostPrice], [RetailPrice], [SalePrice], [CalculatedPrice], [FixedShippingPrice], [FreeShipping], [AllowPurchases], [ProductVisible], [ProductAvailability], [ProductInventoried], [StockLevel], [LowStockLevel], [CategoryDetails], [Images], [PageTitle], [METAKeywords], [METADescription], [ProductCondition], [ProductURL], [RedirectOldURL], [ProductTaxCode], [ProductCustomFields]) VALUES (1842, N'D', N'E-Learn - P101', N'E-Learning Peening 101', N'', N'Peening 101 Course Launching CastExpo April 23rd 2022  Pre-order now or a 25% discvount to the normal prices after Cast Expo 22. Course materials include a complete understanding of the following:  What is Shot Peening Typical Industries Served Process Comparisons Controlable Elements  Media  How to choose Media type Media Size, Shape & Type Ferros Medias Non-Ferrous Medias Media Classification  Size Classification Shape Classification     Intinisity / Impact Energy / Kinetic Energy  Understanding Kinetic Energy Understanding Media Mass Wheel Blast Velocities Air Blast Velocities  Calculating Intinisity    Coverage  Percentage Coverage Checking Coverage Understanding Saturation Curves   Location / Masking      Shot Peening Specifications Process Parameters Review Quiz Certificate of Completetion   Link to EI Saturation Curve Calculation Sheets Link to EI Coverage Predictor Calculation Sheet Free Wheel & Air Blast Velocity Calculator Sheet Free Mechanical Inspection App to maintain controlable elements consistently on a monthly basis a $99.00 Value E-Learning Course on Wheel Blast Controllable Elements a $150.00 Value E-Learning Course on Air Blast Controlable Elements a $150.00 Value Access to our blog page Order Today!', N'0', N'0', N'0', N'0', N'0', 0, 1, 1, 1, 0, N'0', N'0', N'Category Name: Cabinet & Material Handling, Category Path: Cabinet & Material Handling|Category Name: E-Learning Courses, Category Path: E-Learning Courses|Category Name: Steel Flight Template, Category Path: Cabinet & Material Handling/Material Handling Templates/Steel Flight Template|Category Name: E-Learning Courses, Category Path: E-Learning Courses/E-Learning Courses', N'', N'E-Learning Peening 101', N'Mill Belt Template,<ol> <li>Add this product to the cart to download.</li> <li>Fill out template</li> <li>Email completed form to sales@durableblastparts.com&nbsp;</li> </ol>', N'E-Learning, Peening, Shot Peening, Aerospace Peening, Automotive Peening, Laser Peening', N'New', N'/e-learning-peening-101/', N'', N'', N'Vendor=sales@durableblastparts')
INSERT [dbo].[Product] ([ProductID], [ProductType], [Code], [Name], [Brand], [Description], [CostPrice], [RetailPrice], [SalePrice], [CalculatedPrice], [FixedShippingPrice], [FreeShipping], [AllowPurchases], [ProductVisible], [ProductAvailability], [ProductInventoried], [StockLevel], [LowStockLevel], [CategoryDetails], [Images], [PageTitle], [METAKeywords], [METADescription], [ProductCondition], [ProductURL], [RedirectOldURL], [ProductTaxCode], [ProductCustomFields]) VALUES (1843, N'P', N'2100-010-02S', N'2100-010-02S | Pop-Up Head Ste', N'Schmidt', N'Picture is representative of product. Pop-up head, stem seal, for 3 & 6 bag', N'93', N'0', N'0', N'124', N'0', 0, 1, 1, 0, 0, N'0', N'0', N'Category Name: Pot Parts, Category Path: Airblast Parts/Replacement Parts/Pot Parts', N'Product Image File: 2100-010_1__07520.1595518352.1280.1280__34683.jpg, Product Image URL: http://durableblastparts.com/product_images/e/519/2100-010_1__07520.1595518352.1280.1280__34683.jpg|Product Image File: image005__80075.jpg, Product Image URL: http://durableblastparts.com/product_images/f/930/image005__80075.jpg', N'Schmidt,2100-010-02S | Pop-Up Head Stem Seal', N'Schmidt,2100-010 | Pop-Up Head,Pop-up head, w/stem, for 3 & 6 bag', N'Schmidt,2100-010-02S | Pop-Up Head Stem Seal', N'New', N'/2100-010-02S-pop-up-head-stem-seal/', N'', N'', N'Vendor=Salesgroup@axxiommfg.co')
INSERT [dbo].[Product] ([ProductID], [ProductType], [Code], [Name], [Brand], [Description], [CostPrice], [RetailPrice], [SalePrice], [CalculatedPrice], [FixedShippingPrice], [FreeShipping], [AllowPurchases], [ProductVisible], [ProductAvailability], [ProductInventoried], [StockLevel], [LowStockLevel], [CategoryDetails], [Images], [PageTitle], [METAKeywords], [METADescription], [ProductCondition], [ProductURL], [RedirectOldURL], [ProductTaxCode], [ProductCustomFields]) VALUES (1844, N'P', N'LSTB-72', N'LSTB-72 | Rubber Reinforced Do', N'Viking', N'Priopartary Door design - No photo provided Reinforced Rubber Door Machine Model: LS 72', N'750', N'0', N'0', N'1250', N'0', 0, 1, 1, 0, 0, N'0', N'0', N'Category Name: Rubber Mill, Category Path: Cabinet & Material Handling/Tumblast Mill Components/Rubber Mill', N'', N'LSTB-72-rubber-reinforced-door-12/', N'Viking,DBP-V1500 | Rubber Mill Belt,,Rubber Mill Belt,Machine Model: V1500,DRAIN HOLE DIAMETER & SQ or ST Pattern: 5 Ply Belt w/ .3125 Drain Holes,', N'LSTB-72-rubber-reinforced-door-12/', N'New', N'/lstb-72-rubber-reinforced-door-12/', N'', N'', N'Vendor=efranke@bistaterubber.c')
SET IDENTITY_INSERT [dbo].[tbl_roles] ON 

INSERT [dbo].[tbl_roles] ([id], [name], [created_date], [created_by], [updated_date], [updated_by], [is_active], [is_deleted]) VALUES (1, N'Admin', CAST(0x0000AF020078B426 AS DateTime), N'Admin', CAST(0x0000AF020078B426 AS DateTime), N'Admin', 1, 0)
INSERT [dbo].[tbl_roles] ([id], [name], [created_date], [created_by], [updated_date], [updated_by], [is_active], [is_deleted]) VALUES (2, N'Player', CAST(0x0000AF020078C317 AS DateTime), N'Admin', CAST(0x0000AF020078C317 AS DateTime), N'Admin', 1, 0)
SET IDENTITY_INSERT [dbo].[tbl_roles] OFF
SET IDENTITY_INSERT [dbo].[tbl_user] ON 

INSERT [dbo].[tbl_user] ([id], [user_id], [user_name], [password], [email], [mobile], [roles], [created_date], [created_by], [updated_date], [updated_by], [is_active], [is_deleted], [city], [IPAdress]) VALUES (3, N'7428066620', N'Noor Alam', N'rfDdwrUTlvH3mwYk6J2khg==', N'86.nooralam@gmail.com', N'7428066620', N'2', CAST(0x0000AEFE0020927E AS DateTime), N'7428066620', NULL, NULL, 1, 0, N'Kanpur', N'47.9.3.144')
INSERT [dbo].[tbl_user] ([id], [user_id], [user_name], [password], [email], [mobile], [roles], [created_date], [created_by], [updated_date], [updated_by], [is_active], [is_deleted], [city], [IPAdress]) VALUES (4, N'7007123456', N'Zeeshan', N'Vv0rbtNjxK8KA3w8PB0fBw==', N'zeeshan@gmail.com', N'7007123456', N'2', CAST(0x0000AF0200D78FCE AS DateTime), N'7007123456', NULL, NULL, 1, 0, N'Delhi', N'47.15.6.85')
INSERT [dbo].[tbl_user] ([id], [user_id], [user_name], [password], [email], [mobile], [roles], [created_date], [created_by], [updated_date], [updated_by], [is_active], [is_deleted], [city], [IPAdress]) VALUES (5, N'9971590258', N'Abdul', N'Vv0rbtNjxK8KA3w8PB0fBw==', N'abdul.rub@gmail.com', N'9971590258', N'2', CAST(0x0000AF0200D7DA7B AS DateTime), N'9971590258', CAST(0x0000AF0300981527 AS DateTime), N'Abdul Rub', 1, 0, N'Fizy', N'103.95.81.52')
INSERT [dbo].[tbl_user] ([id], [user_id], [user_name], [password], [email], [mobile], [roles], [created_date], [created_by], [updated_date], [updated_by], [is_active], [is_deleted], [city], [IPAdress]) VALUES (6, N'7007112233', N'Afzal', N'Sdppy+aUbc5oCEEC1cUQcw==', N'afzal@gmail.com', N'7007112233', N'1', CAST(0x0000AF0200D88309 AS DateTime), N'7007112233', NULL, NULL, 1, 0, N'Kanpur', N'47.15.6.85')
INSERT [dbo].[tbl_user] ([id], [user_id], [user_name], [password], [email], [mobile], [roles], [created_date], [created_by], [updated_date], [updated_by], [is_active], [is_deleted], [city], [IPAdress]) VALUES (7, N'7007111222', N'Khan', N'zA0FoDwuo6euqzsuRhrFgA==', N'faiz@gmail.com', N'7007111222', N'2', CAST(0x0000AF030021FA1A AS DateTime), N'7007111222', NULL, NULL, 1, 0, N'Kanpur', N'103.46.203.60')
SET IDENTITY_INSERT [dbo].[tbl_user] OFF
SET IDENTITY_INSERT [dbo].[tbl_user_roles] ON 

INSERT [dbo].[tbl_user_roles] ([user_role_id], [user_id], [role_id], [created_date], [created_by], [updated_date], [updated_by], [is_active], [is_deleted]) VALUES (1, N'9971590258', 2, CAST(0x0000AF02007F7D3C AS DateTime), N'Admin', CAST(0x0000AF02007F7D3C AS DateTime), N'Admin', 1, 0)
INSERT [dbo].[tbl_user_roles] ([user_role_id], [user_id], [role_id], [created_date], [created_by], [updated_date], [updated_by], [is_active], [is_deleted]) VALUES (2, N'11224455', 1, CAST(0x0000AF02007FAE52 AS DateTime), N'Admin', CAST(0x0000AF02007FAE52 AS DateTime), N'Admin', 1, 0)
INSERT [dbo].[tbl_user_roles] ([user_role_id], [user_id], [role_id], [created_date], [created_by], [updated_date], [updated_by], [is_active], [is_deleted]) VALUES (3, N'7007108050', 2, CAST(0x0000AF02007FAE52 AS DateTime), N'Admin', CAST(0x0000AF02007FAE52 AS DateTime), N'Admin', 1, 0)
INSERT [dbo].[tbl_user_roles] ([user_role_id], [user_id], [role_id], [created_date], [created_by], [updated_date], [updated_by], [is_active], [is_deleted]) VALUES (4, N'7428066620', 2, CAST(0x0000AF02007FAE53 AS DateTime), N'Admin', CAST(0x0000AF02007FAE53 AS DateTime), N'Admin', 1, 0)
INSERT [dbo].[tbl_user_roles] ([user_role_id], [user_id], [role_id], [created_date], [created_by], [updated_date], [updated_by], [is_active], [is_deleted]) VALUES (5, N'7007123456', 2, CAST(0x0000AF0200E0E1E0 AS DateTime), N'Admin', CAST(0x0000AF0200E0E1E0 AS DateTime), N'Admin', 1, 0)
INSERT [dbo].[tbl_user_roles] ([user_role_id], [user_id], [role_id], [created_date], [created_by], [updated_date], [updated_by], [is_active], [is_deleted]) VALUES (6, N'7007112233', 1, CAST(0x0000AF0200E0E1E0 AS DateTime), N'Admin', CAST(0x0000AF0200E0E1E0 AS DateTime), N'Admin', 1, 0)
SET IDENTITY_INSERT [dbo].[tbl_user_roles] OFF
SET IDENTITY_INSERT [dbo].[tbl_user_token] ON 

INSERT [dbo].[tbl_user_token] ([id], [user_id], [token], [created_date], [created_by], [update_date], [updated_by], [is_active], [is_deleted]) VALUES (2, N'7428066620', N'rIh5BL/kNo+mOPBav8mNslYuLUQGD51asvRa8KXZCvwMaXFYzxzpVlWjRN4tSQIY', CAST(0x0000AEFE0020A4F8 AS DateTime), N'7428066620', NULL, NULL, 1, 0)
INSERT [dbo].[tbl_user_token] ([id], [user_id], [token], [created_date], [created_by], [update_date], [updated_by], [is_active], [is_deleted]) VALUES (4, N'9971590258', N'+hgWL55Gf7oLyWDWJJwExZTBDHZBHK8AltfGqzudFWbbQXk+vFFLnKPddqo9s4MY', CAST(0x0000AF0200DF8D52 AS DateTime), N'9971590258', NULL, NULL, 1, 0)
INSERT [dbo].[tbl_user_token] ([id], [user_id], [token], [created_date], [created_by], [update_date], [updated_by], [is_active], [is_deleted]) VALUES (5, N'7007123456', N'Mam7V0XZvLwDHS245baYbcKGXAgi8h8uDR/CxBZuglZqRJjduqq/zSCfUMgkualP', CAST(0x0000AF0200DFE7BE AS DateTime), N'7007123456', NULL, NULL, 1, 0)
INSERT [dbo].[tbl_user_token] ([id], [user_id], [token], [created_date], [created_by], [update_date], [updated_by], [is_active], [is_deleted]) VALUES (6, N'7007112233', N'Ydjca2I4rh+WzDvZbuHjRDIXRwiBjyvYNNdUtrOo99QD26IrsLK1MgX7nnJRsQS5', CAST(0x0000AF0200E01550 AS DateTime), N'7007112233', NULL, NULL, 1, 0)
SET IDENTITY_INSERT [dbo].[tbl_user_token] OFF
SET IDENTITY_INSERT [dbo].[tblGameCategory] ON 

INSERT [dbo].[tblGameCategory] ([GameCategoryId], [GameTypeId], [CategoryName], [bidRate], [isActive], [CreatedBy], [UpdatedBy], [UpdatedDate], [CreatedDate]) VALUES (7, 1, N'DOUBLE', 90, 1, N'Admin', N'Admin', CAST(0x0000AF0300A70A3D AS DateTime), CAST(0x0000AF0300A70A3D AS DateTime))
INSERT [dbo].[tblGameCategory] ([GameCategoryId], [GameTypeId], [CategoryName], [bidRate], [isActive], [CreatedBy], [UpdatedBy], [UpdatedDate], [CreatedDate]) VALUES (8, 1, N'HARAF', 90, 1, N'Admin', N'Admin', CAST(0x0000AF0300A70A3D AS DateTime), CAST(0x0000AF0300A70A3D AS DateTime))
INSERT [dbo].[tblGameCategory] ([GameCategoryId], [GameTypeId], [CategoryName], [bidRate], [isActive], [CreatedBy], [UpdatedBy], [UpdatedDate], [CreatedDate]) VALUES (9, 1, N'CROSSING', 90, 1, N'Admin', N'Admin', CAST(0x0000AF0300A70A3E AS DateTime), CAST(0x0000AF0300A70A3E AS DateTime))
INSERT [dbo].[tblGameCategory] ([GameCategoryId], [GameTypeId], [CategoryName], [bidRate], [isActive], [CreatedBy], [UpdatedBy], [UpdatedDate], [CreatedDate]) VALUES (10, 2, N'DOUBLE', 90, 1, N'Admin', N'Admin', CAST(0x0000AF0300A713B4 AS DateTime), CAST(0x0000AF0300A713B4 AS DateTime))
INSERT [dbo].[tblGameCategory] ([GameCategoryId], [GameTypeId], [CategoryName], [bidRate], [isActive], [CreatedBy], [UpdatedBy], [UpdatedDate], [CreatedDate]) VALUES (11, 2, N'HARAF', 90, 1, N'Admin', N'Admin', CAST(0x0000AF0300A713B4 AS DateTime), CAST(0x0000AF0300A713B4 AS DateTime))
INSERT [dbo].[tblGameCategory] ([GameCategoryId], [GameTypeId], [CategoryName], [bidRate], [isActive], [CreatedBy], [UpdatedBy], [UpdatedDate], [CreatedDate]) VALUES (12, 2, N'CROSSING', 90, 1, N'Admin', N'Admin', CAST(0x0000AF0300A713B5 AS DateTime), CAST(0x0000AF0300A713B5 AS DateTime))
INSERT [dbo].[tblGameCategory] ([GameCategoryId], [GameTypeId], [CategoryName], [bidRate], [isActive], [CreatedBy], [UpdatedBy], [UpdatedDate], [CreatedDate]) VALUES (13, 3, N'DOUBLE', 90, 1, N'Admin', N'Admin', CAST(0x0000AF0300A71C05 AS DateTime), CAST(0x0000AF0300A71C05 AS DateTime))
INSERT [dbo].[tblGameCategory] ([GameCategoryId], [GameTypeId], [CategoryName], [bidRate], [isActive], [CreatedBy], [UpdatedBy], [UpdatedDate], [CreatedDate]) VALUES (14, 3, N'HARAF', 90, 1, N'Admin', N'Admin', CAST(0x0000AF0300A71C05 AS DateTime), CAST(0x0000AF0300A71C05 AS DateTime))
INSERT [dbo].[tblGameCategory] ([GameCategoryId], [GameTypeId], [CategoryName], [bidRate], [isActive], [CreatedBy], [UpdatedBy], [UpdatedDate], [CreatedDate]) VALUES (15, 3, N'CROSSING', 90, 1, N'Admin', N'Admin', CAST(0x0000AF0300A71C05 AS DateTime), CAST(0x0000AF0300A71C05 AS DateTime))
SET IDENTITY_INSERT [dbo].[tblGameCategory] OFF
SET IDENTITY_INSERT [dbo].[tblGameSubCategory] ON 

INSERT [dbo].[tblGameSubCategory] ([GameSubCategoryId], [GameCategeryId], [SubCategoryName], [bidRate], [isActive]) VALUES (1, 7, N'Chart', 90, 1)
INSERT [dbo].[tblGameSubCategory] ([GameSubCategoryId], [GameCategeryId], [SubCategoryName], [bidRate], [isActive]) VALUES (2, 8, N'Andar Harup', 90, 1)
INSERT [dbo].[tblGameSubCategory] ([GameSubCategoryId], [GameCategeryId], [SubCategoryName], [bidRate], [isActive]) VALUES (3, 8, N'Bahar Harup', 90, 1)
INSERT [dbo].[tblGameSubCategory] ([GameSubCategoryId], [GameCategeryId], [SubCategoryName], [bidRate], [isActive]) VALUES (4, 9, N'With Jodi', 90, 1)
INSERT [dbo].[tblGameSubCategory] ([GameSubCategoryId], [GameCategeryId], [SubCategoryName], [bidRate], [isActive]) VALUES (5, 9, N'Without Jodi', 90, 1)
INSERT [dbo].[tblGameSubCategory] ([GameSubCategoryId], [GameCategeryId], [SubCategoryName], [bidRate], [isActive]) VALUES (6, 10, N'Chart', 90, 1)
INSERT [dbo].[tblGameSubCategory] ([GameSubCategoryId], [GameCategeryId], [SubCategoryName], [bidRate], [isActive]) VALUES (7, 11, N'Andar Harup', 90, 1)
INSERT [dbo].[tblGameSubCategory] ([GameSubCategoryId], [GameCategeryId], [SubCategoryName], [bidRate], [isActive]) VALUES (8, 11, N'Bahar Harup', 90, 1)
INSERT [dbo].[tblGameSubCategory] ([GameSubCategoryId], [GameCategeryId], [SubCategoryName], [bidRate], [isActive]) VALUES (9, 12, N'With Jodi', 90, 1)
INSERT [dbo].[tblGameSubCategory] ([GameSubCategoryId], [GameCategeryId], [SubCategoryName], [bidRate], [isActive]) VALUES (10, 12, N'Without Jodi', 90, 1)
INSERT [dbo].[tblGameSubCategory] ([GameSubCategoryId], [GameCategeryId], [SubCategoryName], [bidRate], [isActive]) VALUES (11, 13, N'Chart', 90, 1)
INSERT [dbo].[tblGameSubCategory] ([GameSubCategoryId], [GameCategeryId], [SubCategoryName], [bidRate], [isActive]) VALUES (12, 14, N'Andar Harup', 90, 1)
INSERT [dbo].[tblGameSubCategory] ([GameSubCategoryId], [GameCategeryId], [SubCategoryName], [bidRate], [isActive]) VALUES (13, 14, N'Bahar Harup', 90, 1)
INSERT [dbo].[tblGameSubCategory] ([GameSubCategoryId], [GameCategeryId], [SubCategoryName], [bidRate], [isActive]) VALUES (14, 15, N'With Jodi', 90, 1)
INSERT [dbo].[tblGameSubCategory] ([GameSubCategoryId], [GameCategeryId], [SubCategoryName], [bidRate], [isActive]) VALUES (15, 15, N'Without Jodi', 90, 1)
SET IDENTITY_INSERT [dbo].[tblGameSubCategory] OFF
SET IDENTITY_INSERT [dbo].[tblGameType] ON 

INSERT [dbo].[tblGameType] ([GameTypeId], [GameName], [StartDate], [EndDate], [isActive], [CreatedBy], [UpdatedBy], [CreatedDate], [updatedDate]) VALUES (1, N'Desawar', CAST(0x0000AF0200D29C77 AS DateTime), CAST(0x0000AF2A00D29C77 AS DateTime), 1, N'Admin', N'Admin', CAST(0x0000AF0200D29C77 AS DateTime), CAST(0x0000AF0200D29C77 AS DateTime))
INSERT [dbo].[tblGameType] ([GameTypeId], [GameName], [StartDate], [EndDate], [isActive], [CreatedBy], [UpdatedBy], [CreatedDate], [updatedDate]) VALUES (2, N'Faridabad', CAST(0x0000AF0300A6A8C8 AS DateTime), CAST(0x0000AF2B00A6A8C8 AS DateTime), 1, N'Admin', N'Admin', CAST(0x0000AF0300A6A8C8 AS DateTime), CAST(0x0000AF0300A6A8C8 AS DateTime))
INSERT [dbo].[tblGameType] ([GameTypeId], [GameName], [StartDate], [EndDate], [isActive], [CreatedBy], [UpdatedBy], [CreatedDate], [updatedDate]) VALUES (3, N'Kashipur', CAST(0x0000AF0300A6A8C8 AS DateTime), CAST(0x0000AF2B00A6A8C8 AS DateTime), 1, N'Admin', N'Admin', CAST(0x0000AF0300A6A8C8 AS DateTime), CAST(0x0000AF0300A6A8C8 AS DateTime))
SET IDENTITY_INSERT [dbo].[tblGameType] OFF
SET IDENTITY_INSERT [dbo].[Vendor] ON 

INSERT [dbo].[Vendor] ([VendorID], [VendorName], [VAddress], [City], [VState], [Zip], [ContactName], [ContactNumber], [ContactEmail], [PartTypeCategory], [PaymentTermsOffered], [ShippingNotes]) VALUES (1, N'Astech Inc', N'5512 Scotch Rd', N'Vassar', N'MI', N'48768', N'Jackie Magryta', N'800.327.8474', N'jackie@astechblast.com', N'Wheel, Cabinet Liners', N'Net 30 Days', N'UPS')
INSERT [dbo].[Vendor] ([VendorID], [VendorName], [VAddress], [City], [VState], [Zip], [ContactName], [ContactNumber], [ContactEmail], [PartTypeCategory], [PaymentTermsOffered], [ShippingNotes]) VALUES (2, N'Axxiom Manufacturing Inc', N'11927 South State Hwy 6', N'Fresno', N'TX', N'77545', N'Terry Hummel x 5212', N'281.431.0581', N'salesgroup@axxiommfg.com', N'Air Abrasive Blasting', N'Net 30 Days (not set up for Credit Card', N'Ship to Romac 1st')
INSERT [dbo].[Vendor] ([VendorID], [VendorName], [VAddress], [City], [VState], [Zip], [ContactName], [ContactNumber], [ContactEmail], [PartTypeCategory], [PaymentTermsOffered], [ShippingNotes]) VALUES (3, N'Pleatco LLC', N'11201 Ampere Court', N'Louisville', N'KY', N'40299', N'Dainel Hockersmith', N'205.417.6597', N'DHockersmith@pleatco.com', N'Dust Collector Filters', N'Credit Card', N'UPS')
INSERT [dbo].[Vendor] ([VendorID], [VendorName], [VAddress], [City], [VState], [Zip], [ContactName], [ContactNumber], [ContactEmail], [PartTypeCategory], [PaymentTermsOffered], [ShippingNotes]) VALUES (4, N'Ross Manufacturing Company, Inc.', N'9415 Highway 54 West', N'Brownsville', N'TN', N'38012', N'Patrick Craig', N'731.772.0567', N'patrick@rossmfgco.com', N'Elevator Pulleys & Hardware', N'Credit Card', N'UPS')
INSERT [dbo].[Vendor] ([VendorID], [VendorName], [VAddress], [City], [VState], [Zip], [ContactName], [ContactNumber], [ContactEmail], [PartTypeCategory], [PaymentTermsOffered], [ShippingNotes]) VALUES (5, N'Beltservice Corporation', N'4143 Rider Trail North', N'St. Louis', N'MO', N'63045', N'Sherry Arbogast', N'314-715-3112', N'sales@beltservice.com.', N'Finger Seals', N'Credit Card @ 2.5%', N'UPS')
INSERT [dbo].[Vendor] ([VendorID], [VendorName], [VAddress], [City], [VState], [Zip], [ContactName], [ContactNumber], [ContactEmail], [PartTypeCategory], [PaymentTermsOffered], [ShippingNotes]) VALUES (6, N'Bag House America', N'2415 East Camelback Road, Ste. 700', N'Phoenix', N'AZ', N'85016', N'Vicky Waterhouse', N'888-261-3538', N'Sales@baghouseamerica.com', N'Dust Collector Components', N'Credit Card', N'UPS')
INSERT [dbo].[Vendor] ([VendorID], [VendorName], [VAddress], [City], [VState], [Zip], [ContactName], [ContactNumber], [ContactEmail], [PartTypeCategory], [PaymentTermsOffered], [ShippingNotes]) VALUES (7, N'Air Filters Inc.', N'8282 Warren Road', N'Houston', N'TX', N'77040', N'Noel Nichols', N'713.896.8901', N'noel.nichols@airfilterusa.com', N'Dust Collector After Filters', N'Credit Card', N'UPS')
INSERT [dbo].[Vendor] ([VendorID], [VendorName], [VAddress], [City], [VState], [Zip], [ContactName], [ContactNumber], [ContactEmail], [PartTypeCategory], [PaymentTermsOffered], [ShippingNotes]) VALUES (8, N'Faulkner Industrial', N'294 Merrywood Ln', N'Sterrett', N'AL', N'35147', N'Clint Jewell', N'205.672.8550', N'clint@faulknerindustrial.com', N'Dust Collector Leak Dust', N'Credit Card', N'They Perfer Fedex?')
INSERT [dbo].[Vendor] ([VendorID], [VendorName], [VAddress], [City], [VState], [Zip], [ContactName], [ContactNumber], [ContactEmail], [PartTypeCategory], [PaymentTermsOffered], [ShippingNotes]) VALUES (9, N'Smith Equipment and Supply Company', N'3825 Maine Ave', N'Lakeland', N'FL', N'33801', N'Amber Smith', N'863.665.4904', N'smith@smith-equipment.com', N'Waffer Brushes', N'Credit Card', N'LTL')
INSERT [dbo].[Vendor] ([VendorID], [VendorName], [VAddress], [City], [VState], [Zip], [ContactName], [ContactNumber], [ContactEmail], [PartTypeCategory], [PaymentTermsOffered], [ShippingNotes]) VALUES (10, N'McMaster Carr - ATL', N'1901 Riverside Pkwy', N'Douglasville', N'GA', N'30135', N'Sales', N'404.346.7000', N'atl.sales@mcmaster.com', N'Miscellaneous Components (DC)', N'Credit Card', N'UPS')
INSERT [dbo].[Vendor] ([VendorID], [VendorName], [VAddress], [City], [VState], [Zip], [ContactName], [ContactNumber], [ContactEmail], [PartTypeCategory], [PaymentTermsOffered], [ShippingNotes]) VALUES (11, N'Nelson Stud Welding, Inc.', N'7900 West Ridge Road', N'Elyria', N'OH', N'44036-2019', N'Chris Shannon', N'440.329.0400', N'Chris.Shannon@sbdinc.com', N'Cabinet Liner Studs', N'Credit Card', N'UPS')
INSERT [dbo].[Vendor] ([VendorID], [VendorName], [VAddress], [City], [VState], [Zip], [ContactName], [ContactNumber], [ContactEmail], [PartTypeCategory], [PaymentTermsOffered], [ShippingNotes]) VALUES (12, N'B&D Technologies', N'2010 Cobb International Blvd NW Suite E', N'Kennesaw', N'GA', N'30152-4364', N'John Thornton', N'770.792.2922', N'team4@bdindustrial.com', N'sew Eurodrives', N'Credit Card', N'UPS')
INSERT [dbo].[Vendor] ([VendorID], [VendorName], [VAddress], [City], [VState], [Zip], [ContactName], [ContactNumber], [ContactEmail], [PartTypeCategory], [PaymentTermsOffered], [ShippingNotes]) VALUES (13, N'CIRCLE R INDUSTRIES, INC.', N'530 Curtis Ray Rd.', N'Midlothian', N'TX', N'76065', N'Jean Volini', N'(972) 775-15', N'jean@circlerindustries.com', N'Hanger Bearings', N'Credit Card', N'UPS')
INSERT [dbo].[Vendor] ([VendorID], [VendorName], [VAddress], [City], [VState], [Zip], [ContactName], [ContactNumber], [ContactEmail], [PartTypeCategory], [PaymentTermsOffered], [ShippingNotes]) VALUES (14, N'Blast Services Inc', N'995 Cable Rd', N'Waleska', N'GA', N'30188', N'Joe Craig', N'706.570.7692', N'joe.craig@blastservicesinc.com', N'Elevator belt Assemblies', N'Credit Card', N'UPS')
INSERT [dbo].[Vendor] ([VendorID], [VendorName], [VAddress], [City], [VState], [Zip], [ContactName], [ContactNumber], [ContactEmail], [PartTypeCategory], [PaymentTermsOffered], [ShippingNotes]) VALUES (15, N'Bi-State Rubber', N'1611 Headland Dr. PO Box 608', N'Fenton', N'MO', N'63026', N'Eric Frankie', N'(636) 349-23', N'efranke@bistaterubber.com', N'Split Mill Belts', N'Net 30 Days', N'LTL')
INSERT [dbo].[Vendor] ([VendorID], [VendorName], [VAddress], [City], [VState], [Zip], [ContactName], [ContactNumber], [ContactEmail], [PartTypeCategory], [PaymentTermsOffered], [ShippingNotes]) VALUES (16, N'Blastec, Inc.', N'4965 Atlanta Hwy', N'Alpharetta', N'GA', N'30004', N'Sales', N'800-241-3016', N'contact@blastec.com', N'Blastec Parts & Shot Savers', N'Net 30 Days', N'UPS')
INSERT [dbo].[Vendor] ([VendorID], [VendorName], [VAddress], [City], [VState], [Zip], [ContactName], [ContactNumber], [ContactEmail], [PartTypeCategory], [PaymentTermsOffered], [ShippingNotes]) VALUES (17, N'4B Components Ltd.', N'625 Erie Avenue', N'Morton', N'IL', N'61550', N'Tim Williams', N'309-698-5611', N'twilliams@go4b.com', N'Elevator Belt Splice Kits', N'Credit Card', N'UPS')
INSERT [dbo].[Vendor] ([VendorID], [VendorName], [VAddress], [City], [VState], [Zip], [ContactName], [ContactNumber], [ContactEmail], [PartTypeCategory], [PaymentTermsOffered], [ShippingNotes]) VALUES (18, N'U.S. Hose & Coupling', N'3400 Town Point Drive, Suite 130', N'Kennesaw', N'GA', N'30144', N'Brandon Hughes', N'800-344-0150', N'bhughes@ushoseco.com', N'Abrasive Feed Hose', N'Credit Card', N'LTL')
INSERT [dbo].[Vendor] ([VendorID], [VendorName], [VAddress], [City], [VState], [Zip], [ContactName], [ContactNumber], [ContactEmail], [PartTypeCategory], [PaymentTermsOffered], [ShippingNotes]) VALUES (19, N'Plan B Services & Solutions, LLC', N'25 N. Lawton Ave.', N'Tulsa', N'OK', N'74127', N'Amanda Cato', N'918-806-2327', N'accounting@planbtulsa.com', N'Goff Parts & Valves', N'Net 30 Days', N'UPS')
SET IDENTITY_INSERT [dbo].[Vendor] OFF
ALTER TABLE [dbo].[Product] ADD  CONSTRAINT [DF_Product_FreeShipping]  DEFAULT ((0)) FOR [FreeShipping]
GO
ALTER TABLE [dbo].[Product] ADD  CONSTRAINT [DF_Product_AllowPurchases]  DEFAULT ((0)) FOR [AllowPurchases]
GO
ALTER TABLE [dbo].[Product] ADD  CONSTRAINT [DF_Product_ProductVisible]  DEFAULT ((0)) FOR [ProductVisible]
GO
ALTER TABLE [dbo].[Product] ADD  CONSTRAINT [DF_Product_ProductAvailability]  DEFAULT ((0)) FOR [ProductAvailability]
GO
ALTER TABLE [dbo].[Product] ADD  CONSTRAINT [DF_Product_ProductInventoried]  DEFAULT ((0)) FOR [ProductInventoried]
GO
ALTER TABLE [dbo].[tbl_menu] ADD  CONSTRAINT [DF_tbl_menu_is_active]  DEFAULT ((1)) FOR [is_active]
GO
ALTER TABLE [dbo].[tbl_menu] ADD  CONSTRAINT [DF_tbl_menu_is_deleted]  DEFAULT ((0)) FOR [is_deleted]
GO
ALTER TABLE [dbo].[tbl_module] ADD  CONSTRAINT [DF_tbl_module_IsActive]  DEFAULT ((1)) FOR [is_active]
GO
ALTER TABLE [dbo].[tbl_module] ADD  CONSTRAINT [DF_tbl_module_IsDeleted]  DEFAULT ((0)) FOR [is_deleted]
GO
ALTER TABLE [dbo].[tbl_payment_mode] ADD  CONSTRAINT [DF_tbl_payment_mode_IsActive]  DEFAULT ((1)) FOR [is_active]
GO
ALTER TABLE [dbo].[tbl_payment_mode] ADD  CONSTRAINT [DF_tbl_payment_mode_IsDeleted]  DEFAULT ((0)) FOR [is_deleted]
GO
ALTER TABLE [dbo].[tbl_role_menu] ADD  CONSTRAINT [DF_tbl_role_menu_is_active]  DEFAULT ((1)) FOR [is_active]
GO
ALTER TABLE [dbo].[tbl_role_menu] ADD  CONSTRAINT [DF_tbl_role_menu_is_deleted]  DEFAULT ((0)) FOR [is_deleted]
GO
ALTER TABLE [dbo].[tbl_roles] ADD  CONSTRAINT [DF_tbl_Roles_IsActive]  DEFAULT ((1)) FOR [is_active]
GO
ALTER TABLE [dbo].[tbl_roles] ADD  CONSTRAINT [DF_tbl_Roles_IsDeleted]  DEFAULT ((0)) FOR [is_deleted]
GO
ALTER TABLE [dbo].[tbl_user] ADD  CONSTRAINT [DF_tbl_User_IsActive]  DEFAULT ((1)) FOR [is_active]
GO
ALTER TABLE [dbo].[tbl_user] ADD  CONSTRAINT [DF_tbl_User_IsDeleted]  DEFAULT ((0)) FOR [is_deleted]
GO
ALTER TABLE [dbo].[tbl_user_roles] ADD  CONSTRAINT [DF_tbl_user_roles_IsActive]  DEFAULT ((1)) FOR [is_active]
GO
ALTER TABLE [dbo].[tbl_user_roles] ADD  CONSTRAINT [DF_tbl_user_roles_IsDeleted]  DEFAULT ((0)) FOR [is_deleted]
GO
ALTER TABLE [dbo].[tbl_user_token] ADD  CONSTRAINT [DF_tbl_Token_IsActive]  DEFAULT ((1)) FOR [is_active]
GO
ALTER TABLE [dbo].[tbl_user_token] ADD  CONSTRAINT [DF_tbl_Token_IsDeleted]  DEFAULT ((0)) FOR [is_deleted]
GO
ALTER TABLE [dbo].[tblUserAmountDeposit] ADD  CONSTRAINT [DF_tblUserAmountDeposit_isApproved]  DEFAULT ((0)) FOR [isApproved]
GO
