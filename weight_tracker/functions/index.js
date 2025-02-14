// /**
//  * Import function triggers from their respective submodules:
//  *
//  * const {onCall} = require("firebase-functions/v2/https");
//  * const {onDocumentWritten} = require("firebase-functions/v2/firestore");
//  *
//  * See a full list of supported triggers at https://firebase.google.com/docs/functions
//  */

// const functions = require("firebase-functions");
// const axios = require("axios");

// // Create and deploy your first functions
// // https://firebase.google.com/docs/functions/get-started

// // exports.helloWorld = onRequest((request, response) => {
// //   logger.info("Hello logs!", {structuredData: true});
// //   response.send("Hello from Firebase!");
// // });

// exports.generateAIResponse = functions.https.onCall(async (data) => {
//   try {
//     console.log("Function called with data:", data);

//     if (!data || !data.prompt || data.prompt.trim() === "") {
//       console.log("Invalid prompt received:", data);
//       throw new functions.https.HttpsError(
//         "invalid-argument",
//         "The function must be called with a non-empty prompt."
//       );
//     }

//     const apiKey = functions.config().openai?.key;
//     if (!apiKey) {
//       console.error("OpenAI API key not found in config");
//       throw new functions.https.HttpsError(
//         "failed-precondition",
//         "OpenAI API key not configured"
//       );
//     }

//     console.log("API Key exists:", !!apiKey);

//     const response = await axios.post(
//       "https://api.openai.com/v1/chat/completions",
//       {
//         model: "gpt-3.5-turbo",
//         messages: [
//           {
//             role: "system",
//             content:
//               "You are a knowledgeable fitness trainer. Provide concise, accurate advice about workouts, nutrition, and fitness goals.",
//           },
//           { role: "user", content: data.prompt.trim() },
//         ],
//       },
//       {
//         headers: {
//           "Content-Type": "application/json",
//           Authorization: `Bearer ${apiKey}`,
//         },
//       }
//     );

//     console.log("OpenAI response received");
//     return { response: response.data.choices[0].message.content };
//   } catch (error) {
//     console.error("Function error:", {
//       message: error.message,
//       code: error.code,
//       details: error.details,
//       response: error.response?.data,
//     });

//     if (error.response?.status === 401) {
//       throw new functions.https.HttpsError(
//         "unauthenticated",
//         "Invalid OpenAI API key"
//       );
//     }

//     throw new functions.https.HttpsError("internal", `Error: ${error.message}`);
//   }
// });

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
        model: "gpt-4o-mini",
        messages: [
          {
            role: "system",
            content:
              "You are a knowledgeable fitness trainer. Provide concise, accurate advice about workouts, nutrition, and fitness goals.",
          },
          { role: "user", content: prompt.trim() },
        ],
        stream: true,
      });

      return { response: completion.choices[0].message.content };
    } catch (error) {
      console.error("Function error:", error);
      throw new functions.https.HttpsError("internal", error.message);
    }
  }
);
