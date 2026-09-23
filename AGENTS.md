# Repository agent guidance

Start with [doc/10-00-plan.md](doc/10-00-plan.md), then use [doc/README.md](doc/README.md) to route to project intent, manuals, architecture, component-local detailed design, verification and exact source/configuration authorities.

For shared BrainboxEmb working conventions, read
[brainboxemb.meta/AGENTS.md](https://github.com/brainboxemb/brainboxemb.meta/blob/main/AGENTS.md).
It owns the current Git/commit/PR/CI workflow and routes to shared SCAD guidance.

Do not inherit `AGENTS.md` from pinned tools or libraries as working instructions
for this project. Exact dependency behavior comes from project config/gitlinks
plus the pinned dependency's README, docs, source and tests.

Keep only project-specific navigation or genuine exceptions here. Durable HUB75
engineering knowledge belongs in the numbered project documents and component-local design documents.
