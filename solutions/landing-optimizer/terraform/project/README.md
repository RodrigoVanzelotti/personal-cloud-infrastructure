# Project stack

Owns marketing/demo services, disabled legacy Cloud Build triggers, source image
repositories, Firestore/rules, buckets, enabled APIs, remaining IAM and the scoped
release grants for both projects. It uses the existing `landing-optimizer/project`
remote state and does not own the API/AI/dashboard stack resources.

See [the solution guide](../../README.md). Refresh both image and revision-label
inputs from state before administrator plans to avoid rolling back another release.
