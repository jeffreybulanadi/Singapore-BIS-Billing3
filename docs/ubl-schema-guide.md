# UBL Schema Implementation Guide

This guide provides detailed information about implementing UBL 2.1 schemas for Singapore BIS billing.

## Overview

Universal Business Language (UBL) 2.1 is the foundation for Singapore BIS billing documents. This guide covers practical implementation aspects, common patterns, and best practices.

## UBL 2.1 Structure

### Document Types
- **Invoice**: Primary billing document
- **CreditNote**: Credit adjustments
- **DebitNote**: Additional charges (less common)

### Core Components
- **CommonBasicComponents (cbc)**: Simple data elements
- **CommonAggregateComponents (cac)**: Complex data structures
- **Document Root**: Invoice, CreditNote, or DebitNote

## Essential Schema Elements

### Document Header
```xml
<?xml version="1.0" encoding="UTF-8"?>
<Invoice xmlns="urn:oasis:names:specification:ubl:schema:xsd:Invoice-2"
         xmlns:cac="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2"
         xmlns:cbc="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2">
```

### Mandatory Elements
```xml
<!-- Document metadata -->
<cbc:UBLVersionID>2.1</cbc:UBLVersionID>
<cbc:CustomizationID>urn:cen.eu:en16931:2017#conformant#urn:fdc:peppol.eu:2017:poacc:billing:international:sg:3.0</cbc:CustomizationID>
<cbc:ProfileID>urn:fdc:peppol.eu:2017:poacc:billing:01:1.0</cbc:ProfileID>
<cbc:ID>INV-001</cbc:ID>
<cbc:IssueDate>2024-01-15</cbc:IssueDate>
<cbc:InvoiceTypeCode>380</cbc:InvoiceTypeCode>
<cbc:DocumentCurrencyCode>SGD</cbc:DocumentCurrencyCode>
```

## Party Information

### Supplier (AccountingSupplierParty)
```xml
<cac:AccountingSupplierParty>
    <cac:Party>
        <!-- Endpoint for PEPPOL -->
        <cbc:EndpointID schemeID="0195">SGUENT08GA0028A</cbc:EndpointID>
        
        <!-- Party identification -->
        <cac:PartyIdentification>
            <cbc:ID schemeID="0195">201234567A</cbc:ID>
        </cac:PartyIdentification>
        
        <!-- Address -->
        <cac:PostalAddress>
            <cbc:StreetName>123 Business Street</cbc:StreetName>
            <cbc:CityName>Singapore</cbc:CityName>
            <cbc:PostalZone>123456</cbc:PostalZone>
            <cac:Country>
                <cbc:IdentificationCode>SG</cbc:IdentificationCode>
            </cac:Country>
        </cac:PostalAddress>
        
        <!-- Legal entity -->
        <cac:PartyLegalEntity>
            <cbc:RegistrationName>My Company Pte Ltd</cbc:RegistrationName>
            <cbc:CompanyID>201234567A</cbc:CompanyID>
        </cac:PartyLegalEntity>
        
        <!-- Tax scheme (GST) -->
        <cac:PartyTaxScheme>
            <cbc:CompanyID>M12345678A</cbc:CompanyID>
            <cac:TaxScheme>
                <cbc:ID>GST</cbc:ID>
            </cac:TaxScheme>
        </cac:PartyTaxScheme>
    </cac:Party>
</cac:AccountingSupplierParty>
```

### Customer (AccountingCustomerParty)
```xml
<cac:AccountingCustomerParty>
    <cac:Party>
        <cbc:EndpointID schemeID="0195">BUYERUENT123456</cbc:EndpointID>
        <cac:PostalAddress>
            <cbc:StreetName>456 Customer Avenue</cbc:StreetName>
            <cbc:CityName>Singapore</cbc:CityName>
            <cbc:PostalZone>654321</cbc:PostalZone>
            <cac:Country>
                <cbc:IdentificationCode>SG</cbc:IdentificationCode>
            </cac:Country>
        </cac:PostalAddress>
        <cac:PartyLegalEntity>
            <cbc:RegistrationName>Customer Company Pte Ltd</cbc:RegistrationName>
        </cac:PartyLegalEntity>
    </cac:Party>
</cac:AccountingCustomerParty>
```

## Tax Handling

### Tax Total Structure
```xml
<cac:TaxTotal>
    <cbc:TaxAmount currencyID="SGD">16.00</cbc:TaxAmount>
    <cac:TaxSubtotal>
        <cbc:TaxableAmount currencyID="SGD">200.00</cbc:TaxableAmount>
        <cbc:TaxAmount currencyID="SGD">16.00</cbc:TaxAmount>
        <cac:TaxCategory>
            <cbc:ID>SR</cbc:ID>
            <cbc:Percent>8.0</cbc:Percent>
            <cac:TaxScheme>
                <cbc:ID>GST</cbc:ID>
            </cac:TaxScheme>
        </cac:TaxCategory>
    </cac:TaxSubtotal>
</cac:TaxTotal>
```

### Singapore Tax Categories
| Category | Code | Rate | Description |
|----------|------|------|-------------|
| Standard Rate | SR | 8% | Standard GST rate |
| Zero Rate | ZR | 0% | Zero-rated supplies |
| Exempt | ES | 0% | Exempt supplies |
| Out of Scope | OS | 0% | Out of scope |
| Not GST Registered | NG | 0% | Supplier not registered |

## Invoice Lines

### Basic Line Structure
```xml
<cac:InvoiceLine>
    <cbc:ID>1</cbc:ID>
    <cbc:InvoicedQuantity unitCode="EA">5</cbc:InvoicedQuantity>
    <cbc:LineExtensionAmount currencyID="SGD">100.00</cbc:LineExtensionAmount>
    
    <cac:Item>
        <cbc:Name>Product Name</cbc:Name>
        <cbc:Description>Product Description</cbc:Description>
        
        <!-- Seller's item identification -->
        <cac:SellersItemIdentification>
            <cbc:ID>PROD-001</cbc:ID>
        </cac:SellersItemIdentification>
        
        <!-- Tax category for this line -->
        <cac:ClassifiedTaxCategory>
            <cbc:ID>SR</cbc:ID>
            <cbc:Percent>8.0</cbc:Percent>
            <cac:TaxScheme>
                <cbc:ID>GST</cbc:ID>
            </cac:TaxScheme>
        </cac:ClassifiedTaxCategory>
    </cac:Item>
    
    <cac:Price>
        <cbc:PriceAmount currencyID="SGD">20.00</cbc:PriceAmount>
    </cac:Price>
</cac:InvoiceLine>
```

## Monetary Totals

### Legal Monetary Total
```xml
<cac:LegalMonetaryTotal>
    <!-- Sum of line extension amounts -->
    <cbc:LineExtensionAmount currencyID="SGD">100.00</cbc:LineExtensionAmount>
    
    <!-- Total excluding tax -->
    <cbc:TaxExclusiveAmount currencyID="SGD">100.00</cbc:TaxExclusiveAmount>
    
    <!-- Total including tax -->
    <cbc:TaxInclusiveAmount currencyID="SGD">108.00</cbc:TaxInclusiveAmount>
    
    <!-- Amount due for payment -->
    <cbc:PayableAmount currencyID="SGD">108.00</cbc:PayableAmount>
</cac:LegalMonetaryTotal>
```

## Payment Information

### Payment Means
```xml
<cac:PaymentMeans>
    <cbc:PaymentMeansCode name="Bank transfer">30</cbc:PaymentMeansCode>
    <cbc:PaymentID>REF-123456</cbc:PaymentID>
    
    <cac:PayeeFinancialAccount>
        <cbc:ID>1234567890</cbc:ID>
        <cbc:Name>Company Bank Account</cbc:Name>
        <cac:FinancialInstitutionBranch>
            <cbc:ID>DBSSSGSG</cbc:ID>
            <cbc:Name>DBS Bank</cbc:Name>
        </cac:FinancialInstitutionBranch>
    </cac:PayeeFinancialAccount>
</cac:PaymentMeans>
```

### Payment Terms
```xml
<cac:PaymentTerms>
    <cbc:Note>Payment due within 30 days</cbc:Note>
</cac:PaymentTerms>
```

## Allowances and Charges

### Document Level Allowance
```xml
<cac:AllowanceCharge>
    <cbc:ChargeIndicator>false</cbc:ChargeIndicator>
    <cbc:AllowanceChargeReasonCode>95</cbc:AllowanceChargeReasonCode>
    <cbc:AllowanceChargeReason>Discount</cbc:AllowanceChargeReason>
    <cbc:Amount currencyID="SGD">10.00</cbc:Amount>
    
    <cac:TaxCategory>
        <cbc:ID>SR</cbc:ID>
        <cbc:Percent>8.0</cbc:Percent>
        <cac:TaxScheme>
            <cbc:ID>GST</cbc:ID>
        </cac:TaxScheme>
    </cac:TaxCategory>
</cac:AllowanceCharge>
```

### Document Level Charge
```xml
<cac:AllowanceCharge>
    <cbc:ChargeIndicator>true</cbc:ChargeIndicator>
    <cbc:AllowanceChargeReasonCode>FC</cbc:AllowanceChargeReasonCode>
    <cbc:AllowanceChargeReason>Freight</cbc:AllowanceChargeReason>
    <cbc:Amount currencyID="SGD">15.00</cbc:Amount>
    
    <cac:TaxCategory>
        <cbc:ID>SR</cbc:ID>
        <cbc:Percent>8.0</cbc:Percent>
        <cac:TaxScheme>
            <cbc:ID>GST</cbc:ID>
        </cac:TaxScheme>
    </cac:TaxCategory>
</cac:AllowanceCharge>
```

## Common Implementation Patterns

### Date Handling
- **Format**: YYYY-MM-DD (ISO 8601)
- **Time zones**: Singapore Standard Time (SST)
- **Examples**: `2024-01-15`, `2024-12-31`

### Currency Handling
- **Primary**: SGD (Singapore Dollar)
- **Foreign currencies**: Supported with exchange rates
- **Decimal places**: 2 for monetary amounts
- **Rounding**: Standard commercial rounding

### Quantity and Units
- **Unit codes**: UN/ECE Recommendation 20
- **Common units**: EA (each), MTR (meter), KG (kilogram)
- **Decimal precision**: As required by business

## Validation Best Practices

### Schema Validation
1. Validate against UBL 2.1 XSD schemas
2. Check business rule compliance
3. Verify Singapore-specific requirements
4. Test with PEPPOL validation tools

### Business Logic Validation
1. Tax calculations accuracy
2. Total amounts consistency
3. Mandatory field presence
4. Data format compliance

### Testing Approach
1. Unit test individual components
2. Integration test complete documents
3. End-to-end test with PEPPOL network
4. Regulatory compliance testing

## Common Pitfalls and Solutions

### Schema Validation Errors
- **Issue**: Namespace declarations missing
- **Solution**: Include all required namespace declarations

### Tax Calculation Mismatches
- **Issue**: Rounding differences in tax amounts
- **Solution**: Use consistent rounding rules (2 decimal places)

### Missing Mandatory Elements
- **Issue**: Required fields not populated
- **Solution**: Use comprehensive validation checklist

### Incorrect Date Formats
- **Issue**: Dates not in ISO format
- **Solution**: Always use YYYY-MM-DD format

## Tools and Resources

### Validation Tools
- Saxon XSLT processor for Schematron validation
- XMLSpy for schema validation
- Online UBL validators

### Development Libraries
- **Java**: UBL-Tools library
- **.NET**: UBL.NET library
- **Python**: PyUBL library
- **JavaScript**: UBL-JS library

### Official Resources
- [UBL 2.1 Specification](http://docs.oasis-open.org/ubl/UBL-2.1.html)
- [PEPPOL BIS Documentation](https://docs.peppol.eu/)
- [Singapore BIS Guidelines](https://www.imda.gov.sg/)
