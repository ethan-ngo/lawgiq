# syntax=docker/dockerfile:1

# Read-only demo image: the pipeline output in demo-data/ is baked in, Clio is never
# called (no Python, no Clio keys), and SQLite lives in /tmp so every restart is clean.

FROM node:22-bookworm-slim AS base
WORKDIR /app
ENV NEXT_TELEMETRY_DISABLED=1

# 1. Dependencies. better-sqlite3 downloads a prebuilt binary; the toolchain is the
#    fallback for when none matches. None of this reaches the final image.
FROM base AS deps
RUN apt-get update \
 && apt-get install -y --no-install-recommends python3 make g++ \
 && rm -rf /var/lib/apt/lists/*
COPY package.json package-lock.json ./
RUN npm ci

# 2. Build. output: "standalone" writes .next/standalone with its own server.js.
FROM base AS builder
COPY --from=deps /app/node_modules ./node_modules
COPY . .
RUN npm run build

# 3. Runtime: standalone server + static assets + demo data, run as the non-root node user.
FROM base AS runner
ENV NODE_ENV=production \
    PORT=3000 \
    HOSTNAME=0.0.0.0 \
    PIPELINE_DATA_DIR=/app/demo-data \
    LAWGIQ_DB_PATH=/tmp/lawgiq.db \
    DATASET_TODAY=2026-10-02
COPY --from=builder --chown=node:node /app/public ./public
COPY --from=builder --chown=node:node /app/.next/standalone ./
COPY --from=builder --chown=node:node /app/.next/static ./.next/static
COPY --chown=node:node demo-data ./demo-data
USER node
EXPOSE 3000
HEALTHCHECK --interval=30s --timeout=5s --start-period=15s --retries=3 \
  CMD node -e "fetch('http://127.0.0.1:3000/api/health').then(r=>process.exit(r.ok?0:1)).catch(()=>process.exit(1))"
CMD ["node", "server.js"]
