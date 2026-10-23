
# syntax=docker/dockerfile:1
 
# ---- build stage ----
FROM node:22-slim AS build
WORKDIR /app
 
COPY package.json package-lock.json ./
RUN npm ci
 
COPY . .
 
# Public values that Vite inlines into the browser bundle at build time.
ARG VITE_SUPABASE_URL
ARG VITE_SUPABASE_PUBLISHABLE_KEY
ENV VITE_SUPABASE_URL=$VITE_SUPABASE_URL \
    VITE_SUPABASE_PUBLISHABLE_KEY=$VITE_SUPABASE_PUBLISHABLE_KEY \
    NITRO_PRESET=node-server
RUN npm run build
 
# ---- runtime stage ----
FROM node:22-slim AS runtime
ENV NODE_ENV=production \
    PORT=3000 \
    NITRO_HOST=0.0.0.0
WORKDIR /app
 
# The build output is self-contained: no node_modules are needed at runtime.
COPY --from=build --chown=node:node /app/.output ./.output
 
USER node
EXPOSE 3000
 
HEALTHCHECK --interval=30s --timeout=5s --start-period=10s --retries=3 \
  CMD node -e "fetch('http://127.0.0.1:3000/').then(r=>process.exit(r.ok?0:1)).catch(()=>process.exit(1))"
 
# Server-side secrets (SUPABASE_URL, SUPABASE_PUBLISHABLE_KEY, AI_API_KEY, ...) are passed at runtime,
# never baked into the image. See docker-compose.yml.
CMD ["node", ".output/server/index.mjs"]