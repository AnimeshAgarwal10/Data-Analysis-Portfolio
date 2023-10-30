--Cleaning Data using SQL queries
-------------------------------------------------------------------------
Select *
from [SQL portfolio]..NashvilleHousing

--Standardizing Sale date

Select SaleDateConverted --CONVERT(Date,SaleDate)
from [SQL portfolio]..NashvilleHousing

--Update NashvilleHousing set SaleDate=CONVERT(Date,SaleDate)

Alter table NashvilleHousing add SaleDateConverted date;
Update NashvilleHousing set SaleDateConverted = CONVERT(Date,SaleDate)

-------------------------------------------------------------------------

--Populate Property Address data(Replace NULL addresses with references from matching parcel IDs)


--Select *
--from [SQL portfolio]..NashvilleHousing
--where PropertyAddress is null

Select a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress--, ISNULL(a.PropertyAddress, b.PropertyAddress)
from [SQL portfolio]..NashvilleHousing a
Join [SQL portfolio]..NashvilleHousing b
	on a.ParcelID=b.ParcelID
	AND a.[UniqueID ]<> b.[UniqueID ]
where a.PropertyAddress is null

Update a
Set PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
from [SQL portfolio]..NashvilleHousing a
Join [SQL portfolio]..NashvilleHousing b
	on a.ParcelID=b.ParcelID
	AND a.[UniqueID ]<> b.[UniqueID ]
where a.PropertyAddress is null


-------------------------------------------------------------------------
--Breaking out property address into INdividual columns(Address,City,State)
 
Select *
from [SQL portfolio]..NashvilleHousing
where PropertyAddress is null

SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 ) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress)) as Address
From [SQL portfolio]..NashvilleHousing


ALTER TABLE NashvilleHousing
Add PropertySplitAddress Nvarchar(255);

Update NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 )


ALTER TABLE NashvilleHousing
Add PropertySplitCity Nvarchar(255);

Update NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress))






Select OwnerAddress
From [SQL portfolio]..NashvilleHousing

Select
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)
From [SQL portfolio]..NashvilleHousing


ALTER TABLE NashvilleHousing
Add OwnerSplitAddress Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)


ALTER TABLE NashvilleHousing
Add OwnerSplitCity Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)



ALTER TABLE NashvilleHousing
Add OwnerSplitState Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)

-------------------------------------------------------------------------
-- Change Y and N to Yes and No in "Sold as Vacant" field

Select Distinct(SoldAsVacant), count(SoldAsVacant)
From [SQL portfolio]..NashvilleHousing
Group by SoldAsVacant
order by 2




Select SoldAsVacant
, CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END
From [SQL portfolio]..NashvilleHousing


Update [SQL portfolio]..NashvilleHousing
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END



-------------------------------------------------------------------------
-- Delete Unused Columns

Select *
From [SQL portfolio]..NashvilleHousing


ALTER TABLE [SQL portfolio]..NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate



