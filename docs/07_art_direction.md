# 07 — Art Direction

## Zweck

Dieses Dokument definiert die visuelle Identität von Curio World: Stilanleitung, Farben, Charakterdesign, UI, Audio-Empfehlungen, Performance-Vorgaben für Assets. Es ist die verbindliche Referenz für alle visuellen Entscheidungen.

## Annahmen

- Zielgruppe ist 9–16; visuelle Sprache muss altersübergreifend funktionieren, ohne kindisch für die älteren Spieler:innen zu wirken.
- Anime-Cute / Chibi / stylisiert — keine realistische Proportion.
- Pastell- und Candy-Akzente auf gut lesbarer Basis.
- Kulturelle Bezirke feiern Eigenheiten, ohne Klischees zu reproduzieren.
- Performance-Budget ist nicht verhandelbar; stilisiert = optimierbar.
- Multi-Plattform (Mobile, Tablet, Desktop, Konsole) muss funktionieren.

## Quellen

- `roblox_ai_briefing.md` (Stilpfeiler)
- `06_world_bible.md` (Bezirks-Identitäten)
- Performance-Empfehlungen aus der Roblox-Creator-Community

## Stilpfeiler

1. **Anime-Cute als Grundton.** Charmant, freundlich, fantasievoll, energiegeladen.
2. **Klare Silhouetten.** Jeder Charakter und jedes Gebäude muss auf einen Blick erkennbar sein.
3. **Frische Farben.** Pastelle und Candy-Töne auf warmer Basis; keine dumpfen, dunklen Töne.
4. **Modular.** Bausteine, die in mehreren Kontexten wiederverwendet werden.
5. **Sammelwürdig.** Items und Pets sollen sich „sammeln lohnen" anfühlen.
6. **Performance-zuerst.** Stilisiert heißt auch: wenig Polygone, einfache Texturen, saubere Animationen.

## Charakterdesign

### Proportionen

- Kopf-zu-Körper-Verhältnis ~1:2,5 (Chibi-nahe, aber nicht übertrieben).
- Große Augen, klar lesbare Mimik.
- Sanfte Körperformen, keine sexualisierten Proportionen.
- Hände als vereinfachte „Paddel" mit klaren Griff-Gesten.

### Charakterbasen

- Drei Grundbasen mit jeweils 3–5 Höhenvarianten.
- Modularer Aufbau: Kopf, Torso, Beine, Accessoires.
- Haare als separates Mesh für einfaches Skinnen.

### Begleiter / Companions

- 8–12 Sammel-Companions, alle im gleichen Stilkanon.
- Beispiel: Hafen-Katze Sumi, Werkstatt-Roboter Piko, Bio-Dome-Igel Mochi, Stern-Eule Luma.
- Companions tragen keine spielmechanischen Vorteile, sondern sind kosmetisch und story-tragend.

## Farbpalette (Basis)

| Rolle | Farbe | Hex (Beispiel) | Verwendung |
|---|---|---|---|
| Primary Sky | Helles Pastellblau | #BDE3FF | Himmel, UI-Hintergründe |
| Primary Sun | Warmes Pastellgelb | #FFE6A1 | Highlights, Licht-Akzente |
| Accent Mint | Frisches Mintgrün | #B8F2D5 | Erfolgsmeldungen, „Geschafft!"-Effekte |
| Accent Coral | Fröhliches Korallenrot | #FF9A8B | Aktions-Buttons, Quest-Marker |
| Accent Lavender | Sanftes Lavendel | #D7BFFF | Magie, Story-Momente |
| Neutral Cloud | Helles Off-White | #F8F4EE | Hintergründe, Texturen |
| Neutral Slate | Gedämpftes Anthrazit | #2E3540 | Text, UI-Strukturen |

Bezirks-Akzente ergänzen die Palette:
- SkyBridge Bay: Sky-Blau + Golden Gate Coral
- Liberty Blocks: Mond-Silber + Subway Mint
- Neo Sakura: Sakura-Pink + Tech-Cyan
- Hamburg Harbor: Wasserblau + Werft-Orange
- Moon Bazaar: Laternen-Gelb + Gewürz-Rot

## Bezirks-Paletten (Kurz)

### SkyBridge Bay
- Himmelblau, Goldenes Coral, Nebelweiß, Möwen-Creme

### Liberty Blocks
- Mondsilber, Subway-Mint, Skyline-Lavendel

### Neo Sakura
- Sakura-Pink, Tech-Cyan, Neon-Coral, Tiefes Indigo

### Hamburg Harbor
- Wasserblau, Werft-Orange, Hafen-Beige, Laterne-Gelb

### Moon Bazaar
- Laternen-Gelb, Gewürz-Rot, Basar-Pfirsich, Tiefer Mitternachtsblau

## UI-Stil

### Formen

- Runde Ecken (Radius 8–12 px in 1080p-Ref).
- Kartenähnliche Panels mit weichen Schatten.
- Icons mit dicken Außenlinien (mind. 2 px) für Lesbarkeit.

### Typografie

- Primärschrift: eine runde, freundliche Sans (z. B. „Nunito", „Quicksand" oder vergleichbar mit guter Lesbarkeit für 9-Jährige).
- Sekundärschrift: gleiche Familie in einer zweiten Variante für Hervorhebungen.
- Lokalisierungs-Schriften müssen in allen 9 Sprachen kindlesbar sein (Audit in Phase 6).

### Sprache

- Maximal 5–7 Wörter pro UI-Zeile.
- Aktive Sprache, einfache Verben.
- Konsistente Begriffe für gleiche Funktionen.
- Niemals bewertende Sprache („falsch!" → „Versuch's nochmal").

### Icons

- Eindeutige, kontrastreiche Icons mit klarer Funktion.
- Farb-Codierung:
  - Blau: Info
  - Mint: Erfolg
  - Coral: Aktion
  - Lavendel: Story
  - Anthrazit: Neutral

## Audio-Stil

### Musik

- Themen pro Bezirk, alle im gleichen Stilkanon (freundlich, kindgerecht, abwechslungsreich).
- Hauptthema für Hub.
- Saisonale Themes, die das Haupthema variieren.
- Adaptive Layer: Musikintensität steigt mit Spieler-Aktivität, ohne aufdringlich zu werden.

### Soundeffekte

- Kurze, klare, freundliche SFX.
- Komponierte Tierstimmen (kein Originalton).
- UI-SFX in passendem, kindgerechtem Stil.
- Optionale Reduktion (SFX-Lautstärke und -Dichte regelbar).

### Vertonung

- NPCs voll vertont (kindgerechte Sprecher:innen) in 9 Sprachen.
- Texte immer auch verfügbar für Spieler:innen, die Audio nicht nutzen wollen/können.

## Performance-Vorgaben

| Kategorie | Max Polygone | Max Texturen | Max Draw Calls |
|---|---|---|---|
| Spieler:in (Basis) | 8.000 | 4 × 512² | n/a |
| NPC (Basis) | 6.000 | 4 × 512² | n/a |
| Companion | 4.000 | 2 × 256² | n/a |
| Prop (klein) | 1.500 | 1 × 256² | n/a |
| Prop (mittel) | 4.000 | 2 × 512² | n/a |
| Landmarke | 25.000 | 4 × 1024² | n/a |
| Umgebung gesamt pro Bezirk | 500.000 | 50 MB Texturen | siehe Budget pro Sicht |

Diese Budgets sind Zielwerte, die in Phase 2 mit echten Roblox-Messungen validiert werden.

## Modulare Asset-Strategie

### Modularer Baukasten

- Jeder Bezirk hat ein Set von Bausteinen:
  - Wände (gerade, Kurve, Ecke, T-Stück)
  - Dächer (flach, Spitz, Kuppel)
  - Fenster (3 Größen, 3 Zustände)
  - Türen (3 Größen, 2 Zustände)
  - Deko-Streifen, Geländer, Laternen, Schilder
- Bausteine werden per Snap-System kombiniert.

### Trim Sheets

- Pro Bezirk 1–2 Trim Sheets für Architektur.
- Reduziert Textur-Größe und Draw Calls drastisch.

### LOD-Stufen

- L0 (0–20 m): volle Detail.
- L1 (20–80 m): reduzierte Polygone, vereinfachte Texturen.
- L2 (>80 m): Silhouette + einfache Farbflächen.

## Animationsrichtlinien

- Sanfte, übertriebene Bewegungen (kindgerecht, lesbar).
- Emotes 2–4 Sekunden lang, mit klarer Pose.
- NPC-Animationen loopfähig.

## Risiken

- **Stildrift:** Mehrere Künstler:innen können den Stil brechen. Mitigation: Style-Guide mit Referenzbildern und Reviews.
- **Performance-Hit:** Zu hohe Polygon-Zahlen oder Textur-Größen gefährden Mobile-Spielbarkeit. Mitigation: Performance-Budgets, automatische Asset-Validierung.
- **Kulturelle Klischees:** Charakterdesigns könnten in Klischees kippen. Mitigation: Kulturberatung pro Bezirk.
- **Schrift-Hack:** Lokalisierte Schriften in 9 Sprachen können inkonsistent wirken. Mitigation: Schrift-Audit in Phase 6.

## Offene Fragen

- Welche konkrete Schriftart funktioniert in allen 9 Sprachen kindlesbar? (Audit Phase 6.)
- Welche Animationsbibliothek ist performant genug für Mobile? (Phase 3.)
- Wie balancieren wir Anime-Cute mit dem Wunsch der 14–16-Jährigen, nicht „zu kindlich" zu wirken? (Phase 2-3, mit User-Tests.)

## Nächste Schritte

1. Style-Guide PDF mit Farben, Formen, Beispielcharakteren erstellen.
2. Erstes Modular-Asset (z. B. Hafen-Tür) in Blender bauen und nach Roblox exportieren.
3. Schrift-Audit: 3 Kandidaten-Schriftarten pro Sprache testen.

## Änderungsverlauf

| Datum | Version | Änderung | Autor |
|---|---|---|---|
| 2026-06-27 | 0.1 | Initiale Art Direction | Mavis (Agent) |
| 2026-06-27 14:25 | 0.2 | Refit: alle 5 Bezirks-Paletten (SkyBridge Bay, Liberty Blocks, Neo Sakura, Hamburg Harbor, Moon Bazaar) ergänzt | Mavis (Agent) |
| 2026-06-27 14:50 | 0.3 | Refit: Wonder World → Curio World (Naming-Kollision mit existierendem Roblox-Pet-Game aufgedeckt) | Mavis (Agent) |
| 2026-06-27 14:25 | 0.2 | Refit: alle 5 Bezirks-Paletten (SkyBridge Bay, Liberty Blocks, Neo Sakura, Hamburg Harbor, Moon Bazaar) ergänzt | Mavis (Agent) |