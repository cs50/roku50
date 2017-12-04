'******************************************************************
' Author: Jason Dixon
' Description: Main Thread - Creates HomeScene thread.
'******************************************************************

'******************************************************************
' Description: Launch App
'******************************************************************
sub Main()
    initSiteSpecificSettings()
    showChannelSGScreen()
end sub

'******************************************************************
' Description: create instance of HomeScene
'******************************************************************
sub showChannelSGScreen()
    screen = CreateObject("roSGScreen")
    m.port = CreateObject("roMessagePort")
    screen.setMessagePort(m.port)
    homeScene = screen.CreateScene("HomeScene")
    screen.show()
    
    categoriesScreen = homeScene.findNode("CategoriesScreen")
    categoriesScreen.observeField("exitFlag", m.port)
    
    
    while(true)
        msg = wait(0, m.port)
        msgType = type(msg)
        if msgType = "roSGNodeEvent"
        
            'exit listener'
            if(msg.getField() = "exitFlag")
                if(categoriesScreen.exitFlag = true)
                    exitProgram()
                end if
           end if

        end if  
    end while
end sub