--// Insert Update Delete Store Procedure

CREATE PROC [dbo].[udp_Admin_ups]

	@Id INT,
	@AdminId uniqueidentifier,
	@EmailId nvarchar(250),
	@Username nvarchar(250),
	@PasswordHash nvarchar(250),
	@HostIp nvarchar(250),
	@CreatedBy uniqueidentifier,
	@CreationDate datetime,
	@UpdatedBy uniqueidentifier,
	@UpdatedDate datetime,
	@IsActive bit,
	@IsDeleted bit
AS
SET NOCOUNT ON
IF @Id = 0 BEGIN
	INSERT INTO Admin (

		[AdminId],

		[EmailId],

		[Username],

		[PasswordHash],

		[HostIp],

		[CreatedBy],

		[CreationDate],

		[UpdatedBy],

		[UpdatedDate],

		[IsActive],

		[IsDeleted]
	)
	VALUES (

		@AdminId,

		@EmailId,

		@Username,

		@PasswordHash,

		@HostIp,

		@CreatedBy,

		@CreationDate,

		@UpdatedBy,

		@UpdatedDate,

		@IsActive,

		@IsDeleted
	)
	SELECT @AdminId As InsertedID
END
ELSE BEGIN
	UPDATE Admin SET 

		[AdminId] = @AdminId,

		[EmailId] = @EmailId,

		[Username] = @Username,

		[PasswordHash] = @PasswordHash,

		[HostIp] = @HostIp,

		[CreatedBy] = @CreatedBy,

		[CreationDate] = @CreationDate,

		[UpdatedBy] = @UpdatedBy,

		[UpdatedDate] = @UpdatedDate,

		[IsActive] = @IsActive,

		[IsDeleted] = @IsDeleted
	WHERE AdminId = @AdminId
 SELECT @AdminId

END

SET NOCOUNT OFF

GO


--// Get All List Query
CREATE PROC [dbo].[udp_Admin_lst]
AS
SET NOCOUNT ON

SELECT [Id], 
	[AdminId], 
	[EmailId], 
	[Username], 
	[PasswordHash], 
	[HostIp], 
	[CreatedBy], 
	[CreationDate], 
	[UpdatedBy], 
	[UpdatedDate], 
	[IsActive], 
	[IsDeleted]
FROM Admin WHERE [IsDeleted]=0 
SET NOCOUNT OFF
GO


--// Select Query
CREATE PROC [dbo].[udp_Admin_sel]
	@Id UNIQUEIDENTIFIER
AS
SET NOCOUNT ON

SELECT [Id], 
	[AdminId], 
	[EmailId], 
	[Username], 
	[PasswordHash], 
	[HostIp], 
	[CreatedBy], 
	[CreationDate], 
	[UpdatedBy], 
	[UpdatedDate], 
	[IsActive], 
	[IsDeleted]
FROM Admin
WHERE [IsDeleted]=0 and AdminId = @Id
SET NOCOUNT OFF
GO


--// Delete Query
CREATE PROC [dbo].[udp_Admin_del]
	@Id int
AS
SET NOCOUNT ON
UPDATE Admin
SET [IsDeleted]=1 WHERE [Id] = @Id
SET NOCOUNT OFF
GO


--// Pageinagion Query
CREATE PROC [dbo].[udp_Admin_lstpage]
 (
@pageNum INT, @pageSize INT, @TotalRecords INT NULL OUTPUT ) 
AS
SET NOCOUNT ON;

WITH PagingCTE AS
    ( SELECT [Id], 
	[AdminId], 
	[EmailId], 
	[Username], 
	[PasswordHash], 
	[HostIp], 
	[CreatedBy], 
	[CreationDate], 
	[UpdatedBy], 
	[UpdatedDate], 
	[IsActive], 
	[IsDeleted]
, ROW_NUMBER() OVER (ORDER BY [Id]) AS RowNumber FROM Admin WITH(NOLOCK)  WHERE [IsDeleted]=0 
 
 )SELECT PagingCTE.* FROM PagingCTE WHERE RowNumber BETWEEN (@pageNum - 1) * @pageSize + 1 AND @pageNum * @pageSize;
Select @TotalRecords = Count([Id]) FROM Admin WITH(NOLOCK) WHERE [IsDeleted]=0 
SET NOCOUNT OFF
GO
