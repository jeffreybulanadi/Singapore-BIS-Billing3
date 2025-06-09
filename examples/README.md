# Singapore BIS Billing Examples Index

This directory contains comprehensive XML examples for Singapore BIS billing compliance.

## 📁 Directory Structure

```
examples/
├── invoices/           # Invoice examples
│   ├── basic/          # Standard invoice scenarios
│   ├── gst-scenarios/  # Different GST treatments
│   ├── payment-methods/ # Various payment options  
│   └── special-cases/  # Unique business scenarios
├── credit-notes/       # Credit note examples
└── error-examples/     # Common validation errors
```

## 📋 Complete Examples Index

### Credit Notes
| File | Description | Use Case |
|------|-------------|----------|
| [CN-001-basic-credit-note.xml](credit-notes/CN-001-basic-credit-note.xml) | Basic credit note with standard GST | Product return, price adjustment |

### Invoices - Basic Scenarios
| File | Description | Use Case |
|------|-------------|----------|
| [INV-001-full-valid-invoice.xml](invoices/basic/INV-001-full-valid-invoice.xml) | Complete invoice with all standard elements | Standard B2B transaction |
| [INV-002-allowances-and-charges.xml](invoices/basic/INV-002-allowances-and-charges.xml) | Invoice with discounts and additional charges | Complex pricing scenarios |
| [INV-003-agd-compliant-with-references.xml](invoices/basic/INV-003-agd-compliant-with-references.xml) | Government-compliant invoice with purchase order references | Government procurement |
| [INV-004-decimals.xml](invoices/basic/INV-004-decimals.xml) | Invoice demonstrating decimal precision handling | Precise quantity/pricing scenarios |

### Invoices - GST Scenarios
| File | Description | Use Case |
|------|-------------|----------|
| [INV-003-non-gst-registered.xml](invoices/gst-scenarios/INV-003-non-gst-registered.xml) | Invoice from non-GST registered supplier | Small business transactions |
| [INV-004-zero-rated-gst.xml](invoices/gst-scenarios/INV-004-zero-rated-gst.xml) | Zero-rated GST invoice | Export transactions |
| [INV-005-gst-in-sgd.xml](invoices/gst-scenarios/INV-005-gst-in-sgd.xml) | Standard GST invoice in SGD | Local GST-registered transactions |

### Invoices - Payment Methods
| File | Description | Use Case |
|------|-------------|----------|
| [INV-008-bank-transfer.xml](invoices/payment-methods/INV-008-bank-transfer.xml) | Invoice with bank transfer payment details | Traditional banking |
| [INV-009-giro.xml](invoices/payment-methods/INV-009-giro.xml) | Invoice with GIRO payment setup | Automated recurring payments |
| [INV-010-paynow.xml](invoices/payment-methods/INV-010-paynow.xml) | Invoice with PayNow payment option | Modern digital payments |
| [INV-011-credit-card.xml](invoices/payment-methods/INV-011-credit-card.xml) | Invoice with credit card payment | Consumer transactions |

### Invoices - Special Cases
| File | Description | Use Case |
|------|-------------|----------|
| [INV-004-foreign-currency.xml](invoices/special-cases/INV-004-foreign-currency.xml) | Invoice in foreign currency | International trade |
| [INV-005-foreign-buyer.xml](invoices/special-cases/INV-005-foreign-buyer.xml) | Invoice to foreign customer | Export scenarios |
| [INV-006-factored-invoice.xml](invoices/special-cases/INV-006-factored-invoice.xml) | Invoice for factoring arrangements | Invoice financing |
| [INV-007-prepayment.xml](invoices/special-cases/INV-007-prepayment.xml) | Invoice with prepayment scenarios | Advance payment handling |

### Error Examples
| File | Description | Learning Purpose |
|------|-------------|------------------|
| [INV-ERROR-001-gst-validation-errors.xml](error-examples/INV-ERROR-001-gst-validation-errors.xml) | Common GST validation errors | Error identification and fixing |

## 🎯 Usage Scenarios

### For Developers
- **Integration Testing**: Use these examples to test your UBL generation code
- **Schema Validation**: Validate your XML output against working examples
- **Business Logic**: Understand proper GST calculations and business rules

### For Business Analysts
- **Requirements Gathering**: See real-world scenarios in XML format
- **Compliance Review**: Understand regulatory requirements through examples
- **Process Design**: Map business processes to XML structures

### For System Integrators
- **PEPPOL Integration**: Test PEPPOL network connectivity
- **ERP Mapping**: Map ERP data to UBL structures
- **Validation Testing**: Ensure compliance before production

## 📊 Example Categories by Complexity

### Beginner Level
- Basic invoice with minimal fields
- Simple credit note
- Standard GST scenarios

### Intermediate Level
- Allowances and charges
- Multiple payment methods
- Foreign currency handling

### Advanced Level
- Government compliance (AGD)
- Complex business scenarios
- Multi-party transactions

## 🔍 How to Use These Examples

### 1. Find Relevant Example
```bash
# Search for payment-related examples
find examples/ -name "*payment*" -o -name "*giro*" -o -name "*paynow*"

# Search for GST scenarios
find examples/ -name "*gst*" -o -name "*tax*"
```

### 2. Validate Example
```bash
# Validate single file
./validation/scripts/validate-xml.sh examples/invoices/basic/INV-001-full-valid-invoice.xml

# Validate all examples
./validation/scripts/validate-xml.sh
```

### 3. Study Structure
```bash
# View formatted XML
xmllint --format examples/invoices/basic/INV-001-full-valid-invoice.xml

# Extract specific elements
xmllint --xpath "//cac:TaxTotal" examples/invoices/basic/INV-001-full-valid-invoice.xml
```

### 4. Adapt for Your Use Case
1. Copy relevant example as template
2. Modify party information (supplier/customer)
3. Update line items and amounts
4. Adjust GST treatment as needed
5. Validate modified document

## 🛠️ Testing Your Implementation

### Unit Testing
```python
def test_invoice_generation():
    # Generate your XML
    generated_xml = generate_invoice(test_data)
    
    # Compare with reference example
    reference_xml = load_example("INV-001-full-valid-invoice.xml")
    
    # Validate structure similarity
    assert_xml_structure_matches(generated_xml, reference_xml)
```

### Integration Testing
```java
@Test
public void testPeppolValidation() {
    // Load your generated invoice
    Document invoice = loadInvoice("my-generated-invoice.xml");
    
    // Validate against PEPPOL rules
    ValidationResult result = peppolValidator.validate(invoice);
    
    // Assert no errors
    assertTrue(result.isValid());
}
```

## 📈 Business Scenarios Covered

### Standard Business Operations
- Product sales with GST
- Service billing
- Subscription invoicing
- Project-based billing

### Special Circumstances
- Export transactions (zero-rated GST)
- Import handling
- Multi-currency operations
- Government procurement

### Financial Operations
- Credit notes for returns
- Debit notes for additional charges
- Prepayment invoicing
- Invoice factoring

### Payment Processing
- Traditional bank transfers
- Modern digital payments (PayNow)
- Automated payments (GIRO)
- Credit card processing

## 🔧 Customization Guidelines

### Adapting Examples
1. **Never modify original examples** - copy to new files
2. **Update document IDs** - ensure uniqueness
3. **Change party information** - use your business details
4. **Adjust line items** - match your products/services
5. **Validate thoroughly** - test all modifications

### Common Customizations
- Company information (name, address, GST number)
- Product/service descriptions
- Pricing and tax calculations
- Payment terms and methods
- Currency and exchange rates

## 🚨 Important Notes

### Production Usage
- **Remove test data**: Replace all example data with real information
- **Validate thoroughly**: Test all business rules and calculations
- **Security review**: Ensure no sensitive data in examples
- **Compliance check**: Verify current regulatory requirements

### Legal Compliance
- These examples are for technical reference only
- Always consult current IRAS and IMDA guidelines
- Verify GST rates and regulations
- Ensure proper business registration and licensing

## 📞 Getting Help

### Validation Issues
1. Check validation logs in `validation/`
2. Review error examples for common issues
3. Consult documentation in `docs/`
4. Test with PEPPOL validation service

### Business Rule Questions
1. Refer to Singapore BIS specifications
2. Consult IRAS GST guidelines
3. Review PEPPOL BIS documentation
4. Contact relevant authorities for clarification

---

*Last updated: Current as of repository creation. Always verify with latest regulatory requirements.*
