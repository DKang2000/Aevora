import { readFileSync } from "node:fs";
import path from "node:path";

const contentPath = path.resolve(__dirname, "../../../../content/launch/launch-content.min.v1.json");
const copyPath = path.resolve(__dirname, "../../../../content/launch/copy/en/core.v1.json");

const contentPayload = JSON.parse(readFileSync(contentPath, "utf8")) as Record<string, unknown>;
const copyPayload = JSON.parse(readFileSync(copyPath, "utf8")) as Record<string, unknown>;

const requiredContentKeys = ["schemaVersion", "originFamilies", "identityShells", "districts", "chapters"] as const;
for (const key of requiredContentKeys) {
  if (!(key in contentPayload)) {
    throw new Error(`Content payload is missing required key: ${key}`);
  }
}

if (!("schemaVersion" in copyPayload)) {
  throw new Error("Copy payload is missing schemaVersion.");
}

console.log(`Validated launch content payload at ${contentPath} and copy payload at ${copyPath}.`);
