# Singapore BIS Billing XML Validator (PowerShell)
# Windows-compatible validation script

param(
    [Parameter(Position=0)]
    [string[]]$Files,
    
    [switch]$Help,
    
    [switch]$Verbose
)

# Configuration
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$ProjectRoot = Split-Path -Parent $ScriptDir
$ExamplesDir = Join-Path $ProjectRoot "examples"
$SchemasDir = Join-Path $ProjectRoot "schemas"
$ValidationLog = Join-Path $ProjectRoot "validation.log"

# Counters
$TotalFiles = 0
$ValidFiles = 0
$InvalidFiles = 0

function Show-Help {
    Write-Host @"
Singapore BIS Billing XML Validator (PowerShell)

Usage: .\Validate-XML.ps1 [OPTIONS] [FILES...]

If no files are specified, all XML files in the examples directory will be validated.

Options:
    -Help          Show this help message
    -Verbose       Show detailed output
    
Examples:
    .\Validate-XML.ps1                                    # Validate all example files
    .\Validate-XML.ps1 examples\invoices\basic\*.xml      # Validate specific files
    .\Validate-XML.ps1 my-invoice.xml                     # Validate single file

Requirements:
    - PowerShell 5.0 or later
    - .NET Framework for XML processing

Log file: $ValidationLog
"@
}

function Write-Status {
    param(
        [string]$Status,
        [string]$File,
        [string]$Message = ""
    )
    
    $RelativePath = $File.Replace($ProjectRoot + "\", "")
    
    switch ($Status) {
        "PASS" { 
            Write-Host "✅ PASS - $RelativePath" -ForegroundColor Green
        }
        "FAIL" { 
            Write-Host "❌ FAIL - $RelativePath" -ForegroundColor Red
            if ($Message) {
                Write-Host "   Error: $Message" -ForegroundColor Red
            }
        }
        "WARN" { 
            Write-Host "⚠️  WARN - $RelativePath" -ForegroundColor Yellow
            if ($Message) {
                Write-Host "   Warning: $Message" -ForegroundColor Yellow
            }
        }
    }
}

function Write-Log {
    param(
        [string]$Status,
        [string]$File,
        [string]$Message = ""
    )
    
    $LogEntry = "$(Get-Date): $Status - $File"
    if ($Message) {
        $LogEntry += " - $Message"
    }
    Add-Content -Path $ValidationLog -Value $LogEntry
}

function Test-XMLWellFormed {
    param([string]$FilePath)
    
    try {
        $xml = New-Object System.Xml.XmlDocument
        $xml.Load($FilePath)
        return $true
    }
    catch {
        if ($Verbose) {
            Write-Host "   XML Error: $($_.Exception.Message)" -ForegroundColor Red
        }
        return $false
    }
}

function Test-UBLSchema {
    param([string]$FilePath)
    
    try {
        $xml = New-Object System.Xml.XmlDocument
        $xml.Load($FilePath)
        
        # Basic UBL structure validation
        $rootElement = $xml.DocumentElement.LocalName
        
        $validRoots = @("Invoice", "CreditNote", "DebitNote")
        if ($validRoots -notcontains $rootElement) {
            if ($Verbose) {
                Write-Host "   Invalid root element: $rootElement" -ForegroundColor Red
            }
            return $false
        }
        
        # Check for required namespaces
        $expectedNamespaces = @(
            "urn:oasis:names:specification:ubl:schema:xsd:$rootElement-2",
            "urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2",
            "urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2"
        )
        
        $xmlNamespaces = $xml.DocumentElement.GetNamespaceOfPrefix("")
        if (-not $expectedNamespaces.Contains($xmlNamespaces)) {
            if ($Verbose) {
                Write-Host "   Missing or incorrect default namespace" -ForegroundColor Red
            }
            return $false
        }
        
        return $true
    }
    catch {
        if ($Verbose) {
            Write-Host "   Schema validation error: $($_.Exception.Message)" -ForegroundColor Red
        }
        return $false
    }
}

function Test-SingaporeCompliance {
    param([string]$FilePath)
    
    $errors = @()
    
    try {
        $xml = New-Object System.Xml.XmlDocument
        $xml.Load($FilePath)
        
        # Create namespace manager
        $nsmgr = New-Object System.Xml.XmlNamespaceManager($xml.NameTable)
        $nsmgr.AddNamespace("cbc", "urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2")
        $nsmgr.AddNamespace("cac", "urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2")
        
        # Check UBL version
        $ublVersion = $xml.SelectSingleNode("//cbc:UBLVersionID", $nsmgr)
        if (-not $ublVersion -or $ublVersion.InnerText -ne "2.1") {
            $errors += "UBL version should be 2.1"
        }
        
        # Check customization ID for Singapore
        $customizationId = $xml.SelectSingleNode("//cbc:CustomizationID", $nsmgr)
        if (-not $customizationId -or $customizationId.InnerText -notlike "*sg*") {
            $errors += "Missing Singapore customization ID"
        }
        
        # Check profile ID for PEPPOL
        $profileId = $xml.SelectSingleNode("//cbc:ProfileID", $nsmgr)
        if (-not $profileId -or $profileId.InnerText -notlike "*peppol*") {
            $errors += "Missing PEPPOL profile ID"
        }
        
        # Check document currency
        $currencyCode = $xml.SelectSingleNode("//cbc:DocumentCurrencyCode", $nsmgr)
        if (-not $currencyCode) {
            $errors += "Missing document currency code"
        }
        
        if ($errors.Count -eq 0) {
            return $null
        } else {
            return $errors -join "; "
        }
    }
    catch {
        return "Singapore compliance check failed: $($_.Exception.Message)"
    }
}

function Test-XMLFile {
    param([string]$FilePath)
    
    $script:TotalFiles++
    $RelativePath = $FilePath.Replace($ProjectRoot + "\", "")
    
    Write-Host "`nValidating: $RelativePath" -ForegroundColor Blue
    
    # Test 1: Well-formedness
    if (-not (Test-XMLWellFormed -FilePath $FilePath)) {
        Write-Status -Status "FAIL" -File $FilePath -Message "XML is not well-formed"
        Write-Log -Status "FAIL" -File $RelativePath -Message "Not well-formed"
        $script:InvalidFiles++
        return
    }
    
    # Test 2: Basic UBL structure
    if (-not (Test-UBLSchema -FilePath $FilePath)) {
        Write-Status -Status "FAIL" -File $FilePath -Message "UBL structure validation failed"
        Write-Log -Status "FAIL" -File $RelativePath -Message "UBL structure validation failed"
        $script:InvalidFiles++
        return
    }
    
    # Test 3: Singapore compliance
    $complianceErrors = Test-SingaporeCompliance -FilePath $FilePath
    if ($complianceErrors) {
        Write-Status -Status "WARN" -File $FilePath -Message $complianceErrors
        Write-Log -Status "WARN" -File $RelativePath -Message $complianceErrors
    }
    
    Write-Status -Status "PASS" -File $FilePath
    Write-Log -Status "PASS" -File $RelativePath
    $script:ValidFiles++
}

function Show-Summary {
    Write-Host ""
    Write-Host "================================================" -ForegroundColor Blue
    Write-Host "  Validation Summary" -ForegroundColor Blue
    Write-Host "================================================" -ForegroundColor Blue
    Write-Host "Total files processed: $TotalFiles" -ForegroundColor Blue
    Write-Host "Valid files: $ValidFiles" -ForegroundColor Green
    Write-Host "Invalid files: $InvalidFiles" -ForegroundColor Red
    
    if ($InvalidFiles -eq 0) {
        Write-Host "`n🎉 All validations passed!" -ForegroundColor Green
        Write-Host "Log file: $ValidationLog"
    } else {
        Write-Host "`n❌ Validation errors found" -ForegroundColor Red
        Write-Host "Log file: $ValidationLog"
        exit 1
    }
}

# Main execution
if ($Help) {
    Show-Help
    exit 0
}

Write-Host "================================================" -ForegroundColor Blue
Write-Host "  Singapore BIS Billing XML Validator" -ForegroundColor Blue
Write-Host "================================================" -ForegroundColor Blue

# Initialize log file
"Validation started at $(Get-Date)" | Out-File -FilePath $ValidationLog -Encoding UTF8

if ($Files.Count -eq 0) {
    # No arguments, validate all example files
    $XmlFiles = Get-ChildItem -Path $ExamplesDir -Filter "*.xml" -Recurse
    foreach ($file in $XmlFiles) {
        Test-XMLFile -FilePath $file.FullName
    }
} else {
    # Validate specific files
    foreach ($file in $Files) {
        if (Test-Path $file) {
            Test-XMLFile -FilePath (Resolve-Path $file).Path
        } else {
            Write-Host "File not found: $file" -ForegroundColor Red
            $TotalFiles++
            $InvalidFiles++
        }
    }
}

Show-Summary
