WITH CTE_DIRECT_REPORTS AS 
(select MgrID, count(*) as DirectStaff 
from [EMPLOYEEVIEW].[v_EmployeeData]
where [EmployeeStatus] IN('A','L','P','S') 
group by MgrID)
	
SELECT A.[SnapshotDate]
	,A.[ID]
    ,A.[NameFirst]
    ,A.[NameLast]
    ,A.[OrgL3]
    ,A.[OrgL3Desc]
    ,A.[OrgL4]
    ,A.[OrgL4Desc]
    ,A.[OrgL5]
    ,A.[OrgL5Desc]
    ,A.[OrgL6]
    ,A.[OrgL6Desc]
    ,A.[OrgL7]
    ,A.[OrgL7Desc]
    ,A.[OrgL8]
    ,A.[OrgL8Desc]
    ,A.[OrgL9]
    ,A.[OrgL9Desc]
    ,A.[OrgL10]
    ,A.[OrgL10Desc]
    ,A.[OrgL11]
    ,A.[OrgL11Desc]
	,FORMAT(A.[HIREDATE],'MM/dd/yyyy') AS 'HIRE DATE'
	,A.[HIREDATE_LOS] as 'Hire Date Years'
	, CASE A.[HIREDATE_LOS_Desc] 
		WHEN '< 1 Year                 ' THEN '<=1'
		WHEN '1-3 Years               ' THEN '1.01 TO 3'
		WHEN '3-5 Years               ' THEN '3.01 TO 5'
		WHEN '5-7 Years               ' THEN '5.01 TO 7'
		WHEN '7-10 Years              ' THEN '7.01 TO 10'
		WHEN '10-15 Years             ' THEN '10.01 TO 15'
		WHEN '15-20 Years             ' THEN '15.01 TO 20'
		WHEN '20-25 Years             ' THEN '20.01 TO 25'
		WHEN '20-25 Years             ' THEN '20.01 TO 25'
		WHEN '25+ Years               ' THEN '>25'
		ELSE A.[HIREDATE_LOS_Desc] 
		END AS 'HD Year Group'
	,A.[HireDate] as 'Original Hire Date'
	,A.[OrgYears]
	, CASE A.[EmployeeType] 
		WHEN 'I' THEN 'ICE' 
		WHEN 'S' THEN 'STU/INT'
		ELSE 'Regular'
		END AS 'Employee Type'
	,A.[Reg]
	,A.[FullPartT]
	,A.[Status]
	,A.[JobCode]
	,CONCAT(A.[JobCode],' - ',A.[Level]) AS 'Job Code Detail'
	,A.[JobCodeDesc] 
	,B.[JobFam] AS 'Job Family'
	,B.[JobFamilyDsc] AS 'Job Family Group'
	,B.[JobSegment]
	,B.[JobSegmentDsc]
	,A.[JobYears]
	,A.[DILabor] AS 'Job Category'
	,A.[JobClass] AS 'Job Type'
	,A.[Level]
	,A.[LevelDesc]
	,LEFT(A.[LevelGroup] , LEN(A.[LevelGroup] )-4) AS 'GRADE GROUP'
	, CASE A.[LevelGroup]
		WHEN 'G 9(03)' THEN 'YES'
		WHEN 'G 10+(04)' THEN 'YES'
		ELSE 'NO'
		END AS NULL
	,A.[LevelYears]
	,CONCAT(A.[HomeCode],' ',A.[HomeDesc]) AS 'Location'
	,A.[HomeDesc] AS 'Location Slim'
	,A.[HomeCountry] AS 'Country'
	,A.[HomeSubGeo] AS 'Region'
	,A.[HomeHubDesc] AS 'Site'
	,A.[HomeGeo] AS 'GEO'
	,A.[HomeSubdivDesc] as 'Work State'
	,A.[MgrID]
	,A.[Mgr]
	,A.[MgrMonths]
	,A.[HRDID]
	,A.[HR]
	,CASE A.[PayType]
		WHEN 'S' THEN 'Exempt'
		ELSE 'Non-Exempt'
		END AS 'Exempt vs Non'
	,B.[ManagCd]
	,A.[OrgMgr]
	,D.Staff
	, CASE 
		WHEN C.timemanag > A.CompServS THEN A.HIREDATE_LOS 
		ELSE C.timeasmanag 
		END AS 'Time as Manager'
	,A.[ClockStim]
	,A.[Sex]
	,A.[Age]
	,CASE A.[AgeSegment]
		WHEN 'Age0 - 20              ' THEN '<=20'
		WHEN 'Age20 - 25             ' THEN '20.01 TO 25'
		WHEN 'Age25 - 30             ' THEN '25.01 TO 30'
		WHEN 'Age30 - 35             ' THEN '30.01 TO 35'
		WHEN 'Age35 - 40             ' THEN '35.01 TO 40'
		WHEN 'Age40 - 45             ' THEN '40.01 TO 45'
		WHEN 'Age45 - 50             ' THEN '45.01 TO 50'
		WHEN 'Age50 - 55             ' THEN '50.01 TO 55'
		WHEN 'Age55 - 60              ' THEN '55.01 TO 60'
		WHEN 'Age 60+ Years                 ' THEN '>60'
		ELSE A.[HIREDATE_LOS_Desc]
		END AS 'Age Group'
	 ,C.[DiversityInd]
	 ,A.[DiverDesc]
FROM [EMPLOYEEVIEW].[v_EmployeeData] AS A
	LEFT JOIN [ALLVIEW].[v_Job] AS B
		ON CONCAT(A.[JCode],' - ',A.[Level]) = B.[JobId]
			LEFT JOIN [SEMPLOYEEVIEW].[v_Employee] AS C
				ON A.[ID] = C.[EmployeeID] AND A.[SnapshotYear] = C.[FiscalYear] AND A.[SnapshotMonth] = C.[AccountNbr]
					LEFT JOIN CTE_DIRECT_REPORTS AS D
						ON A.[ID] = D.MgrID
WHERE A.[EmployeeStatus] IN('A','L','P','S')