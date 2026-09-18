# PF-03 — Medium linker corner coupler passen

**Vraag**

Past de geprinte medium linker corner coupler natuurlijk en herhaalbaar op zijn twee bedoelde chirale posities — top-left en na 180° Y-rotatie bottom-right — zonder forceren, wiebelen of locatorinterferentie?

Deze testcase controleert alleen deze fysieke pasvraag. Een groene CI-run of
digitale render telt niet als fysiek resultaat.

**Status**

`ready to execute` — nog niet fysiek uitgevoerd.

**Exacte fixture**

- STL: [`corner-edge-coupler-left-medium.stl`](https://github.com/brainboxemb/2026-009-01.cad.HUB75-display-frame/blob/prod/bld/stl/corner-edge-coupler-left-medium.stl)
- functionele source commit: `a85c3f31b508a3d761011328768d6ca99f6f3a33`
- production run: `35330842746`
- Git blob: `f07e565d54686e3d65f9ce1e0879c401dae7629d`
- digitale plaatsingsreferentie: [fit-detail](https://github.com/brainboxemb/2026-009-01.cad.HUB75-display-frame/blob/prod/vrf/png/corner-edge-coupler-left-medium-fit-detail.png)

**Benodigd**

- één fysiek P5 64 × 32-paneel met sample-ID;
- één print van de exacte PF-03 STL;
- een passende losse montageschroef, als die beschikbaar is;
- telefoon of camera.

**Vooraf**

Leg het paneel met de achterzijde naar je toe en begin bij de fysieke top-left hoek. Deze linker variant bevat de locator-pin clearance die bij deze hoek hoort.

Print de STL op 100% schaal. Verwijder alleen normale printbrim/support waar dat
geen mating-geometrie verandert. Schuur of ruim pasvlakken, geleiders, locators
of gaten niet op vóór de eerste test.

| # | Handeling | Verwacht |
| ---: | --- | --- |
| 1 | Plaats de coupler zonder schroef op top-left met lichte handdruk. | Top- en side-guide, reinforcement locator en locator-pin clearance vinden hun features zonder forceren. |
| 2 | Controleer de base, beide buitenranden en de 19,5 mm buitenprojectie visueel. | De base zit vlak; beide ridges volgen de panelranden en niets trekt de part scheef. |
| 3 | Controleer screw/tube/reinforcement/locator interfaces en steek een beschikbare schroef alleen los in. | De fysieke locator pin loopt vrij in zijn clearance en de schroef start zonder de part in positie te trekken. |
| 4 | Neem de coupler weg en plaats hem drie keer opnieuw op top-left. | Dezelfde natuurlijke seating is herhaalbaar zonder haken of rocking. |
| 5 | Draai de coupler 180° om Y en plaats dezelfde part op bottom-right. | De gedocumenteerde tweede chirale positie past eveneens natuurlijk en de locator interface komt op de overeenkomstige fysieke feature. |
| 6 | Maak een duidelijke foto van ten minste de top-left seating en noteer eventuele afdrukken/stress. | Geen zichtbare schade of spanning; bewijs maakt seating en locatorgebied zichtbaar. |

**Registratie**

- Paneelsample(s): `...`
- Datum: `...`
- STL / Git blob: `corner-edge-coupler-left-medium.stl` / `f07e565d54686e3d65f9ce1e0879c401dae7629d`
- Printer / materiaal / printprofiel: `...`
- Resultaat: `agrees` / `investigate` / `not checked`
- Waargenomen: `...`
- Bewijs (foto/link): `...`
- Vervolg: `...`
