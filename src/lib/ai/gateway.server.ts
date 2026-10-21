import { createOpenAI } from "@ai-sdk/openai";
import { createOpenAICompatible } from "@ai-sdk/openai-compatible";
import { generateText, streamText, type ModelMessage } from "ai";

/**
 * AI provider access (server only).
 *
 * Environment variables:
 *   AI_API_KEY      provider API key (required)
 *   AI_MODEL        model id (default: openai/gpt-oss-120b) - use a name from your provider's list
 *   AI_BASE_URL     endpoint (default: https://api.groq.com/openai/v1)
 *   AI_PROVIDER     optional: "openai" or "compatible" (default: compatible). The compatible client
 *                   sends only standard request fields and works with Groq, Mistral, Ollama, ...
 *   AI_REASONING    optional: "low", "medium" or "high". Only for reasoning models (for example
 *                   gpt-oss). "low" gives faster, cheaper answers. Leave unset for other models.
 *   AI_DEBUG        optional: set to 1 to show the provider's error text in the chat.
 */
export const AI_MODEL = process.env["AI_MODEL"] ?? "openai/gpt-oss-120b";
const BASE_URL = process.env["AI_BASE_URL"] ?? "https://api.groq.com/openai/v1";
const PROVIDER = process.env["AI_PROVIDER"] ?? "compatible";
const REASONING = process.env["AI_REASONING"];

function model() {
  const apiKey = process.env["AI_API_KEY"];
  if (!apiKey) throw new Error("The AI service is not configured (missing AI_API_KEY).");
  if (PROVIDER === "openai") return createOpenAI({ baseURL: BASE_URL, apiKey }).chat(AI_MODEL);
  return createOpenAICompatible({ name: "ai-provider", baseURL: BASE_URL, apiKey }).chatModel(
    AI_MODEL,
  );
}

/** Optional reasoning effort, passed only when AI_REASONING is set. */
function reasoningSetting() {
  return REASONING ? { reasoning: REASONING as "low" | "medium" | "high" } : {};
}

/**
 * Reasoning models stream their "thinking" separately from the answer. The client library would
 * send that thinking back to the provider as an extra field on the earlier assistant messages, and
 * strict providers reject it with a 400 error, so the second chat message fails. Earlier thinking
 * is not needed to answer the next question, so it is removed from the history.
 */
function withoutReasoning(messages: ModelMessage[]): ModelMessage[] {
  return messages.map((message) =>
    message.role === "assistant" && Array.isArray(message.content)
      ? { ...message, content: message.content.filter((part) => part.type !== "reasoning") }
      : message,
  ) as ModelMessage[];
}

type ProviderError = {
  statusCode?: number;
  message?: string;
  responseBody?: string;
  lastError?: unknown;
};

/** The AI SDK wraps repeated failures (for example 429) in a retry error; unwrap the real one. */
function unwrap(error: unknown): ProviderError {
  const e = error as ProviderError;
  return (e?.lastError as ProviderError | undefined) ?? e;
}

/** Server-side log line with the provider's HTTP status and its own error text. */
function logError(label: string, error: unknown) {
  const e = unwrap(error);
  console.error(label, e?.statusCode ?? "", e?.responseBody || e?.message || error);
}

/**
 * Text sent to the browser when a streamed answer fails. It always includes the provider's HTTP
 * status (the chat widget uses 429 and 402 for friendlier messages). Set AI_DEBUG=1 to also include
 * the provider's own error response, which helps when diagnosing setup problems.
 */
function describeStreamError(error: unknown) {
  const e = unwrap(error);
  const status = e?.statusCode ? ` (${e.statusCode})` : "";
  if (process.env["AI_DEBUG"] === "1") {
    const detail = e?.responseBody || e?.message || String(error);
    return `The AI request failed${status}: ${detail.slice(0, 300)}`;
  }
  return `The AI could not produce an answer${status}. Please try again.`;
}

/** Streaming chat for the UI-message protocol. */
export function streamChat(request: Request, system: string, messages: ModelMessage[]) {
  const result = streamText({
    model: model(),
    system,
    messages: withoutReasoning(messages),
    abortSignal: request.signal,
    ...reasoningSetting(),
    onError: ({ error }) => logError("[ai] streaming failed:", error),
  });
  return result.toUIMessageStreamResponse({ sendReasoning: false, onError: describeStreamError });
}

/** One-shot generation returning the final text. */
export async function generateOnce(system: string, messages: ModelMessage[]) {
  let text: string;
  try {
    ({ text } = await generateText({
      model: model(),
      system,
      messages: withoutReasoning(messages),
      ...reasoningSetting(),
    }));
  } catch (error) {
    logError("[ai] generateText failed:", error);
    const status = unwrap(error).statusCode;
    if (status === 429) throw new Error("The AI is busy right now. Please try again in a minute.");
    if (status === 401 || status === 403)
      throw new Error("The AI key was rejected. Please check AI_API_KEY.");
    if (status === 402) throw new Error("AI credits have run out. Please add credits to continue.");
    throw new Error("The AI could not produce an answer. Please try again.");
  }
  if (!text.trim()) throw new Error("The AI could not produce an answer. Please try again.");
  return text.trim();
}
