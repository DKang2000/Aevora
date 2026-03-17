import { readFileSync } from "node:fs";
import path from "node:path";

type AssetManifest = {
  schemaVersion?: string;
  releaseId?: string;
  generatedAt?: string;
  cdnBaseURL?: string;
  assets?: Array<Record<string, unknown>>;
};

const manifestPath = path.resolve(__dirname, "../../../../ops/assets/manifests/launch-assets.v1.json");
const manifest = JSON.parse(readFileSync(manifestPath, "utf8")) as AssetManifest;

if (!manifest.schemaVersion || !manifest.releaseId || !manifest.generatedAt || !manifest.cdnBaseURL || !Array.isArray(manifest.assets)) {
  throw new Error("Asset manifest is missing required top-level fields.");
}

const requiredAssetKeys = [
  "assetId",
  "channel",
  "logicalPath",
  "artifactPath",
  "contentHash",
  "versionToken",
  "contentType",
  "cacheControl",
  "sizeBytes"
] as const;

manifest.assets.forEach((asset, index) => {
  for (const key of requiredAssetKeys) {
    if (!(key in asset)) {
      throw new Error(`Asset manifest entry ${index} is missing required key: ${key}`);
    }
  }
});

console.log(`Validated asset manifest at ${manifestPath} with ${manifest.assets.length} entries.`);
