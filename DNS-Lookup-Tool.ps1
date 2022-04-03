# This is a GUI Based tool used to run DNS record checks against a list of domains and record types.

# Created by: Brian Giuffre
# v1.0 - April 1, 2022 - Initial Release
# v1.1 - April 2, 2022 - Added ability to search by Hostname or Ip Address and locked resize of window and disabled minimize button
# v1.2 - April 3, 2022 - Changed Search Wildcard to be a ComboBox selection instead of a manual entry included in the search textbox

# Hide the Powershell Console
Add-Type -Name Window -Namespace Console -MemberDefinition '
[DllImport("Kernel32.dll")]
public static extern IntPtr GetConsoleWindow();
[DllImport("user32.dll")]
public static extern bool ShowWindow(IntPtr hWnd, Int32 nCmdShow);
'
$consoleHide = [Console.Window]::GetConsoleWindow()
[Console.Window]::ShowWindow($consoleHide, 0)

# Assembly of the GUI Objects
Add-Type -AssemblyName System.Windows.Forms

# Objects for the GUI
$FormObject = [System.Windows.Forms.form]
$LabelObject = [System.Windows.Forms.label]
$TextBoxObject = [System.Windows.Forms.textbox]
$ButtonObject = [System.Windows.Forms.button]
$ComboboxObject = [System.Windows.Forms.combobox]

# Create the shape of the GUI
$AppForm = New-Object $FormObject
$AppForm.ClientSize = [System.Drawing.size]::new(400, 230)
$AppForm.Text = "DNS Lookup Tool v1.2"
$AppForm.FormBorderStyle = "Fixed3D"
$AppForm.MaximizeBox = $false
$AppForm.StartPosition = [System.Windows.Forms.formstartposition]::CenterScreen
$AppForm.BackColor = [System.Drawing.color]::White

# Create the DNS Server selection label
$DNSLabel = New-Object $LabelObject
$DNSLabel.Text = "DNS Server: "
$DNSLabel.Location = [System.Drawing.point]::new(10, 10)
$DNSLabel.AutoSize = $true

# Create the DNS Server selection combobox
$DNSCombobox = New-Object $ComboboxObject
$DNSCombobox.Location = [System.Drawing.point]::new(125, 10)
$DNSCombobox.Width = 250

# Create the options for the DNS Server selection combobox
$DNSComboBox.Items.AddRange(@("Populate Your DNS Servers Here", "Line 49"))

# set the default DNS Server to the first item in the combobox
$DNSCombobox.SelectedIndex = 0

# Create the Zone selection label
$ZoneLabel = New-Object $LabelObject
$ZoneLabel.Text = "Zone: "
$ZoneLabel.Location = [System.Drawing.point]::new(10, 40)
$ZoneLabel.AutoSize = $true

# Create the Zone selection combobox
$ZoneCombobox = New-Object $ComboboxObject
$ZoneCombobox.Location = [System.Drawing.point]::new(125, 40)
$ZoneCombobox.Width = 250

# Create the options for the Zone selection combobox
$ZoneComboBox.Items.AddRange(@("Populate Your Zones Here", "Line 66"))

# set the default Zone to the first item in the combobox
$ZoneCombobox.SelectedIndex = 0

# Create the RR Type selection label
$RRTypeLabel = New-Object $LabelObject
$RRTypeLabel.Text = "Record Type: "
$RRTypeLabel.Location = [System.Drawing.point]::new(10, 70)
$RRTypeLabel.AutoSize = $true

# Create the RR Type selection combobox
$RRTypeCombobox = New-Object $ComboboxObject
$RRTypeCombobox.Location = [System.Drawing.point]::new(125, 70)
$RRTypeCombobox.Width = 250

# Create the options for the RR Type selection combobox
$RRTypeComboBox.Items.AddRange(@("A", "AAAA", "CNAME", "MX", "NS", "PTR", "SOA", "SRV", "TXT"))

# set the default RR Type to the first item in the combobox
$RRTypeCombobox.SelectedIndex = 0

# Create the search by Hostname or Ip Address label
$SearchLabel = New-Object $LabelObject
$SearchLabel.Text = "Search By: "
$SearchLabel.Location = [System.Drawing.point]::new(10, 100)
$SearchLabel.AutoSize = $true

# Create the search by Hostname or Ip Address combobox
$SearchCombobox = New-Object $ComboboxObject
$SearchCombobox.Location = [System.Drawing.point]::new(125, 100)
$SearchCombobox.Width = 250

# Create the options for the search by Hostname or Ip Address combobox
$SearchComboBox.Items.AddRange(@("Hostname", "IP Address"))

# set the default search by to the first item in the combobox
$SearchCombobox.SelectedIndex = 0

# create the search wildcard label
$SearchWildcardLabel = New-Object $LabelObject
$SearchWildcardLabel.Text = "Wildcard: "
$SearchWildcardLabel.Location = [System.Drawing.point]::new(10, 130)
$SearchWildcardLabel.AutoSize = $true

# Create the search wildcard combobox
$SearchWildcardCombobox = New-Object $ComboboxObject
$SearchWildcardCombobox.Location = [System.Drawing.point]::new(125, 130)
$SearchWildcardCombobox.Width = 250

# Create the options for the search wildcard combobox
$SearchWildcardComboBox.Items.AddRange(@("Contains", "Begins With", "Ends With"))

# set the default search wildcard to the first item in the combobox
$SearchWildcardCombobox.SelectedIndex = 0

# Create the search field label
$SearchFieldLabel = New-Object $LabelObject
$SearchFieldLabel.Text = "Search Keyword: "
$SearchFieldLabel.Location = [System.Drawing.point]::new(10, 160)
$SearchFieldLabel.AutoSize = $true

# Create the search field textbox
$SearchFieldTextbox = New-Object $TextBoxObject
$SearchFieldTextbox.Location = [System.Drawing.point]::new(125, 160)
$SearchFieldTextbox.Width = 250

# Create the search button
$SearchButton = New-Object $ButtonObject
$SearchButton.Text = "Search"
$SearchButton.Location = [System.Drawing.point]::new(175, 190)
$SearchButton.AutoSize = $true

# Create the Function to run when the search button is clicked
Function RunSearch() {
  $DNS = $DNSComboBox.SelectedItem
  $Zone = $ZoneComboBox.SelectedItem
  $RecordType = $RRTypeComboBox.SelectedItem
  $SearchText = $SearchFieldTextbox.Text
  $Wildcard = $SearchWildcardCombobox.SelectedItem

  # combine the wildcard combobox selection with the search text entry
  if ($Wildcard -eq "Contains") {
    $SearchText = "*" + $SearchText + "*"
  }
  elseif ($Wildcard -eq "Begins With") {
    $SearchText = $SearchText + "*"
  }
  elseif ($Wildcard -eq "Ends With") {
    $SearchText = "*" + $SearchText
  }

  # create the search string based on all of the selections
  switch($SearchComboBox.SelectedItem) {
    "Hostname" {
      $SearchResults = Get-DnsServerResourceRecord -ZoneName $Zone -ComputerName $DNS  -RRType $RecordType | Where-Object {$_.hostname -like "$SearchText" -and $_.hostname -ne "@"}
    }
    "IP Address" {
      $SearchResults = Get-DnsServerResourceRecord -ZoneName $Zone -ComputerName $DNS  -RRType $RecordType | Where-Object {$_.RecordData.IPv4Address -like "$SearchText" -and $_.hostname -ne "@"}
    }
    }
    # display the results in a separate grid view window
  $SearchResultsTextBox.Text = $SearchResults | Out-GridView
}

# add the function to the Search button when clicked
$SearchButton.Add_Click({ RunSearch })

# Assemble the objects to the GUI Window
$AppForm.Controls.AddRange(@($DNSLabel, $DNSCombobox, $ZoneLabel, $ZoneCombobox, $RRTypeLabel, $RRTypeCombobox, $SearchLabel, $SearchCombobox, $SearchWildcardLabel, $SearchWildcardCombobox, $SearchFieldLabel, $SearchFieldTextbox, $SearchButton))

# Show the GUI Window
$AppForm.ShowDialog()

# Clean up the GUI Window
$AppForm.Dispose()

# End of the Script