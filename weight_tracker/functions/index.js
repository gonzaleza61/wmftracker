const functions = require("firebase-functions");
const { onCall } = require("firebase-functions/v2/https");
const { defineSecret } = require("firebase-functions/params");
const OpenAI = require("openai");

// Securely retrieve the OpenAI API key from Firebase Secrets
const openaiApiKey = defineSecret("OPENAI_API_KEY");

exports.generateAIResponse = onCall(
  { secrets: [openaiApiKey] },
  async (request) => {
    try {
      console.log("Function called with request data:", request.data);

      const prompt = request.data?.prompt;
      if (!prompt?.trim()) {
        throw new functions.https.HttpsError(
          "invalid-argument",
          "The function must be called with a non-empty prompt."
        );
      }

      const openai = new OpenAI({
        apiKey: openaiApiKey.value(),
      });

      const completion = await openai.chat.completions.create({
        model: "gpt-3.5-turbo",
        messages: [
          {
            role: "system",
            content:
              "You are a knowledgeable fitness trainer. Provide concise, accurate advice about workouts, nutrition, and fitness goals.",
          },
          { role: "user", content: prompt.trim() },
        ],
        max_tokens: 500,
      });

      if (!completion?.choices?.[0]?.message?.content) {
        throw new functions.https.HttpsError(
          "internal",
          "Invalid response from OpenAI"
        );
      }

      return { response: completion.choices[0].message.content };
    } catch (error) {
      console.error("Function error:", error);

      if (error.code === "insufficient_quota") {
        throw new functions.https.HttpsError(
          "resource-exhausted",
          "OpenAI API quota exceeded"
        );
      }

      throw new functions.https.HttpsError(
        "internal",
        `Error: ${error.message}`
      );
    }
  }
);
