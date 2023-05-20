--Cleaning data in SQL Queries

select *
from Datacleaningproject.dbo.housingdata


--Here i will be seperating SaleTime from SaleDate

select SaleDateConverted, convert(date, SaleDate) As SaleDate
from Datacleaningproject.dbo.housingdata

ALTER TABLE  housingdata
add SaleDateConverted Date

Update housingdata
SET SaleDateConverted = convert(Date, SaleDate)


-- Here we will be populating address where properties address is null

select *
from Datacleaningproject.dbo.housingdata
order by ParcelID


-- Here we will join and replace property addresses with the culunm where properties address is NULl

select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
from Datacleaningproject.dbo.housingdata a
join Datacleaningproject.dbo.housingdata b
on a.ParcelID = b.ParcelID
And a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

update a
set PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
from Datacleaningproject.dbo.housingdata a
join Datacleaningproject.dbo.housingdata b
on a.ParcelID = b.ParcelID
And a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

select *
from Datacleaningproject.dbo.housingdata
where PropertyAddress is null

select *
from Datacleaningproject.dbo.housingdata
where PropertyAddress is not null

-- Here i will be seperating propertyaddress, city, and state into different column

select PropertyAddress
from Datacleaningproject.dbo.housingdata

select
SUBSTRING (PropertyAddress,1, CHARINDEX(',', PropertyAddress)-1) AS Address
, SUBSTRING (PropertyAddress, CHARINDEX(',', PropertyAddress)+1 , LEN(PropertyAddress)) AS City
from Datacleaningproject.dbo.housingdata

ALTER TABLE  housingdata
add PropertySplitAddress Nvarchar(255);

Update housingdata
SET PropertySplitAddress = SUBSTRING (PropertyAddress,1, CHARINDEX(',', PropertyAddress)-1)

ALTER TABLE  housingdata
add PropertySplitCity  Nvarchar(255);

Update housingdata
SET PropertySplitCity =SUBSTRING (PropertyAddress, CHARINDEX(',', PropertyAddress)+1 , LEN(PropertyAddress))

select SoldAsVacant
from Datacleaningproject.dbo.housingdata

--Here we change Y and N to Yes and No 'sold as vacant' field using case statement

select Distinct(SoldAsVacant), count(SoldAsVacant) As Number_as_Vacant
from Datacleaningproject.dbo.housingdata
group by SoldAsVacant
order by Number_as_Vacant

select SoldAsVacant,
CASE 
    when SoldAsVacant = 'Y' Then 'YES'
	When SoldAsVacant = 'N' Then 'NO'
	Else SoldAsVacant
END As SoldAsVacant
from Datacleaningproject.dbo.housingdata

update Datacleaningproject.dbo.housingdata
set SoldAsVacant =
CASE 
    when SoldAsVacant = 'Y' Then 'YES'
	When SoldAsVacant = 'N' Then 'NO'
	Else SoldAsVacant
END 


-- Here we will be removing dublicate from the data using CTE

with row_numberCTE AS(
select *,
ROW_NUMBER() OVER(partition by
parcelID,
PropertyAddress,
SaleDate,
SalePrice,
LegalReference
order by UniqueID
) row_number
from Datacleaningproject.dbo.housingdata
)

--delete
--from row_numberCTE
--where row_number > 1

select *
from row_numberCTE
where row_number > 1
order by PropertyAddress

--Note it is not always advicable to do this to raw data from database for best practice

-- Here we will be removing unused column from the data

select * 
from Datacleaningproject.dbo.housingdata
order by 2,3

ALTER TABLE Datacleaningproject.dbo.housingdata
DROP COLUMN OwnerAddress, PropertyAddress, TaxDistrict, SaleDate

-- Here will be update Housing data where OwenerName are Null

update housingdata
set OwnerName = 'Felix Ehis osawaru'
where OwnerName is NUll 



