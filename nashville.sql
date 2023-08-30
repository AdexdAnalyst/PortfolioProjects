
use Housing

Select *
From dbo.Nashville_Housing

--------------------------------------------------------------------------------------------------------------------------

-- Standardize Date Format


Select Sale_DateConverted, CONVERT(Date,Sale_Date)
From dbo.Nashville_Housing


Update Nashville_Housing
SET Sale_Date = CONVERT(Date,SaleDate)

-- If it doesn't Update properly

ALTER TABLE Nashville_Housing
Add Sale_DateConverted Date;

Update Nashville_Housing
SET Sale_DateConverted = CONVERT(Date,Sale_Date)

Select Sale_DateConverted
From dbo.Nashville_Housing


 --------------------------------------------------------------------------------------------------------------------------

-- Populate Property Address data

Select *
From dbo.Nashville_Housing --where property_Address is null
order by Parcel_id

ALTER TABLE Nashville_Housing
Add Unique_id int 

Update Nashville_Housing
SET Unique_id = CONVERT(int,Unnamed_0)

Select *
From dbo.Nashville_Housing
Where Property_Address is null
order by parcel_id



Select a.Parcel_ID, a.Property_Address, b.Parcel_ID, b.Property_Address, ISNULL(a.Property_Address,b.Property_Address)
From dbo.Nashville_Housing a
JOIN dbo.Nashville_Housing b
	on a.Parcel_ID = b.Parcel_ID
	AND a.[Unique_ID ] <> b.[Unique_ID ]
Where a.Property_Address is null


Update a
SET Property_Address = ISNULL(a.Property_Address,b.Property_Address)
From dbo.Nashville_Housing a
JOIN dbo.Nashville_Housing b
	on a.Parcel_ID = b.Parcel_ID
	AND a.[Unique_ID ] <> b.[Unique_ID ]
Where a.Property_Address is null


--------------------------------------------------------------------------------------------------------------------------

-- Breaking out Address into Individual Columns (Address, City, State)


Select Property_Address
From dbo.Nashville_Housing
--Where PropertyAddress is null
--order by ParcelID

SELECT
SUBSTRING(Property_Address, 1, CHARINDEX(',', Property_Address) -1 ) as Address
, SUBSTRING(Property_Address, CHARINDEX(',', Property_Address) + 1 , LEN(Property_Address)) as Address

From dbo.Nashville_Housing


ALTER TABLE Nashville_Housing
Add Property_Address Nvarchar(255);

Update Nashville_Housing
SET Property_Address = SUBSTRING(Property_Address, 1, CHARINDEX(',', Propert_yAddress) -1 )


ALTER TABLE NashvilleHousing
Add Property_City Nvarchar(255);

Update Nashville_Housing
SET Property_City = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress))




Select *
From dbo.Nashville_Housing





Select Owner_Address
From dbo.Nashville_Housing


Select
PARSENAME(REPLACE(Owner_Address, ',', '.') , 3)
,PARSENAME(REPLACE(Owner_Address, ',', '.') , 2)
,PARSENAME(REPLACE(Owner_Address, ',', '.') , 1)
From dbo.Nashville_Housing



ALTER TABLE Nashville_Housing
Add Address Nvarchar(255);

Update Nashville_Housing
SET Address = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)


ALTER TABLE Nashville_Housing
Add City Nvarchar(255);

Update Nashville_Housing
SET City = PARSENAME(REPLACE(Owner_Address, ',', '.') , 2)



ALTER TABLE Nashville_Housing
Add State Nvarchar(255);

Update Nashville_Housing
SET State = PARSENAME(REPLACE(Owner_Address, ',', '.') , 1)



Select *
From dbo.Nashville_Housing




--------------------------------------------------------------------------------------------------------------------------


-- Change Y and N to Yes and No in "Sold as Vacant" field


Select Distinct(Sold_As_Vacant), Count(Sold_As_Vacant)
From dbo.Nashville_Housing
Group by Sold_As_Vacant
order by 2




Select Sold_As_Vacant
, CASE When Sold_As_Vacant = 'Y' THEN 'Yes'
	   When Sold_As_Vacant = 'N' THEN 'No'
	   ELSE Sold_As_Vacant
	   END
From dbo.Nashville_Housing


Update Nashville_Housing
SET Sold_As_Vacant = CASE When Sold_As_Vacant = 'Y' THEN 'Yes'
	   When Sold_As_Vacant = 'N' THEN 'No'
	   ELSE Sold_As_Vacant
	   END






-----------------------------------------------------------------------------------------------------------------------------------------------------------

-- Remove Duplicates
WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY Parcel_ID,
				 Property_Address,
				 Sale_Price,
				 Sale_Date,
				 Legal_Reference
				 ORDER BY
					Unique_ID
					) row_num

From dbo.Nashville_Housing
--order by ParcelID
)
Select *
From RowNumCTE
Where row_num > 1
Order by Property_Address

WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY Parcel_ID,
				 Property_Address,
				 Sale_Price,
				 Sale_Date,
				 Legal_Reference
				 ORDER BY
					Unique_ID
					) row_num

From dbo.Nashville_Housing
--order by ParcelID
)
Delete
From RowNumCTE
Where row_num > 1
--Order by Property_Address



Select *
From dbo.Nashville_Housing




---------------------------------------------------------------------------------------------------------

-- Delete Unused Columns


Select *
From dbo.Nashville_Housing


ALTER TABLE dbo.Nashville_Housing
DROP COLUMN Owner_Address, Tax_District, Property_Address, Sale_Date







