# Singapore BIS Billing 3

A comprehensive collection of Singapore Business Information System (BIS) billing XML examples following UBL 2.1 standards and PEPPOL specifications.

## 📋 Overview

This repository contains XML examples for Singapore's e-invoicing system, demonstrating various billing scenarios including invoices, credit notes, and different GST treatments. All examples are compliant with:

- UBL 2.1 (Universal Business Language)
- EN 16931 European Standard for Electronic Invoicing
- PEPPOL BIS Billing 3.0
- Singapore GST regulations

## 📁 Examples Categories

### Invoices
- **Basic Examples**: Standard invoice formats
- **GST Scenarios**: Various GST treatments (standard, zero-rated, exempt)
- **Payment Methods**: Bank transfer, GIRO, PayNow, Credit card

## 🚀 Quick Start

1. Clone the repository:
   ```bash
   git clone https://github.com/your-username/singapore-bis-billing-examples.git
   cd singapore-bis-billing-examples
   ```

2. Browse examples in the `examples/` directory

3. Validate XML files using provided validation tools

## 📖 Documentation

- [Singapore BIS Specifications](docs/singapore-bis-specifications.md)
- [UBL Schema Guide](docs/ubl-schema-guide.md)
- [Validation Guidelines](docs/validation-guidelines.md)

## 🛠️ Tools

- XML validators
- Format converters
- Compliance checkers

## 📋 Example Index

| File | Description | Category |
|------|-------------|----------|
| [CN-001-basic](examples/credit-notes/CN-001-basic.xml) | Basic credit note | Credit Notes |
| [INV-001-full-valid](examples/invoices/basic/INV-001-full-valid.xml) | Complete valid invoice | Basic |
| [INV-002-allowances-charges](examples/invoices/basic/INV-002-allowances-charges.xml) | Invoice with allowances and charges | Basic |
| [INV-003-non-gst-registered](examples/invoices/gst-scenarios/INV-003-non-gst-registered.xml) | Non-GST registered supplier | GST Scenarios |
| [INV-004-zero-rated-gst](examples/invoices/gst-scenarios/INV-004-zero-rated-gst.xml) | Zero-rated GST invoice | GST Scenarios |
| [INV-005-foreign-currency](examples/invoices/special-cases/INV-005-foreign-currency.xml) | Foreign currency invoice | Special Cases |
| [INV-006-foreign-buyer](examples/invoices/special-cases/INV-006-foreign-buyer.xml) | Foreign buyer invoice | Special Cases |
| [INV-007-bank-transfer](examples/invoices/payment-methods/INV-007-bank-transfer.xml) | Bank transfer payment | Payment Methods |
| [INV-008-paynow](examples/invoices/payment-methods/INV-008-paynow.xml) | PayNow payment method | Payment Methods |

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 📞 Support

For questions about Singapore BIS billing requirements, please refer to:
- [IMDA Singapore](https://www.imda.gov.sg/)
- [IRAS GST Guidelines](https://www.iras.gov.sg/)

## 🏷️ Tags

`singapore` `bis` `billing` `e-invoicing` `ubl` `xml` `peppol` `gst` `accounting` `fintech`