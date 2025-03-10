Subroutine BASFOR(PARAMS,MATRIX_WEATHER, &
                  CALENDAR_FERT,CALENDAR_NDEP,CALENDAR_PRUNT,CALENDAR_THINT, &
				  NDAYS,NOUT, &
				  y)
!=====================================================
! This is the BASFOR model.
! Authors: Marcel van Oijen, mvano@ceh.ac.uk
!          David Cameron   , dcam@ceh.ac.uk
! MODEL VERSION: CONIFEROUS & DECIDUOUS
! Date: 2015-04-21
!=====================================================

use parameters
use environment
use tree
use belowgroundres
use soil
use management
implicit none

integer :: day, doy, NDAYS, NOUT, year

! As long as the total number of parameters stays below 100, the next line need not be changed
integer, parameter        :: NPAR     = 100
real                      :: PARAMS(NPAR)
integer, parameter        :: NWEATHER = 7
real                      :: MATRIX_WEATHER(NMAXDAYS,NWEATHER)
real   , dimension(100,3) :: CALENDAR_FERT, CALENDAR_NDEP, CALENDAR_PRUNT, CALENDAR_THINT
integer, dimension(100,2) :: DAYS_FERT    , DAYS_NDEP    , DAYS_PRUNT    , DAYS_THINT
real   , dimension(100)   :: NFERTV       , NDEPV        , FRPRUNT	     , FRTHINT
real                      :: y(NDAYS,NOUT)

! State variables
real    :: chillday, Tsum
real    :: CR, CS, CB, CL, CRES, NL
real    :: WA, CLITT, CSOMF, CSOMS, NLITT, NSOMF, NSOMS, NMIN

! Additional output variables
real    :: ET_mmd, NPP_gCm2d, GPP_gCm2d, Reco_gCm2d, NEE_gCm2d


! PARAMETERS
call set_params(PARAMS)
! Composite parameters
NLAMAX   = NCLMAX / SLA     ! kg N m-2 leaf
NLAMIN   = NLAMAX * FNCLMIN ! kg N m-2 leaf


! CALENDARS
! Calendar of weather
YEARI  = MATRIX_WEATHER(:,1)
DOYI   = MATRIX_WEATHER(:,2)
GRI    = MATRIX_WEATHER(:,3)
TI     = MATRIX_WEATHER(:,4)
RAINI  = MATRIX_WEATHER(:,5)
WNI    = MATRIX_WEATHER(:,6)
VPI    = MATRIX_WEATHER(:,7)
! Calendar of management
DAYS_FERT  = CALENDAR_FERT (:,1:2)
DAYS_NDEP  = CALENDAR_NDEP (:,1:2)
DAYS_PRUNT = CALENDAR_PRUNT(:,1:2)
DAYS_THINT = CALENDAR_THINT(:,1:2)
NFERTV     = CALENDAR_FERT (:,3)
NDEPV      = CALENDAR_NDEP (:,3)
FRPRUNT    = CALENDAR_PRUNT(:,3)
FRTHINT    = CALENDAR_THINT(:,3)


! Initial states
chillday = 0
Thist    = 10
! Thist    = TI(1) ! USE THIS CODE AFTER TESTING THE MODEL!!
Tsum     = 0
treedens = TREEDENS0
CR       = CRtree0 * TREEDENS0
CS       = CStree0 * TREEDENS0
CB       = CBtree0 * TREEDENS0
CL       = CLtree0 * TREEDENS0
NL       = CLtree0 * TREEDENS0 * NCLMAX
#ifdef deciduous
  CRES   = CLtree0 * TREEDENS0 * 0.1
#else
  CRES   = 0.
#endif
WA       = 1000 * ROOTD * WCST * FWCFC
CLITT    = CLITT0
CSOMF    = CSOM0 * FCSOMF0
CSOMS    = CSOM0 * (1-FCSOMF0)
NLITT    = CLITT0 / CNLITT0
NSOMF    = (CSOM0 *    FCSOMF0)  / CNSOMF0
NSOMS    = (CSOM0 * (1-FCSOMF0)) / CNSOMS0
NMIN     = NMIN0


do day = 1, NDAYS

! Environment
  call set_weather_day(day, year,doy)

! Tree phenology  
  call dtsum_dchillday(chillday,doy,Tsum, dchillday,dTsum)
  chillday = chillday + dchillday
  Tsum     = Tsum     + dTsum
  call phenology(chillday,doy,Tsum, leaffall,treegrow)
  
! Management
  call fert_prune_thin(year,doy,DAYS_FERT,NFERTV,DAYS_PRUNT,FRPRUNT,DAYS_THINT,FRTHINT)
  treedens = treedens - thintreedens
  call morphology(CL,CS,CB,treedens,LAI)
  call foliarDynamics(CL,CRES,fTran,NL,LAI)

! Update model fluxes
  call PETtr(LAI,RAINint)
  call water_flux(WA,Evap,Tran,fTran,RWA,WFPS)
  call Nsupply(CR,NMIN,Nsup)
  call NPP(fTran)
  call allocation(fTran,LAI)
  call NdemandOrgans
  call gtreeNupt(Nsup)
  call CNtree(CR,CS,CB)
  call water(WA,RAINint,Evap,Tran,LAI)
  call Tsoil_calc
  call CNsoil(RWA,WFPS,WA,gCR,CLITT,CSOMF,NLITT,NSOMF,NSOMS,NMIN,CSOMS) 
  call N_dep(year,doy,DAYS_NDEP,NDEPV)

! Outputs
  y(day, 1)  = year + (doy-0.5)/366                   ! "Time" = Decimal year (approximation)
  y(day, 2)  = year
  y(day, 3)  = doy
  y(day, 4)  = AC
  y(day, 5)  = dCLold
  y(day, 6)  = dCLsenNdef
  y(day, 7)  = dLAIold
  y(day, 8)  = dNLdeath
  y(day, 9)  = dNLlitt
  y(day,10)  = LAI
  y(day,11)  = LAIcrit
  y(day,12)  = LAIsurv
  y(day,13)  = NL
  y(day,14)  = NLsurv
  y(day,15)  = NLsurvMIN
  y(day,16)  = recycNLold
  y(day,17)  = retrNLMAX
  y(day,18)  = CL                                     ! kg C m-2
  y(day,19)  =      CB + CS                           ! kg C m-2
  y(day,20)  = CL + CB + CS                           ! kg C m-2 "CLBS"
  y(day,21)  = CR                                     ! kg C m-2
  y(day,22)  = CRES                                   ! kg C m-2
  y(day,23)  = 0.001 * WA / ROOTD                     ! m3 m-3
  y(day,24)  = CLITT                                  ! kg C m-2  
  y(day,25)  =         CSOMF + CSOMS                  ! kg C m-2 "CSOM"
  y(day,26)  = CLITT + CSOMF + CSOMS                  ! kg C m-2
  y(day,27)  = NLITT + NSOMF + NSOMS + NMIN           ! kg N m-2
  y(day,28)  = DBH                                    ! m
  y(day,29)  = H                                      ! m
  y(day,30)  = Rsoil                                  ! kg C m-2 d-1
  NPP_gCm2d  = (gCL + gCB + gCS + gCR + gCRES) * 1000 ! g C m-2 d-1
  GPP_gCm2d  = NPP_gCm2d / (1-GAMMA)                  ! g C m-2 d-1
  Reco_gCm2d = (GPP_gCm2d - NPP_gCm2d) + Rsoil*1000   ! g C m-2 d-1
  NEE_gCm2d  = Reco_gCm2d - GPP_gCm2d                 ! g C m-2 d-1
  ET_mmd     = Evap + Tran                            ! mm d-1
  y(day,31)  = NEE_gCm2d                              ! g C m-2 d-1
  y(day,32)  = GPP_gCm2d                              ! g C m-2 d-1
  y(day,33)  = Reco_gCm2d                             ! g C m-2 d-1
  y(day,34)  = ET_mmd                                 ! mm d-1
  y(day,35)  = NemissionN2O                           ! kg N m-2 d-1
  y(day,36)  = NemissionNO                            ! kg N m-2 d-1

! Update model states
  CR    = CR    + gCR - dCR
  CS    = CS    + gCS - dCS
  CB    = CB    + gCB - dCB
  if (CL < 1.E-100) then
    CL  = 0.
    NL  = 0.
  else
    CL  = CL    + gCL - dCL          + dCRESgrow
    NL  = NL    + gNL - dNL - retrNL + dCRESgrow * NCLMAX
  end if
  CRES  = CRES  + gCRES              - dCRESgrow - dCRESthin
  WA    = WA    + RAIN - RAINint - Runoff - Drain - Evap - Tran
  CLITT = CLITT + dCL + dCB - rCLITT - dCLITT
  CSOMF = CSOMF + dCLITTsomf + dCR - rCSOMF - dCSOMF
  CSOMS = CSOMS + dCSOMFsoms - dCSOMS
  NLITT = NLITT + dNLlitt + dNBlitt - rNLITT - dNLITT
  NSOMF = NSOMF + dNRsomf + NLITTsomf - rNSOMF - dNSOMF
  NSOMS = NSOMS + NSOMFsoms - dNSOMS
  NMIN  = NMIN  + Ndep + Nfert + Nmineralisation + Nfixation - Nupt - Nleaching - Nemission
  NMIN  = max(0.,NMIN)

end do ! end time loop

end subroutine BASFOR


subroutine BASFOR_C(params_ptr, matrix_weather_ptr, calendar_fert_ptr, &
                     calendar_ndep_ptr, calendar_prunt_ptr, calendar_thint_ptr, &
                     ndays, nout, y_ptr) bind(C, name="BASFOR_C")
  use, intrinsic:: iso_c_binding, only: c_int, c_double, c_ptr, c_f_pointer
  use reset, only: reset_all
  use parameters, only: NMAXDAYS
  implicit none

  type(c_ptr), value :: params_ptr, matrix_weather_ptr, calendar_fert_ptr
  type(c_ptr), value :: calendar_ndep_ptr, calendar_prunt_ptr, calendar_thint_ptr
  type(c_ptr), value :: y_ptr
  integer(c_int), value :: ndays, nout

  real(c_double), pointer :: params(:)
  real(c_double), pointer :: matrix_weather(:,:)
  real(c_double), pointer :: calendar_fert(:,:)
  real(c_double), pointer :: calendar_ndep(:,:)
  real(c_double), pointer :: calendar_prunt(:,:)
  real(c_double), pointer :: calendar_thint(:,:)
  real(c_double), pointer :: y(:,:)

  integer, dimension(:), allocatable :: arr_shape

  call c_f_pointer(params_ptr, params, [100])
  call c_f_pointer(matrix_weather_ptr, matrix_weather, [NMAXDAYS, 7])
  call c_f_pointer(calendar_fert_ptr, calendar_fert, [100, 3])
  call c_f_pointer(calendar_ndep_ptr, calendar_ndep, [100, 3])
  call c_f_pointer(calendar_prunt_ptr, calendar_prunt, [100, 3])
  call c_f_pointer(calendar_thint_ptr, calendar_thint, [100, 3])
  call c_f_pointer(y_ptr, y, [ndays, nout])

  call reset_all()

  call BASFOR(params, matrix_weather, calendar_fert, calendar_ndep, &
              calendar_prunt, calendar_thint, ndays, nout, y)
end subroutine BASFOR_C
