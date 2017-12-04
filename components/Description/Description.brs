' ********** Copyright 2016 Roku Corp.  All Rights Reserved. ********** 
 'setting top interfaces
Sub Init()
    m.top.Title             = m.top.findNode("Title")
    m.top.Description       = m.top.findNode("Description")
    m.top.ReleaseDate       = m.top.findNode("ReleaseDate")
    'm.top.length            = m.top.findNode("length")
    m.top.Description.font.uri = "pkg:/Fonts/Quicksand-Regular.ttf"
    m.top.Title.font = "font:LargeSystemFont"
    m.top.Description.font.size = m.top.Title.font.size + 10
    
End Sub

' Content change handler
' All fields population
Sub OnContentChanged()
    item = m.top.content

    title = item.title.toStr()
    if title <> invalid then
        m.top.Title.text = title.toStr()
    end if
    
    value = item.description
    if value <> invalid then
        if value.toStr() <> "" then
            m.top.Description.text = value.toStr()
        else
            m.top.Description.text = "No description"
        end if
    end if
    
    value = item.ReleaseDate
    if value <> invalid then
        if value <> ""
            m.top.ReleaseDate.text = value.toStr()'' + " " + HumanizeSeconds(value.length)
        else
            m.top.ReleaseDate.text = ""
        end if
    end if
End Sub