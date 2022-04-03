# Powershell DNS Lookup Tool Script

## What is it?

This is a script written in `Powershell` that you can pouplate with your own networks information to have a quick tool that can lookup DNS entries on a `Enterprise Network` with the following options

- `DNS Servers`
- `Zones`
- `Search by DNS Record Type`
- `Search by hostname or IP`
- `Search with Wildcards`

Please note, the intended use environment for this tool is not to look up DNS records on the internet, but closed `corporate` networks.

## How it works

This script makes use of the `Get-DnsServerResourceRecord` command and modifies it based on selected options.

It opens up a `GUI` for users to select their lookup options and then upon the completion of the search, outputs it in a `Grid-View`. You can `Sort/Filter` the `Grid-View` as well as `Copy/Paste` from it. 

You can have multiple results windows open which is helpful when you are comparing records between more than one `DNS Server`.

On initial clone it is not configured to do anything as the `DNS Servers` and `Zones` are populated with placeholder text. You must enter your own `DNS Servers` and `Zones` prior to using the tool.

It will search by the following `DNS Record Types`
- `A` - Default
- `AAAA`
- `CNAME`
- `MX`
- `NX`
- `PTR`
- `SOA`
- `SRV`
- `TXT`

It will allow you to use the following wildcards
- `Contains` - Default
- `Begins with`
- `Ends With`

As with all publicly used code, you should review it before using it, and make sure your Cyber Folks are ok with you using it. This is just a best practice reminder. All of this code is very straght forward and commented for easy readability.

## Configuring it for use on a network

The following steps will walk through how to configure the two areas that you customize for use in your own network.

### Populating the DNS Server List

Edit the file with your code editor of choice (I recommend `Microsoft Visual Studio Code`)

For the DNS Server list scroll down to `line 49` and looks like this..

``` Powershell
# Create the options for the DNS Server selection combobox
$DNSComboBox.Items.AddRange(@("Populate Your DNS Servers Here", "Line 49"))
```

Simply replace the text between the `"Double Quotes"` with your own DNS Server host names. Additional entries can be separated by `commas` as shown in the example.

### Populating the Zones list

The Zone list information is found on `line 66` and looks like this

``` Powershell
# Create the options for the Zone selection combobox
$ZoneComboBox.Items.AddRange(@("Populate Your Zones Here", "Line 66"))
```

Simply replace the text between the `"Double Quotes"` with your own zone names. Additional entries can be separated by `commas` as shown in the example.


## Using the Tool

After you finish adding your `DNS Servers` and `Zones`, launch the tool by `right clicking` and selecting `Run with Powershell`. This will pop up the `Powershell` prompt temporarily and may ask for a prompt entry. Hit `Enter` for the default respons of `n`.

You should then see the GUI ready for use.

Select your options for 
- `DNS Server`
- `Zone`
- `Record Type`
- `Search By`
- `Wildcard`
- `Search Keywords`

Then click on `Search`. After a few seconds a second window should open up with the results.

