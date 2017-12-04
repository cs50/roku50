'******************************************************************
' Author: Jason Dixon
' Description: Label List for SubCategoriesScreen
'******************************************************************


'******************************************************************
' Description: Init component
'******************************************************************
sub init()
    m.top.contentSet = false
    m.top.functionName = "buildSubcategoryButtonList"
end sub


'******************************************************************
' Description: Build vertical button list and associated links
' for each button
'******************************************************************
sub buildSubcategoryButtonList()
    LinkArray = []
    buttonList = []
    ButtonListMetaData = CreateObject("roAssociativeArray")
    index = 0
    for each item in m.top.subCategoryContent.Actors
        'Print item
        buttonList.push(item)
        index += 1
    next
    for each item in m.top.subCategoryContent.Directors
        LinkArray.push(item)
    next
    m.top.LinkArray = LinkArray
    m.top.buttonListAA = ButtonListFactory().BuildButtonList(buttonList)
end sub