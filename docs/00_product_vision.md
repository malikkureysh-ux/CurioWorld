# 00 — Product Vision

## Zweck

Dieses Dokument definiert die unveränderliche Produktvision von **Curio World** und dient als Referenzpunkt für jede Designentscheidung. Alle Game-, Lern-, Wirtschafts- und Sicherheitsentscheidungen müssen mit dieser Vision begründbar sein.

## Annahmen

- Das Produkt ist ein persistent spielbares Community-Adventure für Roblox.
- Die Zielgruppe ist 9–16 Jahre, mit drei Tiefenprofilen (9–11, 12–13, 14–16).
- Lernen wird unsichtbar in Spielmechaniken eingebettet, nie als Quiz oder Prüfung dargeboten.
- Monetarisierung ist ethisch, transparent und nicht pay-to-win.
- Die Plattform Roblox hat Vorrang vor Third-Party-Tools für Social, Chat und Monetarisierung.
- Die Welt ist eine vernetzte Mega-Stadt mit fünf Pflichtbezirken plus optionalen Erweiterungen.
- Multi-Language von Anfang an: DE, TR, EN, HI, ES, FR, ZH, JA, AR.

## Quellen

- `roblox_ai_briefing.md` (Auftraggeber-Briefing)
- Roblox Creator Documentation (Stand 2026)
- Lernforschung zu adaptiven Spielen und Retrieval Practice (siehe `01_research_log.md`)

## Vision Statement

> **Curio World** ist eine lebendige, freundliche Mega-Stadt, in der Kinder und Jugendliche zwischen 9 und 16 Jahren als junge City-Ranger, Erfinder und Kollektivbauer eine fantasievolle Welt aus fünf kulturell inspirierten Bezirken erkunden, reparieren, erweitern und beschützen — und dabei ganz nebenbei Mathematik, Physik, Chemie, Informatik, Logik, Sprache, Gedächtnis und Planungskompetenz aufbauen, ohne dass es sich je nach Schule anfühlt.

## Core Fantasy

Ich bin ein junger Ranger in einer Stadt voller Wunder. Ich erkenne Muster, die andere übersehen. Ich helfe Stadtbewohnern, deren Maschinen verrücktspielen, deren Brücken zerbrechen, deren Rätsel niemand lösen kann. Ich lerne dabei ständig dazu — nicht weil jemand mich prüft, sondern weil ich es brauche, um die nächste Tür zu öffnen, das nächste Festival vorzubereiten, den nächsten Freund zu beeindrucken. Und gemeinsam mit anderen baue ich diese Stadt Monat für Monat sichtbar weiter.

## Creative Pillars

1. **Spiel zuerst, Lernen unsichtbar.** Jede Mechanik muss zuerst Spaß machen. Wenn Lernen nicht in einer verspielten Geste versteckt werden kann, wird die Mechanik umformuliert.
2. **Wachstum ohne Schulgefühl.** Kompetenzaufbau durch Handeln, nicht durch Belehrung. Niemals Klassenzimmer-Ästhetik, Bewertungsangst oder Quiz-Symbolik.
3. **Adaptive Großzügigkeit.** Das Spiel passt sich leise an, nie offensichtlich. Spieler merken, dass Aufgaben passen, nicht dass sie gesteuert werden.
4. **Sichere Gemeinschaft.** Sozialer Kontakt entsteht durch gemeinsame Aufgaben, strukturierte Kooperation und sichere Kommunikation — nicht durch ungefilterte Chats.
5. **Faire Schönheit.** Monetarisierung verkauft Ausdruck, Komfort und Sammlerstücke — niemals unfaire Vorteile oder soziale Ausgrenzung.
6. **Vielfalt als Identität.** Die Bezirke feiern kulturelle Inspirationen ohne stereotyp zu werden. Spieler sollen sich überall wiederfinden können.

## Designprinzipien

| Prinzip | Bedeutung | Anti-Pattern |
|---|---|---|
| Spiel zuerst | Mechanik muss ohne Lernkontext schon Spaß machen | Quiz mit Story drumherum |
| Tun, nicht antworten | Spieler wenden Wissen an, statt Fragen zu beantworten | Multiple-Choice-Frage als Hindernis |
| Sichtbarer Fortschritt | Jede Session bringt etwas Konkretes (Item, Freischaltung, Baufortschritt) | Energie-Timer ohne Spielwert |
| Stille Adaptivität | Schwierigkeit passt sich ohne Hinweis an | „Wähle deinen Schwierigkeitsgrad" als Hauptmenüpunkt |
| Sichere Kommunikation | Pings, Emotes, vorgegebene Phrasen vor Freitext | Globaler Chat für 9-Jährige |
| Faire Schönheit | Nur Kosmetik, Komfort, Sammlerstücke im Shop | Power-Items für Echtgeld |

## Tone of Voice

- **Freundlich, nie bevormundend.** „Deine Stadt braucht dich" statt „Lerne jetzt".
- **Klar, nie herablassend.** Kurze Sätze, einfache Wörter, keine Doppeldeutigkeiten.
- **Warm, nie manipulativ.** Belohnungen werden angekündigt, nicht erzwungen.
- **Kulturell sensibel.** Inspiration wird gewürdigt, Klischees werden vermieden.

## Erfolgsdefinition (Phase 1 — Foundation)

**Diese Phase ist erfolgreich, wenn:**

- Alle 20 Pflichtdokumente liegen in `docs/` mit den Pflichtsektionen vor.
- Der Decision Log enthält mindestens 12 begründete Entscheidungen mit Querverweisen.
- Die fünf Pflichtbezirke sind mit Lernfokus, Mechanik und Art-Vibe dokumentiert.
- Das adaptive Modell hat ein erklärbares Schätzverfahren und klare Anpassungshebel.
- Die Compliance-Matrix deckt die wichtigsten Roblox-Regeln kindersicher ab.
- Hamburg Harbor ist als Vertical-Slice-Bezirk ausreichend detailliert, um in Phase 2 ein Prototyp zu starten.

**Diese Phase ist nicht erfolgreich, wenn:**

- Lücken in der Doku mit „später" markiert sind, ohne dass ein Owner und ein Termin existieren.
- Entscheidungen ohne Begründung im Decision Log stehen.
- Die Welt keine klare Hierarchie von Hub → Bezirk → Aktivität hat.

## Risiken

- **Scope-Creep:** Die Fülle an Bezirken, Fächern und Systemen kann das Team überlasten. Mitigation: Vertical Slice first, Expansion später.
- **Vision-Drift:** Im Verlauf der Entwicklung kann sich die Vision verwässern. Mitigation: Jede PR/Designänderung wird gegen die Creative Pillars geprüft.
- **Lern-Sichtbarkeit:** Der Drang, Lernfortschritt sichtbar zu machen, kann das Schulgefühl erzeugen. Mitigation: Keine Punktzahlen, Noten, Tests im Spiel. Lern-Companion sammelt nur interne Telemetrie.

## Offene Fragen

- Wie differenzieren wir die drei Altersbänder so, dass 14–16-Jährige nicht das Gefühl haben, ein „Kinder-Spiel" zu spielen? (Verantwortlich: Lead Designer; zu klären in Phase 2.)
- Welche Bezirke werden nach Hamburg Harbor (Vertical Slice) priorisiert? (Aktuelle Empfehlung: SkyBridge Bay als zweiter Slice in Phase 5, dann Neo Sakura, Liberty Blocks und Moon Bazaar in Wellen Phase 6.)
- Wie messen wir Lernerfolg außerhalb des Spiels, ohne in testähnliche Mechanik zu verfallen? (Verantwortlich: Learning Architect; Ziel: qualitative Eltern-/Lehrer-Reports in Phase 6.)
- Wie gestalten wir den Übergang von Hamburg-Harbor-Spieler:innen in die anderen 4 Bezirke, ohne dass Hub-Player als „Anfänger" erkennbar werden? (Verantwortlich: Community Lead; zu klären in Phase 2.)

## Nächste Schritte

1. Übergang in **Phase 2 — Konzeptarchitektur**: World Bible, Learning Architecture, Art Direction und Blender-Pipeline vertiefen.
2. Vertical Slice Hamburg Harbor: konkrete Missionsliste, Asset-Liste und System-Specs erstellen.
3. Erste Stakeholder-Reviews (Eltern, Lehrkräfte, junge Spieler) zur Validierung der Vision.

## Änderungsverlauf

| Datum | Version | Änderung | Autor |
|---|---|---|---|
| 2026-06-27 | 0.1 | Initialer Entwurf aus Briefing | Mavis (Agent) |
| 2026-06-27 14:18 | 0.2 | Refit auf Curio World + 5-District-Plan | Mavis (Agent) |
| 2026-06-27 14:50 | 0.3 | Refit: Wonder World → Curio World (Naming-Kollision mit existierendem Roblox-Pet-Game aufgedeckt) | Mavis (Agent) |
| 2026-06-27 14:18 | 0.2 | Refit auf Curio World + 5-District-Plan | Mavis (Agent) |