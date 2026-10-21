import { existsSync } from "node:fs";
import path from "node:path";
import { NextResponse } from "next/server";

export const dynamic = "force-dynamic";

const DATA_DIR = process.env.PIPELINE_DATA_DIR ?? path.join(process.cwd(), "data");

/** Liveness + readiness for Docker and the host: 503 until the pipeline data is in place. */
export function GET() {
  const data = existsSync(path.join(DATA_DIR, "clio", "matter.json"));
  return NextResponse.json({ ok: data, data }, { status: data ? 200 : 503 });
}
