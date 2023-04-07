
/*======================================

Created by Rafal Bielecki 2023-04-03

		===Wordle Solver===

======================================*/

--Wordle challange=648 is a good example
--https://lookleft.github.io/wordle-history/?challenge=648
--CRANE, PIOUS, BORAX, RAZOR

/*

TO DO:
- better probablility?
- '' instead of NULL
- @grey_letters without commas


*/

DECLARE 
	---------------------------------------------<< PLAY >>---------------------------------------------------------
	--GREEN
	 @a AS CHAR	= NULL
	,@b AS CHAR	= 'a'
	,@c AS CHAR	= NULL
	,@d AS CHAR	= 'o'
	,@e AS CHAR	= 'r'
	--YELLOW
	,@yellow_a AS VARCHAR(100) = NULL	,@yellow_a2 AS VARCHAR(100) = NULL	,@yellow_a3 AS VARCHAR(100) = NULL
	,@yellow_b AS VARCHAR(100) = 'r'	,@yellow_b2 AS VARCHAR(100) = NULL	,@yellow_b3 AS VARCHAR(100) = 'o'
	,@yellow_c AS VARCHAR(100) = 'a'	,@yellow_c2 AS VARCHAR(100) = 'o'	,@yellow_c3 AS VARCHAR(100) = 'r'
	,@yellow_d AS VARCHAR(100) = NULL	,@yellow_d2 AS VARCHAR(100) = NULL	,@yellow_d3 AS VARCHAR(100) = 'a'
	,@yellow_e AS VARCHAR(100) = NULL	,@yellow_e2 AS VARCHAR(100) = NULL	,@yellow_e3 AS VARCHAR(100) = NULL
	--GREY 
	,@grey_letters AS VARCHAR(100) = 'c,n,e,p,i,u,s,b,x,r,z'
	--FINAL WORD
	,@today_word VARCHAR(10) = ''
	--SHOW HISTORY (Y/N)
	,@show_hist INT = 0
	----------------------------------------------------------------------------------------------------------------
	--Other
	,@max_date_hist DATE
	,@grey_letters_in_yellow AS VARCHAR(100) 
	,@count_words AS INT

SELECT @max_date_hist = MAX(date_word)  FROM _tb_wordle_base_hist

SELECT @grey_letters_in_yellow = CONCAT_WS(',',@a,@yellow_a,@yellow_a2,@yellow_a3
												,@b,@yellow_b,@yellow_b2,@yellow_b3
												,@c,@yellow_c,@yellow_c2,@yellow_c3
												,@d,@yellow_d,@yellow_d2,@yellow_d3
												,@e,@yellow_e,@yellow_e2,@yellow_e3)

DROP TABLE IF EXISTS #wordle

SELECT
	 UPPER(wb.a) AS A
	,UPPER(wb.b) AS B
	,UPPER(wb.c) AS C 
	,UPPER(wb.d) AS D
	,UPPER(wb.e) AS E
	,UPPER(wb.final_word) as final_word
	,CASE
		WHEN wbh.past_word IS NOT NULL THEN 0.00
		ELSE wb.probability
	END AS probability
	,wbh.past_word
	,wbh.date_word
INTO
	#wordle
FROM 
	_tb_wordle_base wb
LEFT JOIN --words used in the past
	_tb_wordle_base_hist wbh 
		ON wb.final_word = wbh.past_word
WHERE
	--matching letters with correct place (green)
		(wb.a = @a OR @a IS NULL)
	AND (wb.b = @b OR @b IS NULL)
	AND (wb.c = @c OR @c IS NULL)
	AND (wb.d = @d OR @d IS NULL)
	AND (wb.e = @e OR @e IS NULL)
	--matching letters with incorrect place (yellow)
	AND	(wb.a <> @yellow_a OR @yellow_a IS NULL)
	AND (wb.b <> @yellow_b OR @yellow_b IS NULL)
	AND (wb.c <> @yellow_c OR @yellow_c IS NULL)
	AND (wb.d <> @yellow_d OR @yellow_d IS NULL)
	AND (wb.e <> @yellow_e OR @yellow_e IS NULL)
		AND	(wb.a <> @yellow_a2 OR @yellow_a2 IS NULL)
		AND (wb.b <> @yellow_b2 OR @yellow_b2 IS NULL)
		AND (wb.c <> @yellow_c2 OR @yellow_c2 IS NULL)
		AND (wb.d <> @yellow_d2 OR @yellow_d2 IS NULL)
		AND (wb.e <> @yellow_e2 OR @yellow_e2 IS NULL)
			AND	(wb.a <> @yellow_a3 OR @yellow_a3 IS NULL)
			AND (wb.b <> @yellow_b3 OR @yellow_b3 IS NULL)
			AND (wb.c <> @yellow_c3 OR @yellow_c3 IS NULL)
			AND (wb.d <> @yellow_d3 OR @yellow_d3 IS NULL)
			AND (wb.e <> @yellow_e3 OR @yellow_e3 IS NULL)
	AND (wb.final_word LIKE '%' + @yellow_a + '%' OR @yellow_a IS NULL) 
	AND (wb.final_word LIKE '%' + @yellow_b + '%' OR @yellow_b IS NULL) 
	AND (wb.final_word LIKE '%' + @yellow_c + '%' OR @yellow_c IS NULL) 
	AND (wb.final_word LIKE '%' + @yellow_d + '%' OR @yellow_d IS NULL) 
	AND (wb.final_word LIKE '%' + @yellow_e + '%' OR @yellow_e IS NULL)
		AND (wb.final_word LIKE '%' + @yellow_a2 + '%' OR @yellow_a2 IS NULL) 
		AND (wb.final_word LIKE '%' + @yellow_b2 + '%' OR @yellow_b2 IS NULL) 
		AND (wb.final_word LIKE '%' + @yellow_c2 + '%' OR @yellow_c2 IS NULL) 
		AND (wb.final_word LIKE '%' + @yellow_d2 + '%' OR @yellow_d2 IS NULL) 
		AND (wb.final_word LIKE '%' + @yellow_e2 + '%' OR @yellow_e2 IS NULL) 
			AND (wb.final_word LIKE '%' + @yellow_a3 + '%' OR @yellow_a3 IS NULL) 
			AND (wb.final_word LIKE '%' + @yellow_b3 + '%' OR @yellow_b3 IS NULL) 
			AND (wb.final_word LIKE '%' + @yellow_c3 + '%' OR @yellow_c3 IS NULL) 
			AND (wb.final_word LIKE '%' + @yellow_d3 + '%' OR @yellow_d3 IS NULL) 
			AND (wb.final_word LIKE '%' + @yellow_e3 + '%' OR @yellow_e3 IS NULL)
	--not existing or exists in yellow 
	AND (wb.a NOT IN (SELECT item FROM [dbo].[udf_Split2](@grey_letters,',')) OR wb.a IN (SELECT item FROM [dbo].[udf_Split2](@grey_letters_in_yellow,',')))
	AND (wb.b NOT IN (SELECT item FROM [dbo].[udf_Split2](@grey_letters,',')) OR wb.b IN (SELECT item FROM [dbo].[udf_Split2](@grey_letters_in_yellow,',')))
	AND (wb.c NOT IN (SELECT item FROM [dbo].[udf_Split2](@grey_letters,',')) OR wb.c IN (SELECT item FROM [dbo].[udf_Split2](@grey_letters_in_yellow,',')))
	AND (wb.d NOT IN (SELECT item FROM [dbo].[udf_Split2](@grey_letters,',')) OR wb.d IN (SELECT item FROM [dbo].[udf_Split2](@grey_letters_in_yellow,',')))
	AND (wb.e NOT IN (SELECT item FROM [dbo].[udf_Split2](@grey_letters,',')) OR wb.e IN (SELECT item FROM [dbo].[udf_Split2](@grey_letters_in_yellow,',')))

SELECT @count_words = COUNT(1) FROM #wordle WHERE past_word IS NULL

SELECT 
	 A
	,B
	,C 
	,D
	,E
	,final_word
	,CASE
		WHEN probability IS NULL THEN 100/@count_words
		ELSE probability
	END AS probability
	,past_word
	,date_word 
FROM 
	#wordle
ORDER BY 
	probability DESC
	,final_word 

--UPDATE hist table
IF @today_word = '' 
	BEGIN
		SELECT 'todays word is empty, fill it in' AS reminder
	END
ELSE IF LEN(@today_word) <> 5 
	BEGIN
		SELECT 'todays word ' + UPPER(@today_word) + ' has wrong number of letters: ' + CAST(LEN(@today_word) AS VARCHAR(5)) AS reminder
	END
ELSE IF @max_date_hist = CAST(GETDATE() AS DATE) AND @today_word = (SELECT TOP 1 past_word FROM _tb_wordle_base_hist ORDER BY date_word DESC) 
	BEGIN
		SELECT 'todays word ' + UPPER(@today_word) + ' has been added already' AS reminder
	END
ELSE IF @today_word IN (SELECT past_word FROM _tb_wordle_base_hist) 
	BEGIN
		SELECT 'todays word ' + UPPER(@today_word) + ' already EXISTS in the history table' AS reminder
	END
ELSE IF @max_date_hist < CAST(GETDATE() AS DATE)
	BEGIN
		INSERT INTO _tb_wordle_base_hist SELECT UPPER(@today_word),CAST(GETDATE() AS DATE) 
		SELECT 'Congrats, todays word ' + UPPER(@today_word) + ' has been added' AS reminder
	END
ELSE IF @max_date_hist = CAST(GETDATE() AS DATE) 
	BEGIN
		SELECT 'todays word has been added, but its not ' + UPPER(@today_word) AS reminder
	END

IF @show_hist = 1
	BEGIN
		SELECT * FROM _tb_wordle_base_hist ORDER BY date_word DESC
	END

