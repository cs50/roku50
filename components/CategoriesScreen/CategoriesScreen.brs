'******************************************************************
' Author: Jason Dixon
' Description: Main scene graph component. All action on this page
'******************************************************************


'******************************************************************
' Description: initalize all variables and observers
'******************************************************************
Function Init()
   
    m.videoPlayer           = m.top.findNode("VideoPlayer")
    m.CategoryList          = m.top.findNode("CategoryList")
    m.SubCategoryLabelList  = m.top.findNode("SubCategoryLabelList")
    m.posterGrid            = m.top.findNode("PosterGridScreen")
    m.playIcon              = m.top.findNode("playIcon")
    m.exitDialogButtons     = m.top.findNode("exitDialogButtons")
    m.ExitMaskLabel         = m.top.findNode("ExitMaskLabel")
    
    'set screen focus onto first list'
    m.currentRowList        = m.CategoryList

    m.description           = m.top.findNode("Description")
    m.background            = m.top.findNode("Background")


    m.top.observeField("visible", "onVisibleChange")
    m.top.observeField("focusedChild", "OnFocusedChildChange")
    m.top.observeField("itemFocused", "OnItemFocused")
    m.top.observeField("labelFocused", "OnLabelFocused")
    m.top.observeField("videoFocused","OnVideoFocused")
    m.top.observeField("CategoryListItemSelected", "OnCategoryListItemSelected")
    m.top.observeField("videoSelected", "OnVideoSelected")
    m.top.observeField("AnimateToSubCategoriesState", "OnAnimationComplete")
    m.top.observeField("exitButtonClicked", "OnExitSelection")


    m.CategoryList.rowLabelFont.size = m.CategoryList.rowLabelFont.size + 8
    m.description.title.font.size = m.description.title.font.size + 30
    m.top.isLoaded = false


    channel_font = "pkg:/Fonts/Quicksand-Regular.ttf"

    m.SubCategoryLabelList.font.uri = channel_font
    m.SubCategoryLabelList.focusedFont.uri = channel_font
    m.posterGrid.caption1Font.uri = channel_font
    m.CategoryList.rowLabelFont.uri = channel_font

    'default setup'
    m.CategoryList.visible = true
    
    setButtonListProperties(m)
    setVideoPlayerColors()

    runTask()

End Function


'******************************************************************
' Description: retrieve data from API with async task node
'******************************************************************
sub runTask()
    m.readGridTask = createObject("roSGNode","fetchDataFromAPI")
    m.readGridTask.postergriduri = "http://cs50.tv/?output=roku"
    m.readGridTask.observeField("gridscreencontent","showGridScreen")
    m.readGridTask.control = "RUN"
end sub


'******************************************************************
' Description: assign retrieved data to postergrid
'******************************************************************
sub showGridScreen()
  m.top.content = m.readGridTask.gridscreencontent
  m.top.contentSet = true
end sub


'******************************************************************
' Description: handler of focused item in RowList
'******************************************************************
Sub OnItemFocused()
    m.itemFocused   = m.top.itemFocused
    focusedContent  = m.top.content.getChild(m.itemFocused[0]).getChild(m.itemFocused[1])
    m.top.lastItemFocus = [1, m.itemFocused[1]]

    'When an item gains the key focus, set to a 2-element array,
    'where element 0 contains the index of the focused row,
    'and element 1 contains the index of the focused item in that row.
    If m.itemFocused.Count() = 2 then
        'focusedContent       = m.top.content.getChild(m.itemFocused[0]).getChild(m.itemFocused[1])
        if focusedContent <> invalid then
            m.top.focusedContent    = focusedContent
            m.description.content   = focusedContent
            m.background.uri        = focusedContent.hdBackgroundImageUrl
            m.itemID                = focusedContent.itemID
        end if
    end if
End Sub


'******************************************************************
' Description: event handler for subcategory label focus change
' fetches new label's column of videos from async task on focus.
' Prevents duplicate calls when returning from video column to 
' originating label.
'******************************************************************
Sub OnLabelFocused()
    if(m.top.posterGridDataLoaded = true) then
        m.top.posterGridDataLoaded = false
    else
        if(m.top.labelFocused >= 0) then
            m.posterGridTask = createObject("roSGNode","FetchSubCategory")
            m.posterGridTask.subCategoryUri = m.top.subCategoryLinkArray[m.top.labelFocused]
            m.posterGridTask.observeField("subCategoryContent","updatePosterGrid")
            m.posterGridTask.control = "RUN"
        end if
   end if
end Sub


'******************************************************************
' Description: assign retrieved data to postergrid
'******************************************************************
sub updatePosterGrid()
  m.top.posterContent = m.posterGridTask.subCategoryContent
end sub


'******************************************************************
' Description: set proper focus to RowList in case if return from Details Screen
'******************************************************************
Sub onVisibleChange()
    
    if m.top.visible = true then
        runTask()
    
        if(m.top.lastItemFocus[0] = 0 AND m.top.lastItemFocus[1] = 0) then
            m.CategoryList.setFocus(true)
            m.CategoryList.jumpToRowItem = [0, 0]
        else
            if(m.CategoryList.hasFocus()) then
               m.lastElement = m.top.lastItemFocus[1]
               m.CategoryList.setFocus(true)
               m.CategoryList.jumpToRowItem = [0, m.lastElement]
            end if
       end if
    end if
End Sub


'******************************************************************
' Description: set proper focus to RowList in case if return 
' from Details Screen
'******************************************************************
Sub OnFocusedChildChange()
    if(m.top.visible = false and not m.currentRowList.hasFocus()) then
        m.currentRowList.setFocus(true)
    end if
End Sub


'******************************************************************
' Description: Row item selected handler
'******************************************************************
Function OnCategoryListItemSelected()
    populateSubCategoryLabelList()
    AnimateToSubCategories = m.top.FindNode("AnimateToSubCategories")
    AnimateToSubCategories.control = "start"
    m.SubCategoryLabelList.setFocus(true)
End Function

'******************************************************************
' Description: if category to sub category animation is complete, show label list
'******************************************************************
Function OnAnimationComplete()
    if(m.top.AnimateToSubCategoriesState = "stopped") then
        m.SubCategoryLabelList.visible = true
    end if
end function

'******************************************************************
' Description: fetch data from async task to populate label list
'******************************************************************
Function populateSubCategoryLabelList()
    m.labellistTask = createObject("roSGNode","BuildSubcategoryLabelList")
    m.labellistTask.subCategoryContent = m.top.focusedContent
    m.labellistTask.observeField("buttonListAA","AssignLabelListData")
    m.labellisttask.observeField("linkArray", "AssignLinkArray")
    m.labellistTask.control = "RUN"
End Function


'******************************************************************
' Description: assign label list data to label list object
'******************************************************************
sub AssignLabelListData()
  m.top.buttonsContent = m.labellistTask.buttonListAA
end sub


'******************************************************************
' Description: store associated link array that is indexed to label
' list text labels in method above
'******************************************************************
sub AssignLinkArray()
    m.top.subCategoryLinkArray = m.labellistTask.linkArray
end sub


'******************************************************************
' Description: assign data from currently focused video
'******************************************************************
Function OnVideoFocused()
    m.focusedVideo  = m.top.posterContent.getChild(m.top.videoFocused)
End Function


'******************************************************************
' Description: play video
'******************************************************************
Function OnVideoSelected()  
  videoContent = createObject("RoSGNode", "ContentNode")
  videoContent.url = m.focusedVideo.url
  videoContent.streamformat = "mp4"
 
  m.VideoPlayer.content = videoContent
  m.VideoPlayer.visible = true
  m.VideoPlayer.control = "play"
  m.VideoPlayer.setFocus(true)
end Function


'******************************************************************
' Description: event handler of Video player msg
'******************************************************************
Sub OnVideoPlayerStateChange()
    if m.videoPlayer.state  = "error"
        ' error handling
        ?"ERROR"
        m.videoPlayer.visible = false
    else if m.videoPlayer.state = "playing"
        ' playback handling
        '?"playing"
    else if m.videoPlayer.state = "finished"
        '?"finished"
        m.videoPlayer.visible = false
        'm.videoPlayer.control = "stop"
    end if
End Sub


'******************************************************************
' Description: if back press on homescreen, show exit dialog
'******************************************************************
Function OnExitSelection()
    if(m.top.exitButtonClicked = 0) then
        m.top.exitFlag = true
    else if(m.top.exitButtonClicked = 1) then
        AnimateToHideExitMask = m.top.FindNode("AnimateToHideExitMask")
        AnimateToHideExitMask.control = "start"
        m.CategoryList.setFocus(true)   
   end if     
End Function


'******************************************************************
' Description: local remote key press handler
'******************************************************************
Function OnKeyEvent(key, press) as Boolean
    result = false
    if press then
        'print(key)

        if key = "back"
            
            'catch back press while loading main CategoriesScreen'
            if(m.VideoPlayer.visible = true) then
                m.VideoPlayer.visible = false
                m.VideoPlayer.control = "stop"
                m.posterGrid.setFocus(true)
                result = true
                
            'this will trigger exit screen    
            else if(m.SubCategoryLabelList.visible = false) then
                AnimateToShowExitMask = m.top.FindNode("AnimateToShowExitMask")
                AnimateToShowExitMask.control = "start"
                m.exitDialogButtons.setFocus(true)
                'do nothing
                result = true
            
            else
                m.playIcon.visible = false
                m.SubCategoryLabelList.visible = false
                AnimateBackToCategories = m.top.FindNode("AnimateBackToCategories")
                AnimateBackToCategories.control = "start"
                m.CategoryList.setFocus(true)
                '******** clear label list *******
                result = true                   
            end if
            
        else if key = "right"
            if(m.SubCategoryLabelList.hasFocus()) then
                m.top.posterGridDataLoaded = true
                m.posterGrid.setFocus(true)
                m.playIcon.visible = true
                result = true
            end if
            
        else if key = "left"
            if(m.posterGrid.hasFocus() = true) then
                m.playIcon.visible = false
                m.SubCategoryLabelList.setFocus(true)
                result = true
            end if
        
        else if key = "OK"
            if(m.SubCategoryLabelList.hasFocus()) then
                m.top.posterGridDataLoaded = true
                m.posterGrid.setFocus(true)
                m.playIcon.visible = true
                result = true
           end if     
        end if
    end if
    return result
End Function


'******************************************************************
' Description: set button size, and onfocus size for enlarging-focus effect
'******************************************************************
Function setButtonListProperties(m)
  m.SubCategoryLabelList.font.uri = "pkg:/Fonts/Quicksand-Regular.ttf"
  m.SubCategoryLabelList.font.size = m.SubCategoryLabelList.font.size + 4
  m.SubCategoryLabelList.focusedFont.uri= "pkg:/Fonts/Quicksand-Regular.ttf"
  m.SubCategoryLabelList.focusedFont.size = m.SubCategoryLabelList.focusedFont.size+10
  
  m.exitDialogButtons.font.uri = "pkg:/Fonts/Quicksand-Regular.ttf"
  m.exitDialogButtons.font.size = m.exitDialogButtons.font.size + 14
  m.exitDialogButtons.focusedFont.uri = "pkg:/Fonts/Quicksand-Regular.ttf"
  m.exitDialogButtons.focusedFont.size = m.exitDialogButtons.focusedFont.size + 48
  
  m.ExitMaskLabel.font.uri = "pkg:/Fonts/Quicksand-Regular.ttf"
  m.ExitMaskLabel.font.size = m.ExitMaskLabel.font.size + 36
end Function


'******************************************************************
' Description: custom colors for video player features
'******************************************************************
Function setVideoPlayerColors()
    m.videoPlayerColor = "#c90016"

    rtBar = m.videoPlayer.retrievingBar
    rtBar.filledBarBlendColor = m.videoPlayerColor

    tpbar = m.videoPlayer.trickPlayBar
    tpbar.filledBarBlendColor = m.videoPlayerColor

    bfBar = m.videoPlayer.bufferingBar
    bfBar.filledBarBlendColor = m.videoPlayerColor
end Function