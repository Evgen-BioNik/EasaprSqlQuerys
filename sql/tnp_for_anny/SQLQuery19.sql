
DECLARE @locoNum CHAR(8),@ownerOKPO VARCHAR(14),@ownerName VARCHAR(MAX),
@rentContractDate DATETIME,@rentContractNum VARCHAR(50),@unhookDate DATETIME,
@techFailName VARCHAR(MAX),@trainUnhookNum INT,@trainUnhookIndex CHAR(13)




-- Заполнять данные здесь
SET @locoNum		= '37126237'
SET @ownerOKPO		= '12345612345'
SET @ownerName		= 'Олооло'
SET @rentContractDate	= ''
SET @rentContractNum	= ''
SET @unhookDate		= ''
SET @techFailName	= ''
SET @trainUnhookNum = ''
SET @trainUnhookIndex	= ''












IF ISNULL(@locoNum,'') != '' AND ISNULL(@ownerOKPO,'') != '' AND ISNULL(@ownerName,'') != ''
BEGIN
INSERT INTO interface_buff.dbo.asoup_own_locomotives
(
	locoNum,
	ownerOKPO,
	ownerName,
	rentContractDate,
	rentContractNum,
	unhookDate,
	techFailName,
	trainUnhookNum,
	trainUnhookIndex
)
VALUES
(
	CASE WHEN ISNULL(@locoNum,'') = '' THEN NULL ELSE @locoNum END,
	CASE WHEN ISNULL(@ownerOKPO,'') = '' THEN NULL ELSE @ownerOKPO END,
	CASE WHEN ISNULL(@ownerName,'') = '' THEN NULL ELSE @ownerName END,
	CASE WHEN ISNULL(@rentContractDate,'') = '' THEN NULL ELSE @rentContractDate END,
	CASE WHEN ISNULL(@rentContractNum,'') = '' THEN NULL ELSE @rentContractNum END,
	CASE WHEN ISNULL(@unhookDate,'') = '' THEN NULL ELSE @unhookDate END,
	CASE WHEN ISNULL(@techFailName,'') = '' THEN NULL ELSE @techFailName END,
	CASE WHEN ISNULL(@trainUnhookNum,'') = '' THEN NULL ELSE @trainUnhookNum END,
	CASE WHEN ISNULL(@trainUnhookIndex,'') = '' THEN NULL ELSE @trainUnhookIndex END
)


END