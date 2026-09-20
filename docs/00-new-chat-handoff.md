# New chat / project handoff

Use this instruction to continue work on the HUB75 display-frame project in a
new ChatGPT/work session.

Generic repository/tooling behaviour is not defined here. Read
[`brainboxemb/brainboxemb.meta`](https://github.com/brainboxemb/brainboxemb.meta)
for the shared working model and the pinned tool repositories for implementation
policy. This repository owns only the HUB75 display-frame design, its
project-specific plan and its evidence.

## Copy/paste start instruction

```text
Werk vanuit brainboxemb/2026-009-01.cad.HUB75-display-frame als project source.

Gebruik oude chatgeschiedenis niet als source of truth. Controleer eerst de
actuele repository, open issues/pull requests, CI/evidence en gegenereerde
output.

Gebruik brainboxemb/brainboxemb.meta voor generieke brainboxemb-afspraken en
cross-project context. Dupliceer generiek repository-, tooling-, publication- of
workflowgedrag niet in dit projectplan.

Lees in deze projectrepository eerst:
- README.md;
- AGENTS.md;
- docs/00-new-chat-handoff.md;
- docs/01-project-plan.md;
- CHANGELOG.md;
- project.yml;
- project.scad.yml.

Lees uit brainboxemb.meta alleen wat voor de actuele stap relevant is. Begin bij
docs/working-model/projects.md en het SCAD-domein wanneer generiek project- of
SCAD-gedrag nodig is. Gebruik STATUS.md alleen wanneer de actuele projectstap
door een cross-project work track wordt geraakt.

Bepaal daarna zelf:
1. welke projectstap volgens docs/01-project-plan.md en de actuele GitHub-status
   werkelijk aan de beurt is;
2. welke open issue/PR of prerequisite daarbij hoort;
3. welke source, build/verification evidence en fysieke evidence relevant zijn;
4. wat de kleinste geldige volgende wijziging is.

Vraag mij niet om een stepnummer als dat uit het plan en de repository kan
worden afgeleid.

Herverifieer voor implementatie de geplande stap tegen de actuele source,
issues/PRs en evidence. Als aannames, volgorde of verificatie niet meer kloppen,
corrigeer eerst het projectplan. Voer oude plantekst niet mechanisch uit.

Gebruik de normale pull-request-first flow uit de gepinde tooling. Houd:
- generieke afspraken in brainboxemb.meta of de relevante tool-owner;
- permanente HUB75-projectregels in AGENTS.md;
- toekomstig/open projectwerk in docs/01-project-plan.md;
- afgeronde functionele historie in CHANGELOG.md;
- implementatiedetails bij de source die ze bezit.

Gegenereerde dev/prod/rel branches zijn evidence, geen authoring source.
Onderscheid digitale geometrieverificatie expliciet van fysieke print-fit
acceptatie.

Werk alleen aan de actuele stap en noodzakelijke correcties/prerequisites.
Begin geen latere reinforcement-tube-, clip- of frame-laag zolang de eerdere
panel- en coupler-fit stappen niet geaccepteerd zijn.

Na implementatie:
- controleer de relevante CI en gegenereerde evidence;
- inspecteer visuele evidence inhoudelijk, niet alleen workflowstatus;
- werk docs/01-project-plan.md status/evidence bij waar nuttig;
- werk CHANGELOG.md bij voor betekenisvolle functionele én zichtbare
  repository/resource-wijzigingen volgens brainboxemb.meta;
- laat een repositorytoestand achter waaruit een nieuwe sessie zelfstandig de
  volgende stap kan bepalen.
```

## Resolution rule

A fresh session should be able to determine the next project step from the plan,
current issues/PRs and generated evidence without relying on old chat history.

The plan is intentionally project-local. Cross-project migrations, experiments
and shared tooling changes remain coordinated from
`brainboxemb/brainboxemb.meta`.
