# Notification Engine (Ruby on Rails)

## Overview

Notification Engine is a backend system that allows administrators to create, schedule, and deliver notifications to users asynchronously.

The system uses **background jobs with Sidekiq**, **Redis for job queueing**, and **PostgreSQL for persistent storage**.

Notifications can be delivered immediately or scheduled for future delivery.

---

# Features

* Admin notification creation
* Immediate notification delivery
* Scheduled notifications
* Background processing using Sidekiq
* Retry mechanism for failed deliveries
* User notification retrieval
* Mark notifications as read
* Token-based authentication
* API documentation using Swagger
* Dockerized setup for easy project execution

---

# Tech Stack

* Ruby on Rails 7
* PostgreSQL
* Redis
* Sidekiq
* Swagger (rswag)
* Docker & Docker Compose

---

# System Architecture

Admin creates notification
↓
NotificationSenderService processes request
↓
UserNotification records are created
↓
Sidekiq background jobs process deliveries
↓
External API simulation sends notifications
↓
Delivery status updated

---

# Database Schema

## Users

```
id
name
email
role
auth_token
created_at
updated_at
```

## Notifications

```
id
title
message
status
scheduled_at
created_by
created_at
updated_at
```

## UserNotifications

```
id
user_id
notification_id
status
delivered_at
read_at
created_at
updated_at
```

---

# Project Structure

```
app/
  controllers/
    admin/
      notifications_controller.rb
    notifications_controller.rb

  models/
    user.rb
    notification.rb
    user_notification.rb

  jobs/
    notification_sender_job.rb
    deliver_notification_job.rb

  services/
    notification_sender_service.rb
```

---

# Authentication

Token-based authentication is used.

Each user has a unique token stored in the `auth_token` column.

Example request header:

```
Authorization: Bearer USER_TOKEN
```

---

# API Endpoints

## Admin APIs

### Create Notification

```
POST /admin/notifications
```

Example request:

```
{
  "title": "Flash Sale",
  "message": "70% discount today",
  "status": "draft"
}
```

---

### Schedule Notification

```
POST /admin/notifications
```

Example request:

```
{
  "title": "Flash Sale",
  "message": "70% discount today",
  "status": "scheduled",
  "scheduled_at": "2026-03-12T10:30:00"
}
```

---

### Send Notification Immediately

```
POST /admin/notifications/:id/send_notification
```

---

### List Notifications

```
GET /admin/notifications
```

---

### Show Notification

```
GET /admin/notifications/:id
```

---

# User APIs

### Get User Notifications

```
GET /notifications
```

---

### Mark Notification as Read

```
POST /notifications/:id/read
```

---

# Background Job Processing

Notifications are delivered asynchronously using Sidekiq.

Flow:

```
NotificationSenderJob
        ↓
DeliverNotificationJob
        ↓
External Notification API
        ↓
Delivery Status Update
```

Retries are implemented for failed notification deliveries.

---

# API Documentation

Swagger UI is available at:

```
http://localhost:3000/api-docs
```

You can authorize using:

```
Bearer USER_TOKEN
```

---

# Running the Project (Local Setup)

## Install dependencies

```
bundle install
```

## Setup database

```
rails db:create
rails db:migrate
```

## Start Redis

```
redis-server
```

## Start Sidekiq

```
bundle exec sidekiq
```

## Start Rails server

```
rails server
```
## Start Rails CONSOLE FOR CREATING THE USERS
---



# Running the Project with Docker

The entire system can run using Docker.

## Build containers

```
docker compose build
```

## Start application

```
docker compose up
```

This starts:

* Rails API
* PostgreSQL
* Redis
* Sidekiq
## Start Rails CONSOLE FOR CREATING THE USERS

docker compose exec web rails c

User.create!(
  name: "Admin",
  email: "admin@test.com",
  role: "admin"
)

User.create!(
  name: "Gaurav",
  email: "gaurav@test.com",
  role: "user"
)
---

# Access URLs

Rails server:

```
http://localhost:3000
```

Swagger documentation:

```
http://localhost:3000/api-docs
```

Sidekiq dashboard:

```
http://localhost:3000/sidekiq
```

---

# Database Setup in Docker

The system uses:

```
rails db:prepare
```

This means:

* If database does not exist → it is created
* If database exists → migrations are applied
* Existing data is preserved

---

# Design Decisions

### Background Jobs

Sidekiq is used for asynchronous notification delivery to avoid blocking API requests.

### Token Authentication

A lightweight token-based authentication approach was used for simplicity.

### Database Normalization

Notifications and user delivery records are separated using the `UserNotification` join table.

### Scheduling

Scheduled notifications are implemented using delayed Sidekiq jobs.

---

# AI Tool Usage

AI tools (such as ChatGPT) were used for:

* architecture discussion
* debugging assistance
* documentation formatting

All code was reviewed and integrated manually.

---

# Author

Gaurav Singh
