import { readFileSync } from "node:fs";
import path from "node:path";

import { validateAnalyticsEvent } from "../src/validation";

const fixturePath = path.resolve(process.cwd(), "shared/contracts/fixtures/launch/analytics_events_sample.json");
const events = JSON.parse(readFileSync(fixturePath, "utf8")) as unknown[];

const failures: string[] = [];
for (const [index, event] of events.entries()) {
  const result = validateAnalyticsEvent(event);
  if (!result.success) {
    failures.push(`event[${index}] => ${result.errors.join("; ")}`);
  }
}

if (failures.length > 0) {
  console.error("Fixture validation failed.");
  failures.forEach((failure) => console.error(`- ${failure}`));
  process.exit(1);
}

console.log(`Validated ${events.length} analytics fixtures.`);
