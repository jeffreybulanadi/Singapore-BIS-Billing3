# Validation Guidelines

This document provides comprehensive validation guidelines for Singapore BIS billing XML documents.

## Overview

Proper validation ensures that your XML documents are compliant with UBL 2.1, PEPPOL BIS 3.0, and Singapore-specific requirements. This guide covers multiple validation layers and common validation scenarios.

## Validation Layers

### 1. XML Schema Validation (XSD)
- **Purpose**: Structural validation against UBL 2.1 schemas
- **Coverage**: Element presence, data types, cardinality
- **Tools**: xmllint, Saxon, XMLSpy

### 2. Schematron Business Rules
- **Purpose**: Business logic validation
- **Coverage**: Cross-field validations, calculations, business constraints
- **Tools**: Saxon with Schematron stylesheets

### 3. Singapore BIS Compliance
- **Purpose**: Local regulatory compliance
- **Coverage**: GST rules, mandatory fields, format requirements
- **Tools**: Singapore BIS validator, custom validation scripts

### 4. PEPPOL Network Validation
- **Purpose**: Network transmission readiness
- **Coverage**: Endpoint validation, routing requirements
- **Tools**: PEPPOL validation service, access point validators

## Validation Checklist

### Document Structure ✅
- [ ] Valid XML declaration with UTF-8 encoding
- [ ] Correct root element (Invoice, CreditNote, DebitNote)
- [ ] All required namespaces declared
- [ ] UBL version 2.1 specified
- [ ] Singapore customization ID present

### Mandatory Fields ✅
- [ ] Document ID (Invoice number)
- [ ] Issue date in YYYY-MM-DD format
- [ ] Document type code (380, 381, 383)
- [ ] Document currency code
- [ ] Supplier information complete
- [ ] Customer information complete

### Singapore-Specific Requirements ✅
- [ ] GST registration number (if applicable)
- [ ] Correct GST tax categories
- [ ] Proper currency handling
- [ ] Valid UEN format
- [ ] Singapore address format

### Calculations ✅
- [ ] Line extension amounts = quantity × unit price
- [ ] Tax amounts calculated correctly (2 decimal precision)
- [ ] Document totals reconcile
- [ ] Allowances/charges properly applied
- [ ] Currency consistency throughout document

## Validation Tools

### Command Line Tools

#### xmllint (XML Schema Validation)
```bash
# Validate against UBL Invoice schema
xmllint --schema UBL-Invoice-2.1.xsd invoice.xml --noout

# Check well-formedness
xmllint invoice.xml --noout
```

#### Saxon (Schematron Validation)
```bash
# Transform Schematron to XSLT
java -jar saxon.jar -s:PEPPOL-EN16931-UBL.sch -xsl:schematron-skeleton.xsl -o:validation.xsl

# Validate document
java -jar saxon.jar -s:invoice.xml -xsl:validation.xsl
```

### Online Validators
- **PEPPOL Validation Service**: https://validation.peppol.org/
- **UBL Validators**: Various online schema validators
- **Singapore BIS Validator**: Government-provided validation tools

### Programming Libraries

#### Java Example
```java
import javax.xml.validation.Schema;
import javax.xml.validation.SchemaFactory;
import javax.xml.validation.Validator;

// Schema validation
SchemaFactory factory = SchemaFactory.newInstance(XMLConstants.W3C_XML_SCHEMA_NS_URI);
Schema schema = factory.newSchema(new File("UBL-Invoice-2.1.xsd"));
Validator validator = schema.newValidator();
validator.validate(new StreamSource(new File("invoice.xml")));
```

#### C# Example
```csharp
XmlReaderSettings settings = new XmlReaderSettings();
settings.Schemas.Add("urn:oasis:names:specification:ubl:schema:xsd:Invoice-2", 
                     "UBL-Invoice-2.1.xsd");
settings.ValidationType = ValidationType.Schema;
settings.ValidationEventHandler += ValidationEventHandler;

XmlReader reader = XmlReader.Create("invoice.xml", settings);
while (reader.Read()) { }
```

## Common Validation Errors

### Schema Validation Errors

#### Missing Namespace Declaration
```xml
<!-- ❌ Incorrect -->
<Invoice>
    <cbc:ID>INV-001</cbc:ID>
</Invoice>

<!-- ✅ Correct -->
<Invoice xmlns="urn:oasis:names:specification:ubl:schema:xsd:Invoice-2"
         xmlns:cbc="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2">
    <cbc:ID>INV-001</cbc:ID>
</Invoice>
```

#### Invalid Element Order
```xml
<!-- ❌ Incorrect order -->
<Invoice>
    <cbc:ID>INV-001</cbc:ID>
    <cbc:UBLVersionID>2.1</cbc:UBLVersionID>
</Invoice>

<!-- ✅ Correct order -->
<Invoice>
    <cbc:UBLVersionID>2.1</cbc:UBLVersionID>
    <cbc:ID>INV-001</cbc:ID>
</Invoice>
```

### Business Rule Violations

#### Tax Calculation Error
```xml
<!-- ❌ Incorrect calculation -->
<cac:TaxSubtotal>
    <cbc:TaxableAmount currencyID="SGD">100.00</cbc:TaxableAmount>
    <cbc:TaxAmount currencyID="SGD">7.00</cbc:TaxAmount> <!-- Should be 8.00 -->
    <cac:TaxCategory>
        <cbc:ID>SR</cbc:ID>
        <cbc:Percent>8.0</cbc:Percent>
    </cac:TaxCategory>
</cac:TaxSubtotal>
```

#### Missing Mandatory Reference
```xml
<!-- ❌ Missing customization ID -->
<Invoice>
    <cbc:UBLVersionID>2.1</cbc:UBLVersionID>
    <cbc:ProfileID>urn:fdc:peppol.eu:2017:poacc:billing:01:1.0</cbc:ProfileID>
</Invoice>

<!-- ✅ Complete -->
<Invoice>
    <cbc:UBLVersionID>2.1</cbc:UBLVersionID>
    <cbc:CustomizationID>urn:cen.eu:en16931:2017#conformant#urn:fdc:peppol.eu:2017:poacc:billing:international:sg:3.0</cbc:CustomizationID>
    <cbc:ProfileID>urn:fdc:peppol.eu:2017:poacc:billing:01:1.0</cbc:ProfileID>
</Invoice>
```

### Singapore-Specific Errors

#### Invalid GST Registration Format
```xml
<!-- ❌ Invalid format -->
<cac:PartyTaxScheme>
    <cbc:CompanyID>12345678</cbc:CompanyID> <!-- Missing suffix -->
</cac:PartyTaxScheme>

<!-- ✅ Valid format -->
<cac:PartyTaxScheme>
    <cbc:CompanyID>M12345678A</cbc:CompanyID>
</cac:PartyTaxScheme>
```

#### Wrong Tax Category for Non-GST Registered
```xml
<!-- ❌ Incorrect for non-GST registered supplier -->
<cac:ClassifiedTaxCategory>
    <cbc:ID>SR</cbc:ID>
    <cbc:Percent>8.0</cbc:Percent>
</cac:ClassifiedTaxCategory>

<!-- ✅ Correct for non-GST registered -->
<cac:ClassifiedTaxCategory>
    <cbc:ID>NG</cbc:ID>
    <cbc:Percent>0</cbc:Percent>
</cac:ClassifiedTaxCategory>
```

## Validation Automation

### Continuous Integration Pipeline
```yaml
# Example GitHub Actions workflow
name: XML Validation
on: [push, pull_request]

jobs:
  validate:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      
      - name: Install xmllint
        run: sudo apt-get install libxml2-utils
        
      - name: Validate XML files
        run: |
          for file in examples/**/*.xml; do
            xmllint --schema schemas/UBL-Invoice-2.1.xsd "$file" --noout
          done
```

### Custom Validation Script
```bash
#!/bin/bash
# validate-all.sh

SCHEMA_DIR="schemas"
EXAMPLES_DIR="examples"
ERRORS=0

echo "Starting validation..."

for xml_file in $(find $EXAMPLES_DIR -name "*.xml"); do
    echo "Validating: $xml_file"
    
    # Schema validation
    if ! xmllint --schema $SCHEMA_DIR/UBL-Invoice-2.1.xsd "$xml_file" --noout 2>/dev/null; then
        echo "❌ Schema validation failed: $xml_file"
        ERRORS=$((ERRORS + 1))
    fi
    
    # Business rules validation (if Schematron available)
    if [ -f "$SCHEMA_DIR/PEPPOL-validation.xsl" ]; then
        if ! saxon -s:"$xml_file" -xsl:"$SCHEMA_DIR/PEPPOL-validation.xsl" 2>/dev/null | grep -q "No errors"; then
            echo "❌ Business rules validation failed: $xml_file"
            ERRORS=$((ERRORS + 1))
        fi
    fi
done

if [ $ERRORS -eq 0 ]; then
    echo "✅ All validations passed!"
    exit 0
else
    echo "❌ $ERRORS validation errors found"
    exit 1
fi
```

## Performance Considerations

### Large Document Validation
- Use streaming XML readers for large files
- Implement progressive validation
- Cache compiled schemas
- Parallelize validation where possible

### Batch Validation
- Process files in parallel
- Use schema compilation caching
- Implement early exit on critical errors
- Provide summary reports

## Validation Reporting

### Error Report Format
```json
{
  "document": "invoice-001.xml",
  "validationDate": "2024-01-15T10:30:00Z",
  "status": "failed",
  "errors": [
    {
      "type": "schema",
      "severity": "error",
      "line": 45,
      "column": 12,
      "message": "Element 'cbc:TaxAmount' is not allowed here",
      "xpath": "/Invoice/cac:TaxTotal/cac:TaxSubtotal/cbc:TaxAmount[2]"
    },
    {
      "type": "business",
      "severity": "warning", 
      "rule": "BR-SG-01",
      "message": "GST registration number should be provided for GST registered suppliers"
    }
  ],
  "warnings": 1,
  "totalErrors": 1
}
```

### Validation Metrics
- Processing time per document
- Error frequency by type
- Compliance rate trends
- Most common validation failures

## Best Practices

### Development Phase
1. **Validate Early**: Integrate validation into development workflow
2. **Use Templates**: Start with validated example templates
3. **Test Incrementally**: Validate components before full document
4. **Document Decisions**: Record validation rule interpretations

### Production Phase
1. **Pre-transmission Validation**: Always validate before sending
2. **Error Logging**: Maintain detailed validation logs
3. **Monitoring**: Track validation success rates
4. **Quick Recovery**: Have processes for fixing common errors

### Maintenance Phase
1. **Regular Updates**: Keep validation tools current
2. **Rule Evolution**: Adapt to changing regulations
3. **Performance Monitoring**: Track validation performance
4. **Training**: Keep team updated on validation requirements

## Troubleshooting Guide

### Schema Loading Issues
- Verify schema file paths
- Check network connectivity for remote schemas  
- Ensure proper file permissions
- Validate schema files themselves

### Performance Problems
- Profile validation code
- Optimize schema caching
- Consider streaming parsers
- Parallelize where appropriate

### False Positives
- Review business rule interpretations
- Check for schema version mismatches
- Verify test data quality
- Consult specification documentation

## Resources

### Validation Tools
- [Saxon XSLT Processor](http://saxonica.com/)
- [XMLSpy Validator](https://www.altova.com/xmlspy-xml-editor)
- [PEPPOL Validation](https://validation.peppol.org/)

### Specifications
- [UBL 2.1 Documentation](http://docs.oasis-open.org/ubl/UBL-2.1.html)
- [PEPPOL BIS Billing 3.0](https://docs.peppol.eu/poacc/billing/3.0/)
- [EN 16931 Standard](https://standards.cen.eu/dyn/www/f?p=204:110:0::::FSP_PROJECT:60602&cs=1B61B766636F9FB34B7DBD72CE9026C72)

### Singapore Resources
- [IMDA Guidelines](https://www.imda.gov.sg/)
- [IRAS GST Information](https://www.iras.gov.sg/)
- [Singapore Standards](https://www.singaporestandardseshop.sg/)
