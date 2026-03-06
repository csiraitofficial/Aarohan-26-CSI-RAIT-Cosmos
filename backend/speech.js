const express = require("express");
const router = express.Router();
const multer = require("multer");
const FormData = require("form-data");
const fs = require("fs");
const path = require("path");
const { exec } = require("child_process");
const util = require("util");

const execPromise = util.promisify(exec);

// In-memory storage for audio files
const upload = multer({ storage: multer.memoryStorage() });

// Configuration
const USE_LOCAL_WHISPER = process.env.USE_LOCAL_WHISPER === "true";
const WHISPER_MODEL = process.env.WHISPER_MODEL || "base"; // tiny, base, small, medium, large
const OPENAI_API_KEY = process.env.OPENAI_API_KEY;
const OLLAMA_URL = process.env.OLLAMA_HOST || "http://localhost:11434";

/**
 * POST /speech/transcribe
 * Accepts an audio file and transcribes it using either:
 * 1. Local Whisper (faster, no API key needed)
 * 2. OpenAI Whisper API (more accurate, requires API key)
 * Returns { text: "transcribed text" }
 */
router.post("/transcribe", upload.single("audio"), async (req, res) => {
  try {
    if (!req.file) {
      return res.status(400).json({ error: "No audio file provided" });
    }

    if (USE_LOCAL_WHISPER) {
      return await _transcribeWithLocalWhisper(req.file, res);
    } else {
      return await _transcribeWithOpenAI(req.file, res);
    }
  } catch (err) {
    console.error("[Speech] Transcription error:", err.message);
    res.status(500).json({
      error: "Failed to transcribe audio",
      detail: err.message,
    });
  }
});

/**
 * Transcribe using local whisper.cpp binary
 * Requires whisper binary to be installed:
 * https://github.com/ggerganov/whisper.cpp
 */
async function _transcribeWithLocalWhisper(file, res) {
  const tempDir = path.join(__dirname, "temp");
  if (!fs.existsSync(tempDir)) {
    fs.mkdirSync(tempDir, { recursive: true });
  }

  const audioPath = path.join(tempDir, `audio_${Date.now()}.wav`);
  const outputPath = path.join(tempDir, `output_${Date.now()}`);

  try {
    // Save audio file temporarily
    fs.writeFileSync(audioPath, file.buffer);

    // Run whisper locally
    const whisperCmd = `whisper "${audioPath}" --model ${WHISPER_MODEL} --output_format json --output_dir "${tempDir}" -o "${outputPath}" --language en`;

    console.log("[Speech] Running local whisper:", whisperCmd);
    const { stdout, stderr } = await execPromise(whisperCmd, {
      timeout: 120000, // 2 minutes timeout
    });

    if (stderr && !stderr.includes("Progress")) {
      console.error("[Speech] Whisper stderr:", stderr);
    }

    // Read the JSON output
    const jsonPath = `${outputPath}.json`;
    if (!fs.existsSync(jsonPath)) {
      return res.status(500).json({
        error: "Whisper output not found",
        detail: "Check if whisper binary is installed correctly",
        hint: "Install from: https://github.com/ggerganov/whisper.cpp",
      });
    }

    const result = JSON.parse(fs.readFileSync(jsonPath, "utf8"));
    const text = result.text || "";

    // Cleanup
    fs.unlinkSync(audioPath);
    fs.unlinkSync(jsonPath);

    res.json({ text });
  } catch (err) {
    // Cleanup on error
    if (fs.existsSync(audioPath)) fs.unlinkSync(audioPath);

    console.error("[Speech] Local whisper error:", err.message);

    if (err.message.includes("command not found") || err.message.includes("whisper")) {
      return res.status(503).json({
        error: "Local whisper not installed",
        detail: err.message,
        hint: "Install whisper.cpp from: https://github.com/ggerganov/whisper.cpp/releases",
      });
    }

    res.status(500).json({
      error: "Local transcription failed",
      detail: err.message,
    });
  }
}

/**
 * Transcribe using OpenAI Whisper API
 */
async function _transcribeWithOpenAI(file, res) {
  if (!OPENAI_API_KEY) {
    return res.status(500).json({
      error: "OpenAI API key not configured",
      detail: "Set OPENAI_API_KEY environment variable or USE_LOCAL_WHISPER=true",
    });
  }

  try {
    // Create FormData for OpenAI API
    const formData = new FormData();
    formData.append("file", file.buffer, "speech.wav");
    formData.append("model", "whisper-1");
    formData.append("language", "en");

    // Send to OpenAI Whisper API
    const response = await fetch("https://api.openai.com/v1/audio/transcriptions", {
      method: "POST",
      headers: {
        Authorization: `Bearer ${OPENAI_API_KEY}`,
        ...formData.getHeaders(),
      },
      body: formData,
    });

    if (!response.ok) {
      const error = await response.json();
      console.error("[Speech] OpenAI API error:", error);
      return res.status(response.status).json({
        error: "Transcription failed",
        detail: error.error?.message || "Unknown error",
      });
    }

    const data = await response.json();
    res.json({
      text: data.text || "",
    });
  } catch (err) {
    console.error("[Speech] OpenAI transcription error:", err.message);
    res.status(500).json({
      error: "OpenAI transcription failed",
      detail: err.message,
    });
  }
}

module.exports = router;
