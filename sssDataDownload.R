# ============================================================================ #
#
# Download monthly RSS SMAP Level 3 Sea Surface Salinity Standard Mapped Image
# Monthly V4.0 Validated Dataset from NASA JPL PODAAC:
# https://podaac.jpl.nasa.gov/dataset/SMAP_RSS_L3_SSS_SMI_MONTHLY_V4#
#
# ============================================================================ #

# Libraries
# install.packages(c("devtools", "terra"))
# devtools::install_github("boettiger-lab/earthdatalogin")
library(earthdatalogin)
library(terra)

# Use this to set Earthdata authorization credentials the first time. Replace
# "user" with your Earthdata account username and "password" with your password.
# Recommend deleting your login credentials from this RScript once this is run
# successfully.
# earthdatalogin::edl_netrc(
#   username = "user", # add your user name
#   password = "password" # add you password
# )
# This information will be saved to a `netrc` file stored here:
# earthdatalogin::edl_netrc_path()

# Authenticate using the `netrc` file created above
earthdatalogin::edl_netrc()

# Define the data we want. Using a bounding box to limit the amount of data we
# download and the corresponding file sizes
short_name <- "SMAP_RSS_L3_SSS_SMI_MONTHLY_V4"
bbox <- c(ymin = -84.5,
          ymax = -75.0,
          xmin = 33.5,
          xmax = 37.0)

# Fetch the data from the S3 cloud bucket
results <- earthdatalogin::edl_search(
  short_name = short_name,
  bounding_box = paste(bbox,collapse=","))

# Download the data to working directory (change if desired)
outDir <- getwd()
for (result in results) {
  fname <- basename(result)
  earthdatalogin::edl_download(
    result,
    dest = file.path(outDir, fname))
}

# ============================================================================ #
# Work in the cloud instead of downloading - THIS DOES NOT WORK YET
# Error: [rast] file does not exist: /vsicurl/https://archive.podaac.earthdata.nasa.gov/podaac-ops-cumulus-protected/SMAP_RSS_L3_SSS_SMI_MONTHLY_V4/RSS_smap_SSS_L3_monthly_2015_04_FNL_v04.0.nc
# In addition: Warning message:
#  Opening a /vsi file with the netCDF driver requires Linux userfaultfd to be
#  available. Or you may set the GDAL_SKIP=netCDF configuration option to force
#  the use of the HDF5 driver. (GDAL error 1)

# Re-authenticate (just in case)
earthdatalogin::edl_netrc()
ras <- terra::rast(x = results[1], vsi=TRUE)
plot(ras)

# Tried:
# - Reauthenticating in case of timeout
# - Reinstalling "terra" using RStudio package installer
# - Accepting all EULAs at https://urs.earthdata.nasa.gov/home
# - Setting `Sys.setenv(GDAL_SKIP = "netCDF")` as in the Warning

# Windows 10 Enterprise
# R version 4.4.1
# RStudio 2024.04.2+764 "Chocolate Cosmos"