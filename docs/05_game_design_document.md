# 05 — Game Design Document

## Zweck

Dieses Dokument definiert das Game-Design von Curio World: Core Loop, sekundäre Loops, Progression, Missionstypen und Spielmechaniken. Es ist die spielmechanische Spezifikation; alle anderen Docs (Welt, Lernen, Wirtschaft, Tech) hängen hieran.

## Annahmen

- Das Spiel ist persistent spielbar; jede Session bringt sichtbaren Fortschritt.
- Sessions dauern typischerweise 15–45 Minuten; Loops sind so designt, dass sie in diesem Zeitraum befriedigend sind.
- Eine Session muss ohne „Bestrafung" beendet werden können — keine künstlichen Timeouts, keine Energie-Verluste.
- Das Spiel belohnt Vielfalt: gleicher Bezirk mehrfach mit anderen Mechaniken.
- Spielspaß hat Vorrang vor Lernabdeckung; wenn eine Mechanik keinen Spaß macht, wird sie umformuliert.

## Quellen

- `roblox_ai_briefing.md` (Genre-Mix, Loops)
- `00_product_vision.md` (Creative Pillars)
- `04_learning_architecture.md` (Lern-Mechaniken)

## Genre-Mix

- 3D Jump-and-Run (Kernbewegung)
- Adventure-Exploration
- Leichte Rätsel- und Systemsimulation
- Community-Metagame
- Sammel- und Progressionsspiel
- Saisonales LiveOps-Spiel
- Unsichtbar integriertes Lernspiel

## Core Fantasy

Ich bin ein junger Ranger, der eine lebendige Mega-Stadt erkundet, gemeinsam mit anderen Aufgaben löst, sichtbar zur Stadt beiträgt und dabei laufend dazulernt, ohne dass es wie Unterricht wirkt.

## Primärer Core Loop

1. **Erkunden.** Spieler:in betritt einen Bezirk oder den Hub.
2. **Parkour/Adventure-Route.** Bewältigung einer Strecke mit Sprüngen, Klettern, Rutschen, Gleiten.
3. **Mission entdecken.** Spieler:in findet einen NPC, ein Objekt, ein Rätsel oder ein Event.
4. **Eingebettetes Lernproblem lösen.** Aufgabe in Form von Sortieren, Bauen, Programmieren, Erinnern.
5. **Belohnung erhalten.** Materialien, Blaupausen, Story-Fortschritt, kosmetische Items.
6. **Zurückkehren.** Hub oder anderes Projekt.
7. **Freischalten.** Neue Bezirke, Aufgaben, Deko, Companions, Bauoptionen.

Dieser Loop dauert im Optimalfall 8–15 Minuten und schließt mit einer sichtbaren Belohnung.

## Sekundäre Loops

- **Tägliche Micro-Quests.** 3 kleine Aufgaben pro Tag, je 2–5 Minuten, abwechslungsreich über Bezirke.
- **Wöchentliche Community-Ziele.** Globale Fortschrittsbalken, an denen alle Spieler:innen beitragen.
- **Saisonale Festivals.** Mehrwöchige Events mit eigener Stadtteil-Deko, thematischen Missionen und limitierten Sammlerstücken.
- **Bezirks-Ränge.** Jeder Bezirk hat 10–15 Ränge, die durch Bezirks-spezifische Aufgaben steigen.
- **Meisterschaften.** Wenn ein Bezirks-Rang voll ist, schaltet sich ein „Meistertitel" frei, der kosmetisch sichtbar ist.
- **Housing.** Persönliches Studio oder Wohnung, die dekoriert und Freunden gezeigt werden kann.
- **Companion-Entwicklung.** NPCs/Pets, die sammelbar sind und durch Interaktion „wachsen" (kosmetisch).
- **Sammelalben.** Sticker, Erinnerungen, Rezepte — mit aktiven Recall Challenges.

## Progression

### Charakter-Level

- Charakter-Level steigt durch alle Aktivitäten, die XP geben.
- Level-Up schaltet: mehr Inventar-Slots, mehr Deko-Slots im Housing, neue Emotes.
- Keine Vorteile für höhere Level im Gameplay-Balancing — alle Spieler:innen bleiben konkurrenzfähig.

### Bezirks-Ränge

- Pro Bezirk 10–15 Ränge, geknüpft an Bezirks-spezifische Aufgaben.
- Rangaufstieg schaltet: Bezirks-Deko, exklusive NPCs, neue Bezirks-Areale.

### Story-Fortschritt

- Story ist episodisch: jeder Bezirk hat 3–5 Story-Kapitel.
- Story ist Hauptmotor für Erkundung, aber nicht alleiniger Antrieb.

### Sammel- und Rezeptbücher

- Rezepte, Baupläne, Erinnerungs-Sticker.
- Vollständige Alben schalten kosmetische Belohnungen frei.

## Missionstypen

### Solo-Missionen (8–15 Min)

- Erkundung eines Pfades, Rätsel am Ende, Boss-Hindernis (kein Kampf, eher ein Bewegungs- oder Logik-Test).
- Beispiel: Hafen-Turm — klettere hoch, löse Ventil-Puzzle, schalte Dach-Deko frei.

### Duo-Missionen (10–20 Min)

- Zwei Rollen mit komplementären Aufgaben.
- Beispiel: Brückenwartung — eine Person steuert Kran, andere navigiert Last.

### Team-Missionen (15–30 Min)

- 3–5 Spieler:innen mit Rollen (Builder, Scout, Solver, Collector, optional Coordinator).
- Beispiel: Festmaschine-Bau — sammelt Material, baut Maschine, justiert Schaltungen.

### Wiederholbare Mini-Spiele (3–8 Min)

- Schnelle Runs für Materialien und tägliche Quests.
- Beispiel: Memory-Lauf durch den Hafen.

### Erkundungs-Missionen (offen)

- Spieler:in findet Geheimnisse auf eigene Faust; jede Entdeckung wird im Sammelbuch vermerkt.
- Beispiel: Versteckte Graffiti-Serie, die zu einem NPC-Dialog führt.

### Community-Events (live)

- Mehrstündige oder mehrtägige globale Events mit gemeinsamem Ziel.
- Beispiel: Alle Spieler:innen gemeinsam bauen eine Brücke über den Hafen.

## Spielmechaniken-Überblick

### Bewegung

- Laufen, Springen, Doppelsprung, Rutschen, Klettern, Gleiten.
- Bezirks-spezifische Bewegungsstile (Hafen: Schwingen mit Kranen; SkyBridge: Kabelbahn-Gleiten; Neo Sakura: Wandlauf an Gebäuden).

### Interaktion

- Kontextsensitive Aktion (Taste E).
- Pings und Emotes statt ständiger Texteingabe.
- NPC-Dialoge: vollständig vertont oder textbasiert mit Optionen; beide vollständig lokalisiert.

### Rätsel-Mechaniken

- Sortier-Puzzles (Mathematik, Logik).
- Bau-/Steuer-Puzzles (Physik, Informatik).
- Erinnerungs-Puzzles (Gedächtnis).
- Reihenfolge-Puzzles (Sprache, Planen).

### Bau-Mechaniken

- Dekoration im Housing mit Item-Snap-System.
- Community-Bauquests mit gemeinsamem Materialkonto.

### Sammel-Mechaniken

- Sammelitems in der Welt (mit Funkel-Effekt, klar sichtbar).
- Rezepte, Baupläne, Sticker.
- Companion-Karten (alle Companions im Spiel bekannt, nur gefundene sichtbar).

### Soziale Mechaniken

- Pingsystem mit Emote-Kategorien.
- Vorgegebene Phrasen („Hilfe!", „Geschafft!", „Gut gemacht!").
- Teamquests mit Rollen-Broadcast.
- Housing-Einladungen (1:1 oder kleines Team).

## Spielersozialisation

- Erste 10 Minuten: Tutorial mit klaren Aufgaben und einer ersten Belohnung.
- Nach 30 Minuten: erste Duo-Mission freigeschaltet.
- Nach 60 Minuten: erste Bezirks-Story abgeschlossen.
- Nach 1 Tag: tägliche Quests verfügbar.
- Nach 1 Woche: erste Community-Quest aktiv.
- Nach 1 Monat: vollständiges Spielrepertoire freigeschaltet (Bezirke, Sammelbücher, alle Core-Mechaniken).

## Schwierigkeitskurve

- Woche 1: einfache Aufgaben, viel Hilfe, viel Belohnung.
- Woche 2–4: mittelschwere Aufgaben, weniger Hilfe, neue Bezirke.
- Monat 2+: kombinierte Aufgaben, Team-Mechaniken, Optimierungsspielraum.

Adaptive Engine (`12_adaptive_difficulty_model.md`) justiert innerhalb dieser Kurve basierend auf individueller Leistung.

## Risiken

- **Loop-Ermüdung:** Spieler:innen könnten süchtig werden. Mitigation: klare Session-Indikatoren, Empfehlungen für Pausen, keine künstlichen Timeouts.
- **Onboarding-Overload:** Erste 10 Minuten müssen tragen. Mitigation: minimaler Erstkontakt, erstes Erfolgserlebnis in 90 Sekunden.
- **Solo-zwang:** Manche Spieler:innen wollen nicht kooperieren. Mitigation: Solo-Äquivalente für alle Hauptmissionen (ggf. mit reduzierter Belohnung).

## Offene Fragen

- Welche Belohnungs-Pacing-Dichte ist optimal? (Phase 3: Telemetrie-getestet.)
- Wie balancieren wir Solo/Duo/Team ohne unfaire Vorteile? (Phase 3.)
- Welche Erinnerungs-Recall-Challenges funktionieren in der Praxis? (Phase 2-3: Tests.)

## Nächste Schritte

1. Mission-by-Mission-Skript für Vertical Slice Hamburg Harbor erstellen.
2. Belohnungs-Tabellen mit XP, Materialien, Story-Schritten entwerfen.
3. Onboarding-Skript in 9 Sprachen.
4. Telemetrie-Events pro Mission definieren (in `14_telemetry_plan.md`).

## Änderungsverlauf

| Datum | Version | Änderung | Autor |
|---|---|---|---|
| 2026-06-27 | 0.1 | Initiales GDD aus Briefing | Mavis (Agent) |
| 2026-06-27 14:25 | 0.2 | Refit: Curio World + 5-District-Plan + Gold/Gems/Robux (kein Stamina) + VIP-Komfort-Pass | Mavis (Agent) |
| 2026-06-27 14:50 | 0.3 | Refit: Wonder World → Curio World (Naming-Kollision mit existierendem Roblox-Pet-Game aufgedeckt) | Mavis (Agent) |
| 2026-06-27 | 0.1 | Initiales GDD aus Briefing | Mavis (Agent) |