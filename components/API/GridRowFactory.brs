'******************************************************************
' Author: Jason Dixon
' Description: Builds and Returns GridRows and PosterGridRows
'******************************************************************


'******************************************************************
' Description: Accessor function for GridRowFactory
'******************************************************************
Function GridRowFactory() as Object
    this = {
        
        BuildCategoryGridRow:        GridRowFactory_BuildCategoryGridRow
        BuildPosterGridRow:          GridRowFactory_BuildPosterGridRow
    }
    return this
End Function


'******************************************************************
' Description: takes in xml data and returns content node structured
' for RowList object. ContentMeta fields are defined and assigned here
'******************************************************************
Function GridRowFactory_BuildCategoryGridRow(xmlDataIn)
    responseXML = API_Utils().ParseXML2(xmlDataIn)
    
    responseArray = responseXML.GetChildElements()
    result = []

    categoryFeedLinks = []

    for each xmlItem in responseArray
        if xmlItem.getName() = "category"

            item = {}
            'item["Title"] = xmlItem.getAttributes().title
            item["HDPosterUrl"] = xmlItem.getAttributes().hd_img
            item["SDPosterUrl"] = xmlItem.getAttributes().sd_img
            item["DESCRIPTION"] = xmlItem.getAttributes().title
            item["HDBackgroundImageUrl"] = "pkg:/images/background.jpg"
            item["SDBackgroundImageUrl"] = "pkg:/images/background.jpg"

            leaves = xmlItem.GetChildElements()
            titles = []
            feedLinks = []

            for each leaf in leaves
                'print leaf.getAttributes().title, leaf.getAttributes().feed
                titles.push(leaf.getAttributes().title)
                feedLinks.push(leaf.getAttributes().feed)
            next

            item["Actors"] = titles 'this is a string array content meta variable -- use to pass titles
            item["Directors"] = feedLinks 'this is a string array content meta variable -- use to pass feed urls
            'Print item
           result.push(item)

        end if
    end for
    
    categoriesList = [{
              Title: "Course Years"
              ContentList : result
            }] 
    
    return API_Utils().ParseXMLContent(categoriesList)
end function


'******************************************************************
' Description: takes in xml data and returns content node structured
' for PosterGrid object. ContentMeta fields are defined and assigned here
'******************************************************************
Function GridRowFactory_BuildPosterGridRow(xmlDataIn)

    responseXML = API_Utils().ParseXML2(xmlDataIn)
    responseArray = responseXML.GetChildElements()

    result = []
    
    for each xmlItem in responseArray
        'Print xmlItem
        if xmlItem.getName() = "item"
            rowItem = {}
            rowItem["SDGRIDPOSTERURL"] = xmlItem.getAttributes().sdImg
            rowItem["HDGRIDPOSTERURL"] = xmlItem.getAttributes().hdImg
                
            cmetadata = xmlItem.GetChildElements()
            
            for each cItem in cmetadata
                if(cItem.getName() = "title") then
                    rowItem["shortdescriptionline1"] = cItem.GetText()
                else if(cItem.getName() = "contentId") then
                    rowItem["url"] = cItem.GetText()
                end if
            next
             
            result.Push(rowItem)
       end if
    next
            
    return API_Utils().ParsePosterGridXMLContent(result)
End Function
