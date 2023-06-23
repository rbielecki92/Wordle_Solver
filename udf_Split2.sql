/****** Object:  UserDefinedFunction [dbo].[udf_Split2]    Script Date: 4/3/2023 08:59:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER FUNCTION [dbo].[udf_Split2]

(   
-- List of delimited items 
@sInputList nVARCHAR(max)
-- delimiter that separates items
, @sDelimiter nVARCHAR(max) = ','
)

RETURNS @List TABLE (item nVARCHAR(max))

BEGIN

DECLARE @sItem nVARCHAR(max)

       WHILE CHARINDEX(@sDelimiter,@sInputList,0) <> 0
              BEGIN
                     SELECT  @sItem=RTRIM(LTRIM(SUBSTRING(@sInputList,1,CHARINDEX(@sDelimiter,@sInputList,0)-1))), 
                                   @sInputList=RTRIM(LTRIM(SUBSTRING(@sInputList,CHARINDEX(@sDelimiter,@sInputList,0)+LEN(@sDelimiter),LEN(@sInputList)))) 

                     IF LEN(@sItem) > 0 
                            INSERT INTO @List
                            SELECT @sItem END

                     IF LEN(@sInputList) > 0

                            INSERT INTO @List
                            SELECT @sInputList
                            -- Put the last item in
       RETURN

END