## Production link:
https://zen-counseling-production-4a7de6447247.herokuapp.com/

## Introduction:

This API is developed for Zen Family Counseling. It 

## Authentication:

This API uses Devise for user authentication. In order to access endpoints that need authentication, a Bearer Token must be sent.

This API uses the dotenv gem for environment variable management. A .env file has to be created in development in order to store ENV variables

### Environment variables that must be set:

#### Devise authentication:
- SECRET_KEY_BASE 

#### Amazon Web Storage:
- AWS_ACCESS_KEY_ID
- AWS_SECRET_ACCESS_KEY
- AWS_REGION
- AWS_BUCKET

#### Stripe authentication:
- STRIPE_PUBLISHABLE_KEY
- STRIPE_SECRET_KEY
 
#### Mailjet authenication
- MAILJET_LOGIN
- MAILJET_PWD
- MAILJET_DEFAULT_FROM

## Endpoints:
#### User Registrations
- GET    /users/cancel
- GET    /users/sign_up
- GET    /users/edit
- PATCH  /users
- PUT    /users
- DELETE /users
- POST   /users

#### User Sessions
- GET    /users/sign_in
- POST   /users/sign_in
- DELETE /users/sign_out

#### Users
- GET /users
- GET /users/:id
- GET /current_user
- GET /index_admins

#### Updates
- GET    /updates
- POST   /updates
- GET    /updates/:id
- PATCH  /updates/:id
- PUT    /updates/:id
- DELETE /updates/:id

#### Stripe Checkout
- GET    /invoices/:invoice_id/session-status
- GET    /orders/:order_id/session-status
- POST   /invoices/:invoice_id/create_checkout_session
- POST   /orders/:order_id/create_checkout_session_status

### Counseling specific endpoints

### Invoices
- GET    /invoices/:invoice_id/download_pdf
- GET    /users/:user_id/invoices
- POST   /users/:user_id/invoices
- GET    /users/:user_id/invoices/:id
- PATCH  /users/:user_id/invoices/:id
- PUT    /users/:user_id/invoices/:id
- DELETE /users/:user_id/invoices/:id

### Appointments
- GET    /users/:user_id/appointments
- POST   /users/:user_id/appointments
- GET    /users/:user_id/appointments/:id
- PATCH  /users/:user_id/appointments/:id
- PUT    /users/:user_id/appointments/:id
- DELETE /users/:user_id/appointments/:id
- GET    /confirmed_appointments
- GET    /pending_appointments
- GET    /available_appointment
- GET    /users/:user_id/appointments/by_date/:appointment_date

#### Private Messages
- GET    /private_messages/:id
- DELETE /private_messages/:id
- GET    /users/:user_id/private_messages
- POST   /users/:user_id/private_messages
- GET    /my_chats

### Store specific endpoints
#### Cart
- POST   /items/:item_id/cart_items
- PATCH  /cart/cart_items/:id
- DELETE /cart/cart_items/:id
- GET    /cart

#### Items
- POST   /items/:item_id/cart_items
- GET    /items
- POST   /items
- GET    /items/:id
- PATCH  /items/:id
- PUT    /items/:id
- DELETE /items/:id
- PATCH  /cart/cart_items/:id
- DELETE /cart/cart_items/:id

#### Orders
- GET    /users/:user_id/orders
- POST   /users/:user_id/orders
- GET    /users/:user_id/orders/:id
- PATCH  /users/:user_id/orders/:id
- PUT    /users/:user_id/orders/:id
- DELETE /users/:user_id/orders/:id
- GET    /orders
- GET    /orders/:id

## Parameters:


