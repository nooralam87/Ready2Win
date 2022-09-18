USE [Ready2Enjoy]
GO
/****** Object:  UserDefinedTableType [dbo].[utt_report_column]    Script Date: 4/3/2022 11:40:53 AM ******/
CREATE TYPE [dbo].[utt_report_column] AS TABLE(
	[column_name] [varchar](255) NULL,
	[data_type] [varchar](50) NULL,
	[display_name] [varchar](255) NULL,
	[order_by] [bit] NULL
)
GO
/****** Object:  StoredProcedure [dbo].[sp_generate_inserts]    Script Date: 4/3/2022 11:40:53 AM ******/
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
/****** Object:  StoredProcedure [dbo].[usp_change_password]    Script Date: 4/3/2022 11:40:53 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[usp_change_password]
@UserId varchar(50),
@Password varchar(255),
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
		set @Message = 'Password changed.' 
	end
	else
	begin
		set @Code = 201
		set @Message = 'User not found.' 
	end
end




GO
/****** Object:  StoredProcedure [dbo].[usp_delete_module]    Script Date: 4/3/2022 11:40:53 AM ******/
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
/****** Object:  StoredProcedure [dbo].[usp_delete_user]    Script Date: 4/3/2022 11:40:53 AM ******/
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
/****** Object:  StoredProcedure [dbo].[usp_export_users]    Script Date: 4/3/2022 11:40:53 AM ******/
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
/****** Object:  StoredProcedure [dbo].[usp_insert_module]    Script Date: 4/3/2022 11:40:53 AM ******/
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
/****** Object:  StoredProcedure [dbo].[usp_insert_token]    Script Date: 4/3/2022 11:40:53 AM ******/
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
/****** Object:  StoredProcedure [dbo].[usp_insert_user]    Script Date: 4/3/2022 11:40:53 AM ******/
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
/****** Object:  StoredProcedure [dbo].[usp_logoff]    Script Date: 4/3/2022 11:40:53 AM ******/
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
/****** Object:  StoredProcedure [dbo].[usp_reset_password]    Script Date: 4/3/2022 11:40:53 AM ******/
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
/****** Object:  StoredProcedure [dbo].[usp_select_gamecatbyid]    Script Date: 4/3/2022 11:40:53 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create proc [dbo].[usp_select_gamecatbyid]
@GameTypeId bigint
as
begin
	select *
	from tblGameCategory where GameTypeId=@GameTypeId
	and is_active=1 and is_deleted=0
end




GO
/****** Object:  StoredProcedure [dbo].[usp_select_GameSubCategorybyId]    Script Date: 4/3/2022 11:40:53 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create proc [dbo].[usp_select_GameSubCategorybyId]
@GameCategeryId bigint
as
begin
	select *
	from tblGameSubCategory where GameCategeryId=@GameCategeryId
	and is_active=1 and is_deleted=0
end




GO
/****** Object:  StoredProcedure [dbo].[usp_select_gametype]    Script Date: 4/3/2022 11:40:53 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[usp_select_gametype]
as
begin
	select *
	from tblGameType where is_active=1 and is_deleted=0
end




GO
/****** Object:  StoredProcedure [dbo].[usp_select_grid]    Script Date: 4/3/2022 11:40:53 AM ******/
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
/****** Object:  StoredProcedure [dbo].[usp_select_modules]    Script Date: 4/3/2022 11:40:53 AM ******/
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
/****** Object:  StoredProcedure [dbo].[usp_select_onlineuser]    Script Date: 4/3/2022 11:40:53 AM ******/
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
/****** Object:  StoredProcedure [dbo].[usp_select_rolebyuserid]    Script Date: 4/3/2022 11:40:53 AM ******/
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
	where [user_id] = @UserId
end




GO
/****** Object:  StoredProcedure [dbo].[usp_select_tokenbyuserid]    Script Date: 4/3/2022 11:40:53 AM ******/
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
/****** Object:  StoredProcedure [dbo].[usp_select_user]    Script Date: 4/3/2022 11:40:53 AM ******/
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
/****** Object:  StoredProcedure [dbo].[usp_select_userbyuserid]    Script Date: 4/3/2022 11:40:53 AM ******/
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
/****** Object:  StoredProcedure [dbo].[usp_update_module]    Script Date: 4/3/2022 11:40:53 AM ******/
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
/****** Object:  StoredProcedure [dbo].[usp_verify_policy]    Script Date: 4/3/2022 11:40:53 AM ******/
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
/****** Object:  UserDefinedFunction [dbo].[getwhereclauseforfilter]    Script Date: 4/3/2022 11:40:53 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[getwhereclauseforfilter] 
(
	@ColumnParams nvarchar(max)
)
RETURNS nvarchar(max)
AS
BEGIN
	declare @filters table(split_value varchar(max))

	insert into @filters
	select * from dbo.SplitString('product:Reinstate Audit report,Reinstate Audit report,Surrender Audit report;template_id:22',';')

	return '';
END





GO
/****** Object:  UserDefinedFunction [dbo].[SplitString]    Script Date: 4/3/2022 11:40:53 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[SplitString]
(
      @Input NVARCHAR(MAX),
      @Character CHAR(1)
)
RETURNS @Output TABLE ([value] NVARCHAR(1000))
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
           
            INSERT INTO @Output([value])
            SELECT SUBSTRING(@Input, @StartIndex, @EndIndex - 1)
           
            SET @Input = SUBSTRING(@Input, @EndIndex + 1, LEN(@Input))
      END
 
      RETURN
END




GO
/****** Object:  Table [dbo].[tbl_menu]    Script Date: 4/3/2022 11:40:53 AM ******/
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
/****** Object:  Table [dbo].[tbl_module]    Script Date: 4/3/2022 11:40:53 AM ******/
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
/****** Object:  Table [dbo].[tbl_payment_mode]    Script Date: 4/3/2022 11:40:53 AM ******/
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
/****** Object:  Table [dbo].[tbl_role_menu]    Script Date: 4/3/2022 11:40:53 AM ******/
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
/****** Object:  Table [dbo].[tbl_roles]    Script Date: 4/3/2022 11:40:53 AM ******/
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
/****** Object:  Table [dbo].[tbl_user]    Script Date: 4/3/2022 11:40:53 AM ******/
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
/****** Object:  Table [dbo].[tbl_user_account]    Script Date: 4/3/2022 11:40:53 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING OFF
GO
CREATE TABLE [dbo].[tbl_user_account](
	[created_date] [datetime] NOT NULL,
	[created_by] [varchar](200) NOT NULL,
	[updated_date] [datetime] NULL,
	[updated_by] [varchar](200) NULL,
	[is_active] [bit] NOT NULL,
	[is_deleted] [bit] NOT NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tbl_user_amount_deposit]    Script Date: 4/3/2022 11:40:53 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tbl_user_amount_deposit](
	[id] [bigint] IDENTITY(1,1) NOT NULL,
	[user_id] [bigint] NOT NULL,
	[user_amount] [money] NULL,
	[screeb_shot] [image] NOT NULL,
	[payment_mode_id] [bigint] NULL,
	[status] [bit] NOT NULL,
	[user_approve_amount] [money] NULL,
	[created_date] [datetime] NOT NULL,
	[created_by] [varchar](200) NOT NULL,
	[updated_date] [datetime] NULL,
	[updated_by] [varchar](200) NULL,
	[is_active] [bit] NOT NULL,
	[is_deleted] [bit] NOT NULL,
 CONSTRAINT [PK_tbl_user_amount_deposit] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tbl_user_roles]    Script Date: 4/3/2022 11:40:53 AM ******/
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
/****** Object:  Table [dbo].[tbl_user_token]    Script Date: 4/3/2022 11:40:53 AM ******/
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
/****** Object:  Table [dbo].[tbl_user_transaction]    Script Date: 4/3/2022 11:40:53 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING OFF
GO
CREATE TABLE [dbo].[tbl_user_transaction](
	[created_date] [datetime] NOT NULL,
	[created_by] [varchar](200) NOT NULL,
	[updated_date] [datetime] NULL,
	[updated_by] [varchar](200) NULL,
	[is_active] [bit] NOT NULL,
	[is_deleted] [bit] NOT NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tbl_user_winning_amount]    Script Date: 4/3/2022 11:40:53 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING OFF
GO
CREATE TABLE [dbo].[tbl_user_winning_amount](
	[created_date] [datetime] NOT NULL,
	[created_by] [varchar](200) NOT NULL,
	[updated_date] [datetime] NULL,
	[updated_by] [varchar](200) NULL,
	[is_active] [bit] NOT NULL,
	[is_deleted] [bit] NOT NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblGameCategory]    Script Date: 4/3/2022 11:40:53 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblGameCategory](
	[GameCategeryId] [bigint] IDENTITY(1,1) NOT NULL,
	[GameTypeId] [bigint] NOT NULL,
	[CategoryName] [varchar](50) NULL,
	[bidRate] [money] NOT NULL,
	[created_date] [datetime] NOT NULL,
	[created_by] [varchar](200) NOT NULL,
	[updated_date] [datetime] NULL,
	[updated_by] [varchar](200) NULL,
	[is_active] [bit] NOT NULL,
	[is_deleted] [bit] NOT NULL,
 CONSTRAINT [PK_tblGameCategory] PRIMARY KEY CLUSTERED 
(
	[GameCategeryId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblGameSubCategory]    Script Date: 4/3/2022 11:40:53 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblGameSubCategory](
	[GameSubCategoryId] [bigint] IDENTITY(1,1) NOT NULL,
	[GameCategeryId] [bigint] NOT NULL,
	[GameName] [varchar](50) NULL,
	[bidRate] [money] NOT NULL,
	[is_active] [bit] NULL,
	[created_date] [datetime] NOT NULL,
	[created_by] [varchar](200) NOT NULL,
	[updated_date] [datetime] NULL,
	[updated_by] [varchar](200) NULL,
	[is_deleted] [bit] NOT NULL,
 CONSTRAINT [PK_tblGameSubCategory] PRIMARY KEY CLUSTERED 
(
	[GameSubCategoryId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblGameType]    Script Date: 4/3/2022 11:40:53 AM ******/
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
	[is_active] [bit] NULL,
	[created_date] [datetime] NULL,
	[created_by] [varchar](200) NULL,
	[updated_date] [datetime] NULL,
	[updated_by] [varchar](200) NULL,
	[is_deleted] [bit] NULL,
 CONSTRAINT [PK_tblGameType] PRIMARY KEY CLUSTERED 
(
	[GameTypeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblUserMaster]    Script Date: 4/3/2022 11:40:53 AM ******/
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
SET IDENTITY_INSERT [dbo].[tbl_roles] ON 

GO
INSERT [dbo].[tbl_roles] ([id], [name], [created_date], [created_by], [updated_date], [updated_by], [is_active], [is_deleted]) VALUES (1, N'Admin', CAST(0x0000AE610165CC6E AS DateTime), N'Admin', CAST(0x0000AE610165CC6E AS DateTime), N'Admin', 1, 0)
GO
INSERT [dbo].[tbl_roles] ([id], [name], [created_date], [created_by], [updated_date], [updated_by], [is_active], [is_deleted]) VALUES (2, N'Player', CAST(0x0000AE610165CC6E AS DateTime), N'Admin', CAST(0x0000AE610165CC6E AS DateTime), N'Admin', 1, 0)
GO
SET IDENTITY_INSERT [dbo].[tbl_roles] OFF
GO
SET IDENTITY_INSERT [dbo].[tbl_user] ON 

GO
INSERT [dbo].[tbl_user] ([id], [user_id], [user_name], [password], [email], [mobile], [roles], [created_date], [created_by], [updated_date], [updated_by], [is_active], [is_deleted], [city], [IPAdress]) VALUES (2, N'9971590244', N'9971590244', N'bK685EW1jFo2Kvclq1V2gw==', N'abc@gmail.com', N'9971590244', N'1', CAST(0x0000AE6200F6111E AS DateTime), N'Abdulrub09', NULL, NULL, 1, 0, NULL, NULL)
GO
INSERT [dbo].[tbl_user] ([id], [user_id], [user_name], [password], [email], [mobile], [roles], [created_date], [created_by], [updated_date], [updated_by], [is_active], [is_deleted], [city], [IPAdress]) VALUES (3, N'9971590259', N'9971590259', N'm4xxNq0RQ5Kd487fbbMR7g==', N'abc@gmail.com', N'9971590259', N'2', CAST(0x0000AE64010D59C5 AS DateTime), N'Abdulrub09', NULL, NULL, 1, 0, NULL, NULL)
GO
INSERT [dbo].[tbl_user] ([id], [user_id], [user_name], [password], [email], [mobile], [roles], [created_date], [created_by], [updated_date], [updated_by], [is_active], [is_deleted], [city], [IPAdress]) VALUES (4, N'9971590210', N'9971590210', N'MpwFP1F+gyG539sVGR9oqA==', N'abc@gmail.com', N'9971590210', N'2', CAST(0x0000AE64010D8DD6 AS DateTime), N'Fizy', NULL, NULL, 1, 0, NULL, NULL)
GO
INSERT [dbo].[tbl_user] ([id], [user_id], [user_name], [password], [email], [mobile], [roles], [created_date], [created_by], [updated_date], [updated_by], [is_active], [is_deleted], [city], [IPAdress]) VALUES (5, N'9971590211', N'9971590210', N'w9PtmDdK7j8JGPdjmeXNTQ==', N'abc@gmail.com', N'9971590211', N'2', CAST(0x0000AE64011297B8 AS DateTime), N'9971590211', NULL, NULL, 1, 0, NULL, NULL)
GO
INSERT [dbo].[tbl_user] ([id], [user_id], [user_name], [password], [email], [mobile], [roles], [created_date], [created_by], [updated_date], [updated_by], [is_active], [is_deleted], [city], [IPAdress]) VALUES (6, N'9971590212', N'9971590212', N'+YdtzbWjT9/4fDDarwqgnw==', N'abc@gmail.com', N'9971590212', N'2', CAST(0x0000AE640115CD05 AS DateTime), N'9971590212', NULL, NULL, 1, 0, NULL, NULL)
GO
INSERT [dbo].[tbl_user] ([id], [user_id], [user_name], [password], [email], [mobile], [roles], [created_date], [created_by], [updated_date], [updated_by], [is_active], [is_deleted], [city], [IPAdress]) VALUES (7, N'9971590213', N'9971590213', N'jk4PstxVfoR5+YukxHTkLA==', N'abc@gmail.com', N'9971590213', N'2', CAST(0x0000AE6401180340 AS DateTime), N'9971590213', NULL, NULL, 1, 0, N'103.95.81.87', N'103.95.81.87')
GO
INSERT [dbo].[tbl_user] ([id], [user_id], [user_name], [password], [email], [mobile], [roles], [created_date], [created_by], [updated_date], [updated_by], [is_active], [is_deleted], [city], [IPAdress]) VALUES (8, N'9971590214', NULL, N'Zd564IiQxjqZgJGKjzb71A==', N'abc@gmail.com', N'9971590214', N'2', CAST(0x0000AE64012F73D8 AS DateTime), N'9971590214', NULL, NULL, 1, 0, N'103.95.81.87', N'103.95.81.87')
GO
INSERT [dbo].[tbl_user] ([id], [user_id], [user_name], [password], [email], [mobile], [roles], [created_date], [created_by], [updated_date], [updated_by], [is_active], [is_deleted], [city], [IPAdress]) VALUES (9, N'7007108050', N'fizy', N'UrSIFEZVCAZ+n8cRGEhtxw==', N'fizy2k7@gmail.com', N'7007108050', N'2', CAST(0x0000AE64012FBF25 AS DateTime), N'7007108050', NULL, NULL, 1, 0, N'103.95.81.87', N'103.95.81.87')
GO
INSERT [dbo].[tbl_user] ([id], [user_id], [user_name], [password], [email], [mobile], [roles], [created_date], [created_by], [updated_date], [updated_by], [is_active], [is_deleted], [city], [IPAdress]) VALUES (10, N'7007108051', N'fizy', N'UrSIFEZVCAZ+n8cRGEhtxw==', N'fizy2k7@gmail.com', N'7007108051', N'2', CAST(0x0000AE640130F824 AS DateTime), N'7007108051', NULL, NULL, 1, 0, N'103.95.81.87', N'103.95.81.87')
GO
INSERT [dbo].[tbl_user] ([id], [user_id], [user_name], [password], [email], [mobile], [roles], [created_date], [created_by], [updated_date], [updated_by], [is_active], [is_deleted], [city], [IPAdress]) VALUES (11, N'9971590', NULL, N'Zd564IiQxjqZgJGKjzb71A==', N'abc@gmail.com', N'9971590', N'2', CAST(0x0000AE6401316A5A AS DateTime), N'9971590', NULL, NULL, 1, 0, N'103.95.81.87', N'103.95.81.87')
GO
INSERT [dbo].[tbl_user] ([id], [user_id], [user_name], [password], [email], [mobile], [roles], [created_date], [created_by], [updated_date], [updated_by], [is_active], [is_deleted], [city], [IPAdress]) VALUES (12, N'1122334455', N'faizan', N'Z6HVbb6uFMLzhyq7ab4l1Q==', N'fizy2k7@gmail.com', N'1122334455', N'2', CAST(0x0000AE6401323C59 AS DateTime), N'1122334455', NULL, NULL, 1, 0, N'103.95.81.87', N'103.95.81.87')
GO
SET IDENTITY_INSERT [dbo].[tbl_user] OFF
GO
SET IDENTITY_INSERT [dbo].[tbl_user_roles] ON 

GO
INSERT [dbo].[tbl_user_roles] ([user_role_id], [user_id], [role_id], [created_date], [created_by], [updated_date], [updated_by], [is_active], [is_deleted]) VALUES (1, N'9971590244', 1, CAST(0x0000AE6200FAB936 AS DateTime), N'Admin', CAST(0x0000AE6200FAB936 AS DateTime), N'Admin', 1, 0)
GO
INSERT [dbo].[tbl_user_roles] ([user_role_id], [user_id], [role_id], [created_date], [created_by], [updated_date], [updated_by], [is_active], [is_deleted]) VALUES (4, N'1122334455', 2, CAST(0x0000AE6200FAB936 AS DateTime), N'Player', CAST(0x0000AE6200FAB936 AS DateTime), N'Player', 1, 0)
GO
SET IDENTITY_INSERT [dbo].[tbl_user_roles] OFF
GO
SET IDENTITY_INSERT [dbo].[tbl_user_token] ON 

GO
INSERT [dbo].[tbl_user_token] ([id], [user_id], [token], [created_date], [created_by], [update_date], [updated_by], [is_active], [is_deleted]) VALUES (1, N'9971590258', N'0SJBLSMnvXRyA5mtKb+xl5hsazIW94AlW8LS2U/zjSIynQXUg2Y+hDEaDlV88+TR', CAST(0x0000AE6101718E91 AS DateTime), N'9971590258', NULL, NULL, 1, 0)
GO
INSERT [dbo].[tbl_user_token] ([id], [user_id], [token], [created_date], [created_by], [update_date], [updated_by], [is_active], [is_deleted]) VALUES (2, N'9971590244', N'nyXA9ulyPImsFUygbC2FX7puFjk3FHx4Z7QmslsUaQ4anNruaQ46XBd4rd/ExfdP', CAST(0x0000AE6200F63BDA AS DateTime), N'9971590244', NULL, NULL, 1, 0)
GO
INSERT [dbo].[tbl_user_token] ([id], [user_id], [token], [created_date], [created_by], [update_date], [updated_by], [is_active], [is_deleted]) VALUES (3, N'1122334455', N'Q6eioOuSEMMz/7y0MXOuDOUoE6rkZiQuoPGTI9vlP4jiJIF1UrahqcTn5sYanFRD', CAST(0x0000AE64013BDDFD AS DateTime), N'1122334455', NULL, NULL, 1, 0)
GO
SET IDENTITY_INSERT [dbo].[tbl_user_token] OFF
GO
SET IDENTITY_INSERT [dbo].[tblGameCategory] ON 

GO
INSERT [dbo].[tblGameCategory] ([GameCategeryId], [GameTypeId], [CategoryName], [bidRate], [created_date], [created_by], [updated_date], [updated_by], [is_active], [is_deleted]) VALUES (1, 1, N'Haraf', 100.0000, CAST(0x0000AE6700085335 AS DateTime), N'Admin', CAST(0x0000AE6700085335 AS DateTime), N'Admin', 1, 0)
GO
INSERT [dbo].[tblGameCategory] ([GameCategeryId], [GameTypeId], [CategoryName], [bidRate], [created_date], [created_by], [updated_date], [updated_by], [is_active], [is_deleted]) VALUES (3, 2, N'Haraf', 100.0000, CAST(0x0000AE6700085335 AS DateTime), N'Admin', CAST(0x0000AE6700085335 AS DateTime), N'Admin', 1, 0)
GO
INSERT [dbo].[tblGameCategory] ([GameCategeryId], [GameTypeId], [CategoryName], [bidRate], [created_date], [created_by], [updated_date], [updated_by], [is_active], [is_deleted]) VALUES (4, 3, N'Hraf', 100.0000, CAST(0x0000AE6700085335 AS DateTime), N'Admin', CAST(0x0000AE6700085335 AS DateTime), N'Admin', 1, 0)
GO
INSERT [dbo].[tblGameCategory] ([GameCategeryId], [GameTypeId], [CategoryName], [bidRate], [created_date], [created_by], [updated_date], [updated_by], [is_active], [is_deleted]) VALUES (5, 1, N'Cross', 100.0000, CAST(0x0000AE6700085335 AS DateTime), N'Admin', CAST(0x0000AE6700085335 AS DateTime), N'Admin', 1, 0)
GO
INSERT [dbo].[tblGameCategory] ([GameCategeryId], [GameTypeId], [CategoryName], [bidRate], [created_date], [created_by], [updated_date], [updated_by], [is_active], [is_deleted]) VALUES (6, 2, N'Cross', 100.0000, CAST(0x0000AE6700085335 AS DateTime), N'Admin', CAST(0x0000AE6700085335 AS DateTime), N'Admin', 1, 0)
GO
INSERT [dbo].[tblGameCategory] ([GameCategeryId], [GameTypeId], [CategoryName], [bidRate], [created_date], [created_by], [updated_date], [updated_by], [is_active], [is_deleted]) VALUES (7, 3, N'Cross', 100.0000, CAST(0x0000AE67000D42F8 AS DateTime), N'Admin', CAST(0x0000AE67000D42F8 AS DateTime), N'Admin', 1, 0)
GO
INSERT [dbo].[tblGameCategory] ([GameCategeryId], [GameTypeId], [CategoryName], [bidRate], [created_date], [created_by], [updated_date], [updated_by], [is_active], [is_deleted]) VALUES (8, 1, N'Chart', 100.0000, CAST(0x0000AE67000D5B65 AS DateTime), N'Admin', CAST(0x0000AE67000D5B65 AS DateTime), N'Admin', 1, 0)
GO
INSERT [dbo].[tblGameCategory] ([GameCategeryId], [GameTypeId], [CategoryName], [bidRate], [created_date], [created_by], [updated_date], [updated_by], [is_active], [is_deleted]) VALUES (9, 2, N'Chart', 100.0000, CAST(0x0000AE67000D5B65 AS DateTime), N'Admin', CAST(0x0000AE67000D5B65 AS DateTime), N'Admin', 1, 0)
GO
INSERT [dbo].[tblGameCategory] ([GameCategeryId], [GameTypeId], [CategoryName], [bidRate], [created_date], [created_by], [updated_date], [updated_by], [is_active], [is_deleted]) VALUES (10, 3, N'Chart', 100.0000, CAST(0x0000AE67000D5B66 AS DateTime), N'Admin', CAST(0x0000AE67000D5B66 AS DateTime), N'Admin', 1, 0)
GO
SET IDENTITY_INSERT [dbo].[tblGameCategory] OFF
GO
SET IDENTITY_INSERT [dbo].[tblGameSubCategory] ON 

GO
INSERT [dbo].[tblGameSubCategory] ([GameSubCategoryId], [GameCategeryId], [GameName], [bidRate], [is_active], [created_date], [created_by], [updated_date], [updated_by], [is_deleted]) VALUES (1, 1, N'Andar', 100.0000, 1, CAST(0x0000AE67000F31EA AS DateTime), N'Admin', CAST(0x0000AE67000F31EA AS DateTime), N'Admin', 0)
GO
INSERT [dbo].[tblGameSubCategory] ([GameSubCategoryId], [GameCategeryId], [GameName], [bidRate], [is_active], [created_date], [created_by], [updated_date], [updated_by], [is_deleted]) VALUES (2, 3, N'Andar', 100.0000, 1, CAST(0x0000AE670010229A AS DateTime), N'Admin', CAST(0x0000AE670010229A AS DateTime), N'Admin', 0)
GO
INSERT [dbo].[tblGameSubCategory] ([GameSubCategoryId], [GameCategeryId], [GameName], [bidRate], [is_active], [created_date], [created_by], [updated_date], [updated_by], [is_deleted]) VALUES (3, 4, N'Andar', 100.0000, 1, CAST(0x0000AE6700102A74 AS DateTime), N'Admin', CAST(0x0000AE6700102A74 AS DateTime), N'Admin', 0)
GO
INSERT [dbo].[tblGameSubCategory] ([GameSubCategoryId], [GameCategeryId], [GameName], [bidRate], [is_active], [created_date], [created_by], [updated_date], [updated_by], [is_deleted]) VALUES (9, 5, N'Round', 100.0000, 1, CAST(0x0000AE670010980C AS DateTime), N'Admin', CAST(0x0000AE670010980C AS DateTime), N'Admin', 0)
GO
INSERT [dbo].[tblGameSubCategory] ([GameSubCategoryId], [GameCategeryId], [GameName], [bidRate], [is_active], [created_date], [created_by], [updated_date], [updated_by], [is_deleted]) VALUES (10, 6, N'Round', 100.0000, 1, CAST(0x0000AE670010A7CF AS DateTime), N'Admin', CAST(0x0000AE670010A7CF AS DateTime), N'Admin', 0)
GO
INSERT [dbo].[tblGameSubCategory] ([GameSubCategoryId], [GameCategeryId], [GameName], [bidRate], [is_active], [created_date], [created_by], [updated_date], [updated_by], [is_deleted]) VALUES (11, 7, N'Round', 100.0000, 1, CAST(0x0000AE670010AE36 AS DateTime), N'Admin', CAST(0x0000AE670010AE36 AS DateTime), N'Admin', 0)
GO
INSERT [dbo].[tblGameSubCategory] ([GameSubCategoryId], [GameCategeryId], [GameName], [bidRate], [is_active], [created_date], [created_by], [updated_date], [updated_by], [is_deleted]) VALUES (12, 8, N'Chart', 100.0000, 1, CAST(0x0000AE670010E1CA AS DateTime), N'Admin', CAST(0x0000AE670010E1CA AS DateTime), N'Admin', 0)
GO
INSERT [dbo].[tblGameSubCategory] ([GameSubCategoryId], [GameCategeryId], [GameName], [bidRate], [is_active], [created_date], [created_by], [updated_date], [updated_by], [is_deleted]) VALUES (13, 9, N'Chart', 100.0000, 1, CAST(0x0000AE670010E541 AS DateTime), N'Admin', CAST(0x0000AE670010E541 AS DateTime), N'Admin', 0)
GO
INSERT [dbo].[tblGameSubCategory] ([GameSubCategoryId], [GameCategeryId], [GameName], [bidRate], [is_active], [created_date], [created_by], [updated_date], [updated_by], [is_deleted]) VALUES (14, 10, N'Chart', 100.0000, 1, CAST(0x0000AE670010EDB4 AS DateTime), N'Admin', CAST(0x0000AE670010EDB4 AS DateTime), N'Admin', 0)
GO
INSERT [dbo].[tblGameSubCategory] ([GameSubCategoryId], [GameCategeryId], [GameName], [bidRate], [is_active], [created_date], [created_by], [updated_date], [updated_by], [is_deleted]) VALUES (15, 1, N'Bahar', 100.0000, 1, CAST(0x0000AE6700112FF5 AS DateTime), N'Admin', CAST(0x0000AE6700112FF5 AS DateTime), N'Admin', 0)
GO
INSERT [dbo].[tblGameSubCategory] ([GameSubCategoryId], [GameCategeryId], [GameName], [bidRate], [is_active], [created_date], [created_by], [updated_date], [updated_by], [is_deleted]) VALUES (16, 3, N'Bahar', 100.0000, 1, CAST(0x0000AE6700113450 AS DateTime), N'Admin', CAST(0x0000AE6700113450 AS DateTime), N'Admin', 0)
GO
INSERT [dbo].[tblGameSubCategory] ([GameSubCategoryId], [GameCategeryId], [GameName], [bidRate], [is_active], [created_date], [created_by], [updated_date], [updated_by], [is_deleted]) VALUES (17, 4, N'Bahar', 100.0000, 1, CAST(0x0000AE67001137C3 AS DateTime), N'Admin', CAST(0x0000AE67001137C3 AS DateTime), N'Admin', 0)
GO
INSERT [dbo].[tblGameSubCategory] ([GameSubCategoryId], [GameCategeryId], [GameName], [bidRate], [is_active], [created_date], [created_by], [updated_date], [updated_by], [is_deleted]) VALUES (18, 5, N'Round2', 100.0000, 1, CAST(0x0000AE6700115AB5 AS DateTime), N'Admin', CAST(0x0000AE6700115AB5 AS DateTime), N'Admin', 0)
GO
INSERT [dbo].[tblGameSubCategory] ([GameSubCategoryId], [GameCategeryId], [GameName], [bidRate], [is_active], [created_date], [created_by], [updated_date], [updated_by], [is_deleted]) VALUES (19, 6, N'Round2', 100.0000, 1, CAST(0x0000AE6700115EFC AS DateTime), N'Admin', CAST(0x0000AE6700115EFC AS DateTime), N'Admin', 0)
GO
INSERT [dbo].[tblGameSubCategory] ([GameSubCategoryId], [GameCategeryId], [GameName], [bidRate], [is_active], [created_date], [created_by], [updated_date], [updated_by], [is_deleted]) VALUES (20, 7, N'Round2', 100.0000, 1, CAST(0x0000AE670011624B AS DateTime), N'Admin', CAST(0x0000AE670011624B AS DateTime), N'Admin', 0)
GO
INSERT [dbo].[tblGameSubCategory] ([GameSubCategoryId], [GameCategeryId], [GameName], [bidRate], [is_active], [created_date], [created_by], [updated_date], [updated_by], [is_deleted]) VALUES (21, 8, N'Chart2', 100.0000, 1, CAST(0x0000AE67001176DD AS DateTime), N'Admin', CAST(0x0000AE67001176DD AS DateTime), N'Admin', 0)
GO
INSERT [dbo].[tblGameSubCategory] ([GameSubCategoryId], [GameCategeryId], [GameName], [bidRate], [is_active], [created_date], [created_by], [updated_date], [updated_by], [is_deleted]) VALUES (22, 9, N'Chart2', 100.0000, 1, CAST(0x0000AE6700117B9A AS DateTime), N'Admin', CAST(0x0000AE6700117B9A AS DateTime), N'Admin', 0)
GO
INSERT [dbo].[tblGameSubCategory] ([GameSubCategoryId], [GameCategeryId], [GameName], [bidRate], [is_active], [created_date], [created_by], [updated_date], [updated_by], [is_deleted]) VALUES (23, 10, N'Chart2', 100.0000, 1, CAST(0x0000AE6700117EF4 AS DateTime), N'Admin', CAST(0x0000AE6700117EF4 AS DateTime), N'Admin', 0)
GO
SET IDENTITY_INSERT [dbo].[tblGameSubCategory] OFF
GO
SET IDENTITY_INSERT [dbo].[tblGameType] ON 

GO
INSERT [dbo].[tblGameType] ([GameTypeId], [GameName], [StartDate], [EndDate], [is_active], [created_date], [created_by], [updated_date], [updated_by], [is_deleted]) VALUES (1, N'Gali mohalla', CAST(0x0000AE6600085334 AS DateTime), CAST(0x0000AE6A00085335 AS DateTime), 1, CAST(0x0000AE6700085335 AS DateTime), N'Admin', CAST(0x0000AE6700085335 AS DateTime), N'Admin', 0)
GO
INSERT [dbo].[tblGameType] ([GameTypeId], [GameName], [StartDate], [EndDate], [is_active], [created_date], [created_by], [updated_date], [updated_by], [is_deleted]) VALUES (2, N'GaziyaBaad', CAST(0x0000AE6600085F6B AS DateTime), CAST(0x0000AE6A00085F6B AS DateTime), 1, CAST(0x0000AE6700085F6B AS DateTime), N'Admin', CAST(0x0000AE6700085F6B AS DateTime), N'Admin', 0)
GO
INSERT [dbo].[tblGameType] ([GameTypeId], [GameName], [StartDate], [EndDate], [is_active], [created_date], [created_by], [updated_date], [updated_by], [is_deleted]) VALUES (3, N'Delhi Darbar', CAST(0x0000AE6600086AC2 AS DateTime), CAST(0x0000AE6A00086AC2 AS DateTime), 1, CAST(0x0000AE6700086AC2 AS DateTime), N'Admin', CAST(0x0000AE6700086AC2 AS DateTime), N'Admin', 0)
GO
INSERT [dbo].[tblGameType] ([GameTypeId], [GameName], [StartDate], [EndDate], [is_active], [created_date], [created_by], [updated_date], [updated_by], [is_deleted]) VALUES (4, N'Test Data', CAST(0x0000AE6600090261 AS DateTime), CAST(0x0000AE6A00090261 AS DateTime), 1, CAST(0x0000AE6700090261 AS DateTime), N'Admin', CAST(0x0000AE6700090261 AS DateTime), N'Admin', 0)
GO
SET IDENTITY_INSERT [dbo].[tblGameType] OFF
GO
SET IDENTITY_INSERT [dbo].[tblUserMaster] ON 

GO
INSERT [dbo].[tblUserMaster] ([userId], [userName], [userEmailId], [userMobileNo], [Password], [userCity], [userState], [isActive], [UserType], [createdDate]) VALUES (1, N'undefined', N'undefined', N'undefined', N'undefined', N'undefined', N'undefined', 1, N'User', NULL)
GO
INSERT [dbo].[tblUserMaster] ([userId], [userName], [userEmailId], [userMobileNo], [Password], [userCity], [userState], [isActive], [UserType], [createdDate]) VALUES (2, N'9971590258', N'abc@gmail.com', N'9971590258', N'2423424', N'Delhi', N'true', 1, N'User', NULL)
GO
INSERT [dbo].[tblUserMaster] ([userId], [userName], [userEmailId], [userMobileNo], [Password], [userCity], [userState], [isActive], [UserType], [createdDate]) VALUES (1, N'undefined', N'undefined', N'undefined', N'undefined', N'undefined', N'undefined', 1, N'User', NULL)
GO
INSERT [dbo].[tblUserMaster] ([userId], [userName], [userEmailId], [userMobileNo], [Password], [userCity], [userState], [isActive], [UserType], [createdDate]) VALUES (2, N'9971590258', N'abc@gmail.com', N'9971590258', N'2423424', N'Delhi', N'true', 1, N'User', NULL)
GO
SET IDENTITY_INSERT [dbo].[tblUserMaster] OFF
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
ALTER TABLE [dbo].[tbl_user_account] ADD  CONSTRAINT [DF_tbl_user_account_IsActive]  DEFAULT ((1)) FOR [is_active]
GO
ALTER TABLE [dbo].[tbl_user_account] ADD  CONSTRAINT [DF_tbl_user_account_IsDeleted]  DEFAULT ((0)) FOR [is_deleted]
GO
ALTER TABLE [dbo].[tbl_user_amount_deposit] ADD  CONSTRAINT [DF_tbl_user_amount_deposit_status]  DEFAULT ((1)) FOR [status]
GO
ALTER TABLE [dbo].[tbl_user_amount_deposit] ADD  CONSTRAINT [DF_tbl_user_amount_deposit_IsActive]  DEFAULT ((1)) FOR [is_active]
GO
ALTER TABLE [dbo].[tbl_user_amount_deposit] ADD  CONSTRAINT [DF_tbl_user_amount_deposit_IsDeleted]  DEFAULT ((0)) FOR [is_deleted]
GO
ALTER TABLE [dbo].[tbl_user_roles] ADD  CONSTRAINT [DF_tbl_user_roles_IsActive]  DEFAULT ((1)) FOR [is_active]
GO
ALTER TABLE [dbo].[tbl_user_roles] ADD  CONSTRAINT [DF_tbl_user_roles_IsDeleted]  DEFAULT ((0)) FOR [is_deleted]
GO
ALTER TABLE [dbo].[tbl_user_token] ADD  CONSTRAINT [DF_tbl_Token_IsActive]  DEFAULT ((1)) FOR [is_active]
GO
ALTER TABLE [dbo].[tbl_user_token] ADD  CONSTRAINT [DF_tbl_Token_IsDeleted]  DEFAULT ((0)) FOR [is_deleted]
GO
ALTER TABLE [dbo].[tbl_user_transaction] ADD  CONSTRAINT [DF_tbl_user_transaction_IsActive]  DEFAULT ((1)) FOR [is_active]
GO
ALTER TABLE [dbo].[tbl_user_transaction] ADD  CONSTRAINT [DF_tbl_user_transaction_IsDeleted]  DEFAULT ((0)) FOR [is_deleted]
GO
ALTER TABLE [dbo].[tbl_user_winning_amount] ADD  CONSTRAINT [DF_tbl_user_winning_amount_IsActive]  DEFAULT ((1)) FOR [is_active]
GO
ALTER TABLE [dbo].[tbl_user_winning_amount] ADD  CONSTRAINT [DF_tbl_user_winning_amount_IsDeleted]  DEFAULT ((0)) FOR [is_deleted]
GO
ALTER TABLE [dbo].[tblGameCategory] ADD  CONSTRAINT [DF_tblGameCategory_IsActive]  DEFAULT ((1)) FOR [is_active]
GO
ALTER TABLE [dbo].[tblGameCategory] ADD  CONSTRAINT [DF_tblGameCategory_IsDeleted]  DEFAULT ((0)) FOR [is_deleted]
GO
ALTER TABLE [dbo].[tblGameSubCategory] ADD  CONSTRAINT [DF_tblGameSubCategory_isActive]  DEFAULT ((1)) FOR [is_active]
GO
ALTER TABLE [dbo].[tblGameSubCategory] ADD  CONSTRAINT [DF_tblGameSubCategory_IsDeleted]  DEFAULT ((0)) FOR [is_deleted]
GO
ALTER TABLE [dbo].[tblGameType] ADD  CONSTRAINT [DF_tblGameType_isActive]  DEFAULT ((1)) FOR [is_active]
GO
ALTER TABLE [dbo].[tblGameType] ADD  CONSTRAINT [DF_tblGameType_is_deleted]  DEFAULT ((0)) FOR [is_deleted]
GO
ALTER TABLE [dbo].[tbl_user_amount_deposit]  WITH CHECK ADD  CONSTRAINT [FK_tbl_user_amount_deposit_tbl_user] FOREIGN KEY([payment_mode_id])
REFERENCES [dbo].[tbl_payment_mode] ([id])
GO
ALTER TABLE [dbo].[tbl_user_amount_deposit] CHECK CONSTRAINT [FK_tbl_user_amount_deposit_tbl_user]
GO
ALTER TABLE [dbo].[tblGameCategory]  WITH CHECK ADD  CONSTRAINT [FK_tblGameCategory_tblGameType] FOREIGN KEY([GameTypeId])
REFERENCES [dbo].[tblGameType] ([GameTypeId])
GO
ALTER TABLE [dbo].[tblGameCategory] CHECK CONSTRAINT [FK_tblGameCategory_tblGameType]
GO
ALTER TABLE [dbo].[tblGameSubCategory]  WITH CHECK ADD  CONSTRAINT [FK_tblGameSubCategory_tblGameCategory] FOREIGN KEY([GameCategeryId])
REFERENCES [dbo].[tblGameCategory] ([GameCategeryId])
GO
ALTER TABLE [dbo].[tblGameSubCategory] CHECK CONSTRAINT [FK_tblGameSubCategory_tblGameCategory]
GO
