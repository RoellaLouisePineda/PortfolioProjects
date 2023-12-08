-- Cleaning Data in SQL Queries

-- Viewing all the whole data

SELECT *
FROM PortfolioProject.dbo.NashvilleHousing



-- Standardized Date Format

SELECT SaleDate, CONVERT(Date, SaleDate)
FROM PortfolioProject.dbo.NashvilleHousing

UPDATE NashvilleHousing
SET SaleDate = CONVERT(Date, SaleDate)

-- Double Check if it was converted

SELECT SaleDate
FROM PortfolioProject.dbo.NashvilleHousing


-- If UPDATE command having issues use ALTER TABLE

ALTER TABLE NashvilleHousing 
ADD SaleDateConverted Date;

UPDATE NashvilleHousing
SET SaleDateConverted = CONVERT(Date, SaleDate)

-- Double Check if it was converted


SELECT SaleDate, SaleDateConverted
FROM PortfolioProject.dbo.NashvilleHousing



-- Populate Property Address Data

SELECT PropertyAddress
FROM PortfolioProject.dbo.NashvilleHousing

-- Populate Property Address Data that is NULL

SELECT PropertyAddress
FROM PortfolioProject.dbo.NashvilleHousing
WHERE PropertyAddress is NULL

-- Populate Property Address Data that is NULL and the context

SELECT *
FROM PortfolioProject.dbo.NashvilleHousing
WHERE PropertyAddress is NULL


SELECT *
FROM PortfolioProject.dbo.NashvilleHousing
-- WHERE PropertyAddress is NULL
ORDER BY ParcelID


-- Self JOIN the table to figure out the Property Address to the NULL values


SELECT a.ParcelID, a. PropertyAddress, b.ParcelID, b. PropertyAddress
FROM PortfolioProject.dbo.NashvilleHousing a
JOIN PortfolioProject.dbo.NashvilleHousing b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress is null


-- Preview: Populate the NULL values with the Property Address using ISNULL
-- Used this script for double checking after the UPDATE below

SELECT a.ParcelID, a. PropertyAddress, b.ParcelID, b. PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM PortfolioProject.dbo.NashvilleHousing a
JOIN PortfolioProject.dbo.NashvilleHousing b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress is null

-- Populate the NULL values with the Property Address using ISNULL
-- ISNULL COMMAND
-- When using UPDATE make sure to use alias or an error will appear

UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM PortfolioProject.dbo.NashvilleHousing a
JOIN PortfolioProject.dbo.NashvilleHousing b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress is null



-- Breaking out Address into Individual Columns (Address, City, State)

SELECT PropertyAddress
FROM PortfolioProject.dbo.NashvilleHousing
-- WHERE PropertyAddress is NULL
-- ORDER BY ParcelID


-- Breaking up the addresses using the delimiter,substring, and character index/char index
-- Delimiter is a separator of columns or values such as a comma


SELECT 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)) as Address

FROM PortfolioProject.dbo.NashvilleHousing


-- Looking at just the CHAR INDEX
-- Numbers shows position of the comma

SELECT 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)) as Address,
CHARINDEX(',', PropertyAddress)

FROM PortfolioProject.dbo.NashvilleHousing


-- Removing the comma by adding "-1" after the Property Address 

SELECT 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) as Address

FROM PortfolioProject.dbo.NashvilleHousing


-- We are not starting at the first position ("1" after the Property Address) 
-- We are starting at the position after the comma to the end of the "PropertyAddress" column which is why we add "+1"

SELECT 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) as Address,
SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress)) as Address

FROM PortfolioProject.dbo.NashvilleHousing


-- Creating 2 new columns since we can't separate 2 values into 1 column
-- Change DATE to NVARCHAR to store string data
-- NVARCHAR "255" is the limit so it can store a large string


ALTER TABLE NashvilleHousing 
ADD PropertySplitAddress NVARCHAR(255);

UPDATE NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1)



ALTER TABLE NashvilleHousing 
ADD PropertySplitCity  NVARCHAR(255);

UPDATE NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress))



-- Troubleshot: Changed NashvilleHousing to the full name "PortfolioProject.dbo.NashvilleHousing" b/c of error

ALTER TABLE PortfolioProject.dbo.NashvilleHousing 
ADD PropertySplitAddress NVARCHAR(255);

UPDATE PortfolioProject.dbo.NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1)



ALTER TABLE PortfolioProject.dbo.NashvilleHousing 
ADD PropertySplitCity  NVARCHAR(255);

UPDATE PortfolioProject.dbo.NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress))




-- Double Check the new columns were added

SELECT *
FROM PortfolioProject.dbo.NashvilleHousing


-- Using another method, possibly simplier method, to separate the addresses again 
-- Separating the Owner Address this time, using PARSENAME instead of SUBSTRING

SELECT OwnerAddress
FROM PortfolioProject.dbo.NashvilleHousing


-- PARSENAME looks for periods not commas so use REPLACE 

SELECT
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)
FROM PortfolioProject.dbo.NashvilleHousing

-- PARSENAME kind of displays columns backwards as results will show below
-- Results shows from left to right "STATE, City, Address" such as "TN, Nashville, 123 Address Dr."


SELECT
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1),
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2),
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3)
FROM PortfolioProject.dbo.NashvilleHousing


-- BUT we want the results from left to right to show "Address, City, STATE" such as "123 Address Dr. TN, Nashville"
-- We will replace the order of the numbers 1,2,3 to 3,2,1 as shown below


SELECT
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3),
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2),
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)
FROM PortfolioProject.dbo.NashvilleHousing


-- Adding new columns and values of OwnerSplitAddress, OwnerSplitCity, and OwnerSplitState


ALTER TABLE PortfolioProject.dbo.NashvilleHousing 
ADD OwnerSplitAddress NVARCHAR(255);

UPDATE PortfolioProject.dbo.NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3)



ALTER TABLE PortfolioProject.dbo.NashvilleHousing 
ADD OwnerSplitCity  NVARCHAR(255);

UPDATE PortfolioProject.dbo.NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2)



ALTER TABLE PortfolioProject.dbo.NashvilleHousing 
ADD OwnerSplitState  NVARCHAR(255);

UPDATE PortfolioProject.dbo.NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)


-- Double Check the new columns were added

SELECT *
FROM PortfolioProject.dbo.NashvilleHousing



-- Change Y and N to Yes and No in "SoldAsVacant" field
-- Viewing the SoldAsVacant column

SELECT DISTINCT (SoldAsVacant)
FROM PortfolioProject.dbo.NashvilleHousing


-- Viewing the count of N, Yes, Y, No 

SELECT DISTINCT (SoldAsVacant), COUNT(SoldAsVacant)
FROM PortfolioProject.dbo.NashvilleHousing
GROUP BY SoldAsVacant
ORDER BY 2


-- Using a CASE Statement to change Y and N to Yes and No in "SoldAsVacant" field
-- Testing the CASE Statement through SELECT command

SELECT SoldAsVacant,
	CASE When SoldAsVacant = 'Y' THEN 'Yes'
		 When SoldAsVacant = 'N' THEN 'No'
		 ELSE SoldAsVacant
		 END
FROM PortfolioProject.dbo.NashvilleHousing


-- Updating NashvilleHousing using the CASE statement


UPDATE PortfolioProject.dbo.NashvilleHousing
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
						When SoldAsVacant = 'N' THEN 'No'
						ELSE SoldAsVacant
						END
						FROM PortfolioProject.dbo.NashvilleHousing



-- Double checking the update results


SELECT DISTINCT (SoldAsVacant), COUNT(SoldAsVacant)
FROM PortfolioProject.dbo.NashvilleHousing
GROUP BY SoldAsVacant
ORDER BY 2


-- Remove Duplicates

-- Creating Temp Table using CTE to find duplicates

WITH RowNumCTE AS (
SELECT *,
	ROW_NUMBER () OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
					ORDER BY
						UniqueID
						) row_num

FROM PortfolioProject.dbo.NashvilleHousing
-- ORDER BY ParcelID
)

SELECT *
FROM RowNumCTE
WHERE row_num > 1
ORDER BY PropertyAddress


-- Deleting Duplicates

WITH RowNumCTE AS (
SELECT *,
	ROW_NUMBER () OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
					ORDER BY
						UniqueID
						) row_num

FROM PortfolioProject.dbo.NashvilleHousing
-- ORDER BY ParcelID
)

DELETE
FROM RowNumCTE
WHERE row_num > 1


-- Double Check that the duplicates were deleted 


WITH RowNumCTE AS (
SELECT *,
	ROW_NUMBER () OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
					ORDER BY
						UniqueID
						) row_num

FROM PortfolioProject.dbo.NashvilleHousing
-- ORDER BY ParcelID
)

SELECT *
FROM RowNumCTE
WHERE row_num > 1
ORDER BY PropertyAddress



-- Viewing the whole dataset
-- Also using this query to double check deleted columns


SELECT *
FROM PortfolioProject.dbo.NashvilleHousing


-- Delete Unused Columns to clean data


ALTER TABLE PortfolioProject.dbo.NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress


ALTER TABLE PortfolioProject.dbo.NashvilleHousing
DROP COLUMN SaleDate