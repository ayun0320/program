; $ID: wrf_contour_erod_column_point.ncl V01 03/29/2012 09:26 BRUCE EXP$
;
;******************************************************************************
;  PROGRAM wrf_contour_erod_column_point PLOTS DUST CONCENTRATION ALONG THE 
;  COLUMN.
;
;  VARIABLES:
;  ============================================================================
;  (1 )
;
;  NOTES:
;  ============================================================================
;  (1 ) ORIGINALLY WRITTEN BY BRUCE. (03/29/2012)
;******************************************************************************

; LOAD LIBRARIES
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm_epa.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/wrf/WRFUserARW.ncl"
load "/Users/bruce/Documents/A/program/ncl/ncl_lib/procedure/universal/WRFUserARW.ncl"
load "/Users/bruce/Documents/A/program/ncl/ncl_lib/procedure/valley_fever/plot_wrf_contour_variable_erod_point.ncl"


begin
;  OPEN A WORKSTATION AND CHOOSE COLORMAP
;  type       = "x11"
;  type       = "pdf"
   type       = "png"
   wks        = gsn_open_wks(type,"1plt_wrf_contour_erod_column_point_d02_v01")
   gsn_define_colormap(wks,"WhAqGrYeOrReVi200")

;  OPEN WRF/CHEM OUTPUT FILES
;  LIST THE NC FILES AND READ NC FILES
   wdir       = "/Volumes/TOSHIBA_3B/iproject/valley_fever/wrf_input/met_em/dust_2d/"
   wfilelist  = "met_em_d02_list"
   wname      = asciiread(wdir+wfilelist, -1, "string")
   nwname     = dimsizes(wname)

;  DEFINE BAD VALUE
   bv2        = -9999.

;  SET UP LIMITED REGION
;  MOTHER DOMAIN (d01)
;  minlat    =  25.0
;  maxlat    =  45.0
;  minlon    = -125.0
;  maxlon    = -95.0
;  NEST DOMAIN (d02)
   minlat    =  30.0
   maxlat    =  37.0
   minlon    = -122.0
   maxlon    = -110.0

;  SET UP SITE INFO
   longitude = (/-112.0667, -118.25/)
   latitude  = (/33.45, 34.05/)

;  GET THE DIMENSION OF VARIABLES
   a         = addfile(wdir+wname(0) + ".nc", "r")
   variable  = wrf_user_getvar(a, "EROD", 0)
   ndim      = dimsizes(variable)
   nleveln   = ndim(0)
   nlatn     = ndim(1)
   nlonn     = ndim(2)
   cdust_monthly = new((/nlatn, nlonn/), float, bv2)

;  DO LOOP TO PLOT THE WRF/CHEM DATA
   cdust_monthly = 0.0 
   icount = 0
   do i = 0, 0;nwname-1
    print("START TIME : ")
    system("date")

;  READ WRF/CHEM DATA
    wf          = addfile(wdir + wname(i) + ".nc", "r")
    times       = wf->Times
    print("NOW WORKING ON : " + times)
    wdust       = getvar(wf, "EROD", 0)
    wlat        = getvar(wf, "XLAT_M", 0)
    wlon        = getvar(wf, "XLONG_M", 0)
    cdust       = dim_sum_n(wdust, 0)
    cdust@lat2d = wlat
    cdust@lon2d = wlon

;  CALL SUBROUTINE plot_wrf_contour_variable_erod_point TO PLOT CONTOUR
    plot_wrf_contour_variable_erod_point \
    (wks, minlat, maxlat, minlon, maxlon, latitude, longitude, cdust, times)
    icount = icount + 1
    cdust_monthly = cdust_monthly + cdust
   end do
    cdust_monthly = cdust_monthly/icount
    cdust_monthly@lat2d = wlat
    cdust_monthly@lon2d = wlon
;  CALL SUBROUTINE plot_wrf_contour_variable_erod_point TO PLOT CONTOUR
   plot_wrf_contour_variable_erod_point \
   (wks, minlat, maxlat, minlon, maxlon, latitude, longitude, cdust_monthly, times(0, 0:6))

end
