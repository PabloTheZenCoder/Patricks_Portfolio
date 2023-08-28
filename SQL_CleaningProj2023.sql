/* Data Cleaning in SQL Project
   I used the "Nashville Housing Data for Data Cleaning" dataset provided by AlecTheAnalyst's github
   I included that CSV dataset in my Portfolio_Projects_Datasets repository
   I created a database in Azure Data Studio titled "SQL Cleaning" where I uploaded this CSV file

   Skills used: Join; CTE;functions:ISNULL, Substring, Charindex, Parsename, count; Expressions: Case; Statements: Alter, Update
    */

/*Simply looking at the data*/
select *
from [SQL Cleaning ].dbo.[Nashville Housing Data for Data Cleaning]

/*Populate Property Address Data*/
/* Where column "PropertyAddress" is null, replace with the corresponding duplicate property address*/
/*Eventually we will delete these duplicates */
select *
from [SQL Cleaning ].dbo.[Nashville Housing Data for Data Cleaning]
--where propertyAddress is null
order by ParcelID

/* Using the ISNULL Function and a self Join to populate 'null' values in the PropertyAddress Column*/
select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
From [SQL Cleaning ].dbo.[Nashville Housing Data for Data Cleaning] a 
join [SQL Cleaning ].dbo.[Nashville Housing Data for Data Cleaning] b   
    on a.ParcelID =b.ParcelID   
    and a.UniqueID <> b.UniqueID
where a.PropertyAddress is NULL

update a
set PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
From [SQL Cleaning ].dbo.[Nashville Housing Data for Data Cleaning] a 
join [SQL Cleaning ].dbo.[Nashville Housing Data for Data Cleaning] b   
    on a.ParcelID =b.ParcelID   
    and a.UniqueID <> b.UniqueID
where a.PropertyAddress is NULL

------------------------------------------------------------------------------------------------------------------------------
--breaking out Address into Individual Columns (address, City, State)

select PropertyAddress
from [SQL Cleaning ].dbo.[Nashville Housing Data for Data Cleaning]
--where propertyAddress is null
--order by ParcelID

/*Using the substring and CharIndex function to separate the property address into separate columns for address and city */
SELECT
substring(propertyAddress,1, CHARINDEX(',',PropertyAddress)-1) as Address,
substring(propertyAddress,CHARINDEX(',',PropertyAddress) +1, len(PropertyAddress)) as Address
from [SQL Cleaning ].dbo.[Nashville Housing Data for Data Cleaning]

Alter Table [SQL Cleaning ].dbo.[Nashville Housing Data for Data Cleaning]
add PropertySplitAddress Nvarchar(255);

Update [SQL Cleaning ].dbo.[Nashville Housing Data for Data Cleaning]
set PropertySplitAddress = substring(propertyAddress,1, CHARINDEX(',',PropertyAddress)-1)

Alter Table [SQL Cleaning ].dbo.[Nashville Housing Data for Data Cleaning]
add PropertySplitcity Nvarchar(255);

Update [SQL Cleaning ].dbo.[Nashville Housing Data for Data Cleaning]
set PropertySplitcity = substring(propertyAddress,CHARINDEX(',',PropertyAddress) +1, len(PropertyAddress))



/* Using an easier method, i.e the parsename function to separate OwnerAddress into address, city, state columns*/

select 
PARSENAME(Replace(OwnerAddress, ',','.') , 3)
,PARSENAME(Replace(OwnerAddress, ',','.') , 2)
,PARSENAME(Replace(OwnerAddress, ',','.') , 1)
from [SQL Cleaning ].dbo.[Nashville Housing Data for Data Cleaning]

Alter Table [SQL Cleaning ].dbo.[Nashville Housing Data for Data Cleaning]
add OwnerSplitAddress Nvarchar(255);

Update [SQL Cleaning ].dbo.[Nashville Housing Data for Data Cleaning]
set OwnerSplitAddress = PARSENAME(Replace(OwnerAddress, ',','.') , 3)

Alter Table [SQL Cleaning ].dbo.[Nashville Housing Data for Data Cleaning]
add OwnerSplitCity Nvarchar(255);

Update [SQL Cleaning ].dbo.[Nashville Housing Data for Data Cleaning]
set OwnerSplitCity = PARSENAME(Replace(OwnerAddress, ',','.') , 2)

Alter Table [SQL Cleaning ].dbo.[Nashville Housing Data for Data Cleaning]
add OwnerSplitState Nvarchar(255);

Update [SQL Cleaning ].dbo.[Nashville Housing Data for Data Cleaning]
set OwnerSplitState = PARSENAME(Replace(OwnerAddress, ',','.') , 1)

----------------------------------------------------------------------------------------------------------------------------------------------------------------
/*Change Y and N to Yes and No in "Sold As Vacant" Column*/

/*Using the count function to see how many rows use Y, N, Yes, No */
select Distinct(SoldAsVacant), COUNT(SoldAsVacant)
from [SQL Cleaning ].dbo.[Nashville Housing Data for Data Cleaning]
group by SoldAsVacant
order by 2

/*Using the Case function to change 'Y' and 'N' rows to 'Yes' and 'No' */
select SoldASVacant
, CASE When SoldAsVacant = 'Y' Then 'Yes'
        When SoldAsVacant = 'N' Then 'No'
        Else SoldAsVacant
        END
        from [SQL Cleaning ].dbo.[Nashville Housing Data for Data Cleaning]


Update [SQL Cleaning ].dbo.[Nashville Housing Data for Data Cleaning]
set SoldAsVacant = CASE When SoldAsVacant = 'Y' Then 'Yes'
        When SoldAsVacant = 'N' Then 'No'
        Else SoldAsVacant
        END

------------------------------------------------------------------------------------------------------------------------------------------------------
    /* Remove Duplicates using a CTE, aka temporary table*/
   With RowNumCTE As(
    SELECT *, 
        ROW_NUMBER() over (
            Partition by ParcelID,
                         PropertyAddress,
                         SalePrice,
                         SaleDate,
                         LegalReference
                         Order by 
                         UniqueID ) row_num
from [SQL Cleaning ].dbo.[Nashville Housing Data for Data Cleaning]
--order by ParcelID
)
--Delete
Select *
From RowNumCTE
where row_num > 1
--order by PropertyAddress

-----------------------------------------------------------------------------------------------------------------------------------------------------------
/* Delete Unused Columns*/

ALTER Table [SQL Cleaning ].dbo.[Nashville Housing Data for Data Cleaning]
Drop Column OwnerAddress, TaxDistrict, PropertyAddress

