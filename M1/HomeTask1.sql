WITH json_string AS
	(
		SELECT replace('[{"employee_id": "5181816516151", "department_id": "1", "class": "src\bin\comp\json"}, {"employee_id": "925155", "department_id": "1", "class": "src\bin\comp\json"}, {"employee_id": "815153", "department_id": "2", "class": "src\bin\comp\json"}, {"employee_id": "967", "department_id": "", "class": "src\bin\comp\json"}]', '\', '\\') [str]
	)
SELECT
	employee_id,
	case when [department_id]=0 then Null else [department_id] end [department_id] 
	from json_string
	cross apply openjson([str])
	with(employee_id bigint '$.employee_id',
	department_id int '$.department_id')