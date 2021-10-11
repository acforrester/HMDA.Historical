# Historical Data from the Home Mortgage Disclosure Act (HMDA)

## Contents

1. [Introduction](#introduction)
2. [Data Description](#data-Description)
3. [Cleaning Methodology](#cleaning-methodology)
4. [Codebooks](#codebooks)
5. [Citation](#citation)

## Introduction

This repository aims to provide historical mortgage lending data pursuant to the Home Mortgage Disclosure Act (HMDA, [12 USC &sect; 29](https://www.law.cornell.edu/uscode/text/12/chapter-29)).

These data are provided *as-is* [here](https://doi.org/10.3886/E151921V1) in order to further discussion in U.S. housing policy and the economics literature.

Data on American housing are as important as ever in current public policy debates. My goal is to advance these debates by making historical data accessible and wide open for researchers.

If these data are helpful to you or if you notice any errors, please drop me a line. As the great people at IPUMS decry: use it for good!

## Data Description

The data provided are a lightly cleaned copy of the HMDA data spanning (for now) 1981-2006.  It is important to note that HMDA reporting and data release standards over this time period changed substantially. In addition, the geographies represented and financial institutions reporting changed as well. It is important to take these changes into consideration in any analysis of the HMDA data over time. Given these caveats, my objective is to provide these the HMDA data in an easily accessible, machine-readable format (pipe `|` delimited).

#### Table 1. Data Availability by Reporting Year
| Reporting Year | Tabular | LAR | Panel | Transmittal Sheet | Lowest Unit |
| :------------- | :------ | :-- | :---- | :---------------- | :---------- |
| 1981  | X |   |   |   | Tract    |
| 1982  | X |   |   |   | Tract    |
| 1983  | X |   |   |   | Tract    |
| 1984  | X |   |   |   | Tract    |
| 1985  | X |   |   |   | Tract    |
| 1986  | X |   |   |   | Tract    |
| 1987  | X |   |   |   | Tract    |
| 1988  | X |   |   |   | Tract    |
| 1989  | X |   |   |   | Tract    |
| 1990  |   | X | X | X | Borrower |
| 1991  |   | X | X | X | Borrower |
| 1992  |   | X | X | X | Borrower |
| 1993  |   | X | X | X | Borrower |
| 1994  |   | X | X | X | Borrower |
| 1995  |   | X | X | X | Borrower |
| 1996  |   | X | X | X | Borrower |
| 1997  |   | X | X | X | Borrower |
| 1998  |   | X | X | X | Borrower |
| 1999  |   | X | X | X | Borrower |
| 2000  |   | X | X | X | Borrower |
| 2001  |   | X | X | X | Borrower |
| 2002  |   | X | X | X | Borrower |
| 2003  |   | X | X | X | Borrower |
| 2004  |   | X | X | X | Borrower |
| 2005  |   | X | X | X | Borrower |
| 2006  |   | X | X | X | Borrower |

## Cleaning Methodology

### 1981-1989 Data

The 1981-1989 HMDA are from the ASCII-converted files published by the National Archives.  These data are the least detailed HMDA data available and are only tabulated by reporting year, lending institution (mortgage companies of bank holding companies were added in 1988), and census tract.

These data are provided as-is.  I have not yet performed any data validation steps to examine the quality of these data. There are various "validity flags" in the data to identify whether the tract information is valid, within a tolerance, zero, or invalid.  Pending a deeper evaluation of these data, I highly recommend consulting these fields when performing any analyses using the older HMDA data.

Further, some of the ASCII characters did not carry over properly when converted by the National Archives.  In these cases you will see bank names listed as `[non-standard characters   ]`; however, the banks still have a reported `respondent_id`. I will perform further analyses to match the `respondent_id` for each missing bank to its proper name in the future.

For each year I did my best to harmonise the variable names to easily match and append each file.  Unfortunately, the 1981-1989 HMDA data structure is substantially different than the future data and the data are tabulated above the borrower level (in contrast to later HMDA releases).  In these years I applied a simple nomenclature to the tabular data fields that work with naming requirements in other statistical software.

### 1990-2006 Data

1990 saw the first restricted release of the HMDA Loan/Application Register (LAR).  The LAR contains detail information about loan applications, their details, their ultimate outcomes, the underlying applicants/borrowers, and the underlying properties.  Since 1990, HMDA provides an incredible degree of detail on home mortgage loans at very fine levels of geography, namely the census tract.  Properties corresponding to each loan application are coded to census tracts.  Census tract numbers are assigned by the Census Bureau and financial institutions reporting HMDA data are instructed as to which which decennial census tract numbering scheme to use, i.e. the 1980 Census, 1990 Census, etc.  It is important to read the documentation to know which tract numbering scheme is employed in each HMDA reporting year.

The 1990-onwards HMDA data also provide detailed information of the financial instituions that reported HMDA data.  These data are provided in two sources: the transmittal sheet (TS) and reporter panel (panel).  These information sheets provide information on each HMDA respondent, such as the institution's office location, federal tax ID, and Federal Reserve `RSSD_ID`.  These data help link the HMDA data to additional data sources, such as the Call Reports, Community Reinvestment Act (CRA) disclosure data, Summary of Deposits (SOD) branch location data, Small Business Administration 7(a) (SBA) lending data, etc.

#### Table 2. Census Tract Delineations by HMDA Reporting Year
| Reporting Year | Delineations |
| :------------- | :----------- |
| 1981-1993      | 1980 Census  |
| 1994-2003      | 1990 Census  |
| 2004-2006      | 2000 Census  |

## Codebooks
Please see the documentation for the variable fields and codes [here](docs/).

## Citation
Please cite the data:

Forrester, Andrew C. Historical Home Mortgage Disclosure Act (HMDA) Data. Ann Arbor, MI: Inter-university Consortium for Political and Social Research [distributor], 2021-10-10. [https://doi.org/10.3886/E151921V1](https://doi.org/10.3886/E151921V1)
