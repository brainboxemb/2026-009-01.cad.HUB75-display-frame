# PF-02 — Medium horizontal-edge coupler passen

**Vraag**

Past de geprinte medium horizontal-edge coupler natuurlijk en herhaalbaar op de bedoelde panelnaad aan de buitenrand, inclusief de connector-zware seam, zonder forceren, wiebelen of connectorinterferentie?

Deze testcase controleert alleen deze fysieke pasvraag. Een groene CI-run of
digitale render telt niet als fysiek resultaat.

**Status**

`ready to execute` — nog niet fysiek uitgevoerd.

**Exacte fixture**

- STL: [`horizontal-edge-coupler-medium.stl`](https://github.com/brainboxemb/2026-009-01.cad.HUB75-display-frame/blob/prod/bld/stl/horizontal-edge-coupler-medium.stl)
- functionele source commit: `a85c3f31b508a3d761011328768d6ca99f6f3a33`
- production run: `35330842746`
- Git blob: `839436b628a68485c66ee099b6ad7cdec9c23a34`
- digitale plaatsingsreferentie: [fit-detail](https://github.com/brainboxemb/2026-009-01.cad.HUB75-display-frame/blob/prod/vrf/png/horizontal-edge-coupler-medium-fit-detail.png)

**Benodigd**

- twee fysieke P5 64 × 32-panelen met sample-ID's;
- één print van de exacte PF-02 STL;
- passende losse montageschroeven, als die beschikbaar zijn;
- telefoon of camera.

**Vooraf**

Leg de panelen met de achterzijde naar je toe. Gebruik voor de eerste plaatsing de sterke seam-pariteit uit de digitale fixture: linker paneel native, rechter paneel 180° gedraaid in het paneelvlak, zodat de seam-side dataconnectoren van beide panelen aan de gedeelde naad liggen. Test aan de bovenrand.

Print de STL op 100% schaal. Verwijder alleen normale printbrim/support waar dat
geen mating-geometrie verandert. Schuur of ruim pasvlakken, geleiders, locators
of gaten niet op vóór de eerste test.

| # | Handeling | Verwacht |
| ---: | --- | --- |
| 1 | Plaats de coupler zonder schroeven op de top-edge seam met lichte handdruk. | De seam locator, guide wall, reinforcement locators en locator-pin clearance vinden hun positie zonder forceren. |
| 2 | Controleer de seating op beide rear mounting planes en langs de buitenrand. | De base ligt gelijkmatig; de exposed outer guide volgt de panelrand zonder rocking of klemmen. |
| 3 | Controleer expliciet de dataconnectoren en omliggende behuizing aan de seam. | De coupler raakt of belast de connectoren niet. |
| 4 | Controleer mounting-tube pockets en screw bores; steek beschikbare schroeven alleen los in. | Gaten starten vrij en schroeven hoeven de coupler niet in positie te trekken. |
| 5 | Neem de coupler weg en plaats hem drie keer opnieuw op dezelfde top-edge seam. | Dezelfde positie en seating zijn herhaalbaar. |
| 6 | Draai dezelfde printable coupler 180° om Y en controleer de overeenkomstige bottom-edge toepassing. | Dezelfde part past ook in de gedocumenteerde bottom-edge oriëntatie zonder nieuwe interferentie. |
| 7 | Maak een foto van de zittende top-edge test en noteer stress, rocking of haken. | Geen blocking issue; bewijs toont seam, buitenrand en connectorruimte. |

**Opmerking**

PF-02 gebruikt bewust de connector-zware seam als eerste fysieke case. Als die `investigate` oplevert, test dan niet automatisch een eenvoudiger seam als vervanging; leg eerst vast wat er botst.

**Registratie**

- Paneelsample(s): `...`
- Datum: `...`
- STL / Git blob: `horizontal-edge-coupler-medium.stl` / `839436b628a68485c66ee099b6ad7cdec9c23a34`
- Printer / materiaal / printprofiel: `...`
- Resultaat: `agrees` / `investigate` / `not checked`
- Waargenomen: `...`
- Bewijs (foto/link): `...`
- Vervolg: `...`
