
const express = require("express");
const bodyParser = require("body-parser");
const fs = require("fs");
const cors = require("cors");
const path = require("path");

const app = express();
const PORT = process.env.PORT || 3000;

// === Enable CORS ===
app.use(cors());
app.use((req, res, next) => {
  res.header("Access-Control-Allow-Origin", "*"); // or restrict to GitHub domain
  res.header("Access-Control-Allow-Headers", "Origin, X-Requested-With, Content-Type, Accept");
  res.header("Access-Control-Allow-Methods", "GET, POST");
  next();
});

app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));

// === Serve static files (optional) ===
app.use(express.static("public"));

// === Data file path ===
const dataPath = path.join(__dirname, "beta_testers.json");

// === Endpoint: Submit form ===
app.post("/submit", (req, res) => {
  const { name, email, wallet } = req.body;

  if (!name || !email || !wallet) {
    return res.status(400).json({ error: "Missing fields" });
  }

  const newEntry = { name, email, wallet, timestamp: new Date().toISOString() };

  let data = [];
  if (fs.existsSync(dataPath)) {
    data = JSON.parse(fs.readFileSync(dataPath));
  }

  data.push(newEntry);
  fs.writeFileSync(dataPath, JSON.stringify(data, null, 2));

  console.log("✅ New beta tester added:", newEntry);
  res.status(200).json({ message: "Beta tester registered successfully" });
});

// === Endpoint: Get beta tester data ===
app.get("/beta-testers", (req, res) => {
  if (fs.existsSync(dataPath)) {
    const data = fs.readFileSync(dataPath);
    res.json(JSON.parse(data));
  } else {
    res.json([]);
  }
});

// === Start server ===
app.listen(PORT, () => {
  console.log(`🚀 Server is running on http://localhost:${PORT}`);
});
