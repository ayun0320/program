;  $ID plot_histogram_terra_cot_ctp_hist.ncl V01 05/19/2015 10:12 BRUCE EXP$
;
;******************************************************************************
;  PROGRAM plot_histogram_terra_cot_ctp_hist PLOTS 2-D HISTOGRAM WITH UNEQUAL 
;  BINS FOR X AND Y AXISES. THIS PROGRAM IS REFERRED FROM raster_6.ncl FROM 
;  NCL WEBSITE (http://www.ncl.ucar.edu/Applications/Scripts/raster_6.ncl)
;   - Generating dummy data which have irregular X and Y coordinates
;   - Drawing raster contours 
;   - Forcing full-sized raster cells at the X,Y axis boundaries
;
;  VARIABLES:
;  ============================================================================
;  (1 ) wks       (GRAPHIC): WORKSTATION                                  [   ]
;  (2 ) xbnd      (1-D)    : X AXIS LABEL                                 [   ]
;  (3 ) ybnd      (1-D)    : Y AXIS LABEL                                 [   ]
;  (4 ) data      (2-D)    : JOINT HISTOGRAM DATA                         [   ]
;  (5 ) times     (STRING) : STRING TO MARK TIME                          [   ]
;
;  NOTES:
;  ============================================================================
;  (1 ) ORIGINALLY WRITTEN BY NCL WEBSITE. MODIFIED BY BRUCE. (05/19/2015)
;******************************************************************************

undef("plot_histogram_terra_cot_ctp_hist")
procedure plot_histogram_terra_cot_ctp_hist \
          (wks          :graphic,                     \ ;INPUT
           xbnd         :float,     ybnd      :float, \ ;INPUT
           data         :numeric,   times     :string)  ;INPUT

begin
  nxbnd = dimsizes(xbnd)                              ; # of x bin boundaries   
  nybnd = dimsizes(ybnd)                              ; # of y bin boundaries 

  nx    = nxbnd
  ny    = nybnd

;=================================================;
; PLOT
;=================================================;

  res                      = True          ; plot mods desired
  res@gsnMaximize          = True          ; Maximize plot in frame.
  res@gsnSpreadColors      = True
  res@gsnDraw              = False
  res@gsnFrame             = False

  res@cnFillOn             = True          ; Turn on contour fill
  res@cnFillMode           = "RasterFill"  ; Turn on raster fill
  res@cnLinesOn            = False         ; Turn off contour lines
  res@cnLineLabelsOn       = False         ; turns off contour line labels

  res@cnLevelSelectionMode = "ManualLevels"
  res@cnMinLevelValF       = 0
  res@cnMaxLevelValF       = 5
  res@cnLevelSpacingF      = 0.025
  res@lbLabelStride        = 40

  res@trYReverse           = True           ; reverses y-axis 

  res@lbLabelBarOn         = True
  res@lbOrientation        = "vertical"     ; vertical label bar
  res@lbLabelFontThicknessF= 0.3
  res@lbBoxLinesOn         = False
  res@lbTitleString        = "%"
  res@lbTitlePosition      = "Right"

  res@trXMinF              = -0.5           ; extend x and y axes 
  res@trXMaxF              =  nx-0.5
  res@trYMinF              = -0.5
  res@trYMaxF              =  ny-0.5

  res@tmXBMode             = "Explicit"                ; explicit labels
  res@tmXBValues           = fspan(res@trXMinF,res@trXMaxF, nxbnd) 
  res@tmXBLabels           = xbnd
  res@sfXArray             = res@tmXBValues    

  res@tmYLMode             = "Explicit"                ; explicit labels
  res@tmYLValues           = fspan(res@trYMinF,res@trYMaxF, nybnd) 
  res@tmYLLabels           = ybnd
  res@sfYArray             = res@tmYLValues

  res@tiXAxisString        = "COT"        ; x-axis title
  res@tiYAxisString        = "CTP [hPa]"  ; y-axis title

  res@tiMainString         = "Aqua Liquid Cloud " + times
  plot = gsn_csm_contour(wks,data,res)       ; contour the variable
  draw(plot)
return
end
