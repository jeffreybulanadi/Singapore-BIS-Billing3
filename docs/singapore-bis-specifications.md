# Singapore BIS Specifications Guide

This document provides an overview of Singapore's Business Information System (BIS) specifications for electronic invoicing.

## 📋 Overview

Singapore BIS is the national e-invoicing framework that enables businesses to exchange invoices electronically in a standardized format. It is based on international standards including UBL 2.1 and PEPPOL specifications, with Singapore-specific adaptations.

## 🏛️ Regulatory Framework

### Key Authorities
- **IMDA (Infocomm Media Development Authority)**: Technical standards and implementation
- **IRAS (Inland Revenue Authority of Singapore)**: GST compliance and tax requirements
- **Ministry of Finance**: Policy and regulatory oversight

### Legal Requirements
- Companies with annual revenue > SGD 10 million must adopt e-invoicing
- GST-registered businesses must comply with digital invoice requirements
- Phased implementation timeline from 2024-2026

## 🔧 Technical Specifications

### Core Standards
- **UBL 2.1**: Universal Business Language standard
- **EN 16931**: European standard for electronic invoicing (Singapore-adapted)
- **PEPPOL BIS Billing 3.0**: International interoperability standard

### Singapore Customization ID
```xml
<cbc:CustomizationID>urn:cen.eu:en16931:2017#conformant#urn:fdc:peppol.eu:2017:poacc:billing:international:sg:3.0</cbc:CustomizationID>
```

### Profile ID
```xml
<cbc:ProfileID>urn:fdc:peppol.eu:2017:poacc:billing:01:1.0</cbc:ProfileID>
```

## 🇸🇬 Singapore-Specific Requirements

### 1. GST Handling

#### GST Categories
- **S**: Standard rated (7%)
- **ZR**: Zero-rated
- **E**: Exempt
- **NG**: Not liable for GST

#### GST Registration
```xml
<cac:PartyTaxScheme>
    <cbc:CompanyID>M12345678X</cbc:CompanyID>
    <cac:TaxScheme>
        <cbc:ID>GST</cbc:ID>
    </cac:TaxScheme>
</cac:PartyTaxScheme>
```

### 2. Currency Requirements
- Primary currency: Singapore Dollar (SGD)
- Foreign currency invoices require SGD equivalent
- Exchange rates must be documented

### 3. Business Registration
- UEN (Unique Entity Number) mandatory for all entities
- Format: XXXXXXXXX (9 characters) or XXXXXXXXXY (10 characters with suffix)

### 4. Addressing Standards
```xml
<cac:PostalAddress>
    <cbc:StreetName>Block 123 Toa Payoh Lorong 1</cbc:StreetName>
    <cbc:AdditionalStreetName>#12-345</cbc:AdditionalStreetName>
    <cbc:CityName>Singapore</cbc:CityName>
    <cbc:PostalZone>310123</cbc:PostalZone>
    <cbc:CountrySubentity>Singapore</cbc:CountrySubentity>
    <cac:Country>
        <cbc:IdentificationCode>SG</cbc:IdentificationCode>
    </cac:Country>
</cac:PostalAddress>
```

### 5. Payment Methods

#### Supported Payment Types
- Bank transfer (Code: 30)
- GIRO (Code: 59)
- PayNow (Code: ZZZ with PayNow identifier)
- Credit card (Code: 54)
- Cheque (Code: 20)

#### PayNow Integration
```xml
<cac:PaymentMeans>
    <cbc:PaymentMeansCode>ZZZ</cbc:PaymentMeansCode>
    <cbc:InstructionNote>PayNow</cbc:InstructionNote>
    <cac:PayeeFinancialAccount>
        <cbc:ID>91234567</cbc:ID>
        <cbc:Name>PayNow Mobile</cbc:Name>
    </cac:PayeeFinancialAccount>
</cac:PaymentMeans>
```

## 📊 Document Types

### Invoice Types
- **380**: Commercial Invoice
- **384**: Corrected Invoice
- **389**: Self-billed Invoice
- **751**: Invoice information for accounting purposes

### Credit Note Types
- **381**: Credit Note
- **396**: Factored Credit Note

## 🔗 Network Requirements

### PEPPOL Network
- Singapore is part of the PEPPOL (Pan-European Public Procurement On-Line) network
- Enables international B2B and B2G transactions
- Requires certified access points

### Endpoint Identification
- Electronic Address Scheme: 0195 (Singapore UEN)
- Format: SGUENXXXXXXXXX (where X is the UEN)

## ✅ Validation Requirements

### Mandatory Business Rules
- BR-1: Invoice must contain supplier and customer information
- BR-2: Invoice must contain at least one invoice line
- BR-3: Document currency must be specified
- BR-4: GST treatment must be specified for each line item
- BR-SG-1: UEN must be provided for Singapore entities
- BR-SG-2: GST registration number required for GST-registered suppliers
- BR-SG-3: Proper GST calculation and classification

### Data Quality Rules
- Amounts must be calculated correctly
- Dates must be in ISO format (YYYY-MM-DD)
- Currency codes must follow ISO 4217
- Country codes must follow ISO 3166-1 alpha-2

## 🏢 Industry-Specific Considerations

### Government Contracts
- Additional document references required
- Compliance with Government e-Procurement standards
- Special reporting requirements

### Financial Services
- Enhanced documentation for regulatory compliance
- Special GST treatment considerations
- Cross-border transaction requirements

### Healthcare
- Insurance claim integration
- Patient data privacy considerations
- Medical coding standards

## 📈 Implementation Timeline

### Phase 1 (2024)
- Large enterprises (revenue > SGD 10M)
- Government suppliers

### Phase 2 (2025)
- Medium enterprises (revenue SGD 1M - 10M)
- Key industry sectors

### Phase 3 (2026)
- Small enterprises
- Full ecosystem implementation

## 🛠️ Integration Methods

### API Integration
- RESTful APIs for invoice submission
- Real-time validation and acknowledgment
- Status tracking and error handling

### File Upload
- Batch processing capabilities
- Support for multiple file formats
- Scheduled processing options

### ERP Integration
- Pre-built connectors for major ERP systems
- Custom integration support
- Data mapping assistance

## 📋 Compliance Checklist

- [ ] UBL 2.1 schema compliance
- [ ] Singapore customization ID included
- [ ] GST calculations accurate
- [ ] UEN provided for all Singapore entities
- [ ] Currency properly specified
- [ ] Payment terms clearly defined
- [ ] Digital signature applied (if required)
- [ ] Document retention policy followed

## 📞 Support Resources

### Official Channels
- IMDA Digital Services Portal
- IRAS GST e-Services
- Business.gov.sg

### Technical Support
- PEPPOL Singapore Community
- Certified Service Providers
- Integration Partners

## 🔄 Updates and Changes

This specification is subject to updates. Always refer to the latest version from official sources:

- [IMDA Official Portal](https://www.imda.gov.sg/)
- [Singapore PEPPOL Authority](https://www.peppol.sg/)
- [IRAS GST Guidelines](https://www.iras.gov.sg/)

---

*Last updated: June 2025*
