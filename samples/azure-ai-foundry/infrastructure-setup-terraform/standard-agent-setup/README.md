---
description: This set of templates demonstrates how to set up Azure AI Agent Service to connect the agent to your secure data.
page_type: sample
products:
- azure
- azure-resource-manager
urlFragment: standard-agent-setup
languages:
- hcl
---



## Module Structure

```text
code/
├── data.tf                                         # Creates data objects for active subscription being deployed to and deployment security context
├── locals.tf                                       # Creates local variables for project GUID
├── main.tf                                         # Main deployment file        
├── outputs.tf                                      # Placeholder file for future outputs
├── providers.tf                                    # Terraform provider configuration 
├── example.tfvars                                  # Sample tfvars file
├── variables.tf                                    # Terraform variables
├── versions.tf                                     # Configures minimum Terraform version and versions for providers
```
