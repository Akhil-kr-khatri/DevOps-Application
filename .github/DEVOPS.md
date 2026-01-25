# **DevOps Assessment – Setup Guide & Troubleshooting Logs**

This section explains how to run the application locally on any machine using Docker.  
Since the application images are already published to Docker Hub through the CI/CD pipeline, no manual build is required.

---
## 📌 **Prerequisites**
Ensure the following tools are installed:
•	Docker
•	Git
•	A web browser
Verify Docker installation:
```bash
docker --version
```
---

## **Step 1 — Pull Backend Image**
```bash
docker pull akhilkhatri/devops-backend:latest
```
This downloads the Django backend image from Docker Hub.
---
## **Step 2 — Pull Frontend Image**
```bash
docker pull akhilkhatri/devops-frontend:latest
```
This downloads the React frontend image from Docker Hub.
---
## **Step 3 — Run Backend Container**
```bash
docker run -d -p 8000:8000 --name backend akhilkhatri/devops-backend:latest
```
The backend API will now be available at:
```bash
http://localhost:8000/api/hello/
```
----
## **Step 4 — Run Frontend Container**
```bash
docker run -d -p 3000:80 --name frontend akhilkhatri/devops-frontend:latest
```
The frontend application will now be accessible at:
```bash
http://localhost:3000
```
--- 
## **Step 5 — Verify Running Containers**
```bash
docker container ls
```
**Expected output:**
backend    akhilkhatri/devops-backend    Up    0.0.0.0:8000->8000
frontend   akhilkhatri/devops-frontend   Up    0.0.0.0:3000->80
---
## **Step 6 — Stop & delete Containers**
docker stop backend frontend
docker rm backend frontend
---
## **Application Access Summary**
Service	URL
Frontend	http://localhost:3000
Backend API	http://localhost:8000/api/hello/
---
## **Result**
After completing the above steps:
•	The frontend UI loads successfully in the browser
•	The frontend communicates with the backend API
•	The application runs fully containerized on the local machine
---

# **Troubleshoot Logs**
This section documents challenges faced during the project and how they were resolved.

---

## **Issue 1: Backend container failed to start**
**Error observed:**
```bash
sqlite3.OperationalError: unable to open database file
```
**Cause:**
The Django backend container was configured to run as a non-root user for security best practices.
However, the /app directory inside the container was owned by root, and SQLite requires write permission to create db.sqlite3.
Because the non-root user lacked write access, Django failed during startup.
**Solution:**
Ownership of the application directory was assigned to the non-root user inside the Dockerfile:
```bash
RUN chown -R djangouser:djangouser /app
```
After rebuilding and redeploying the image, Django successfully created the SQLite database file and the backend container started correctly.
**Learning Outcome:**
Running containers as non-root improves security, but file system permissions must be handled carefully when applications require write access.
---
## **Issue 2: Django module not found in container**
**Error observed:**
```bash  
ModuleNotFoundError: No module named 'django'
```
**Cause:**
Initially, Python dependencies were installed in a root user directory, but the runtime container switched to a non-root user, causing Django not to be found in the runtime PATH.
**Solution:**
Dependencies were installed system-wide inside the Docker image during the build stage, ensuring availability for all users.
```bash
RUN pip install --no-cache-dir -r requirements.txt
```
**Learning Outcome:**
When switching users inside containers, ensure dependencies are installed in global site-packages or copied correctly between build and runtime stages.
---

## **Issue 2: Django module not found in container**
**Error observed:**
```bash
ModuleNotFoundError: No module named 'django'
```
**Cause:**
Initially, Python dependencies were installed in a root user directory, but the runtime container switched to a non-root user, causing Django not to be found in the runtime PATH.
**Solution:**
Dependencies were installed system-wide inside the Docker image during the build stage, ensuring availability for all users.
```bash
RUN pip install --no-cache-dir -r requirements.txt
```
**Learning Outcome:**
When switching users inside containers, ensure dependencies are installed in global site-packages or copied correctly between build and runtime stages.
---

## **Issue 3: GitHub Actions Docker login failure**
**Error observed:**
```bash
Error: Username and password required
```
**Cause:**
Docker Hub credentials were not correctly added as GitHub repository secrets.
**Solution:**
A Docker Hub Personal Access Token (PAT) was created and stored in GitHub Secrets as:
•	DOCKER_USERNAME
•	DOCKER_PASSWORD
After updating secrets, the CI/CD pipeline authenticated successfully and pushed images to Docker Hub.
**Learning Outcome:**
CI/CD pipelines require secure credential management using repository secrets rather than hardcoding sensitive data.
---
## **Issue 4 — Frontend could not connect to backend inside container**
**Error Observed:**
```bash
Failed to connect to the backend. Please ensure the Django server is running.
```
**Cause**
The frontend application was hardcoded to call http://localhost:8000.
Inside Docker containers, localhost refers to the frontend container itself, not the backend container.
**Solution**
``bash
const API_URL = import.meta.env.VITE_API_URL || "http://localhost:8000";
axios.get(`${API_URL}/api/hello/`);
```
**Runtime injection:**
```bash
docker run -e VITE_API_URL=http://backend:8000 ...
```
**Learning Outcome**
Containerized applications should use environment variables for service endpoints instead of hardcoded.
---
## **Summary**
All issues were resolved by analyzing logs, identifying permission and configuration problems, and applying Docker and CI/CD best practices. This improved both container security and deployment reliability.

---
## Author
👤 Akhil Kumar Khatri
📧 Email: akhilkhatri2024@gmail.com
🌐 GitHub: Akhil-kr-khatri












