USE [Ready2Enjoy]
GO
/****** Object:  User [abdulrub08_SQLLogin_1]    Script Date: 10/5/2022 10:56:46 AM ******/
CREATE USER [abdulrub08_SQLLogin_1] FOR LOGIN [abdulrub08_SQLLogin_1] WITH DEFAULT_SCHEMA=[dbo]
GO
ALTER ROLE [db_owner] ADD MEMBER [abdulrub08_SQLLogin_1]
GO
/****** Object:  Schema [abdulrub08_SQLLogin_1]    Script Date: 10/5/2022 10:56:47 AM ******/
CREATE SCHEMA [abdulrub08_SQLLogin_1]
GO
/****** Object:  StoredProcedure [dbo].[InsertProductInfo]    Script Date: 10/5/2022 10:56:47 AM ******/
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
/****** Object:  StoredProcedure [dbo].[InsertVendorInfo]    Script Date: 10/5/2022 10:56:48 AM ******/
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
/****** Object:  StoredProcedure [dbo].[sp_generate_inserts]    Script Date: 10/5/2022 10:56:48 AM ******/
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
/****** Object:  StoredProcedure [dbo].[usp_change_password]    Script Date: 10/5/2022 10:56:48 AM ******/
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
/****** Object:  StoredProcedure [dbo].[usp_delete_module]    Script Date: 10/5/2022 10:56:48 AM ******/
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
/****** Object:  StoredProcedure [dbo].[usp_delete_user]    Script Date: 10/5/2022 10:56:48 AM ******/
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
/****** Object:  StoredProcedure [dbo].[usp_export_users]    Script Date: 10/5/2022 10:56:48 AM ******/
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
/****** Object:  StoredProcedure [dbo].[usp_insert_module]    Script Date: 10/5/2022 10:56:48 AM ******/
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
/****** Object:  StoredProcedure [dbo].[usp_insert_qutation]    Script Date: 10/5/2022 10:56:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create proc [dbo].[usp_insert_qutation]
@ProductID int,
@CustomerEmailID varchar(100),
@CustomerID int,
@DefaultPrice bigint,
@Stock int,
@LowStock int,
@UserName varchar(100),
--@CreateBy varchar(200),
@Code int output,
@Message varchar(max) output
as
begin
	if exists(select * from [dbo].[CustomerTransactions] where ProductID=@ProductID and CustomerEmailID=@CustomerEmailID)
	begin
		set @Code = 204
		set @message = 'Qutation already exists'
	end
	else
	begin
	insert into [dbo].[CustomerTransactions](ProductID,CustomerEmailID,DefaultPrice,Stock,LowStock,CustomerID,IsActive,CreatedDate,UpdatedDate,CreatedBy,UpdatedBy)
		values(@ProductID,@CustomerEmailID,@DefaultPrice,@Stock,@LowStock,@CustomerID,1,GETDATE(),getdate(),@UserName,@UserName)
		
		set @Code = 202
		set @message = 'User created'
	end
end





GO
/****** Object:  StoredProcedure [dbo].[usp_insert_token]    Script Date: 10/5/2022 10:56:48 AM ******/
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
/****** Object:  StoredProcedure [dbo].[usp_insert_user]    Script Date: 10/5/2022 10:56:48 AM ******/
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
/****** Object:  StoredProcedure [dbo].[usp_insert_vendor_reply]    Script Date: 10/5/2022 10:56:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE proc [dbo].[usp_insert_vendor_reply]
@ProductID int,
@VendorID int,
@CustomerEmailID  varchar(100),
@CustomerID int,
@DefaultPrice bigint,
@Stock int,
@Remark varchar(500),
@CreatedBy varchar(500),

@Code int output,
@Message varchar(max) output,
@VendorTransactionID int output

as
begin
	if exists(select * from [dbo].[VendorTransactions] where VendorID=@VendorID and CustomerEmailID=@CustomerEmailID)
	begin
		set @Code = 204
		set @message = 'Already Sent Qutation'
		set @VendorTransactionID=0
	end
	else
	begin
	insert into [dbo].[VendorTransactions](ProductID,VendorID,CustomerEmailID,CustomerID,DefaultPrice,Stock,Remark,IsActive,CreatedDate,UpdatedDate,CreatedBy,UpdatedBy)
		values(@ProductID,(Select top(1) VendorID from Vendor where ContactEmail=@CreatedBy),@CustomerEmailID,@CustomerID,@DefaultPrice,@Stock,@Remark,1,GETDATE(),getdate(),@CreatedBy,@CreatedBy)
		set @VendorTransactionID=SCOPE_IDENTITY()
		set @Code = 202
		set @message = 'Qutation Sent'
	end
end
GO
/****** Object:  StoredProcedure [dbo].[usp_logoff]    Script Date: 10/5/2022 10:56:48 AM ******/
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
/****** Object:  StoredProcedure [dbo].[usp_reset_password]    Script Date: 10/5/2022 10:56:48 AM ******/
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
/****** Object:  StoredProcedure [dbo].[usp_select__all_vendor_Email]    Script Date: 10/5/2022 10:56:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[usp_select__all_vendor_Email]
as
begin
	select ContactEmail,VendorName from Vendor
end
GO
/****** Object:  StoredProcedure [dbo].[usp_select__customer_transaction]    Script Date: 10/5/2022 10:56:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[usp_select__customer_transaction]
@ID int
as
begin
	select CustomerEmailID,CustomerID from CustomerTransactions where CustomerID=@ID
end







GO
/****** Object:  StoredProcedure [dbo].[usp_select_All_user]    Script Date: 10/5/2022 10:56:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

Create PROCEDURE [dbo].[usp_select_All_user]
 AS 
 BEGIN
 Select * from tbl_user
 END
GO
/****** Object:  StoredProcedure [dbo].[usp_select_gamecatbyid]    Script Date: 10/5/2022 10:56:48 AM ******/
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
/****** Object:  StoredProcedure [dbo].[usp_select_GameSubCategorybyId]    Script Date: 10/5/2022 10:56:48 AM ******/
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
/****** Object:  StoredProcedure [dbo].[usp_select_gametype]    Script Date: 10/5/2022 10:56:48 AM ******/
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
/****** Object:  StoredProcedure [dbo].[usp_select_grid]    Script Date: 10/5/2022 10:56:48 AM ******/
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
/****** Object:  StoredProcedure [dbo].[usp_select_modules]    Script Date: 10/5/2022 10:56:48 AM ******/
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
/****** Object:  StoredProcedure [dbo].[usp_select_onlineuser]    Script Date: 10/5/2022 10:56:48 AM ******/
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
/****** Object:  StoredProcedure [dbo].[usp_select_rolebyuserid]    Script Date: 10/5/2022 10:56:48 AM ******/
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
/****** Object:  StoredProcedure [dbo].[usp_select_tokenbyuserid]    Script Date: 10/5/2022 10:56:48 AM ******/
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
/****** Object:  StoredProcedure [dbo].[usp_select_user]    Script Date: 10/5/2022 10:56:48 AM ******/
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
		email,
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
/****** Object:  StoredProcedure [dbo].[usp_select_userbyid]    Script Date: 10/5/2022 10:56:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*
	exec usp_select_userbyuserid 'dfsdfsdf', '1'
*/

CREATE PROCEDURE [dbo].[usp_select_userbyid]
	@Id nvarchar(50)
AS
BEGIN
	SET NOCOUNT ON;

	SELECT * FROM tbl_User
	WHERE [id] = @Id
	and Is_Active = 1
	and Is_Deleted = 0
END











GO
/****** Object:  StoredProcedure [dbo].[usp_select_userbyuserid]    Script Date: 10/5/2022 10:56:48 AM ******/
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
/****** Object:  StoredProcedure [dbo].[usp_select_vendor_by_email]    Script Date: 10/5/2022 10:56:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create proc [dbo].[usp_select_vendor_by_email]
@vendorEmail varchar(100)

as
begin
	
Select top(1) VendorID from Vendor where ContactEmail=@vendorEmail
end
GO
/****** Object:  StoredProcedure [dbo].[usp_update_module]    Script Date: 10/5/2022 10:56:48 AM ******/
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
/****** Object:  StoredProcedure [dbo].[usp_update_user]    Script Date: 10/5/2022 10:56:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[usp_update_user]
@Id bigint,
@EmailID varchar(200),
@City varchar(200),
@Name varchar(200),
@UpdateBy varchar(100),
@Code int output,
@Message varchar(max) output
as
begin
	if exists(select * from [dbo].[tbl_user] where id = @Id)
	begin
		update [dbo].[tbl_user]
		set user_name = @Name,email=@EmailID,updated_by=@UpdateBy,updated_date=getdate(),City=@City
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
/****** Object:  StoredProcedure [dbo].[usp_user_deposit_amount]    Script Date: 10/5/2022 10:56:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[usp_user_deposit_amount]
@Id bigint = NULL,
@UserId varchar(200) = NULL,
@DepositAmount money = NULL,
@PaymentScreenShot varchar(max) = NULL,
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
		--Declare @Screenshot varchar(max)=cast(N'' as xml).value('xs:base64Binary(sql:variable("@PaymentScreenShot"))', 'varbinary(max)');
		--Declare @Screenshot varchar(max)=Convert(varbinary(max), @PaymentScreenShot)
			insert into [dbo].[tblUserAmountDeposit]([UserId],DepositAmount,PaymentScreenShot,PaymentModeId,[Status],ApprovedAmount,Remarks, isActive,isDeleted, CreatedDate,CreatedBy,UpdatedDate, UpdatedBy,FileExt)
			values(@UserId, @DepositAmount, 
			Convert(varbinary(max), @PaymentScreenShot),
			 @PaymentModeId, 'Pending', @ApprovedAmount, @Remarks, @isActive, @isDeleted, getdate(), @UserId, getdate(), @UserId,@Status)
			set @Code = 202
			set @message = 'User Amount Deposited'
		END
	 IF @StatementType = 'Select'
        BEGIN
			SELECT Id, UserId, (Select [user_name] from tbl_user where [id] = tblUserAmountDeposit.UserId) as UserName, DepositAmount, PaymentScreenShot, PaymentModeId,FileExt,			
			PaymentModeId = (select payment_name from [dbo].[tbl_payment_mode] where id = tblUserAmountDeposit.PaymentModeId),
			[Status],ApprovedAmount,Remarks, isActive,isDeleted, CreatedDate,
			CreatedBy =  (Select [user_name] from tbl_user where [id] = tblUserAmountDeposit.UserId),
			UpdatedDate, 
			UpdatedBy =(Select [user_name] from tbl_user where [id]  = tblUserAmountDeposit.UserId)
            FROM  tblUserAmountDeposit order by CreatedDate desc
        END
		IF @StatementType = 'Recent'
        BEGIN
            SELECT Top 5 Id, UserId, (Select [user_name] from tbl_user where [id] = @UserId) as UserName, DepositAmount, PaymentScreenShot, PaymentModeId,
			FileExt,			
			--PaymentModeId = (select payment_name from [dbo].[tbl_payment_mode] where id = @PaymentModeId),
			[Status],ApprovedAmount,Remarks, isActive,isDeleted, CreatedDate,
			CreatedBy =  (Select [user_name] from tbl_user where [id] = @UserId),
			UpdatedDate, 
			UpdatedBy =(Select [user_name] from tbl_user where [id] = @UserId)
            FROM  tblUserAmountDeposit where UserId = @UserId order by CreatedDate desc
        END
		IF @StatementType = 'Select By UserId'
        BEGIN
            SELECT Id, UserId,  UserName = (Select [user_name] from tbl_user where [id] = @UserId), DepositAmount, PaymentScreenShot, PaymentModeId,FileExt,			
			PaymentModeId = (select payment_name from [dbo].[tbl_payment_mode] where id = @PaymentModeId),
			[Status],ApprovedAmount,Remarks, isActive,isDeleted, CreatedDate,
			CreatedBy =  (Select [user_name] from tbl_user where [id] = @UserId),
			UpdatedDate, 
			UpdatedBy =(Select [user_name] from tbl_user where [id]  = @UserId)
            FROM  tblUserAmountDeposit where UserId = @UserId order by CreatedDate desc
        END
		IF @StatementType = 'Select By RecordId'
        BEGIN
            SELECT Id, UserId,  UserName = (Select [user_name] from tbl_user where [id] = tblUserAmountDeposit.UserId), DepositAmount, PaymentScreenShot, PaymentModeId,FileExt,			
			PaymentModeId = (select payment_name from [dbo].[tbl_payment_mode] where id = @PaymentModeId),
			[Status],ApprovedAmount,Remarks, isActive,isDeleted, CreatedDate,
			CreatedBy =  (Select [user_name] from tbl_user where [id] = tblUserAmountDeposit.UserId),
			UpdatedDate, 
			UpdatedBy =(Select [user_name] from tbl_user where [id]  = tblUserAmountDeposit.UserId)
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
/****** Object:  StoredProcedure [dbo].[usp_user_deposit_amount_approvedby_admin]    Script Date: 10/5/2022 10:56:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE proc [dbo].[usp_user_deposit_amount_approvedby_admin]
@Id bigint = NULL,
@UserId varchar(200) = NULL,
@ApprovedAmount money= NULL,
@Remarks varchar(500)= NULL,
@Status varchar(10)= NULL,
@AdminUserId bigint,
@Code int output,
@Message varchar(max) output
AS
BEGIN
	UPDATE tblUserAmountDeposit
	SET     
		[Status] = @Status,
		ApprovedAmount = @ApprovedAmount,
		isApproved = (CASE WHEN @Status ='Approved' THEN 1  ELSE 0 END),
		Remarks = @Remarks,			
		UpdatedDate = getdate(),
		UpdatedBy= @AdminUserId
	WHERE  Id = @Id	and UserId = @UserId
	
	insert into [dbo].[tblTransactionHistory]([UserId],TransactionAmount,TransactionType,ActionId,ActionName, CreatedDate,CreatedBy)
	values(@UserId, @ApprovedAmount, 'Credit' ,@Id, 'Deposit',  getdate(), @UserId)
					
								
	set @Code = 205
	set @message = 'Deposit Amount '+@Status+' by Admin'
END


 






GO
/****** Object:  StoredProcedure [dbo].[usp_user_game_bidding_list]    Script Date: 10/5/2022 10:56:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[usp_user_game_bidding_list] 
@UserId bigint,
@GameTypeId bigint

As
Begin
	
	Select  a.BetNumber, a.BetAmount ,a. CreatedDate ,b.CategoryName
	from tblBettingDetails a 
	inner join tblGameSelectionDetails b ON a.GameSelectionId = b.GameSelectionId  
	Where (a.UserId = @UserId) and (b.GameSelectionId IN (Select GameSelectionId from tblGameSelectionDetails Where GameTypeId= @GameTypeId)) order by a.createdDate

	  
End

GO
/****** Object:  StoredProcedure [dbo].[usp_user_game_played]    Script Date: 10/5/2022 10:56:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create proc [dbo].[usp_user_game_played] 
@UserId bigint
As
Begin
	
	Select GameSelectionId, (Select [user_name] from tbl_user where id = @UserId) as UserName,
		GametypeName, CategoryName, GameSubCategoryName, Amount, CreatedDate
	from  [dbo].[tblGameSelectionDetails] Where UserId = @UserId
End

GO
/****** Object:  StoredProcedure [dbo].[usp_user_game_played_details]    Script Date: 10/5/2022 10:56:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create proc [dbo].[usp_user_game_played_details] 
@GameSelectionId bigint
As
Begin
	
	Select BetNumber, BetAmount
	from  [dbo].[tblBettingDetails] Where GameSelectionId = @GameSelectionId
End

GO
/****** Object:  StoredProcedure [dbo].[usp_user_game_selection_submit]    Script Date: 10/5/2022 10:56:48 AM ******/
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
		SELECT tab1.string,tab2.string, tab1.GameSelectionId, tab1.UserId, 1, 0, getdate(),tab1.UserId, getdate(), tab1.UserId from (
			SELECT A.GameSelectionId,   ROW_NUMBER() over (partition by GameSelectionId order by GameSelectionId ) row_num,
			Split.a.value('.', 'VARCHAR(100)') AS String, UserId
			FROM  
			(SELECT GameSelectionId,  
					CAST ('<M>' + REPLACE(BetNumbers, ',', '</M><M>') + '</M>' AS XML) AS String , UserId 
					FROM  tblGameSelectionDetails) AS A CROSS APPLY String.nodes ('/M') AS Split(a)
			) tab1
		INNER JOIN
			(SELECT A.GameSelectionId, ROW_NUMBER() over (partition by GameSelectionId order by GameSelectionId ) row_num,
					Split.a.value('.', 'VARCHAR(100)') AS String  , UserId
			FROM  (SELECT GameSelectionId,  
				CAST ('<M>' + REPLACE(BetAmounts, ',', '</M><M>') + '</M>' AS XML) AS String  ,UserId
				FROM  tblGameSelectionDetails) AS A CROSS APPLY String.nodes ('/M') AS Split(a)

			) tab2

		on tab1.GameSelectionId=tab2.GameSelectionId and tab2.row_num= tab1.row_num and tab1.GameSelectionId = @LASTID
	 
	 
	insert into [dbo].[tblTransactionHistory]([UserId],TransactionAmount,TransactionType,ActionId,ActionName, CreatedDate,CreatedBy)
	values(@UserId, @Amount, 'Debit' ,@LASTID, 'PlayGame',  getdate(), @UserId)
					

END



GO
/****** Object:  StoredProcedure [dbo].[usp_user_Total_Amount]    Script Date: 10/5/2022 10:56:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[usp_user_Total_Amount] 
@UserId bigint
As
Begin
	declare @creditamt as decimal
	declare @debitamt as decimal
	declare @totamt as decimal
	Select @creditamt = ISNULL(Sum(TransactionAmount) ,0) from tblTransactionHistory Where UserId = @UserId and TransactionType='Credit'

	Select  @debitamt = ISNULL(Sum(TransactionAmount) ,0) from tblTransactionHistory Where UserId = @UserId and TransactionType='Debit'

	--Select @creditamt, @debitamt
	IF @creditamt >  @debitamt
	Begin
		Set @totamt = @creditamt - @debitamt
	End
	Else
	Begin
		Set @totamt = @debitamt - @creditamt
	End
	Select @totamt as 'Total Amount' 
End

GO
/****** Object:  StoredProcedure [dbo].[usp_user_win_declare]    Script Date: 10/5/2022 10:56:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_user_win_declare] 
@GameTypeId bigint = NULL,
@GameTypeName varchar(50)= NULL, 
@WinningNumber int = NULL,
@AdminUserId bigint = NULL,
@Code int output,
@Message varchar(max) output
AS Begin

begin Try
 Begin TRAN 

	Declare @number as int, @dividend as int, @reminder as int
	Set @number = @WinningNumber
	Set @dividend = @number/10;
	Set @reminder = @number%10;
	Select @dividend, @reminder

	Update tblWinningNumberDeclare set isActive = 0

	Insert Into tblWinningNumberDeclare (GameTypeId,GameTypeName, WinningNumber, CreatedDate, isActive, UpdatedDate)
	Values(@GameTypeId, @GameTypeName, @number, getdate(), 1, getdate())

	Update tblUserWinningDetails set isActive = 0

	Insert Into tblUserWinningDetails (UserId, GameBettingId, BettingAmount, BettingNumber, GameTypeId, GameTypeName, GameCategoryId, CategoryName,GameSubCategoryId, GameSubCategoryName, WinAmount, WinDate, isActive, UpdatedDate) 
	Select a.UserId as UserId, a.GameBettingId as GameBettingId, a.BetAmount, a.BetNumber , 
	b.GameTypeId, b.GameTypeName, b.GameCategoryId, b.CategoryName, b.GameSubCategoryId, b.GameSubCategoryName, a.BetAmount * 90, getdate(), 1, getdate()
	from tblBettingDetails a 
	inner join tblGameSelectionDetails b ON a.GameSelectionId = b.GameSelectionId 
	Where a.BetNumber = @number and (a.isActive =1) and (b.GameTypeName = @GameTypeName)
	Union
	Select a.UserId as UserId, a.GameBettingId as GameBettingId, a.BetAmount, a.BetNumber , 
	b.GameTypeId, b.GameTypeName, b.GameCategoryId, b.CategoryName, b.GameSubCategoryId, b.GameSubCategoryName, a.BetAmount * 9, getdate(), 1, getdate()  
	from tblBettingDetails a  
	inner join tblGameSelectionDetails b ON a.GameSelectionId = b.GameSelectionId  
	Where (a.BetNumber = @dividend) and (a.isActive =1) and (b.GameSelectionId IN (Select GameSelectionId from tblGameSelectionDetails Where GameSubCategoryName= 'Andar Harup')) and (b.GameTypeName = @GameTypeName)
	Union
	Select a.UserId as UserId, a.GameBettingId as GameBettingId, a.BetAmount, a.BetNumber , 
	b.GameTypeId, b.GameTypeName, b.GameCategoryId, b.CategoryName, b.GameSubCategoryId, b.GameSubCategoryName, a.BetAmount * 9, getdate(), 1, getdate()  
	from tblBettingDetails a 
	inner join tblGameSelectionDetails b ON a.GameSelectionId = b.GameSelectionId  
	Where (a.BetNumber = @reminder) and (a.isActive =1) and (b.GameSelectionId IN (Select GameSelectionId from tblGameSelectionDetails Where GameSubCategoryName= 'Bahar Harup')) and (b.GameTypeName = @GameTypeName)
	

	insert into [dbo].[tblTransactionHistory]([UserId],TransactionAmount,TransactionType,ActionId,ActionName, CreatedDate,CreatedBy)
	Select UserId, WinAmount, 'Credit' ,WinningId, 'Win',  getdate(), UserId 
	From tblUserWinningDetails Where isActive =1 

	Update tblBettingDetails Set isActive = 0 
	set @Code = 205
	set @message = 'Win Number Declared Successfully'

	Commit Tran
 End try
 begin
 Catch
   ROLLBACK TRAN
end catch

End
GO
/****** Object:  StoredProcedure [dbo].[usp_user_winning_amount]    Script Date: 10/5/2022 10:56:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE proc [dbo].[usp_user_winning_amount]
@Id bigint = NULL,
@UserId varchar(200) = NULL,
@GameTypeId as bigint = NULL, 
@GameTypeName as varchar(50) = NULL,
@GameCategoryId as bigint = NULL,
@CategoryName as varchar(50) = NULL,
@GameSubCategoryId  as bigint = NULL, 
@GameSubCategoryName as varchar(50) = NULL,  
@NumberType as varchar(50) = NULL, 
@WinningAmount as money = NULL, 
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
			INSERT INTO [dbo].[tblWinningDetails]([UserId],[GameTypeId],[GameTypeName],[GameCategoryId],[CategoryName]
			,[GameSubCategoryId],[GameSubCategoryName],[NumberType],[WinningAmount],[Remarks],[isActive],[isDeleted],[CreatedDate],[CreatedBy],[UpdatedDate],[UpdatedBy])
			VALUES (@UserId, @GameTypeId, @GameTypeName, @GameCategoryId, @CategoryName, @GameSubCategoryId, @GameSubCategoryName, @NumberType, @WinningAmount
			,@Remarks, 1, 0, getdate(), @UserId, getdate(), @UserId)

			DECLARE @LASTID as bigint

			Set @LASTID = @@IDENTITY

			insert into [dbo].[tblTransactionHistory]([UserId],TransactionAmount,TransactionType,ActionId,ActionName, CreatedDate,CreatedBy)
			values(@UserId, @WinningAmount, 'Credit' ,@LASTID, 'Win',  getdate(), @UserId)

			set @Code = 202
			set @message = 'User Winning Amount Addedd Successfully'
		END
	 IF @StatementType = 'Select'
        BEGIN
            SELECT Id, UserId,(Select [user_name] from tbl_user where [id] = @UserId) as UserName,GameTypeId, GameTypeName,GameCategoryId ,CategoryName,			
			GameSubCategoryId, GameSubCategoryName,NumberType, WinningAmount,Remarks, isActive,isDeleted, CreatedDate,
			CreatedBy =  (Select [user_name] from tbl_user where [id] = @UserId),
			UpdatedDate, 
			UpdatedBy =(Select [user_name] from tbl_user where [id] = @UserId)
            FROM  tblWinningDetails  order by CreatedDate desc
        END
		IF @StatementType = 'Select By UserId'
        BEGIN
            SELECT Id, UserId,(Select [user_name] from tbl_user where [id] = @UserId) as UserName,GameTypeId, GameTypeName,GameCategoryId ,CategoryName,			
			GameSubCategoryId, GameSubCategoryName,NumberType, WinningAmount,Remarks, isActive,isDeleted, CreatedDate,
			CreatedBy =  (Select [user_name] from tbl_user where [id] = @UserId),
			UpdatedDate, 
			UpdatedBy =(Select [user_name] from tbl_user where [id] = @UserId)
            FROM  tblWinningDetails where UserId = @UserId order by CreatedDate desc
        END
		IF @StatementType = 'Select By RecordId'
        BEGIN
            SELECT Id, UserId,(Select [user_name] from tbl_user where [id] = tblWinningDetails.UserId) as UserName,GameTypeId, GameTypeName,GameCategoryId ,CategoryName,			
			GameSubCategoryId, GameSubCategoryName,NumberType,  WinningAmount,Remarks, isActive,isDeleted, CreatedDate,
			CreatedBy =  (Select [user_name] from tbl_user where [id] = tblWinningDetails.UserId),
			UpdatedDate, 
			UpdatedBy =(Select [user_name] from tbl_user where [id] = tblWinningDetails.UserId)
            FROM  tblWinningDetails where Id = @Id order by CreatedDate desc
        END
	IF @StatementType = 'Update'
        BEGIN
			IF exists(select * from [dbo].[tblWinningDetails] where Id = @Id)
				BEGIN
					UPDATE tblWinningDetails
					SET     UserId = @UserId,
							GameTypeId = @GameTypeId,
							GameTypeName = @GameTypeName,
							GameCategoryId = @GameCategoryId,
							CategoryName = @CategoryName,
							GameSubCategoryId = @GameSubCategoryId,
							GameSubCategoryName= @GameSubCategoryName,
							NumberType= @NumberType,
						    WinningAmount = @WinningAmount,						    				   
						    Remarks = @Remarks,
						    isActive = @isActive,       
						    isDeleted = @isDeleted,
						    UpdatedDate = getdate(),
						    UpdatedBy= @UserId
					        WHERE  Id = @Id

					UPDATE tblTransactionHistory
					SET     UserId = @UserId,
							TransactionAmount = @WinningAmount							
						    WHERE  ActionId = @Id and ActionName = 'Win'
					--insert into [dbo].[tblWinningDetails]([UserId],TransactionAmount,TransactionType,ActionId,ActionName, CreatedDate,CreatedBy)
					--values(@UserId, @ApprovedAmount, 'Debit' ,@Id, 'User Withdraw Amount Approved',  getdate(), @UserId)
					set @Code = 205
					set @message = 'Win Amount Module updated.'
				END
			ELSE
				BEGIN
					set @Code = 201
					set @message = 'Module does not exists.'
				END
        END
     ELSE IF @StatementType = 'Delete'
        BEGIN
            DELETE FROM tblWinningDetails
            WHERE  Id = @Id

			set @Code = 207
			set @message = 'Win Amount deleted'
        END
	
END


GO
/****** Object:  StoredProcedure [dbo].[usp_user_withdraw_amount]    Script Date: 10/5/2022 10:56:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[usp_user_withdraw_amount]
@Id bigint = NULL,
@UserId varchar(200) = NULL,
@RequestedAmount money = NULL,
@MobileNoForPayment varchar(50) = NULL,
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
			insert into [dbo].[tblUserWithdrawDetails](UserId, RequestedAmount,MobileNoForPayment, [Status], PaymentModeId, GameTypeId,  GameSubTypeId, Remarks, isActive,isDeleted, CreatedDate,CreatedBy,UpdatedDate, UpdatedBy)
			values (@UserId, @RequestedAmount, @MobileNoForPayment, @Status , @PaymentModeId, @GameTypeId, @GameSubTypeId, '', @isActive, @isDeleted, getdate(), @UserId, getdate(), @UserId)
			set @Code = 202
			set @message = 'Amount is requested succesfully for withdraw'
		END
	 IF @StatementType = 'Select'
        BEGIN
            SELECT Id, UserId, UserName = (Select [user_name] from tbl_user where [id] = @UserId), RequestedAmount, MobileNoForPayment, PaymentModeId,			
			PaymentModeId = (select payment_name from [dbo].[tbl_payment_mode] where id = tblUserWithdrawDetails.PaymentModeId),
			[Status],ApprovedAmount,Remarks, isActive,isDeleted, CreatedDate,
			CreatedBy =  (select [user_name] from [dbo].[tbl_user] where id = tblUserWithdrawDetails.UserId),
			UpdatedDate, 
			UpdatedBy =(select [user_name] from [dbo].[tbl_user] where id = tblUserWithdrawDetails.UserId)
            FROM  tblUserWithdrawDetails order by CreatedDate desc
        END
	IF @StatementType = 'Recent'
        BEGIN
            SELECT Top 5 Id, UserId,UserName = (Select [user_name] from tbl_user where [id] = @UserId), RequestedAmount,MobileNoForPayment, PaymentModeId,			
			PaymentModeId = (select payment_name from [dbo].[tbl_payment_mode] where id = tblUserWithdrawDetails.PaymentModeId),
			[Status],ApprovedAmount,Remarks, isActive,isDeleted, CreatedDate,
			CreatedBy =  (select [user_name] from [dbo].[tbl_user] where id = tblUserWithdrawDetails.UserId),
			UpdatedDate, 
			UpdatedBy =(select [user_name] from [dbo].[tbl_user] where id = tblUserWithdrawDetails.UserId)
            FROM  tblUserWithdrawDetails where UserId = @UserId order by CreatedDate desc
        END
	IF @StatementType = 'Select By UserId'
        BEGIN
            SELECT Id, UserId,UserName = (Select [user_name] from tbl_user where [id] = @UserId), RequestedAmount,MobileNoForPayment, PaymentModeId,			
			PaymentModeId = (select payment_name from [dbo].[tbl_payment_mode] where id = tblUserWithdrawDetails.PaymentModeId),
			[Status],ApprovedAmount,Remarks, isActive,isDeleted, CreatedDate,
			CreatedBy =  (select [user_name] from [dbo].[tbl_user] where id = tblUserWithdrawDetails.UserId),
			UpdatedDate, 
			UpdatedBy =(select [user_name] from [dbo].[tbl_user] where id = tblUserWithdrawDetails.UserId)
            FROM  tblUserWithdrawDetails where UserId = @UserId order by CreatedDate desc
        END
	IF @StatementType = 'Select By RecordId'
        BEGIN
            SELECT Id, UserId,UserName = (Select [user_name] from tbl_user where [id] = @UserId), RequestedAmount,MobileNoForPayment, PaymentModeId,			
			PaymentModeId = (select payment_name from [dbo].[tbl_payment_mode] where id = tblUserWithdrawDetails.PaymentModeId),
			[Status],ApprovedAmount,Remarks, isActive,isDeleted, CreatedDate,
			CreatedBy =  (select [user_name] from [dbo].[tbl_user] where id = tblUserWithdrawDetails.UserId),
			UpdatedDate, 
			UpdatedBy =(select [user_name] from [dbo].[tbl_user] where id = tblUserWithdrawDetails.UserId)
            FROM  tblUserWithdrawDetails where Id = @Id
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
/****** Object:  StoredProcedure [dbo].[usp_user_withdraw_amount_approvedby_admin]    Script Date: 10/5/2022 10:56:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[usp_user_withdraw_amount_approvedby_admin]
@Id bigint = NULL,
@UserId varchar(200) = NULL,
@ApprovedAmount money= NULL,
@Remarks varchar(500)= NULL,
@AdminUserId bigint,
@Code int output,
@Message varchar(max) output
AS
BEGIN
	UPDATE tblUserWithdrawDetails
	SET     
		[Status] = 'Approved',
		ApprovedAmount = @ApprovedAmount,
		isApproved = 1,
		Remarks = @Remarks,			
		UpdatedDate = getdate(),
		UpdatedBy= @AdminUserId
	WHERE  Id = @Id	and UserId = @UserId
	
	insert into [dbo].[tblTransactionHistory]([UserId],TransactionAmount,TransactionType,ActionId,ActionName, CreatedDate,CreatedBy)
	values(@UserId, @ApprovedAmount, 'Debit' ,@Id, 'Withdraw',  getdate(), @UserId)
					
								
	set @Code = 205
	set @message = 'Withdraw Amount Approved by Admin'
END


 





GO
/****** Object:  StoredProcedure [dbo].[usp_verify_policy]    Script Date: 10/5/2022 10:56:48 AM ******/
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
/****** Object:  StoredProcedure [dbo].[usp_win_declare_history]    Script Date: 10/5/2022 10:56:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_win_declare_history] 
@GameTypeId bigint
AS Begin

Select GameTypeId, GameTypeName, WinningNumber, CreatedDate from tblWinningNumberDeclare Where GameTypeId=@GameTypeId

End
GO
/****** Object:  UserDefinedFunction [dbo].[SplitString]    Script Date: 10/5/2022 10:56:48 AM ******/
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
/****** Object:  Table [dbo].[CustomerTransactions]    Script Date: 10/5/2022 10:56:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[CustomerTransactions](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[ProductID] [int] NULL,
	[CustomerEmailID] [varchar](100) NULL,
	[DefaultPrice] [bigint] NULL,
	[Stock] [int] NOT NULL,
	[LowStock] [int] NOT NULL,
	[CustomerID] [int] NULL,
	[IsActive] [bit] NULL,
	[CreatedDate] [date] NULL,
	[UpdatedDate] [date] NOT NULL,
	[CreatedBy] [varchar](100) NULL,
	[UpdatedBy] [varchar](100) NOT NULL,
 CONSTRAINT [PK_CustomerTransactions] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Product]    Script Date: 10/5/2022 10:56:48 AM ******/
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
/****** Object:  Table [dbo].[tbl_menu]    Script Date: 10/5/2022 10:56:48 AM ******/
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
/****** Object:  Table [dbo].[tbl_module]    Script Date: 10/5/2022 10:56:48 AM ******/
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
/****** Object:  Table [dbo].[tbl_payment_mode]    Script Date: 10/5/2022 10:56:48 AM ******/
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
/****** Object:  Table [dbo].[tbl_role_menu]    Script Date: 10/5/2022 10:56:48 AM ******/
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
/****** Object:  Table [dbo].[tbl_roles]    Script Date: 10/5/2022 10:56:48 AM ******/
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
/****** Object:  Table [dbo].[tbl_user]    Script Date: 10/5/2022 10:56:48 AM ******/
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
/****** Object:  Table [dbo].[tbl_user_roles]    Script Date: 10/5/2022 10:56:48 AM ******/
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
/****** Object:  Table [dbo].[tbl_user_token]    Script Date: 10/5/2022 10:56:48 AM ******/
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
/****** Object:  Table [dbo].[tblBettingDetails]    Script Date: 10/5/2022 10:56:48 AM ******/
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
/****** Object:  Table [dbo].[tblGameCategory]    Script Date: 10/5/2022 10:56:48 AM ******/
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
/****** Object:  Table [dbo].[tblGameSelectionDetails]    Script Date: 10/5/2022 10:56:48 AM ******/
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
/****** Object:  Table [dbo].[tblGameSubCategory]    Script Date: 10/5/2022 10:56:48 AM ******/
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
/****** Object:  Table [dbo].[tblGameType]    Script Date: 10/5/2022 10:56:48 AM ******/
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
/****** Object:  Table [dbo].[tblTransactionHistory]    Script Date: 10/5/2022 10:56:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblTransactionHistory](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[UserId] [bigint] NOT NULL,
	[TransactionAmount] [money] NOT NULL,
	[TransactionType] [varchar](50) NULL,
	[ActionId] [bigint] NULL,
	[ActionName] [varchar](100) NULL,
	[CreatedDate] [datetime] NULL,
	[CreatedBy] [bigint] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblUserAmountDeposit]    Script Date: 10/5/2022 10:56:48 AM ******/
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
	[UpdatedBy] [bigint] NULL,
	[FileExt] [varchar](5) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblUserMaster]    Script Date: 10/5/2022 10:56:48 AM ******/
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
/****** Object:  Table [dbo].[tblUserWinningDetails]    Script Date: 10/5/2022 10:56:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblUserWinningDetails](
	[WinningId] [bigint] IDENTITY(1,1) NOT NULL,
	[UserId] [bigint] NULL,
	[GameBettingId] [bigint] NULL,
	[BettingAmount] [money] NULL,
	[BettingNumber] [int] NULL,
	[GameTypeId] [bigint] NULL,
	[GameTypeName] [varchar](50) NULL,
	[GameCategoryId] [bigint] NULL,
	[CategoryName] [varchar](50) NULL,
	[GameSubCategoryId] [bigint] NULL,
	[GameSubCategoryName] [varchar](50) NULL,
	[WinAmount] [money] NULL,
	[WinDate] [datetime] NULL,
	[isActive] [bit] NULL,
	[UpdatedDate] [datetime] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblUserWithdrawDetails]    Script Date: 10/5/2022 10:56:48 AM ******/
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
	[MobileNoForPayment] [varchar](50) NULL,
	[Status] [varchar](10) NULL,
	[ApprovedAmount] [money] NULL,
	[isApproved] [bit] NULL,
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
/****** Object:  Table [dbo].[tblWinningDetails]    Script Date: 10/5/2022 10:56:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblWinningDetails](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[UserId] [bigint] NULL,
	[GameTypeId] [bigint] NULL,
	[GameTypeName] [varchar](50) NULL,
	[GameCategoryId] [bigint] NULL,
	[CategoryName] [varchar](50) NULL,
	[GameSubCategoryId] [bigint] NULL,
	[GameSubCategoryName] [varchar](50) NULL,
	[NumberType] [varchar](50) NULL,
	[WinningAmount] [money] NULL,
	[Remarks] [varchar](500) NULL,
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
/****** Object:  Table [dbo].[tblWinningNumberDeclare]    Script Date: 10/5/2022 10:56:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblWinningNumberDeclare](
	[Id] [bigint] NULL,
	[GameTypeId] [bigint] NULL,
	[GameTypeName] [varchar](50) NULL,
	[GameCategoryId] [bigint] NULL,
	[CategoryName] [varchar](50) NULL,
	[GameSubCategoryId] [bigint] NULL,
	[GameSubCategoryName] [varchar](50) NULL,
	[WinningNumber] [int] NULL,
	[CreatedDate] [datetime] NULL,
	[isActive] [bit] NULL,
	[UpdatedDate] [datetime] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Vendor]    Script Date: 10/5/2022 10:56:48 AM ******/
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
/****** Object:  Table [dbo].[VendorTransactions]    Script Date: 10/5/2022 10:56:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[VendorTransactions](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[ProductID] [int] NULL,
	[VendorID] [int] NOT NULL,
	[CustomerEmailID] [varchar](100) NULL,
	[CustomerID] [int] NULL,
	[DefaultPrice] [bigint] NULL,
	[Stock] [int] NOT NULL,
	[Remark] [varchar](500) NULL,
	[IsActive] [bit] NULL,
	[CreatedDate] [date] NULL,
	[UpdatedDate] [date] NOT NULL,
	[CreatedBy] [varchar](100) NULL,
	[UpdatedBy] [varchar](100) NOT NULL,
 CONSTRAINT [PK_VendorTransactions] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
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
ALTER TABLE [dbo].[tblUserWithdrawDetails] ADD  CONSTRAINT [DF_tblUserWithdrawDetails_isApproved]  DEFAULT ((0)) FOR [isApproved]
GO
