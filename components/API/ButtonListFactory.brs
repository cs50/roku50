'******************************************************************
' Author: Jason Dixon
' Description: Builds button lists
'******************************************************************


'******************************************************************
' Description: Accessor function for ButtonListFactory
'******************************************************************
Function ButtonListFactory() as Object
    this = {
        
        BuildButtonList:   BuildButtonList
    }
    return this
End Function


'******************************************************************
' Description: Takes in string array, outputs ContentNode for 
' labellist
'******************************************************************
Function BuildButtonList(titles)
    buttonListContent = createObject("RoSGNode","ContentNode")

    for each title in titles
        buttonItem = buttonListContent.createChild("ContentNode")
        buttonItem["TITLE"] = " " + title
    end for

    return buttonListContent
end function