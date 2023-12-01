# Synonyms API

A Rails API for storing and managing synonyms words.

## Table of Contents

### 1. Anonymous User Endpoints

1.1 Search for Synonyms

Endpoint: GET /api/v1/synonyms

Description: Retrieve a list of approved words and their synonyms.
Example Curl Request:

```bash
curl -X GET http://localhost:3000/api/v1/synonyms
```

1.2 Provide a Synonym

Endpoint: POST /api/v1/synonyms
Description: Submit a synonym for an existing or new word.

```bash
curl -X POST -H "Content-Type: application/json" -d '{"synonym": {"word": "example", "synonym": "sample"}}' http://localhost:3000/api/v1/synonyms
```

### 2. Admin User Endpoints

2.1 Login (Get Token) Endpoint: POST /api/v1/login

Description: Authenticate as an admin user and obtain an access token.

```bash
curl -X POST -H "Content-Type: application/json" -d '{"username": "admin", "password": "$dm!nhola123"}' http://localhost:3000/api/v1/login
```

Replace 'your_generated_token' with the actual token obtained from the login response.

2.2 Review Synonyms (Admin Endpoint)

Endpoint: GET /api/v1/admin/synonyms

Description: Retrieve a list of synonyms submitted by anonymous users for review.

```bash
curl -X GET -H "Authorization: Bearer your_generated_token" http://localhost:3000/api/v1/admin/synonyms
```

2.3 Authorize Synonym

Endpoint: PATCH /api/v1/admin/synonyms/:id

Description: Authorize a synonym submitted by an anonymous user.

```bash
curl -X PATCH -H "Authorization: Bearer your_generated_token" http://localhost:3000/api/v1/admin/synonyms/1
```

2.4 Delete Synonym

Endpoint: DELETE /api/v1/admin/synonyms/:id

Description: Delete a synonym submitted by an anonymous user.

```bash
curl -X DELETE -H "Authorization: Bearer your_generated_token" http://localhost:3000/api/v1/admin/synonyms/1
```
