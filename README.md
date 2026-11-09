# RentAny Backend

NestJS + TypeScript backend for the RentAny MVP.

## Development Approach

This project is OpenAPI spec driven:

1. Update `openapi/rentany.yaml` first.
2. Run `npm run openapi:lint`.
3. Run `npm run openapi:types` after dependencies are installed.
4. Implement or adjust NestJS controllers to match the contract.

The API docs are served from the checked-in OpenAPI spec at:

```text
http://localhost:3000/docs
```

## Local Setup

```bash
npm install
npm run start:dev
```

Health check:

```text
GET http://localhost:3000/api/health
```

## MVP Notes

- PostgreSQL will store users, products, rentals, messages, and notification records.
- S3 will store images and videos.
- The database stores S3 object keys, not file bytes.
- Current controllers are endpoint placeholders until persistence is wired in.
