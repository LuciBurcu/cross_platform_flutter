# Landmark Server

A simple Express.js server for demonstrating the MVVM pattern with the Flutter mobile app.

## Setup

```bash
npm install
```

## Running the Server

Development mode (with auto-reload):
```bash
npm run dev
```

Production mode:
```bash
npm start
```

The server will run on `http://localhost:3000`

## API Endpoints

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/landmarks` | Get all landmarks |
| GET | `/landmarks/:id` | Get a single landmark by ID |
| POST | `/landmarks` | Create a new landmark |
| PUT | `/landmarks/:id` | Update a landmark |
| DELETE | `/landmarks/:id` | Delete a landmark |

## Landmark Model

```json
{
  "id": "1",
  "name": "Eiffel Tower",
  "description": "Iconic iron lattice tower on the Champ de Mars in Paris, France.",
  "imageUrl": "https://example.com/image.jpg"
}
```

## Example Requests

### Get all landmarks
```bash
curl http://localhost:3000/landmarks
```

### Get a single landmark
```bash
curl http://localhost:3000/landmarks/1
```

### Create a new landmark
```bash
curl -X POST http://localhost:3000/landmarks \
  -H "Content-Type: application/json" \
  -d '{"name": "Big Ben", "description": "Famous clock tower in London", "imageUrl": "https://example.com/bigben.jpg"}'
```

### Update a landmark
```bash
curl -X PUT http://localhost:3000/landmarks/1 \
  -H "Content-Type: application/json" \
  -d '{"name": "Eiffel Tower", "description": "Updated description", "imageUrl": "https://example.com/eiffel.jpg"}'
```

### Delete a landmark
```bash
curl -X DELETE http://localhost:3000/landmarks/1
```
