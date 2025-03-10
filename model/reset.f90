module reset
  contains

    subroutine reset_belowgroundres()
      use belowgroundres
      implicit none

      RAINint = 0.0
      SSLOPE  = 0.0
      SVP     = 0.0
      WDF     = 0.0
      BOLTZM  = 0.0
      LHVAP   = 0.0
      PSYCH   = 0.0
      PENMD   = 0.0
      PENMRC  = 0.0
      PENMRS  = 0.0
      PEvap   = 0.0
      PTran   = 0.0
      fAvail  = 0.0
      FRR     = 0.0
      RWA     = 0.0
      WAAD    = 0.0
      WC      = 0.0
      WCAD    = 0.0
      WCCR    = 0.0
      WCFC    = 0.0
      WCWP    = 0.0
      WCWET   = 0.0
      WFPS    = 0.0
      Evap    = 0.0
      Tran    = 0.0
      fTran   = 0.0
      Nsup    = 0.0

    end subroutine

    subroutine reset_environment()
      use environment
      implicit none

      ! Reset scalar variables
      GR    = 0.0
      PAR   = 0.0
      T     = 0.0
      RAIN  = 0.0
      WN    = 0.0
      VP    = 0.0
      CO2A  = 0.0
      DAYL  = 0.0
      Ndep  = 0.0

      ! Reset array variables
      doyi  = 0
      yeari = 0
      GRI   = 0.0
      TI    = 0.0
      RAINI = 0.0
      WNI   = 0.0
      VPI   = 0.0

    end subroutine reset_environment

    subroutine reset_management()
      use management
      implicit none

      Nfert        = 0.0
      prunFRT      = 0.0
      thinFRT      = 0.0
      thintreedens = 0.0
      treedens     = 0.0

    end subroutine reset_management

    subroutine reset_parameters()
      use parameters
      implicit none

      LAT        = 0.0
      FWCAD      = 0.0
      FWCWP      = 0.0
      FWCFC      = 0.0
      FWCWET     = 0.0
      WCST       = 0.0
      ROOTD      = 0.0
      TREEDENS0  = 0.0
      BETA       = 0.0
      CBTREE0    = 0.0
      CLTREE0    = 0.0
      CRTREE0    = 0.0
      CSTREE0    = 0.0
      FB         = 0.0
      FLMAX      = 0.0
      FNCLMIN    = 0.0
      FS         = 0.0
      FTCCLMIN   = 0.0
      GAMMA      = 0.0
      KAC        = 0.0
      KACEXP     = 0.0
      KBA        = 0.0
      KEXT       = 0.0
      KH         = 0.0
      KHEXP      = 0.0
      KNMIN      = 0.0
      KNUPT      = 0.0
      KRAININT   = 0.0
      LAI0       = 0.0
      LUEMAX     = 0.0
      NCLMAX     = 0.0
      NCR        = 0.0
      NCW        = 0.0
      SLA        = 0.0
      TCCB       = 0.0
      TCCLMAX    = 0.0
      TCCR       = 0.0
      TOPT       = 0.0
      TTOL       = 0.0
      TRANCO     = 0.0
      WOODDENS   = 0.0
      LAIMAX     = 0.0
      NLAMAX     = 0.0
      NLAMIN     = 0.0
      CLITT0     = 0.0
      CSOM0      = 0.0
      CNLITT0    = 0.0
      CNSOMF0    = 0.0
      CNSOMS0    = 0.0
      FCSOMF0    = 0.0
      FLITTSOMF  = 0.0
      FSOMFSOMS  = 0.0
      RNLEACH    = 0.0
      KNEMIT     = 0.0
      NMIN0      = 0.0
      TCLITT     = 0.0
      TCSOMF     = 0.0
      TCSOMS     = 0.0
      TMAXF      = 0.0
      TSIGMAF    = 0.0
      RFN2O      = 0.0
      WFPS50N2O  = 0.0

    end subroutine reset_parameters

    subroutine reset_soil()
      use soil
      implicit none

      ! Reset scalar variables
      Drain            = 0.0
      Runoff           = 0.0
      WAFC             = 0.0
      WAST             = 0.0
      WC               = 0.0
      WCFC             = 0.0
      dCLITT          = 0.0
      rCLITT          = 0.0
      rCSOMF          = 0.0
      Rsoil           = 0.0
      dCLITTrsoil     = 0.0
      dCLITTsomf      = 0.0
      dCSOMF          = 0.0
      dCSOMFrsoil     = 0.0
      dCSOMFsoms      = 0.0
      dCSOMS          = 0.0
      Nemission       = 0.0
      NemissionN2O    = 0.0
      NemissionNO     = 0.0
      Nfixation       = 0.0
      Nleaching       = 0.0
      NLITTnmin       = 0.0
      NLITTsomf       = 0.0
      NlossTreeLB     = 0.0
      NlossTreeR      = 0.0
      Nmineralisation = 0.0
      dNLITT          = 0.0
      dNSOMF          = 0.0
      dNSOMS          = 0.0
      NSOMFnmin       = 0.0
      NSOMFsoms       = 0.0
      rNLITT          = 0.0
      rNSOMF          = 0.0
      Tsoil           = 0.0
      fTsoil          = 0.0

      ! Reset array variable
      Thist = 0.0

    end subroutine reset_soil

    subroutine reset_tree()
      use tree
      implicit none

      ! Reset integer variables
      treegrow  = 0
      leaffall  = 0

      ! Reset scalar real variables
      dchillday  = 0.0
      dtsum      = 0.0
      AC         = 0.0
      ACtree     = 0.0
      BA         = 0.0
      BAtree     = 0.0
      CBtree     = 0.0
      CStree     = 0.0
      DBH        = 0.0
      H          = 0.0
      LA         = 0.0
      LAI        = 0.0

      ! Reset foliarDynamics variables
      dCL        = 0.0
      dCLold     = 0.0
      dCLprun    = 0.0
      dCLsen     = 0.0
      dCLsenNdef = 0.0
      dCLthin    = 0.0
      dCRESgrow  = 0.0
      dCRESthin  = 0.0
      dLAIold    = 0.0
      LAIsurv    = 0.0
      dNL        = 0.0
      dNLdeath   = 0.0
      dNLlitt    = 0.0
      dNLthin    = 0.0
      NLMax      = 0.0
      NLMin      = 0.0
      NLsurvMax  = 0.0
      NLsurvMin  = 0.0
      NEFF       = 0.0
      NLsurv     = 0.0
      NSTATUS    = 0.0
      NSTATUSF   = 0.0
      recycNLold = 0.0
      retrNLmax  = 0.0

      ! Reset NPP variables
      fLUECO2    = 0.0
      fLUET      = 0.0
      GPP        = 0.0
      LUE        = 0.0
      NPPmaxN    = 0.0
      PARabsCrown = 0.0
      PARabs     = 0.0

      ! Reset allocation variables
      FL         = 0.0
      FR         = 0.0

      ! Reset NdemandOrgans variables
      gCBmaxN    = 0.0
      gCLmaxN    = 0.0
      gCRmaxN    = 0.0
      gCSmaxN    = 0.0
      gCRESmaxN  = 0.0
      NdemandB   = 0.0
      NdemandL   = 0.0
      NdemandR   = 0.0
      NdemandS   = 0.0
      NdemandRES = 0.0

      ! Reset gtreeNupt variables
      fNgrowth   = 0.0
      gCB        = 0.0
      gCL        = 0.0
      gCR        = 0.0
      gCS        = 0.0
      gCRES      = 0.0
      gNB        = 0.0
      gNL        = 0.0
      gNR        = 0.0
      gNS        = 0.0
      gNRES      = 0.0
      Ndemand    = 0.0
      Nupt       = 0.0
      retrNL     = 0.0

      ! Reset CNtree variables
      dCB        = 0.0
      dCBprun    = 0.0
      dCBsen     = 0.0
      dCBthin    = 0.0
      dCR        = 0.0
      dCRsen     = 0.0
      dCRthin    = 0.0
      dCS        = 0.0
      dNBlitt    = 0.0
      dNRsomf    = 0.0
      harvCS     = 0.0
      harvNS     = 0.0
      LAIcrit    = 0.0

    end subroutine reset_tree

    subroutine reset_all()
      call reset_belowgroundres()
      call reset_environment()
      call reset_management()
      call reset_parameters()
      call reset_soil()
      call reset_tree()
    end subroutine reset_all

end module reset