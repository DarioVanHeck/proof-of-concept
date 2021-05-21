function trajectcsv {
    $trajectcsv = ($env:USERPROFILE + "\Downloads\traject.csv").ToString()
    
    Add-Content -Path $trajectcsv  -Value 'Traject'
    
      
    
      $employees = @(
      'Traject 1'
      'Traject 2'
      'Traject 3'
      )
    
      $employees | foreach { Add-Content -Path $trajectcsv -Value $_ }
    }