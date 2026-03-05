<p align="center">
  <img src="https://capsule-render.vercel.app/api?type=waving&color=0:6C63FF,100:00C9FF&height=200&section=header&text=AutoLead&fontSize=50&fontColor=ffffff&animation=fadeIn&fontAlignY=38&desc=Flutter%20%2B%20n8n%20Salon%20Booking%20%26%20Lead%20Automation&descAlignY=58&descSize=16" width="100%"/>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white"/>
  <img src="https://img.shields.io/badge/n8n-EA4B71?style=for-the-badge&logo=n8n&logoColor=white"/>
  <img src="https://img.shields.io/badge/Firebase-FFCA28?style=for-the-badge&logo=firebase&logoColor=black"/>
  <img src="https://img.shields.io/badge/Google%20Sheets-34A853?style=for-the-badge&logo=google-sheets&logoColor=white"/>
  <img src="https://img.shields.io/badge/WhatsApp%20API-25D366?style=for-the-badge&logo=whatsapp&logoColor=white"/>
  <img src="https://img.shields.io/badge/Riverpod-00B4D8?style=for-the-badge&logo=dart&logoColor=white"/>
</p>

---

## 🚨 The Problem

A salon owner was managing bookings through **WhatsApp messages, phone calls, and paper registers.**

- ❌ Appointments were being double-booked
- ❌ Staff spent hours manually entering customer data
- ❌ No-shows had no follow-up system
- ❌ Owner had no real-time view of daily bookings
- ❌ Leads were lost because nobody responded fast enough

**The business was losing money every day — not because of no customers, but because of no system.**

---

## ✅ The Solution

A complete **Flutter app + n8n automation system** that handles the entire booking journey from customer tap to owner action with zero manual work.

---

## ⚡ How The Full System Works

**Step 1** 👤 Customer opens the app

**Step 2** 📋 Fills in: Name, Phone, Email, Service, Message

**Step 3** 📤 Flutter sends data to n8n webhook

**Step 4** ⚙️ n8n automation fires instantly:

- ✉️ Confirmation email sent to customer
- 📊 Data saved to Google Sheets
- 🔥 Data synced to Firebase Firestore

**Step 5** 📱 Admin panel updates in real-time

**Step 6** 👨‍💼 Owner sees booking and contacts customer on WhatsApp in 1 tap

---

## 📱 App Structure

### 👤 User App — `/user-app`

| Screen | What It Does |
|---|---|
| 🏠 Home | Welcome screen with services overview |
| 📋 Booking Form | Customer fills name, phone, email, service, message |
| ✅ Confirmation | Success screen after booking submitted |
| 📜 My Bookings | Customer view of their appointments |

### 🖥️ Admin Panel — `/admin-app`

| Screen | What It Does |
|---|---|
| 🔐 Login | Secure admin authentication |
| 📊 Dashboard | Real-time stats — today's bookings, total leads |
| 📋 Leads Screen | All bookings with name, service, status |
| 👤 Detail Screen | Full customer info + WhatsApp 1-tap contact |
| ⚙️ Profile | Admin profile management |

### ⚙️ n8n Workflow — `/n8n-workflow`

| Node | Action |
|---|---|
| 🎣 Webhook | Receives booking data from Flutter |
| ✉️ Gmail Node | Sends auto confirmation email |
| 📊 Google Sheets | Appends booking to master sheet |
| 🔥 Firebase Node | Saves data to Firestore |
| 📤 Respond Node | Returns success to Flutter app |

---

## 🛠️ Tech Stack

| Layer | Technology |
|---|---|
| 📱 Mobile App | Flutter + Dart |
| 🎨 State Management | Riverpod |
| 🧭 Navigation | GoRouter |
| 🔥 Database | Firebase Firestore |
| ⚙️ Automation | n8n |
| 📊 Data Backup | Google Sheets |
| 📧 Email | Gmail via n8n |
| 💬 Contact | WhatsApp API |

---

## 📸 Screenshots

### 🖥️ Admin Panel

<p align="center">
  <img src="screenshots/admin-dashboard.jpeg" width="18%"/>
  <img src="screenshots/admin-dashboard1.jpeg" width="18%"/>
  <img src="screenshots/admin-dashboard2.jpeg" width="18%"/>
  <img src="screenshots/admin-dashboard3.jpeg" width="18%"/>
  <img src="screenshots/admin-dashboard4.jpeg" width="18%"/>
</p>

<p align="center">
  <img src="screenshots/admin-dashboard5.jpeg" width="18%"/>
</p>

### 👤 User App

<p align="center">
  <img src="screenshots/user-booking.jpeg" width="30%"/>
  &nbsp;&nbsp;
  <img src="screenshots/user-booking1.jpeg" width="30%"/>
  &nbsp;&nbsp;
  <img src="screenshots/user-booking2.jpeg" width="30%"/>
</p>

---

## 🚀 Setup & Run

**1. Clone the repo**
```bash
git clone https://github.com/MuhammadHussnain07/autolead.git
