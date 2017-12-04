'******************************************************************
' Author: Jason Dixon
' Description: Home Scene - creates all children scene graph
' components'
'******************************************************************


'******************************************************************
' Description: initializes CategoriesScreen node with RowList
'******************************************************************
Function Init()
    m.CategoriesScreen               = m.top.findNode("CategoriesScreen")
End Function


'******************************************************************
' Description: if content set, focus on CategoriesScreen
'******************************************************************
Function OnChangeContent()
    m.CategoriesScreen.setFocus(true)
    m.CategoriesScreen.isLoaded = true
End Function


'******************************************************************
' Description: Main Remote keypress event loop
'******************************************************************
Function OnKeyEvent(key, press) as Boolean
    result = false
    if press then
        'print(key)

        if key = "back"
            
            'catch back press while loading main CategoriesScreen'
            if(m.CategoriesScreen.visible = true and m.CategoriesScreen.isLoaded = false) then
                ?"1 - caught"
                result = true                   

            else
                ?"ERROR -- CATCH BACK-BUTTON CASE HIT"
                result = false
            end if
        end if
    end if
    return result
End Function