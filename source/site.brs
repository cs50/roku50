'******************************************************************
' Author: Jason Dixon
' Description: Basic Global Site Settings Put Here
'******************************************************************

Function initSiteSpecificSettings()
    app = CreateObject("roAppManager")
  
    m.RegistryKeyName = "cs50"

    ' Globals
    m.device = CreateObject("roDeviceInfo") 'for future development'

    'single message port
    m.AddReplace("Port", CreateObject("roMessagePort"))
end Function