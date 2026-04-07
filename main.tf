
provider "aws" {
  region     = "us-east-1"
}

resource "aws_vpc" "vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    name = "vpc01"
  }
}
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1a" # Replace with your desired AZ
  map_public_ip_on_launch = true         # For public subnets
  tags = {
    Name = "public01"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "internet-Gateway"
  }
  depends_on = [aws_subnet.public]
}

resource "aws_default_route_table" "default" {
  default_route_table_id = aws_vpc.vpc.default_route_table_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "default-route-table"
  }
}


resource "aws_default_security_group" "sg" {
  vpc_id = aws_vpc.vpc.id

  # SSH
  ingress {
    description = "Allow SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTP
  ingress {
    description = "Allow HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTPS
  ingress {
    description = "Allow HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "default-security-group"
  }

}
resource "aws_instance" "siva-ec2" {
  ami           = "ami-0ec10929233384c7f"
  instance_type = "t3.micro"

  subnet_id = aws_subnet.public.id # ✅ IMPORTANT FIX

  vpc_security_group_ids = [aws_default_security_group.sg.id]

  key_name = "east"
  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("C:\\Users\\nalla\\Downloads\\east.pem")
    host        = self.public_ip
  }
  # User Data script to install Nginx and write your exact HTML file
  user_data = <<-EOF
#!/bin/bash
sudo apt update -y
sudo apt install nginx -y
sudo systemctl start nginx
sudo systemctl enable nginx

# Write the full HTML file
cat << 'HTML_EOF' > /var/www/html/index.html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Siva Brahmaiah Portfolio</title>

    <style>
        body {
            margin: 0;
            font-family: Arial, sans-serif;
            background: #0f172a;
            color: #fff;
        }

        header {
            background: #1e293b;
            padding: 20px;
            text-align: center;
        }

        header img {
            border-radius: 50%;
            display: block;
            margin: 0 auto 10px;
            width: 150px;
            height: 150px;
        }

        header h1 {
            margin: 0;
            color: #38bdf8;
        }

        nav a {
            margin: 0 15px;
            color: #fff;
            text-decoration: none;
        }

        section {
            padding: 40px;
        }

        h2 {
            color: #38bdf8;
        }

        .card {
            background: #1e293b;
            padding: 20px;
            margin: 20px 0;
            border-radius: 10px;
        }

        .skills span {
            display: inline-block;
            background: #38bdf8;
            color: #000;
            padding: 8px 12px;
            margin: 5px;
            border-radius: 5px;
        }

        footer {
            text-align: center;
            padding: 20px;
            background: #1e293b;
        }
    </style>
</head>

<body>

<header>
    <img src="https://siva-portfolio-assets-12345.s3.amazonaws.com/siva-resume-pic.jpg"
         alt="Siva Brahmaiah">
        
    <h1>Nallamekala Siva Brahmaiah</h1>
    <p>Multi-Cloud DevOps Engineer</p>

    <nav>
        <a href="#about">About</a>
        <a href="#skills">Skills</a>
        <a href="#project">Projects</a>
        <a href="#contact">Contact</a>
    </nav>
</header>
<section id="about">
    <h2>About Me</h2>
    <p>
        Motivated and passionate Multi-Cloud DevOps Engineer eager to begin a career in cloud infrastructure 
        and automation. Skilled in AWS, Azure, GCP, Docker, Kubernetes, Terraform and CI/CD pipelines.
    </p>
</section>

<section id="skills">
    <h2>Technical Skills</h2>

    <div class="skills">
        <span>AWS</span>
        <span>Azure</span>
        <span>GCP</span>
        <span>Docker</span>
        <span>Kubernetes</span>
        <span>Terraform</span>
        <span>Jenkins</span>
        <span>Azure DevOps</span>
        <span>Linux</span>
        <span>Git & GitHub</span>
        <span>Maven</span>
        <span>Ansible</span>
        <span>Prometheus</span>
        <span>Grafana</span>
        <span>SonarQube</span>
    </div>

</section>

<section id="project">
    <h2>Project</h2>

    <div class="card">
        <h3>Multi-Cloud DevSecOps Pipeline</h3>
        <p><b>Tools:</b> Terraform, Docker, Kubernetes, Jenkins, Azure DevOps</p>
        <p>
            Built a multi-cloud DevSecOps pipeline using AWS & Azure. Automated infrastructure provisioning,
            CI/CD pipelines, containerization and monitoring using Prometheus and Grafana.
        </p>
    </div>

</section>

<section id="contact">
    <h2>Contact</h2>
    <p>📞 9381372337</p>
    <p>📧 nallasiva552@gmail.com</p>
    <p>🔗 <a href="https://github.com/Nallamekala-SivaBrahmaiah" target="_blank">GitHub</a></p>
    <p>🔗 <a href="https://www.linkedin.com/in/siva-brahmaiah" target="_blank">LinkedIn</a></p>
</section>

<footer>
    <p>© 2026 Siva Brahmaiah | Portfolio</p>
</footer>

</body>
</html>
HTML_EOF
EOF

  tags = {
    Name = "Portfolio-Server"
  }
}



resource "aws_s3_bucket" "bucket" {
  bucket = "siva-portfolio-assets-12345" # must be unique
}
# Disable block public access
resource "aws_s3_bucket_public_access_block" "public_access" {
  bucket = aws_s3_bucket.bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_policy" "policy" {
  bucket = aws_s3_bucket.bucket.id

  depends_on = [aws_s3_bucket_public_access_block.public_access]

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "PublicReadGetObject"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource  = "${aws_s3_bucket.bucket.arn}/*"
      }
    ]
  })
}

resource "aws_s3_object" "image" {
  bucket = aws_s3_bucket.bucket.id
  key    = "siva-resume-pic.jpg"
  # ✅ Local laptop image path
  source       = "C://Users//nalla//OneDrive//Pictures//siva-resume-pic.jpg"
  content_type = "siva-resume-pic.jpg"
}