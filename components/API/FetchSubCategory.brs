'******************************************************************
' Author: Jason Dixon
' Description: Task Node for fetching data for subcategories
'******************************************************************


'******************************************************************
' Description: initialize task node
'******************************************************************
sub init()
    m.top.functionName = "getSubCategoryContent"
end sub


'******************************************************************
' Description: (Loads column of videos) -- takes in xml data, returns
' poster grid row from gridrowfactory to content node in main gridscreen 
'******************************************************************
sub getSubCategoryContent()

    postergridcontent = createObject("RoSGNode","ContentNode")
    readInternet      = createObject("roUrlTransfer")
    taskPort          = CreateObject("roMessagePort")

    readInternet.SetMessagePort(taskPort)
    readInternet.EnableFreshConnection(true) 'Don't reuse existing connections
    readInternet.setUrl(m.top.subCategoryUri)

    xmlDataIn = readInternet.GetToString()
    m.top.subCategoryContent = GridrowFactory().BuildPosterGridRow(xmlDataIn)

end sub