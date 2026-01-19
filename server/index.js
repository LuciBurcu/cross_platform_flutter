const express = require("express");
const cors = require("cors");

const app = express();

// Middleware
app.use(cors());
app.use(express.json());

// Middleware for logging requests
app.use((req, res, next) => {
  const start = Date.now();
  res.on("finish", () => {
    const ms = Date.now() - start;
    console.log(`${req.method} ${req.url} - ${res.statusCode} - ${ms}ms`);
  });
  next();
});

// In-memory landmark data (mimics the Landmark model from Flutter)
const landmarks = [
  {
    id: "1",
    name: "Eiffel Tower",
    description: "Iconic iron lattice tower on the Champ de Mars in Paris, France.",
    imageUrl: "https://picsum.photos/seed/eiffel/500",
  },
  {
    id: "2",
    name: "Statue of Liberty",
    description: "Colossal neoclassical sculpture on Liberty Island in New York Harbor.",
    imageUrl: "https://picsum.photos/seed/liberty/500",
  },
  {
    id: "3",
    name: "Great Wall of China",
    description: "Series of fortifications made of stone, brick, and other materials along the northern borders of China.",
    imageUrl: "https://picsum.photos/seed/greatwall/500",
  },
  {
    id: "4",
    name: "Colosseum",
    description: "Oval amphitheatre in the centre of Rome, Italy. The largest ancient amphitheatre ever built.",
    imageUrl: "https://picsum.photos/seed/colosseum/500",
  },
  {
    id: "5",
    name: "Machu Picchu",
    description: "15th-century Inca citadel situated on a mountain ridge in the Eastern Cordillera of Peru.",
    imageUrl: "https://picsum.photos/seed/machupicchu/200",
  },
];

// Helper to generate next ID
const getNextId = () => {
  const maxId = landmarks.reduce((max, l) => Math.max(max, parseInt(l.id)), 0);
  return String(maxId + 1);
};

// Routes

// GET all landmarks
app.get("/landmarks", (req, res) => {
  res.status(200).json(landmarks);
});

// GET single landmark by ID
app.get("/landmarks/:id", (req, res) => {
  const { id } = req.params;
  const landmark = landmarks.find((l) => l.id === id);

  if (!landmark) {
    return res.status(404).json({ error: "Landmark not found" });
  }

  res.status(200).json(landmark);
});

// POST create a new landmark
app.post("/landmarks", (req, res) => {
  const { name, description, imageUrl } = req.body;

  // Validation
  const errors = {};
  if (!name || typeof name !== "string") {
    errors.name = "Name is required and must be a string.";
  }
  if (!description || typeof description !== "string") {
    errors.description = "Description is required and must be a string.";
  }


  if (Object.keys(errors).length > 0) {
    return res.status(400).json({ errors });
  }

  const newLandmark = {
    id: getNextId(),
    name,
    description,
    imageUrl,
  };

  landmarks.push(newLandmark);
  res.status(201).json(newLandmark);
});

// PUT update a landmark
app.put("/landmarks/:id", (req, res) => {
  const { id } = req.params;
  const { name, description, imageUrl } = req.body;

  const landmarkIndex = landmarks.findIndex((l) => l.id === id);

  if (landmarkIndex === -1) {
    return res.status(404).json({ error: "Landmark not found" });
  }

  // Validation
  const errors = {};
  if (!name || typeof name !== "string") {
    errors.name = "Name is required and must be a string.";
  }
  if (!description || typeof description !== "string") {
    errors.description = "Description is required and must be a string.";
  }
  if (!imageUrl || typeof imageUrl !== "string") {
    errors.imageUrl = "Image URL is required and must be a string.";
  }

  if (Object.keys(errors).length > 0) {
    return res.status(400).json({ errors });
  }

  landmarks[landmarkIndex] = {
    id,
    name,
    description,
    imageUrl,
  };

  res.status(200).json(landmarks[landmarkIndex]);
});

// DELETE a landmark
app.delete("/landmarks/:id", (req, res) => {
  const { id } = req.params;
  const landmarkIndex = landmarks.findIndex((l) => l.id === id);

  if (landmarkIndex === -1) {
    return res.status(404).json({ error: "Landmark not found" });
  }

  const deleted = landmarks.splice(landmarkIndex, 1)[0];
  res.status(200).json(deleted);
});

// Error handling middleware
app.use((err, req, res, next) => {
  console.error("Error encountered:", err);
  res.status(err.status || 500).json({
    error: err.message || "Internal Server Error",
  });
});

// Start server
const port = 3000;
app.listen(port, () => {
  console.log(`🚀 Landmark server listening on port ${port} ... 🚀`);
  console.log(`📍 API endpoints:`);
  console.log(`   GET    http://localhost:${port}/landmarks`);
  console.log(`   GET    http://localhost:${port}/landmarks/:id`);
  console.log(`   POST   http://localhost:${port}/landmarks`);
  console.log(`   PUT    http://localhost:${port}/landmarks/:id`);
  console.log(`   DELETE http://localhost:${port}/landmarks/:id`);
});
