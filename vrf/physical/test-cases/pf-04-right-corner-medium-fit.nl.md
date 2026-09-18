# PF-04 — Medium rechter corner coupler passen

**Vraag**

Past de geprinte medium rechter corner coupler natuurlijk en herhaalbaar op zijn twee bedoelde chirale posities — top-right en na 180° Y-rotatie bottom-left — zonder forceren, wiebelen of interferentie?

Deze testcase controleert alleen deze fysieke pasvraag. Een groene CI-run of
digitale render telt niet als fysiek resultaat.

**Status**

`ready to execute` — nog niet fysiek uitgevoerd.

**Exacte fixture**

- STL: [`corner-edge-coupler-right-medium.stl`](https://github.com/brainboxemb/2026-009-01.cad.HUB75-display-frame/blob/prod/bld/stl/corner-edge-coupler-right-medium.stl)
- functionele source commit: `a85c3f31b508a3d761011328768d6ca99f6f3a33`
- production run: `35330842746`
- Git blob: `2dd42802edd303d2b42edb4ab547ca369244cedd`
- digitale plaatsingsreferentie: [fit-detail](https://github.com/brainboxemb/2026-009-01.cad.HUB75-display-frame/blob/prod/vrf/png/corner-edge-coupler-right-medium-fit-detail.png)

**Benodigd**

- één fysiek P5 64 × 32-paneel met sample-ID;
- één print van de exacte PF-04 STL;
- een passende losse montageschroef, als die beschikbaar is;
- telefoon of camera.

**Vooraf**

Leg het paneel met de achterzijde naar je toe en begin bij de fysieke top-right hoek. Het huidige panelmodel voorspelt op deze chirale hoek géén locator pin. Controleer dat expliciet op het echte paneel; een afwijkende fysieke feature wordt `investigate`.

Print de STL op 100% schaal. Verwijder alleen normale printbrim/support waar dat
geen mating-geometrie verandert. Schuur of ruim pasvlakken, geleiders, locators
of gaten niet op vóór de eerste test.

| # | Handeling | Verwacht |
| ---: | --- | --- |
| 1 | Plaats de coupler zonder schroef op top-right met lichte handdruk. | Top- en side-guide en reinforcement locator vinden hun features zonder forceren. |
| 2 | Controleer de base, beide buitenranden en de 19,5 mm buitenprojectie visueel. | De base zit vlak; beide ridges volgen de panelranden en niets trekt de part scheef. |
| 3 | Controleer screw/tube/reinforcement interfaces en het gebied waar de linker variant een locator clearance heeft; steek een beschikbare schroef alleen los in. | De echte locator-situatie komt overeen met het model en veroorzaakt geen botsing; een onverwachte fysieke feature wordt `investigate`. De schroef start zonder de part in positie te trekken. |
| 4 | Neem de coupler weg en plaats hem drie keer opnieuw op top-right. | Dezelfde natuurlijke seating is herhaalbaar zonder haken of rocking. |
| 5 | Draai de coupler 180° om Y en plaats dezelfde part op bottom-left. | De gedocumenteerde tweede chirale positie past eveneens natuurlijk zonder nieuwe interferentie. |
| 6 | Maak een duidelijke foto van ten minste de top-right seating en noteer eventuele afdrukken/stress. | Geen zichtbare schade of spanning; bewijs toont beide buitenranden en het reinforcementgebied. |

**Registratie**

- Paneelsample(s): `...`
- Datum: `...`
- STL / Git blob: `corner-edge-coupler-right-medium.stl` / `2dd42802edd303d2b42edb4ab547ca369244cedd`
- Printer / materiaal / printprofiel: `...`
- Resultaat: `agrees` / `investigate` / `not checked`
- Waargenomen: `...`
- Bewijs (foto/link): `...`
- Vervolg: `...`
