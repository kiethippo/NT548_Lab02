# Terraform

Terraform là một công cụ Cơ sở hạ tầng dưới dạng Mã (Infrastructure as Code – IaC), chủ yếu được các đội ngũ DevOps sử dụng để tự động hóa các nhiệm vụ cơ sở hạ tầng khác nhau. Việc cung cấp tài nguyên đám mây, chẳng hạn, là một trong những trường hợp sử dụng chính của Terraform. Đây là một công cụ cung cấp mã nguồn mở, không phụ thuộc vào nền tảng đám mây, được viết bằng ngôn ngữ Go và được tạo ra bởi HashiCorp.

Repo này chứa mã nguồn Terraform để tạo:
- VPC riêng
- 1 public subnet + 1 private subnet
- Internet Gateway (IGW)
- NAT Gateway
- Route table cho public & private
- 2 EC2 (public, private)
- Security Group tương ứng

Ngoài ra có thêm thư mục `cloudformation/` để triển khai mẫu tương tự bằng CloudFormation.

---
## 1. Yêu cầu trước khi chạy

1. **Có tài khoản AWS** (IAM user có quyền EC2, VPC, CloudFormation).
2. Đã **tạo key pair trên AWS** và tải file `.pem` về.
3. Đã cài:
   - [Terraform](https://developer.hashicorp.com/terraform/install)
   - [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)
   - Git
4. Đã cấu hình AWS CLI:
   ```terminal
   aws configure
    ```
   ```terminal
   AWS Access Key ID [None]: Access Key ID
   AWS Secrect Key ID [None]: Secrect Key ID lấy lúc tạo key
   Default region name [None]: tên khu vực
   Default output format [None]: json
   ```
 ## 2. Khai báo biến chạy
 Tạo file terraform.tfvars ở thư mục gốc:
 ```powershell
aws_region  = khu vực
project_name = tên dự án
my_ip_cidr  = "0.0.0.0/0" (trên môi trường production thì nên là IP Public)
key_name    = tên keypair đã tạo trên AWS
```
## 3. Chạy Terraform
Trong thư mục dự án:
```bash
terraform init
terraform plan -out=tfplan
terraform apply tfplan
```
Sau khi chạy xong, sẽ thấy output gồm VPC ID, Public Subnets IP, Public EC2 IP.

Output Terraform trả về có dạng:
```bash
public_ec2_ip = "xxx.xxx.xxx.xxx"
public_subnets = ["subnet-xxx"]
vpc_id = "vpc-xxx"
```
## 4. Kiểm tra các dịch vụ
Dùng output để kiểm tra bằng CLI (filters) hoặc có thể kiểm tra một cách trực quan bằng AWS Console.
## 5. SSH vào EC2 Public
Trên Windows:
```powershell
ssh -i "path to your keypem" ec2-user@"your public_ec2_ip"
```
## 6. SSH từ EC2 public sang EC2 private

1. Trên Windows, copy key từ máy local lên EC2 public:
  ```powershell
scp -i "path to your keypem" "path to your keypem" ec2-user@:"your public_ec2_ip"~/
```
2. SSH vào EC2 public:
```powershell
ssh -i "path to your keypem" ec2-user@"your public_ec2_ip"
```
3. Trên EC2 public:
```powershell
chmod 400 your_keypem.pem
ssh -i  your_keypem.pem ec2-user@"your_private_IP"
```
## 7. Kiểm tra nhanh

VPC: AWS Console → VPC → thấy VPC CIDR 10.0.0.0/16

Public subnet: có route 0.0.0.0/0 → igw-...

Private subnet: có route 0.0.0.0/0 → nat-...

EC2 public: có Public IP, SSH được

EC2 private: không có Public IP, chỉ SSH được từ public
