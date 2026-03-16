export const sharedAnalyticsContractManifest = {
  catalogPath: "shared/contracts/events/event-catalog.v1.yaml",
  schemaPaths: [
    "shared/contracts/events/schemas/common-event.schema.json",
    "shared/contracts/events/schemas/vow-completion-event.schema.json",
    "shared/contracts/events/schemas/monetization-event.schema.json"
  ],
  exampleFixturesPath: "shared/contracts/fixtures/launch/analytics_events_sample.json"
} as const;
