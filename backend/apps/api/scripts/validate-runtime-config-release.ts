import { readFileSync } from "node:fs";
import path from "node:path";

const targetPath = path.resolve(
  __dirname,
  "../../../../shared/contracts/remote-config/defaults/launch-defaults.v1.json"
);
const payload = JSON.parse(readFileSync(targetPath, "utf8")) as Record<string, unknown>;
const requiredKeys = [
  "schemaVersion",
  "featureFlags",
  "economy",
  "onboarding",
  "paywall",
  "reminders",
  "widgets",
  "liveActivities",
  "chapterGating"
] as const;

for (const key of requiredKeys) {
  if (!(key in payload)) {
    throw new Error(`Remote config is missing required key: ${key}`);
  }
}

console.log(`Validated runtime config release payload at ${targetPath}.`);
