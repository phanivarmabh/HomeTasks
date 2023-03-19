CREATE or alter PROCEDURE spDatabaseStatistics
@p_DatabaseName NVARCHAR(MAX), 
@p_SchemaName NVARCHAR(MAX),
@p_TableName NVARCHAR(MAX)
as
begin
	declare @SQL nvarchar(max)
	set @SQL = ''
	;with cols as (
	select TABLE_CATALOG, Table_Schema, Table_Name, Column_Name, Data_Type, Row_Number() over(partition by Table_Schema, Table_Name
	order by ORDINAL_POSITION) as RowNum
	from INFORMATION_SCHEMA.COLUMNS
	)

	select @SQL = @SQL + case when RowNum = 1 then '' else ' union all ' end
		+ ' select ''' + TABLE_CATALOG + ''' as Database_Name,''' + TABLE_SCHEMA + ''' as Table_Schema,''' + TABLE_NAME + ''' as Table_Name,
		''' + Column_Name + ''' as Column_Name,''' + DATA_TYPE + ''' as Data_Type, count(distinct ' + quotename (Column_Name) + ' ) as DistinctCountValue, 
		count( '+ quotename (Column_Name) + ') as TotalRowCount, sum(case when '+ quotename (Column_Name) + ' is NULL then 1 else 0 END) as NullValueCount,
		sum(case when ASCII( '+ quotename (Column_Name) + ') between 65 and 90 then 1 else 0 end) as UpperCaseCount,
		sum(case when ASCII( '+ quotename (Column_Name) + ') between 97 and 122 then 1 else 0 end) as LowerCaseCount,
		SUM(CASE WHEN (( ASCII('+ quotename (Column_Name) + ') NOT BETWEEN 97 AND 122 ) AND ( ASCII('+ quotename (Column_Name) + ') NOT BETWEEN 65 AND 90 )) THEN 1 ELSE 0 END) as OtherCharCount,
		min(cast('+ quotename (Column_Name) + ' as varchar)) minValue, max(cast('+ quotename (Column_Name) + ' as varchar)) maxValue
		FROM ' + quotename (Table_Schema) + '.' + quotename (Table_Name)
	from cols
	where Table_Name like @p_TableName + '%' and TABLE_SCHEMA=@p_SchemaName and TABLE_CATALOG=@p_DatabaseName
	execute sp_executesql @SQL
end

execute spDatabaseStatistics 'TRN', 'hr', 'loc'

