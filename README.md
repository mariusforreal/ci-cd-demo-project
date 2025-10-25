```mermaid
flowchart LR
  %% CI/CD for mariusforreal/ci-cd-demo-project
  %% Git push triggers Jenkins; Jenkins builds Docker image and runs container on EC2.

  subgraph DEV["Developer"]
    A[Code changes<br/>commit & push]
  end

  subgraph GH["GitHub<br/>ci-cd-demo-project"]
    B[Repository<br/>main branch]
  end

  subgraph JENK["Jenkins on AWS EC2<br/>(port 8080)"]
    C1[Checkout from GitHub]
    C2[Build Docker image<br/>(docker build -t ci-cd-demo .)]
    C3[Stop old container<br/>(docker stop demo || true)]
    C4[Remove old container<br/>(docker rm demo || true)]
    C5[Run new container<br/>(docker run -d -p 3000:3000 --name demo ci-cd-demo)]
    C6{{Post: success/failure<br/>pipeline logs}}
  end

  subgraph EC2["AWS EC2 Host"]
    D1[Docker Engine]
    D2[(Container: demo)]
    D3[Node.js app<br/>listens on :3000]
  end

  subgraph USERS["End Users"]
    U[Access via<br/>http://<EC2-Public-IP>:3000]
  end

  A -->|git push| B
  B -->|SCM webhook/poll| JENK
  JENK --> C1 --> C2 --> C3 --> C4 --> C5 --> C6
  C2 -.uses.-> D1
  C5 --> D2 --> D3 --> U

  %% Networking notes
  classDef note fill:#f6f8fa,stroke:#d0d7de,color:#24292f,font-size:12px;
  N1[[Security Groups:<br/>22 (SSH), 8080 (Jenkins), 3000 (App)]]:::note
  EC2 --- N1
  ```

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
