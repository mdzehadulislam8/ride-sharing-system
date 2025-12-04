# Ride Sharing System  
*A Shell-Script Based Ride-Sharing Platform using Dijkstra’s Algorithm*  

<p align="center">
  <img src="https://img.shields.io/badge/Language-Bash-blue?style=for-the-badge">
  <img src="https://img.shields.io/badge/Algorithm-Dijkstra's-orange?style=for-the-badge">
  <img src="https://img.shields.io/badge/OS-Linux-green?style=for-the-badge">
  <img src="https://img.shields.io/badge/Storage-Text%20Files-yellow?style=for-the-badge">
</p>

---

## Overview

This project implements a **Ride Sharing System** using **Bash Shell Scripting** with **Dijkstra’s Algorithm** for optimal route calculation.  

Key skills demonstrated:

- Linux Shell Scripting  
- Algorithm design & implementation  
- File-based data management  
- CLI-based system automation  

---

## Features

**Admin Panel**  
- Manage users, riders, and locations  
- View ride history  

**User Panel**  
- Request rides with automatic fare calculation  
- View profile and ride history  
- Cancel rides  

**Rider Panel**  
- Accept or reject ride requests  
- Update ride status  

**Core System**  
- Shortest path calculation via **Dijkstra’s Algorithm**  
- File-based database  
- Timestamp-based unique IDs  
- Real-time ride matching  

---

## System Architecture

```
User / Rider / Admin
        │
Shell Script Menu
 ┌─────────────┬─────────────┬─────────────┐
 │ User Module │ Rider Module│ Admin Module│
 └─────────────┴─────────────┴─────────────┘
        │
Text Files (Database)
admin.txt, userinformation.txt, riderinformation.txt,
location.txt, riderequest.txt, ridinginformation.txt
        │
Dijkstra’s Algorithm
```

---

## Tools & Technologies

| Area       | Technology                  |
|-----------|-----------------------------|
| Language  | Bash (Shell Scripting)      |
| Algorithm | Dijkstra’s Algorithm        |
| Platform  | Ubuntu / Linux              |
| Storage   | Text Files                  |
| Commands  | grep, awk, sed, loops, functions |
| IDE       | VS Code / Terminal          |

---

## Project Structure

```
RideSharingSystem/
├─ ride.sh
├─ admin.txt
├─ userinformation.txt
├─ riderinformation.txt
├─ riderequest.txt
├─ ridinginformation.txt
├─ location.txt
└─ README.md
```

---

## Installation & Setup

**Requirements:** Linux OS (Ubuntu), Bash shell, Terminal/VS Code  

**Run Program:**
```bash
chmod +x ride.sh
./ride.sh
```

---

## How It Works

**User Workflow:**  
Login → Request ride → System calculates shortest route → Fare generated → Rider accepts → Ride stored  

**Admin Workflow:**  
Manage accounts, locations, and ride history  

**Rider Workflow:**  
Accept/reject ride requests, update ride status  

---

## Algorithms

**Dijkstra’s Algorithm:** Shortest path calculation  

**Unique ID Generation:**
```bash
id=$(date +%s)
```

**Authentication:** Matches data from `admin.txt`, `userinformation.txt`, `riderinformation.txt`  

---

## Screenshots

**Main Menu**  
![Main Menu](https://drive.google.com/uc?export=view&id=1bs-LDjLNsgJ3vgpRDSnWcGclWTkMtjGr)

**Admin Login**  
![Admin Login](https://drive.google.com/uc?export=view&id=10jdv2bSWHilcRjv7Kwh0fAjkIQ6YsmAv)

**Create User Account**  
![Create User Account](https://drive.google.com/uc?export=view&id=1dkzwulZiaoxDFgEj571EHwJslPZm7OcQ)

**Search Ride**  
![Search Ride](https://drive.google.com/uc?export=view&id=1hiPrtkyuR4hc5LyJlCYGVp9xaCfIg1Y-)

**Rider Accept Ride**  
![Rider Accept Ride](https://drive.google.com/uc?export=view&id=1S-iTqBq3ZU2h--C4BlafBy3NLunIN_Dq)

---

## Performance Evaluation

- Fast execution and accurate calculations  
- Clean and simple workflow  
- Effective file-based data handling  

---

## Limitations

- Text files are not scalable  
- No GUI (CLI only)  
- No encrypted passwords  
- No real-time GPS  
- Concurrency issues possible  

---

## Future Enhancements

- Migrate to SQL/NoSQL database  
- GUI (JavaFX or Web App)  
- Real-time ride tracking  
- Dynamic pricing & OTP authentication  
- Mobile app version  

---

## Project Report

[Download Project Report (PDF)](https://drive.google.com/file/d/1CdSkJBRGYedwmjKJV-Pa-zh9TEq-sRAJ/view?usp=drive_link)

---

## Authors

- **Md. Zehadul Islam**  
- **Abir Al Anan**  
