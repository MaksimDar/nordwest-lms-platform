import { createOpenAI } from "@ai-sdk/openai";
import { createOpenAICompatible } from "@ai-sdk/openai-compatible";
import { generateText, streamText, type ModelMessage } from "ai";

/**
 * AI provider access (server only).
 *
 * Environment variables:
 *   AI_API_KEY      provider API key (required)
 *   AI_MODEL        model id (default: gpt-4o-mini) - use a name from your provider's model list
 *   AI_BASE_URL     endpoint (default: https://api.openai.com/v1)
 *   AI_PROVIDER     optional: "openai" or "compatible". By default, api.openai.com uses the OpenAI
 *                   client and every other endpoint (Mistral, Groq, Hugging Face, ...) uses the
 *                   generic OpenAI-compatible client, which sends only standard request fields.
 */
export const AI_MODEL = process.env["AI_MODEL"] ?? "gpt-4o-mini";
const BASE_URL = process.env["AI_BASE_URL"] ?? "https://api.openai.com/v1";
const PROVIDER =
  process.env["AI_PROVIDER"] ?? (BASE_URL.includes("api.openai.com") ? "openai" : "compatible");

function model() {
  const apiKey = process.env["AI_API_KEY"];
  if (!apiKey) throw new Error("The AI service is not configured (missing AI_API_KEY).");
  if (PROVIDER === "openai") return createOpenAI({ baseURL: BASE_URL, apiKey }).chat(AI_MODEL);
  return createOpenAICompatible({ name: "ai-provider", baseURL: BASE_URL, apiKey }).chatModel(
    AI_MODEL,
  );
}

/** Streaming chat for the UI-message protocol. */
export function streamChat(request: Request, system: string, messages: ModelMessage[]) {
  const result = streamText({
    model: model(),
    system,
    messages,
    abortSignal: request.signal,
    onError: ({ error }) => console.error("[ai] streaming failed:", error),
  });
  return result.toUIMessageStreamResponse({
    onError: () => "The AI could not produce an answer. Please try again.",
  });
}

/** One-shot generation returning the final text. */
export async function generateOnce(system: string, messages: ModelMessage[]) {
  let text: string;
  try {
    ({ text } = await generateText({ model: model(), system, messages }));
  } catch (error) {
    console.error("[ai] generateText failed:", error);
    const status = (error as { statusCode?: number }).statusCode;
    if (status === 429) throw new Error("The AI is busy right now. Please try again in a minute.");
    if (status === 401 || status === 403)
      throw new Error("The AI key was rejected. Please check AI_API_KEY.");
    if (status === 402) throw new Error("AI credits have run out. Please add credits to continue.");
    throw new Error("The AI could not produce an answer. Please try again.");
  }
  if (!text.trim()) throw new Error("The AI could not produce an answer. Please try again.");
  return text.trim();
}
