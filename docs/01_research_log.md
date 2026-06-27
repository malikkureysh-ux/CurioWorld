# 01 — Research Log

## Zweck

Dieses Dokument sammelt alle wesentlichen externen Recherchen, die Produktentscheidungen für Curio World begründen. Es ist die lebendige Wissensbasis und wird laufend gepflegt.

## Annahmen

- Roblox-Regeln und Sicherheitsdokumente haben Vorrang vor allgemeinen Blogquellen.
- Lernrecherche muss aus peer-reviewten Quellen oder anerkannten Institutionen stammen.
- Jede Designentscheidung, die sich auf eine Quelle stützt, muss die Quelle hier zitieren.

## Quellenstruktur

| Kategorie | Wo gesammelt | Wer pflegt |
|---|---|---|
| Roblox-Plattformregeln | `research/roblox/` | Compliance Lead |
| Lernforschung | `research/learning/` | Learning Architect |
| Markt & Wettbewerb | `research/market/` | Product Lead |
| Art & UX | `research/art/` | Art Director |
| Sicherheit & Jugendschutz | `research/safety/` | Safety Lead |

## Themenfelder

### T-01: Roblox Content Maturity & Altersfreigaben

**Relevanz:** Hoch. Bestimmt, wie das Spiel eingestuft wird und welche Zielgruppe zugänglich ist.

**Kernbefunde (Stand 2026):**
- Roblox verwendet Content-Maturity-Labels zur Einordnung von Experiences.
- Bestimmte Inhalte (Gewalt, Erwachsenenthemen, Glücksspiel-ähnliche Mechaniken) sind für jüngere Nutzer eingeschränkt oder unzulässig.
- Experiences können in ihrer Sichtbarkeit und Zugänglichkeit je nach Konfiguration eingeschränkt werden.

**Implikation für Design:**
- Curio World bleibt im familienfreundlichen Bereich.
- Keine simulierten Glücksspielmechaniken (Lootboxen mit kaufpflichtiger Währung, Wheel-of-Fortune mit Echtgeld).
- Voice-Chat und freier Text-Chat nur mit klarer Altersfreigabe und Moderation.

**Status:** Erste Orientierung dokumentiert; Detail-Recherche für Phase 2 notwendig.

**Verknüpfte Entscheidungen:** D-009 (Monetarisierungsgrenzen)

**Offene Fragen:**
- Wie genau funktionieren die aktuellen Maturity-Stufen technisch?
- Welche Assets/Animationen lösen eine Höherstufung aus?

---

### T-02: Roblox-Monetarisierung für Kinderprodukte

**Relevanz:** Hoch. Monetarisierung ist größte ethische Risikoquelle.

**Kernbefunde:**
- Roblox erlaubt verschiedene Monetarisierungsformen (Developer Products, Game Passes, Premium-Subscriptions, Private Servers).
- Kinderprodukte müssen zusätzliche Anforderungen erfüllen, insbesondere in Bezug auf Transparenz, elterliche Kontrolle und faire Mechaniken.
- Pay-to-Win in kompetitiver Form ist für jüngere Nutzer besonders problematisch.

**Implikation für Design:**
- Verkauf ausschließlich Kosmetik, Deko, Komfort, Sammlerstücke, Saisonpass-Inhalte.
- Klare Trennung: Wer nicht zahlt, hat vollen Zugriff auf Kerninhalt, Story und Progression.
- Eltern-Dashboard im Spiel: Kinder können Eltern zeigen, was sie kaufen wollen, bevor sie kaufen.

**Status:** Konzeptionell klar; Detail-Recherche zu Parental Controls in Phase 3.

**Verknüpfte Entscheidungen:** D-009, D-010 (Währungsdesign)

---

### T-03: Soziale Interaktion für jüngere Nutzer

**Relevanz:** Hoch. Bestimmt, wie wir Community bauen, ohne Risiken zu ignorieren.

**Kernbefunde:**
- Roblox hat zusätzliche Einschränkungen für bestimmte soziale Features bei jüngeren Nutzern (Chat-Settings, Voice-Chat-Verfügbarkeit, Erfahrungs-Zugang).
- Jugendschutz-Standards empfehlen strukturierte, beobachtbare Interaktion statt offener Kommunikation für Kinder.

**Implikation für Design:**
- Primäre soziale Sprache: Pings, Emotes, vorgegebene Phrasen, Kontextmarker.
- Teamquests mit klaren Rollen (Builder, Scout, Solver, Collector) statt freier Kooperation.
- Optionaler Freitext-Chat nur für Nutzer, die Roblox-Berechtigung haben und nicht in der Altersgruppe 9–11 sind.
- Elterninformation zur Aktivierung von Chat-Funktionen.

**Status:** Konzeptionell klar; Implementationsdetails in Phase 3.

**Verknüpfte Entscheidungen:** D-011 (Community-Schutz)

---

### T-04: Adaptive Schwierigkeit in Lernspielen

**Relevanz:** Sehr hoch. Kernpfeiler des Produkts.

**Kernbefunde (Auswahl):**
- Adaptive Lernspiele können Motivation und Lernerfolg verbessern, wenn Aufgaben zum Leistungsstand passen.
- Besonders wirksam: fein abgestufte Aufgaben, motivierendes Feedback, wiederholbare Spielbarkeit.
- Risiko: Überforderung bei zu schneller Steigerung; Unterforderung bei zu langsamer Anpassung.
- Für Kinder mit spezifischen Lernschwierigkeiten sind adaptive, nicht stigmatisierende Systeme mit individueller Anpassung empfohlen.

**Implikation für Design:**
- Diskretes Kompetenzmodell pro Lerndomäne (Mathe, Physik, Logik, …) basiert auf mehreren Signalen.
- Anpassung an Aufgabenkomplexität, Hilfetiefe, Tempo, Sprachniveau.
- Sichtbare Ergebnisse (Erfolg, Items), unsichtbare Anpassung (kein „Level 3.7" im UI).
- Anti-Shame: kein öffentliches Ranking der Lernleistung.

**Status:** Grundannahmen formuliert; konkrete Modell-Spec in `12_adaptive_difficulty_model.md`.

**Verknüpfte Entscheidungen:** D-005 (Adaptive Engine), D-006 (Anti-Shame)

---

### T-05: Gedächtnis, Retrieval Practice & Behalten

**Relevanz:** Hoch. Begründung für Memory-Design.

**Kernbefunde:**
- Aktives Abrufen verbessert das Behalten im Vergleich zu reinem Wiederlesen oder Wiedererkennen, auch bei Kindern.
- Mehrfaches Abrufen in verschiedenen Kontexten verstärkt den Lerneffekt.
- Räumliches Gedächtnis und Sequenz-Erinnerung sind bei Kindern trainierbar.

**Implikation für Design:**
- Hinweise tauchen in mehreren Missionen in veränderter Form wieder auf.
- Story-Artefakte müssen aktiv erinnert werden, um eine spätere Mission zu lösen.
- Recall Challenges in Sammelbüchern (nicht nur Checklisten).
- Teamaufgaben, in denen Informationen zwischen Spielern ergänzt werden müssen.

**Status:** Konzeptionell klar; Mechaniken-Katalog in `04_learning_architecture.md`.

**Verknüpfte Entscheidungen:** D-007 (Memory-Design)

---

### T-06: Projektbasiertes Lernen

**Relevanz:** Mittel-hoch. Begründung für Team-Bauquests.

**Kernbefunde:**
- Projektbasiertes Lernen unterstützt Planung, Eigenverantwortung, Zusammenarbeit und praxisnahe Anwendung.
- Strukturierte Rollenverteilung ist wirksamer als unstrukturierte Gruppenarbeit.

**Implikation für Design:**
- Community-Bauprojekte mit klaren Rollen, Materialplänen, Zeitfenstern.
- Globale Fortschrittsbalken, die sichtbar machen, was die Community zusammen erreicht hat.
- Nach Projektabschluss: sichtbares Bauwerk, das bestehen bleibt.

**Status:** Konzeptionell klar; Mechaniken-Spec in Phase 3.

---

### T-07: Blender-Pipeline für stylisierte Roblox-Assets

**Relevanz:** Hoch. Bestimmt Produktionsgeschwindigkeit und -kosten.

**Kernbefunde (Vorab-Recherche, Detail in Phase 2):**
- Roblox unterstützt `.fbx` und `.obj` für Mesh-Imports; Skripte via Luau.
- Empfehlung aus der Roblox-Creator-Community: stylisierte Low-/Mid-Poly-Assets mit klaren Silhouetten.
- Trim-Sheet-Strategien reduzieren Textur-Größe und Draw Calls.
- LOD (Level of Detail) ist Standard für Performance in Multiplayer-Umgebungen.

**Implikation für Design:**
- Modulares Baukastensystem für Bezirke.
- Trim Sheets pro Bezirk für Architektur und Props.
- LOD-Stufen L0 (Nah), L1 (Mittel), L2 (Fern).
- Performance-Budget pro Asset-Kategorie (Chars, Props, Bauwerke, VFX).

**Status:** Vorab-Notizen; vollständige Spec in `08_asset_pipeline_blender_to_roblox.md`.

**Verknüpfte Entscheidungen:** D-012 (Asset-Pipeline)

---

### T-08: Neurodivergenz-freundliche Spielgestaltung

**Relevanz:** Hoch. Pflichtbereich des Briefings.

**Kernbefunde:**
- Serious-Game-Forschung für Kinder mit spezifischen Lernschwierigkeiten empfiehlt adaptive Systeme mit individueller Anpassung.
- Wiederholbare Schleifen und flexible Zugänge sind wichtig.
- Vorhersagbare UI-Muster reduzieren kognitive Last.
- Reizreduktion-Optionen helfen bei sensorischer Empfindlichkeit.

**Implikation für Design:**
- Drei Reizprofile: Standard, Reduziert, Fokus-Modus.
- Vorhersagbare UI-Konventionen: gleiche Icons, gleiche Farben für gleiche Funktionen.
- Optionaler Fokus-Modus blendet Hintergrund-VFX aus.
- Wahl zwischen Solo-, Duo- und Gruppenformaten.

**Status:** Konzeptionell klar; Implementationsdetails in Phase 3.

**Verknüpfte Entscheidungen:** D-013 (Accessibility-Optionen)

---

### T-09: Markt- und Wettbewerbsscan

**Relevanz:** Mittel. Hilft bei Positionierung.

**Kernbefunde (Auswahl, vollständige Liste in Phase 2):**
- Adopt Me, Brookhaven, Blox Fruits: riesige Reichweite, aber andere Zielsetzung.
- Lernspiele auf Roblox (z. B. tycoon-Lern-Spiele): oft didaktisch, weniger adventure-getrieben.
- Internationale Lernspiele: meist mono-thematisch (Mathe-Olympiade, Vokabel-Trainer).

**Implikation für Design:**
- Differenzierung: Adventure-Wrapper um Multi-Domain-Lernen.
- Nicht mit Top-Spielen um Reichweite konkurrieren, sondern um Qualitätstreue.

**Status:** Skizzenhaft; vollständiger Scan in Phase 2.

---

### T-10: Mehrsprachigkeit & i18n

**Relevanz:** Hoch. Pflicht von Anfang an.

**Kernbefunde:**
- Roblox unterstützt mehrsprachige Experiences über LocalizationService.
- String-Externalisierung von Anfang an ist günstiger als späteres Refactoring.
- RTL-Sprachen (Arabisch) erfordern UI-Spiegelung und Schriftarten.

**Implikation für Design:**
- Alle Spieler-Texte extern in `.json`/`TranslationTable`-Format.
- Arabisch: UI-Spiegelung, Cairo- oder vergleichbare Schriftart.
- Schriften mit Kind-Lesbarkeit; vereinfachtes Chinesisch (zh-CN) und Japanisch (ja-JP) getrennt.
- Türkisch (TR) und Hindi (HI) als transliterations-fähige Texte mit lateinischen Schriften.

**Status:** Grundlagen dokumentiert; technische Spec in `09_system_architecture.md`.

**Verknüpfte Entscheidungen:** D-008 (Sprachstrategie)

---

## Pflegehinweise

- Jede neue Quelle wird hier mit Kategorie, Befund, Implikation und Status eingetragen.
- Veraltete Befunde werden markiert und mit Datum versehen.
- Verknüpfungen zu Entscheidungen (D-XXX) werden im Decision Log gepflegt.

## Offene Fragen

- Welche Roblox-spezifischen Tools für Parental-Reporting sind aktuell verfügbar?
- Welche Lernspiel-Titel werden aktuell am häufigsten auf Roblox gespielt? (Marktanalyse Phase 2.)
- Welche Schriftarten erfüllen Lesbarkeitsanforderungen für 9-Jährige in allen Zielsprachen?

## Risiken

- Veraltete Recherche: Roblox-Regeln können sich ändern; Recherche muss halbjährlich überprüft werden.
- Fehlinterpretation: Übersetzungen aus dem Englischen können kulturelle Nuancen verlieren.
- Bestätigungsfehler: Quellen, die unsere Lieblingshypothese stützen, werden überrepräsentiert.

## Nächste Schritte

1. Detail-Recherche zu Roblox Parental Controls (Phase 2).
2. Marktanalyse: Top 20 Lern-/Adventure-Spiele auf Roblox nach Region und Sprache.
3. Schriftart-Audit für Kind-Lesbarkeit in 9 Sprachen.
4. Adaptive-Engine-Literaturstudie vertiefen (Phase 2-3).

## Änderungsverlauf

| Datum | Version | Änderung | Autor |
|---|---|---|---|
| 2026-06-27 | 0.1 | Initialer Themenkatalog | Mavis (Agent) |
| 2026-06-27 14:25 | 0.2 | Refit: Curio World + 5-District-Plan + Gold/Gems/Robux (kein Stamina) + VIP-Komfort-Pass | Mavis (Agent) |
| 2026-06-27 14:50 | 0.3 | Refit: Wonder World → Curio World (Naming-Kollision mit existierendem Roblox-Pet-Game aufgedeckt) | Mavis (Agent) |
| 2026-06-27 | 0.1 | Initialer Themenkatalog | Mavis (Agent) |