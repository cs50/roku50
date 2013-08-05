'********************************************************************
'**  Video Player Example Application - Main
'**  November 2009
'**  Copyright (c) 2009 Roku Inc. All Rights Reserved.
'********************************************************************

Sub Main()

    'initialize theme attributes like titles, logos and overhang color
    initTheme()

    'prepare the screen for display and get ready to begin
    screen=preShowHomeScreen("", "")
    if screen=invalid then
        print "unexpected error in preShowHomeScreen"
        return
    end if

    'set to go, time to get started
    showHomeScreen(screen)

End Sub


'*************************************************************
'** Set the configurable theme attributes for the application
'** 
'** Configure the custom overhang and Logo attributes
'** Theme attributes affect the branding of the application
'** and are artwork, colors and offsets specific to the app
'*************************************************************

Sub initTheme()

    app = CreateObject("roAppManager")
    theme = CreateObject("roAssociativeArray")

    theme.OverhangOffsetSD_X = "0"
    theme.OverhangOffsetSD_Y = "31"
    theme.OverhangPrimaryLogoOffsetSD_X = "0"
    theme.OverhangPrimaryLogoOffsetSD_Y = "8"
    theme.OverhangSliceSD = "pkg:/images/overhang-sd.png"
    theme.OverhangPrimaryLogoSD = "pkg:/images/banner-sd.png"
    theme.OverhangLogoSD  = ""

    theme.OverhangOffsetHD_X = "0"
    theme.OverhangOffsetHD_Y = "33"
    theme.OverhangPrimaryLogoOffsetHD_X = "0"
    theme.OverhangPrimaryLogoOffsetHD_Y = "11"
    theme.OverhangSliceHD = "pkg:/images/overhang-hd.png"
    theme.OverhangPrimaryLogoHD = "pkg:/images/banner-hd.png"
    theme.OverhangLogoHD  = ""
    
    theme.BackgroundColor = "#000003"
    app.SetTheme(theme)

End Sub
