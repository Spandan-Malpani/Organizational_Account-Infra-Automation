# OU-Account-Infra-Deployment-Automation

This repository contains infrastructure as code (IaC) to set up VPC and related networking resources in AWS accounts. It helps automate the deployment of networking resources, security configurations, and IAM roles for new accounts being added to an AWS Organization.

## Description

The **OU-Account-Infra-Deployment-Automation** is a solution that automates the deployment of essential resources required for networking, security, and access management in an AWS account. This infrastructure is modularized into three main components:

1. **VPC**: For networking resources like VPC, subnets, route tables, etc.
2. **Security**: Configurations for security services like AWS GuardDuty, Security Hub, IAM password policies, and S3 public access blocking.
3. **IAM**: Creation of necessary IAM roles for services like Lambda, support access, and logging.

This approach provides a standardized and generalized framework that can be used across any organization to deploy networking and security resources in AWS.

---

## Deployed Network Resource Map 

![ResourceMap](https://github.com/user-attachments/assets/1a7f3244-1447-46b2-b63c-b0ab4a4e245e)


## Project Structure

```bash
OU-Account-Infra-Deployment-Automation
│
|── modules
|   ├── vpc
|   │   ├── main.tf         # VPC-specific resource definitions
|   │   ├── variables.tf    # VPC-specific variable definitions
|   │   └── output.tf       # VPC-specific output definitions
|   │
|   ├── Security
|   │   ├── main.tf         # Security-related resources (e.g., Security Groups)
|   │   ├── variables.tf    # Security-specific variable definitions
|   │   └── output.tf       # Security-specific output definitions
|   │
|   └── IAM
|       ├── main.tf         # IAM-related resources (e.g., roles, policies)
|       ├── variables.tf    # IAM-specific variable definitions
|       └── output.tf       # IAM-specific output definitions
│
├── main.tf                 # Root Terraform configuration file
├── variables.tf            # Root variable definitions
├── terraform.tfvars        # Root variable values (specific to environments)
├── provider.tf             # Provider configuration (e.g., AWS, Azure)
└── backend.tf              # Backend configuration (e.g., for remote state storage)
```

## Components

### 1. **VPC**

This component creates VPC resources (VPC, Subnets, Route Tables, Endpoint services, Flow Logs, etc.) with custom names and CIDR blocks as per the organization’s requirements.

Key tasks include:
- Creating a VPC with custom CIDR blocks.
- Setting up subnets (public/private).
- Configuring route tables and Internet Gateways.
- Enabling VPC flow logs for network traffic monitoring.

The routing is initially configured based on standard network architecture but can be customized according to specific organizational needs.

### 2. **Security**

This component configures AWS security-related services:
- **AWS GuardDuty**: Enables GuardDuty for threat detection.
- **AWS Security Hub**: Enables security standards and best practices monitoring.
- **S3 Public Access Block**: Blocks any S3 bucket from public access.
- **IAM Password Policies**: Enforces strong password policies for IAM users.

### 3. **IAM**

This module creates necessary IAM roles and policies:
- IAM roles for Lambda functions.
- IAM roles for account support and access management.
- IAM roles to allow services to interact with other AWS services.

---
## Usage Instructions

### Approach 1: Deploy Before Adding to Organization

1. Deploy this infrastructure in the AWS account first.
2. Once deployment is successful, add the account to the appropriate Organizational Unit (OU) in AWS Organizations.

### Approach 2: Deploy After Adding to Organization (Preferred)

1. Add the AWS account to the appropriate Organizational Unit (OU).
2. Deploy this infrastructure in the member account.

---
## Prerequisites

Before you begin, ensure the following prerequisites are met:

- **AWS Account**: You must have an active AWS account. If you don’t have one, you can sign up at [AWS Sign-Up](https://aws.amazon.com/).
- **AWS CLI**: AWS Command Line Interface (CLI) should be installed and configured. (Steps given below)
- **Terraform**: Terraform should be installed on your system. (Steps given below)

---
### Step 1: Install AWS CLI

#### 1.1. Install AWS CLI on Windows/Linux/MacOs

1. Follow the AWS official Documentation - [AWS CLI INSTALLER GUIDE](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html).
2. Once installed, verify the installation by running:

 ```bash
 aws --version
 ```
This should output the version of AWS CLI, confirming it’s successfully installed.

### Step 2: Set Up IAM User and Access Keys

To interact with AWS services through the CLI, you need AWS credentials (access key ID and secret access key). These credentials should be associated with an IAM user.

#### 2.1. Create an IAM User

1. Sign in to the AWS Management Console.
2. Navigate to IAM (Identity and Access Management) from the AWS console.
3. In the left-hand sidebar, click Users and then click the Add user button.
4. Provide a User name (e.g., Terraform-user).
5. On the Set permissions page, choose Attach policies directly.
6. Choose a policy, such as AdministratorAccess (or a more restrictive policy based on your use case).
7. Click Next: Tags (you can skip tagging, but it’s good practice for organizational purposes).
8. Review the configuration and click Create user.
9. Now, In the IAM dashboard, on the left-hand side, click on Users under the Access management section.
10. Click on the User you just created to generate the access keys.
11. In the user details page, click on the Security credentials tab.
12. Click the Create access key button. This will generate a new Access Key ID and Secret Access Key.
13. After the keys are generated, make sure to download the .csv file or copy the keys and store them securely.
    
Example:   
The file will contain :
- Access Key ID: `AKIAEXAMPLEKEY123`
- Secret Access Key: `wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY` 

> [!NOTE]
> Ensure to save the Access key ID and Secret access key that are generated. You won’t be able to retrieve them again.

### Step 3: Configure AWS CLI

Once you have your IAM user’s credentials, you can configure the AWS CLI.

#### 3.1. Run AWS CLI Configuration Command

Open a terminal in VS Code or Command Prompt on Windows and run the following command:

```bash
aws configure
```
This will prompt you to enter the following:

- AWS Access Key ID: Enter the access key ID obtained in Step 2.
- AWS Secret Access Key: Enter the secret access key obtained in Step 2.
- Default region name: Enter the AWS region you want to interact with (e.g., us-west-2, us-east-1). You can always change it later.
- Default output format: Choose your preferred output format. You can choose from:
  - json (default)
  - text
  - table
  - (Keep it Empty if not required)

Example:

```bash
AWS Access Key ID [None]: <your-access-key-id>
AWS Secret Access Key [None]: <your-secret-access-key>
Default region name [None]: us-west-2
Default output format [None]:
```

### Step 4: Install & Setup Terraform 

#### 4.1. Install Terraform on Windows/Linux/MacOS

Download Terraform:
Go to the [Terraform Downloads](https://developer.hashicorp.com/terraform/install) page and download the appropriate version for your OS.

**For Windows**
1. After downloading, extract the ZIP file to a directory of your choice. For example, you can extract it to C:\Terraform.
2. Right-click on 'This PC' (or 'Computer') and select Properties.
3. Click on Advanced system settings on the left.
4. In the System Properties window, click the Environment Variables button.
5. Under System variables, scroll down to select the Path variable and click Edit.
6. In the Edit Environment Variable dialog, click New and then add the path to the directory where you extracted Terraform (e.g., 
   C:\Terraform). For example, if you extracted Terraform to C:\Terraform, add C:\Terraform to your PATH.
7. Click OK to save and close all the dialogs.
8. Verify Installation: Open Command Prompt and run the following command:

```bash
terraform --version
```
If installed correctly, you should see the version of Terraform installed.

### Step 5: Configuring Backend

#### 5.1. Creating Backend S3 Bucket to store Terraform state file
 
 1. Navigate to S3 Console
 2. Click on the "Create bucket" Button
 3. Enter Bucket Name, choose a globally unique name for your S3 bucket. Example: my-terraform-bucket-123
 4. Select a Region, choose an AWS region where your bucket will reside.
 5. Set Bucket Configuration Options (Optional)
      - Versioning: You can enable versioning if you want to keep multiple versions of the same object in your bucket.
      - Tags: You can add metadata to the bucket by adding tags (key-value pairs).
      - Object Lock: If you need to enforce write once, read many (WORM) protection for the objects in the bucket, enable Object Lock.
      - Encryption: Enable encryption to automatically encrypt objects when they are uploaded to the bucket.
      - Advanced settings: Additional settings such as logging, website hosting, and replication.
 6. Review and Create.

## Provisioning

### 1. Clone the repository on your local machine

```bash
git clone <repository-url>
cd OU-Account-Infra-Deployment-Automation/
```
### 2. Adding backend configuration

 - In command prompt open the file `backend.tf` inside the project directory  OR  Open the project in VS Code (Or any other code editor) and open the file `backend.tf`.
 - In the `backend.tf` whick looks like this:

```hcl
terraform {
  backend "s3" {
    bucket         = "<your-backend-s3-bucket-name>" # Enter the name of the S3 bucket you created
    key            = "terraform.tfstate"
    region         = "<aws-region>" # Region of the Backend S3 Bucket you created
    encrypt        = true
  }
}
```

### 3. Configuring variables to meet custom requirements

 - Configuring Variables inside the `terraform.tfvars` file will help you achieve your requirement. Every detail is mentioned inside the `terraform.tfvars` file to help you achieve your requirement:

```hcl
#Security

# IAM Password Policy
password_policy = {
  minimum_password_length        = 14
  require_lowercase_characters   = true
  require_uppercase_characters   = true
  require_numbers                = true
  require_symbols                = true
  allow_users_to_change_password = true
  password_reuse_prevention      = 24
  max_password_age               = 90
  hard_expiry                    = false
  aws_region                     = "us-east-1"
}

#VPC
aws_region                           = "us-east-1" # region for resources to be deployed in
vpc_name                             = "Custom-VPC" # VPC name
vpc_cidr_block                       = "10.0.0.0/16" # VPC CIDR
igw_name                             = "custom-igw" # IGW name

####################################################
# Provide CIDRS for Public and Private Subnets alongwith their respective availabilty zones here
####################################################
/* EXAMPLE: 3 PUBLIC SUBNETS ARE BEING CREATED WITH 2 IN THE SAME AZ. 5 PRIVATE SUBNETS WITH 2 IN THE SAME AZ. ADJUST AS PER YOUR REQUIREMENT. */
subnet_configurations = {                         
  public = [
    {
      cidr_block        = "10.0.1.0/24"
      availability_zone = "us-east-1a"
    },
    {
      cidr_block        = "10.0.2.0/24"
      availability_zone = "us-east-1a"
    },
    {
      cidr_block        = "10.0.3.0/24"
      availability_zone = "us-east-1b"
    }
  ]
  private = [
    {
      cidr_block        = "10.0.4.0/24"
      availability_zone = "us-east-1c"
    },
    {
      cidr_block        = "10.0.5.0/24"
      availability_zone = "us-east-1d"
    },
    {
      cidr_block        = "10.0.6.0/24"
      availability_zone = "us-east-1e"
    },
    {
      cidr_block        = "10.0.7.0/24"
      availability_zone = "us-east-1f"
    },
    {
      cidr_block        = "10.0.8.0/24"
      availability_zone = "us-east-1f"
    }
  ]
}
gwlbe_subnet_cidrs                   = ["10.0.9.0/24", "10.0.10.0/24"] # CIDRs for GWLBE Subnets
gwlbe_subnet_azs                     = ["us-east-1a", "us-east-1b"] /* If empty, GWLBE subnets will be created in all AZs*/
gwlbe_service_name                   = "gwlbe-name" # GWLBE service name
log_group_name                       = "VPC-Flowlog-Group" # Flow log group name
log_group_class                      = "STANDARD" # Make Sure it's in upper case, [STANDARD or INFREQUENT_ACCESS]
log_retention_days                   = 0          # 0 means never expire

# Provide format for VPC flowlog
flowlog_format                       = "$${version} $${account-id} $${interface-id} $${pkt-srcaddr}"
flowlog_maximum_aggregation_interval = 60 # Flowlog maximum aggregation Interval - 60 OR 600 only

# Custom tags to be applied to all resources
tags = {
  Environment = "Test"
}

#IAM
flow_log_role_name               = "vpc_flowlog_role" # VPC Flowlog Role Name
aws_support_role_name            = "aws_support_role" # AWS Support role name
account_id                       = "XXXXXXXXXX" # ID of the Account in which the resources are being deployed
```
 - Everything is detailed out with the help of comments. 

**This flexible solution to choose number of AZ's and number of Subnets was one of the main goals of this project.**

### 4. Choosing Security Standards
 
 - You can also choose which "Security Standards" you want to enable inside security hub:
 - There are 7 Security Standards to choose from that have been implemented in this solution:
   
  1. AWS Foundational Security Best Practices (FSBP) v1.0.0
  2. CIS AWS Foundations Benchmark v3.0.0
  3. NIST SP 800-53 Rev. 5
  4. PCI DSS v3.2.1
  5. AWS Resource Tagging Standard
  6. CIS AWS Foundations Benchmark v1.4.0
  7. PCI DSS v4.0.1

- To enable these standards as per your requirement follow the below steps:
  - Navigate to 
```bash
modules/Security/main.tf
```

```hcl
###############################
# 2. Security Hub Configuration
###############################
resource "aws_securityhub_account" "main" {
  enable_default_standards = false  # We'll explicitly enable the ones we want
}

resource "aws_securityhub_standards_subscription" "cis_3_0_0" {
  depends_on    = [aws_securityhub_account.main]
  standards_arn = "arn:aws:securityhub:${var.aws_region}::standards/cis-aws-foundations-benchmark/v/3.0.0"
}

resource "aws_securityhub_standards_subscription" "nist" {
  depends_on    = [aws_securityhub_account.main]
  standards_arn = "arn:aws:securityhub:${var.aws_region}::standards/nist-800-53/v/5.0.0"
}

resource "aws_securityhub_standards_subscription" "foundational_best_practices" {
  depends_on = [aws_securityhub_account.main]
  standards_arn = "arn:aws:securityhub:${var.aws_region}::standards/aws-foundational-security-best-practices/v/1.0.0"
}

# ENABLE IF NEEDED #
/*
resource "aws_securityhub_standards_subscription" "resource_tagging" {
  depends_on = [aws_securityhub_account.main]
  standards_arn = "arn:aws:securityhub:${var.aws_region}::standards/aws-resource-tagging-standard/v/1.0.0"
}
*/

/*
resource "aws_securityhub_standards_subscription" "cis_1_4_0" {
  depends_on = [aws_securityhub_account.main]
  standards_arn = "arn:aws:securityhub:${var.aws_region}::standards/cis-aws-foundations-benchmark/v/1.4.0"
}
*/

/*
resource "aws_securityhub_standards_subscription" "pci_dss_3_2_1" {
  depends_on    = [aws_securityhub_account.main]
  standards_arn = "arn:aws:securityhub:${var.aws_region}::standards/pci-dss/v/3.2.1"
}
*/

/* 
resource "aws_securityhub_standards_subscription" "pci_dss_4_0_1" {
  depends_on    = [aws_securityhub_account.main]
  standards_arn = "arn:aws:securityhub:${var.aws_region}::standards/pci-dss/v/4.0.1"
}
*/

```
 - Comment out the ones you want to include and then:
   - Navigate to
```bash
modules/Security/output.tf
```
```hcl
output "enabled_security_standards" {
  description = "List of enabled security standards ARNs"
  value = [
    aws_securityhub_standards_subscription.cis_3_0_0.standards_arn,
    aws_securityhub_standards_subscription.nist.standards_arn,
    aws_securityhub_standards_subscription.foundational_best_practices.standards_arn,
    # aws_securityhub_standards_subscription.resource_tagging.standards_arn,
    # aws_securityhub_standards_subscription.cis_1_4_0.standards_arn,
    # aws_securityhub_standards_subscription.pci_dss_4_0_1.standards_arn,
    # aws_securityhub_standards_subscription.pci_dss_3_2_1.standards_arn,
  ]
}

```

 - Comment them out from here as well.

**After making the necessary changes make sure to save the files.**

> [!NOTE] 
> Before moving to the next steps make sure that terraform version and aws credentials are configured for created user  in the present 
> working directory by running the commands mentioned above for the same once again.

### 5. Deploying the Infrastructure

1. Initialize Terraform modules and backend.
```bash
terraform init
```
- Initializes a Terraform working directory. It downloads the necessary provider plugins and sets up the backend for storing state files. This command should be run first before any other Terraform commands.

2. Validate the Terraform Configuration
```bash
terraform validate
```
- Validates the configuration files in the current working directory to check for syntax errors or inconsistencies. It doesn't access any infrastructure; it only checks the configuration for correctness.

3. Plan the infrastructure
```bash
terraform plan
```
- Creates an execution plan, showing the actions Terraform will take to achieve the desired state as defined in the configuration files. It compares the current state with the desired configuration and shows what will be added, modified, or destroyed.

4. Deploying Infrastructure
```bash
terraform apply
```
- Applies the changes required to reach the desired state of the configuration. This command will prompt for confirmation before making any changes, and then it will create, update, or destroy resources according to the plan.

5. Check Deployment
- Login to the console and check if the deployed infrastructure meets your requirement.

> **Warning:**  
> The following command **DESTROYS ALL RESOURCES** in your environment. It should only be used after proper approvals and severity checks.

```bash
terraform destroy
```
**Destroys all the resources managed by Terraform. It is used to clean up infrastructure that is no longer needed.**

---
## Clean Up

- Once the resources have been provisioned, follow these steps to ensure stability and prevent accidental destruction:
    - Monitor for 1-2 Weeks: After provisioning, monitor the resources and configurations for a period of 1-2 weeks to ensure they are functioning as required and meet the project's objectives.
    
    - Validation: During this monitoring phase, verify that everything is operating successfully and according to the defined requirements.
    
    - Delete User and Backend S3 Bucket: If the resources are confirmed to be stable and working as expected after the monitoring period:
      - Delete the User: Ensure that the user associated with provisioning access is removed.
      - Delete the Backend S3 Bucket: Safeguard against any future accidental resource destruction by removing the S3 bucket used for storing the Terraform state files.

- This approach ensures that your resources are correctly set up, monitored for performance, and protected from inadvertent deletion once they are confirmed to be stable.
