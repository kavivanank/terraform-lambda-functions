# 📘 Day 2 Summary: Terraform Infrastructure Modularization

## 🎯 Goal:
Modularize Terraform code for reusable and scalable AWS infrastructure components.

---

## ✅ Key Activities

- 🔨 Created two reusable modules:
  - `vpc` module for managing VPC, public subnets, route tables, and IGW.
  - `ec2` module to launch EC2 instances with user data, security groups, and SSM support.

- 🧩 Parameterized all configurations using variables in `.tfvars` files.
- 📦 Integrated IAM Role, Instance Profile, and custom policy for:
  - ✅ SSM Session Manager access
  - ✅ Full S3 access (`s3:*`)
- 🔐 Ensured secure and SSH-free EC2 access using AWS Systems Manager.
- 💽 Configured root and additional EBS volumes for persistent storage.
- 🌐 Set up public subnet and `associate_public_ip_address = true` for internet access.
- 📝 Used `templatefile()` function to inject variables like `app_name` into EC2 user data scripts.

---

## 📁 Outputs:

- Fully modular infrastructure
- EC2 instance accessible via browser and SSM
- `index.html` deployed with dynamic content using `templatefile()`

---

## 💡 Skills Gained:

- Terraform module best practices
- IAM and policy management
- EC2 storage and network customization
- Secure, keyless access using Session Manager
- Dynamic templating with `templatefile()`