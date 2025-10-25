```mermaid
flowchart TD
  Dev[Developer] -->|git push| GH[GitHub repository]
  GH -->|webhook or poll| J[Jenkins on EC2]

  subgraph CI [CI on Jenkins]
    J --> CO[Checkout code]
    CO --> BI[Build Docker image]
    BI --> ST[Stop old container]
    ST --> RN[Run new container]
  end

  subgraph HOST [AWS EC2 host]
    RN --> APP[Application container on port 3000]
  end

  User[End user] -->|HTTP to port 3000| APP



---
# 🚀 DevOps CI/CD Pipeline with Jenkins, Docker & AWS EC2

This project demonstrates a full CI/CD pipeline using **Jenkins**, **Docker**, and **AWS EC2**, deploying a simple **Node.js web application**.

> ✅ Built from scratch to showcase real-world DevOps practices. Featured on my resume and LinkedIn.

---

## 📦 Technologies Used

- **Node.js** – Lightweight backend application
- **Docker** – Containerization
- **Jenkins** – CI/CD automation
- **GitHub** – Source code repository
- **AWS EC2 (Ubuntu)** – Hosting environment
- **Shell scripting** – Deployment automation

---

## 🌐 Live Deployment

After every push to GitHub, Jenkins:
- Pulls the latest code
- Builds a Docker image
- Runs the container on EC2
- App is accessible at:  
  👉 `http://Your_Public_IP:3000`

---

## 📁 Project Structure

```
ci-cd-demo/
├── app.js
├── Dockerfile
├── Jenkinsfile
├── package.json
└── README.md
```

---

## 🛠️ Setup Instructions

### 1. 🚀 Launch EC2 Instance & Open Ports
- Use Ubuntu 22.04 LTS
- Open ports: **22**, **8080**, **3000**

### 2. ⚙️ Install Jenkins on EC2

```bash
sudo apt update
sudo apt install openjdk-17-jdk -y
wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo apt-key add -
sudo sh -c 'echo deb https://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'
sudo apt update
sudo apt install jenkins -y
sudo systemctl start jenkins
sudo systemctl enable jenkins
```

Access Jenkins at: `http://<your-ec2-ip>:8080`

### 3. 🔓 Setup Jenkins Admin

```bash
sudo cat /var/lib/jenkins/secrets/initialAdminPassword
```

Install suggested plugins and create admin user.

### 4. 🐳 Install Docker & Configure Jenkins Access

```bash
sudo apt install docker.io -y
sudo usermod -aG docker jenkins
sudo systemctl enable docker
sudo systemctl start docker
sudo reboot
```

### 5. 📂 Clone & Push Node.js App

```bash
git clone https://github.com/mariusforreal/ci-cd-demo-project.git
cd ci-cd-demo-project
git add .
git commit -m "Initial CI/CD project commit"
git push origin main
```

---

## 📝 Jenkinsfile

```groovy
pipeline {
  agent any

  stages {
    stage('Build Docker Image') {
      steps {
        sh 'docker build -t ci-cd-demo .'
      }
    }

    stage('Run Docker Container') {
      steps {
        sh '''
          docker stop demo || true
          docker rm demo || true
          docker run -d -p 3000:3000 --name demo ci-cd-demo
        '''
      }
    }
  }

  post {
    success {
      echo '✅ Deployment Successful!'
    }
    failure {
      echo '❌ Build or Deploy Failed!'
    }
  }
}
```

---

## 🧪 Jenkins Pipeline Setup

- Go to Jenkins → **New Item** → **Pipeline**
- Set GitHub repo: `https://github.com/mariusforreal/ci-cd-demo-project.git`
- Branch: `*/main`
- Script path: `Jenkinsfile`
- Save & click **Build Now**

---

## ✅ Results

- CI/CD pipeline triggered on every GitHub push
- Dockerized app deployed live on EC2
- Full automation with zero manual steps

---

## 📌 Author

**Marius Songwa**  
[GitHub](https://github.com/mariusforreal) | [LinkedIn](www.linkedin.com/in/mariuss237)

---

> ⭐ Star this repo if you found it helpful or want to use it as a DevOps reference project.
