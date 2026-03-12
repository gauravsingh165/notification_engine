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

## AI Usage and Prompts

During development, AI tools such as ChatGPT were used to assist with architectural decisions, debugging, infrastructure setup, and documentation.

Below are some examples of prompts used during development.

---

### Prompt 1 – System Design

```
Prompt:
How should I design database tables for a notification system where one notification can be delivered to many users and each user has their own read status?

How I used it:
This helped me decide to create a join table called UserNotification to track delivery status per user.

Modification:
I designed the schema manually and added fields like delivered_at and read_at to track delivery and read events.
```

---

### Prompt 2 – Background Job Strategy

```
Prompt:
What is the recommended way to process notification delivery asynchronously in a Rails API using Sidekiq?

How I used it:
This helped me understand how to separate responsibilities between jobs and background processing.

Modification:
I implemented two jobs:
- NotificationSenderJob (creates delivery records)
- DeliverNotificationJob (handles the external API call for delivery)
```

---

### Prompt 3 – Scheduled Notifications

```
Prompt:
How can I schedule a Sidekiq job to run at a specific time using a scheduled_at timestamp in Rails?

How I used it:
This helped me understand how to enqueue jobs using perform_at when a notification has a scheduled_at value.

Modification:
I added model validation to ensure scheduled_at must be in the future before allowing scheduling.
```

---

### Prompt 4 – Docker Setup

```
Prompt:
What is the correct way to dockerize a Rails application that depends on PostgreSQL and Redis?

How I used it:
This helped me structure Dockerfile and docker-compose configuration for Rails, PostgreSQL, Redis, and Sidekiq.

Modification:
I configured the application to connect to services through Docker networking and environment variables.
```

---

### Prompt 5 – API Documentation

```
Prompt:
What sections should a good README include for a backend API project?

How I used it:
This helped structure the documentation with sections like setup instructions, architecture explanation, and API examples.

Modification:
I customized the documentation to match the actual endpoints and architecture implemented in this project.
```

---

### Prompt 6 – Debugging Scheduled Jobs

```
Prompt:
I scheduled a Sidekiq job using perform_at with a scheduled_at timestamp, but the job is not running at the expected time. What are common issues with scheduled jobs in Rails?

How I used it:
This helped identify potential timezone differences between the application and database that can affect scheduled execution.

Modification:
I verified timezone configuration and ensured scheduled_at values are stored and interpreted consistently.
```

---

### Prompt 7 – Debugging Docker Startup

```
Prompt:
My Rails container fails to connect to PostgreSQL when running docker-compose up. What is the best way to ensure Rails waits until the database is ready?

How I used it:
This helped identify that containers start in parallel and Rails may attempt to connect before PostgreSQL is ready.

Modification:
I implemented a docker-entrypoint script that waits for PostgreSQL using pg_isready before starting the Rails server.
```

---

AI was mainly used for:

* architectural discussion
* debugging assistance
* infrastructure setup guidance
* documentation structure

---

# Author

Gaurav Singh
