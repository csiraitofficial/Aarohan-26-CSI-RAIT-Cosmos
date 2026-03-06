const express = require("express");
const router = express.Router();
const multer = require("multer");
const { PDFParse } = require("pdf-parse");

// Ollama runs on the same PC as this backend
const OLLAMA_URL = process.env.OLLAMA_HOST || "http://localhost:11434";

// In-memory storage for file uploads (no disk writes)
const upload = multer({ storage: multer.memoryStorage() });

/**
 * GET /ollama/health
 * Lightweight ping — just checks if Ollama process is alive.
 * Returns { ok: true } so the app doesn't have to parse /api/tags.
 */
router.get("/health", async (_req, res) => {
  try {
    const controller = new AbortController();
    const timeout = setTimeout(() => controller.abort(), 5000);
    const response = await fetch(`${OLLAMA_URL}/api/tags`, {
      signal: controller.signal,
    });
    clearTimeout(timeout);
    if (response.ok) {
      res.json({ ok: true });
    } else {
      res.status(502).json({ ok: false, error: `Ollama returned ${response.status}` });
    }
  } catch (err) {
    console.error("[Ollama Proxy] Health-check failed:", err.message);
    res.status(502).json({
      ok: false,
      error: "Ollama not reachable",
      detail: err.message,
      hint: "Make sure Ollama is running: ollama serve",
    });
  }
});

/**
 * GET /ollama/tags
 * Proxies to Ollama's /api/tags so the app can verify connectivity.
 */
router.get("/tags", async (_req, res) => {
  try {
    const controller = new AbortController();
    const timeout = setTimeout(() => controller.abort(), 5000);
    const response = await fetch(`${OLLAMA_URL}/api/tags`, {
      signal: controller.signal,
    });
    clearTimeout(timeout);
    const data = await response.json();
    res.json(data);
  } catch (err) {
    console.error("[Ollama Proxy] /tags failed:", err.message);
    res.status(502).json({ error: "Ollama not reachable", detail: err.message });
  }
});

/**
 * POST /ollama/generate
 * Proxies a generate request to Ollama's /api/generate endpoint.
 */
router.post("/generate", async (req, res) => {
  try {
    // 2-minute timeout for generation (large models can be slow)
    const controller = new AbortController();
    const timeout = setTimeout(() => controller.abort(), 120000);
    const response = await fetch(`${OLLAMA_URL}/api/generate`, {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify(req.body),
      signal: controller.signal,
    });
    clearTimeout(timeout);
    const data = await response.json();
    res.json(data);
  } catch (err) {
    console.error("[Ollama Proxy] Generate failed:", err.message);
    res.status(502).json({ error: "Ollama generate failed", detail: err.message });
  }
});

/**
 * POST /ollama/summarize
 * Accepts a file (PDF or TXT) and returns an AI-generated summary.
 * Used by AI Tutor for educational material summarization.
 */
router.post("/summarize", upload.single("material"), async (req, res) => {
  try {
    if (!req.file) {
      return res.status(400).json({ error: "No file uploaded" });
    }

    let extractedText = "";
    const filename = req.file.originalname;

    // Extract text based on file type
    if (filename.endsWith(".pdf")) {
      const parser = new PDFParse({ data: req.file.buffer });
      await parser.load();
      const result = await parser.getText();
      extractedText = result.text || "";
    } else if (filename.endsWith(".txt")) {
      extractedText = req.file.buffer.toString("utf-8");
    } else {
      return res.status(400).json({
        error: "Unsupported file type",
        detail: "Only PDF and TXT files are supported.",
      });
    }

    // Trim to avoid overwhelming Ollama
    if (extractedText.length > 5000) {
      extractedText = extractedText.substring(0, 5000) + "\n[...content truncated...]";
    }

    // Build summary prompt
    const summaryPrompt =
      "Summarize this educational material in simple, clear language. " +
      "Highlight key points and important concepts. " +
      "Make it easy to understand for a student.\n\n" +
      extractedText;

    // Forward to Ollama
    const controller = new AbortController();
    const timeout = setTimeout(() => controller.abort(), 120000);
    const response = await fetch(`${OLLAMA_URL}/api/generate`, {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({
        model: "llama3.2:3b",
        prompt: summaryPrompt,
        stream: false,
        options: {
          num_predict: 512,
          temperature: 0.7,
          num_gpu: 99,
        },
      }),
      signal: controller.signal,
    });
    clearTimeout(timeout);

    const data = await response.json();
    const summary = (data.response || "").trim();

    res.json({
      summary:
        summary ||
        "Unable to generate summary. Please try a different file.",
      title: filename,
    });
  } catch (err) {
    console.error("[Ollama Proxy] Summarize failed:", err.message);
    res.status(502).json({
      error: "Failed to summarize material",
      detail: err.message,
    });
  }
});

module.exports = router;
