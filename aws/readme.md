# AWS IAM Role Terraform Configuration

This repository contains Terraform configuration for creating an AWS IAM role with audit and inventory scanning capabilities.

## Prerequisites

- Terraform installed on your local machine
- AWS CLI configured with appropriate credentials
- Access to create IAM roles and policies in your AWS account

## Deployment Steps

### 1. Initialize the Terraform Configuration

Once you have the `.tf` file, navigate to the directory containing the Terraform code and run the following command to initialize Terraform. This will install the necessary provider plugins (AWS in this case).

```bash
terraform init
```

This command prepares your working directory by initializing the backend and downloading the required provider plugins.

### 2. Review the Plan

Before applying the configuration, you should review what Terraform is planning to do. Run the following command to generate an execution plan:

```bash
terraform plan
```

This will display the actions Terraform will take (e.g., creating the IAM role and attaching policies).

### 3. Apply the Terraform Configuration

After reviewing the plan, you can apply the configuration by running:

```bash
terraform apply
```

Terraform will ask for confirmation before proceeding. Type `yes` to allow it to create the IAM role and attach the policies.

### 4. Verify the Changes

Once Terraform has applied the configuration, verify that the IAM role and policies were created successfully in the AWS Management Console:

- **IAM Role**: Go to the IAM section in the AWS Console, and you should see the role `ace-engine-audit-scan-role` listed under "Roles."
- **Attached Policies**: Verify that the SecurityAudit, ViewOnlyAccess and Inventory policies are attached to the role.
- **External ID**: Open the Trust Relationships tab of the IAM role and confirm that the external ID condition is present in the AssumeRole policy.

## Files in this Repository

- `main.tf` - Main Terraform configuration file
- `Inventory_collect_policy.json` - IAM policy for inventory collection
- `Inventory_collect_policy_2.json` - Additional inventory collection policy
- `Inventory_mutate_policy.json` - IAM policy for inventory mutations

## Cleanup

To remove the created resources, run:

```bash
terraform destroy
```
