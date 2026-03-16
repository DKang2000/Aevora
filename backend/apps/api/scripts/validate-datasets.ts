import { readdirSync, readFileSync } from "node:fs";
import path from "node:path";

const datasetsDir = path.resolve(__dirname, "../../../../backend/packages/analytics-schema/datasets");
const requiredKeys = ["scenarioId", "user", "vows", "subscriptionState"] as const;

const datasetFiles = readdirSync(datasetsDir).filter((file) => file.endsWith(".json"));
for (const file of datasetFiles) {
  const dataset = JSON.parse(readFileSync(path.join(datasetsDir, file), "utf8")) as Record<string, unknown>;
  for (const key of requiredKeys) {
    if (!(key in dataset)) {
      throw new Error(`${file} is missing required key: ${key}`);
    }
  }
}

console.log(`Validated ${datasetFiles.length} demo dataset files.`);
