# PF-01 — Medium middle coupler passen

**Vraag**

Past de geprinte medium middle coupler natuurlijk en herhaalbaar op twee aangrenzende echte HUB75-panelen bij de verticale naad en middelste montage-rij, zonder forceren, wiebelen of zichtbare interferentie?

Deze testcase controleert alleen deze fysieke pasvraag. Een groene CI-run of
digitale render telt niet als fysiek resultaat.

**Status**

`ready to execute` — nog niet fysiek uitgevoerd.

**Exacte fixture**

- STL: [`middle-coupler-medium.stl`](https://github.com/brainboxemb/2026-009-01.cad.HUB75-display-frame/blob/prod/bld/stl/middle-coupler-medium.stl)
- functionele source commit: `a85c3f31b508a3d761011328768d6ca99f6f3a33`
- production run: `35330842746`
- Git blob: `39f1b4c5b334410c8013cdb38d37d6148b39b218`
- digitale plaatsingsreferentie: [fit-detail](https://github.com/brainboxemb/2026-009-01.cad.HUB75-display-frame/blob/prod/vrf/png/middle-coupler-medium-fit-detail.png)

**Benodigd**

- twee fysieke P5 64 × 32-panelen met sample-ID's;
- één print van de exacte PF-01 STL;
- passende losse montageschroeven, als die beschikbaar zijn;
- telefoon of camera.

**Vooraf**

Leg beide panelen met de achterzijde naar je toe in de bedoelde afwisselende oriëntatie en breng de verticale naad rond de middelste montage-rij zonder klemkracht bij elkaar.

Print de STL op 100% schaal. Verwijder alleen normale printbrim/support waar dat
geen mating-geometrie verandert. Schuur of ruim pasvlakken, geleiders, locators
of gaten niet op vóór de eerste test.

| # | Handeling | Verwacht |
| ---: | --- | --- |
| 1 | Plaats de coupler eerst zonder schroeven over de twee seam-side montageposities. Gebruik alleen lichte handdruk. | De geleiders, seam locator en reinforcement locators vinden hun positie zonder buigen of forceren. |
| 2 | Laat de coupler volledig zitten en controleer beide panel-facing vlakken. | De base zit gelijkmatig op beide rear mounting planes; er is geen duidelijke kier of rocking. |
| 3 | Controleer montage-tube pockets, screw bores en reinforcement/locator interfaces rondom beide panelen. | Geen zichtbaar aanlopen; gaten en locators staan natuurlijk op hun fysieke features. |
| 4 | Als passende schroeven beschikbaar zijn: steek ze los door beide gaten zonder de coupler met de schroeven naar het paneel toe te trekken. | Beide schroeven starten vrij; de schroeven zijn niet nodig om een slechte pasvorm te corrigeren. |
| 5 | Neem de coupler weg en plaats hem drie keer opnieuw. | Dezelfde natuurlijke positie en seating zijn iedere keer terug te vinden. |
| 6 | Controleer na de herhalingen op spanning, wit trekken, beschadiging of een plek die steeds blijft haken en maak een duidelijke foto. | Geen zichtbare stress/interferentie; foto toont de volledig gezeten coupler en de seam. |

**Registratie**

- Paneelsample(s): `...`
- Datum: `...`
- STL / Git blob: `middle-coupler-medium.stl` / `39f1b4c5b334410c8013cdb38d37d6148b39b218`
- Printer / materiaal / printprofiel: `...`
- Resultaat: `agrees` / `investigate` / `not checked`
- Waargenomen: `...`
- Bewijs (foto/link): `...`
- Vervolg: `...`
