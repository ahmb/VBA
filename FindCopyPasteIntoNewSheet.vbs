Sub Copy_To_Another_Sheet_1(MyArr, inputDatasheet)
    Dim FirstAddress As String
    'Dim MyArr As Variant
    Dim Rng As Range
    Dim Rcount As Long
    Dim I As Long
    Dim NewSh As Worksheet

    With Application
        .ScreenUpdating = False
        .EnableEvents = False
    End With

    'Fill in the search Value
    'MyArr = Array("O.S.")

    'You can also use more values in the Array
    'myArr = Array("@", "www")

    For I = 0 To UBound(MyArr)
        SearchedValue = MyArr(I)
        'MsgBox TypeName(SearchedValue)
        'Add new worksheet to your workbook to copy to
        'You can also use a existing sheet like this
        On Error Resume Next
        Set NewSh = Sheets(SearchedValue)
        'Set NewSh = Worksheets.Add
        If NewSh Is Nothing Then
            Worksheets.Add(After:=Worksheets(1)).Name = SearchedValue
        End If
        With Sheets(inputDatasheet).Range("A1:Z5000")

        Rcount = 0

        

            'If you use LookIn:=xlValues it will also work with a
            'formula cell that evaluates to "@"
            'Note : I use xlPart in this example and not xlWhole
            Set Rng = .Find(What:=SearchedValue, _
                            After:=.Cells(.Cells.Count), _
                            LookIn:=xlFormulas, _
                            LookAt:=xlPart, _
                            SearchOrder:=xlByRows, _
                            SearchDirection:=xlNext, _
                            MatchCase:=False)
            If Not Rng Is Nothing Then
                FirstAddress = Rng.Address
                    Do
                        Rcount = Rcount + 1
                        'MsgBox Rng.Row
                        RngRow = Rng.Row
                        Worksheets("Sheet1").Range("A" & RngRow & ":Z" & RngRow).Copy Destination:=Worksheets(SearchedValue).Range("A" & Rcount)
                        'Rng.Copy NewSh.Range("A" & Rcount)
    
                        ' Use this if you only want to copy the value
                        'NewSh.Range("A" & Rcount).Rows = Rng.Rows
                        
                        'NewSh.Range("A" & Rcount).Value = Rng.Value
    
                        Set Rng = .FindNext(Rng)
                    Loop While Not Rng Is Nothing And Rng.Address <> FirstAddress
                End If
           
        End With

            
    Next I
    
    
    
                
    With Application
        .ScreenUpdating = True
        .EnableEvents = True
    End With
End Sub
 
 
Sub Button1_Click()
    Dim inputData As Variant
    inputData = Application.InputBox("Example:" & dq & "lsi,sep,serviceplatform,pinpad" & dq, "Enter the search terms you wish to extract (seperated by commas)", Type:=2)
    'inputData = ("baxter,petri")
    Terms = Split(inputData, ",")
    'MsgBox Terms
    inputDatasheet = Application.InputBox("Example:" & dq & "Sheet1" & dq, "Enter the name of the sheet you want to search in", Type:=2)
    Call Copy_To_Another_Sheet_1(Terms, inputDatasheet)


End Sub

