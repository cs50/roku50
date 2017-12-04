'******************************************************************
' Author: Jason Dixon
' Description: Task Node for fetching data for inital channel load
'******************************************************************


'******************************************************************
' Description: initializes task node
'******************************************************************
sub init()
    m.top.contentSet = false
    m.top.functionName = "getContent"
end sub


'******************************************************************
' Description: takes in xml data, returns grid row from gridrowfactory
' to content node in main gridscreen
'******************************************************************
sub getContent()

    postergridcontent = createObject("RoSGNode","ContentNode")
    readInternet      = createObject("roUrlTransfer")
    taskPort          = CreateObject("roMessagePort")

    readInternet.SetMessagePort(taskPort)
    readInternet.EnableFreshConnection(true) 'Don't reuse existing connections
    readInternet.setUrl(m.top.postergriduri)

    xmlDataIn = readInternet.GetToString()
    'Print xmlDataIn
    m.top.gridscreencontent = GridrowFactory().BuildCategoryGridRow(xmlDataIn)

end sub