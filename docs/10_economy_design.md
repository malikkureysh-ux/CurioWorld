# 10 — Economy Design

## Zweck

Dieses Dokument definiert die vollständige Wirtschaftsarchitektur von Curio World: Währungen, Quellen, Senken, Preise, Monetarisierung, LiveOps-Angebote und Eltern-Transparenz. Es ist verbindliche Grundlage für alle Verkaufs-, Belohnungs- und Wirtschaftsentscheidungen.

## Annahmen

- Monetarisierung ist erlaubt, muss aber ethisch, transparent und nicht pay-to-win sein.
- Nur Kosmetik, Komfort, Sammlerstücke, Saisonpass-Inhalte, Komfort und eventbasierte Tickets sind verkaufbar.
- Wer nicht zahlt, hat vollen Zugriff auf Kerninhalt, Story und Progression.
- Kinderprodukte erfordern besondere Sorgfalt bei Werbung, Verkaufsdruck und elterlicher Kontrolle.
- Eltern müssen klar verstehen können, was ihr Kind kauft.

## Quellen

- `roblox_ai_briefing.md` (Monetarisierungs-Auftrag)
- `02_compliance_matrix.md` (Compliance C-002, C-003, C-007, C-015, C-017, C-019)
- Roblox Developer Marketplace (Stand 2026)

## Währungen

### Soft-Currency: **Gold**

**Quelle:** Quest-Belohnungen, Erkundung, tägliche Quests, Events.
**Verwendung:** Materialien kaufen, Bau-Komponenten, einfache Deko, Wiederholungs-Kosten.
**Obergrenzen:** keine harte Obergrenze; Inflation wird über Sink-Mechaniken kontrolliert.

### Seltene Soft-Currency: **Gems**

**Quelle:** Hauptquests (seltene Drops), Saison-Events, Freundschafts-Boni, monatliche Login-Strecken.
**Verwendung:** Premium-Cosmetics, exklusive Companions, Saisonpass-Items, Foto-Filter-Upgrades, Companion-Charakter-Upgrades (rein kosmetisch).
**Niemals:** für Gameplay-Boosts, XP-Boosts, Stamina-Refill oder Story-Skip.
**Obergrenzen:** weiche Obergrenze (max 999 Gems pro Account), Inflation über Sink-Mechaniken (Gems ausgegeben für Premium-Cosmetics).

### Tages-Bonus-Status (ehem. „Stamina"-Slot im HUD)

**Quelle:** Automatischer Tages-Fortschritt, füllt sich beim Spielen.
**Wirkung:** **KEIN Verbrauchs-Resource.** Der Slot zeigt einen Belohnungs-Boost (z.B. „+20 % Gold auf nächste Quest"). Nach 3 verbrauchten Boosts pro Tag füllt er sich über die übliche Spielzeit langsam wieder auf.
**Warum kein Stamina:** Anti-Frust-Prinzip (Briefing-Pflicht). Niemand muss warten, um spielen zu können.
**UI:** Icon ist eine Geschenk-Box (kein Blitz), Text „Tages-Bonus" (nicht „Energy").

### Materialien (ressourcenbasiert, keine Währung)

Holz, Stoff, Metall, Glas, Leuchtstoff, Stoff-Spezial.
**Quelle:** Erkundung, Quests, Events.
**Verwendung:** Bauquests, Housing-Deko, Item-Crafting.

### Premium-Currency: **Robux (Roblox-Plattformwährung)**

Wir führen keine eigene Premium-Currency ein; wir nutzen Robux direkt.
**Verwendung:** VIP-Pass, Kosmetik-Skins, Game Passes, saisonale Pässe, Deko-Sets, Companion-Skins.

### VIP-Komfort-Pass (monatlich, Robux)

**Was es bringt (alles KOSMETISCH + KOMFORT, kein Gameplay-Vorteil):**
- +1 Companion-Slot (Standard: 2, VIP: 3).
- 1 tägliche kosmetische Gratis-Lootbox.
- +8 VIP-exklusive Foto-Filter.
- 1 Woche früher Zugang zu neuen Cosmetics.
- VIP-exklusive Farb-Varianten des Charakters (4 Stück).
- 12 Outfit-Slots statt 5.

**Was es NICHT bringt (explizit verboten):**
- Keine XP- oder Gold-Boosts.
- Keine Gameplay-Vorteile.
- Keine Energy/Stamina-Refill (die gibt's auch nicht zu kaufen).
- Keine Story- oder Lernaufgaben-Skip.

**Compliance-Audit:** Alle VIP-Vorteile werden in einer separaten Modul geprüft, kein Code-Pfad darf unbeabsichtigt Gameplay-Vorteile bieten.

### Event-Tickets: **Heart-Back**

**Quelle:** Tägliche Quests, Login-Boni, Events.
**Verwendung:** Limitierte Event-Items. Tickets verfallen am Saisonende, um Horten zu verhindern.
**Kauf mit Robux:** Optional, nur wenn Kerninhalt auch ohne Kauf erreichbar ist.

## Verkaufbare Kategorien (erlaubt)

| Kategorie | Beispiele | Währung |
|---|---|---|
| Kosmetische Skins | Outfits, Haare, Accessoires, Emotes | Robux |
| Bezirks-Deko | Spezielle Fassaden, Laternen, Banner | Robux |
| Housing-Deko | Möbel, Tapeten, Böden, Beleuchtung | Robux |
| Companion-Skins | Alternative Farben/Muster für Companions | Robux |
| Saisonpass | Mehrere kosmetische Stufen pro Saison | Robux |
| Komfort | Zusätzliche Inventar-Slots, Deko-Speicher | Robux |
| Event-Tickets | Optionale Tickets für Event-Inhalte | Robux |

## Nicht-verkaufbare Kategorien (verboten)

- Spielmechanische Vorteile (Power-Ups, schnellere Bewegung, stärkere Werkzeuge).
- Echtgeld-Wheel-of-Fortune oder Lootboxen mit Echtgeld-Komponente.
- Energie-Booster oder andere Frust-Bremsen.
- Direktes Überspringen von Story-Inhalten.
- Direktes Überspringen von Lernaufgaben (würde Lernarchitektur aushebeln).
- Soziale Ausgrenzung („nur mit Pass einladen").

## Belohnungsquellen (Sink-Prävention)

Wir stellen sicher, dass Gold und Materialien kontinuierlich verwendet werden:

| Mechanik | Verbrauch |
|---|---|
| Bauquests | Materialien für gemeinsame Bauwerke |
| Housing-Deko | Gold und Materialien |
| Item-Crafting (Deko, Sammlerstücke) | Gold + Materialien |
| Event-Spezial-Belohnungen | Tickets |
| Item-Aufrüstungen (rein kosmetisch) | Gold |

## Saisonpass-Struktur

### Beispiel-Saison (8 Wochen)

| Stufe | Belohnung | Erreichbar durch |
|---|---|---|
| 1 (kostenlos) | Deko-Banner | 100 XP |
| 2 (kostenlos) | Avatar-Skin (Basis) | 300 XP |
| 3 (Pass) | Avatar-Skin (Erweitert) | 600 XP |
| 4 (kostenlos) | Material-Paket | 1.000 XP |
| 5 (Pass) | Companion-Skin | 1.500 XP |
| … | … | … |
| 20 (Pass) | Legendary Skin + 500 Gold | 20.000 XP |

**Regeln:**
- Jede Saison hat mindestens 5 kostenlose Stufen.
- Kerninhalt der Saison ist auch ohne Pass erreichbar.
- Pass-Belohnungen sind kosmetisch.
- Saisonpass zeigt verbleibende XP, nie „verbleibende Stunden" (gegen Druckmechanik).

## Preis-Architektur (Vorschlag, final in Phase 5)

| Produkt | Robux (Vorschlag) | Kategorie |
|---|---|---|
| Avatar-Skin (Standard) | 75–150 | Kosmetik |
| Avatar-Skin (Erweitert) | 150–350 | Kosmetik |
| Companion-Skin | 100–200 | Kosmetik |
| Emote-Pack | 50–150 | Kosmetik |
| Deko-Set (Bezirk) | 150–400 | Kosmetik |
| Möbel-Set (Housing) | 200–500 | Kosmetik |
| Saisonpass | 400–600 | Kosmetik |
| **VIP-Komfort-Pass (monatlich)** | **300–450** | **Komfort (kein Gameplay-Vorteil)** |
| Komfort-Pack (Slots) | 100–300 | Komfort |
| Event-Ticket (optional) | 50–150 | Event |

Die endgültigen Preise werden in Phase 5 mit Marktanalyse finalisiert.

## Eltern-Transparenz

### In-Game-Anzeige „Was kostet das?"

Vor jedem Kauf zeigt das Spiel:
- Produktname und Bild.
- Preis in Robux.
- Welche Vorteile es bringt (rein kosmetisch/komfort/sammlerisch).
- Klarer Hinweis: „Du kannst das gleiche Erlebnis auch ohne diesen Kauf haben."

### Elterninformation im About-Bereich

- Übersicht der Monetarisierungs-Kategorien.
- Empfehlung, Roblox Parental Controls zu nutzen.
- Hinweis auf Robux-Limits für jüngere Spieler:innen.
- E-Mail-Kontakt für Elternfragen.

### Kauf-Schutz für jüngere Spieler:innen

- 9–11: Jeder Kauf erfordert Eltern-PIN-Eingabe über Roblox-Parental-Control-Flow.
- 12–13: Käufe nur mit aktivierter Roblox-Berechtigung.
- 14–16: Standard-Roblox-Kauf-Flow.

### Wöchentlicher Eltern-Report (optional)

- Welche Items das Kind in der Woche gekauft hat.
- Welche Items es betrachtet, aber nicht gekauft hat.
- Welche Aktivitäten im Vordergrund standen (ohne Bewertung).

## LiveOps-Angebotskalender

### Saisonale Zyklen

- 8-Wochen-Saisons, 6 pro Jahr.
- Saisonale Themes kulturell sensibel (kein Ausbeuten religiöser/kultureller Feste).
- Saisonale Items werden nach Saisonende als „klassisch" markiert und bleiben im Inventar.

### Wochen-Rotation

- Montag: neuer Mini-Event (Bezirks-spezifisch).
- Mittwoch: Sale auf bestimmte Kategorie (maximal 30 %, klar ausgewiesen).
- Freitag: Doppel-XP-Event (Quests).
- Sonntag: Community-Ziel-Belohnung.

### Monats-Highlight

- Erster Donnerstag im Monat: „Bezirks-Tag" — spezielles Event im Bezirk des Monats.

## Anti-Manipulations-Regeln

- Keine künstliche Verknappung („nur noch 2 Stunden!").
- Keine Frust-Käufe („überspringe Wartezeit").
- Keine Lootboxen mit Echtgeld.
- Käufe sind immer optional und transparent.

## Anti-Pattern-Checkliste (für Wirtschaftsentscheidungen)

| Frage | Wenn ja, dann redesign |
|---|---|
| Erzeugt dieser Kauf einen unfaires Gameplay-Vorteil? | Ja → redesign |
| Können Kinder ohne diesen Kauf Story/Lernen erleben? | Nein → redesign |
| Ist der Preis für jüngere Spieler:innen verständlich? | Nein → redesign |
| Erzeugt der Kauf sozialen Druck? | Ja → redesign |
| Gibt es eine elterliche Kontrollmöglichkeit? | Nein → redesign |
| Ist die Anzeige des Preises klar und ehrlich? | Nein → redesign |

## Sink-Mechaniken (Inflation-Schutz)

| Mechanik | Wirkung |
|---|---|
| Saisonpass-Expiry | Gold wird in Tickets umgewandelt, wenn nicht genutzt |
| Materialverbrauch bei Bauquests | Materialien werden verbraucht, nicht nur gesammelt |
| Item-Upgrade-Kosten (rein kosmetisch) | Gold-Verbrauch für kosmetische Verbesserungen |
| Event-Item-Expiry | Saisonale Items werden „klassisch" markiert, neue Items brauchen neue Aktivität |

## Risiken

- **Kinderkauf-Druck:** Eltern könnten sich durch Käufe unter Druck gesetzt fühlen. Mitigation: klare Kommunikation, Empfehlungen für Roblox Parental Controls.
- **Pay-to-Win-Vorwurf:** Auch kosmetische Käufe können als unfaire Vorteile empfunden werden (z. B. seltene Skins). Mitigation: klare Kommunikation, dass Skins keinen Vorteil bringen.
- **Regulatorische Änderungen:** Roblox- und nationale Regeln können sich ändern. Mitigation: Compliance-Matrix und Review.
- **Inflationsdruck:** Wenn Gold zu leicht verdient wird, verlieren Preise an Wert. Mitigation: Sink-Mechaniken.

## Offene Fragen

- Welche finalen Robux-Preise sind marktgerecht? (Phase 5 Marktanalyse.)
- Wie genau funktioniert die Roblox Parental Control API für Eltern-PIN? (Phase 2.)
- Welche saisonalen Themes sind kulturell sensibel und attraktiv? (Phase 5.)

## Nächste Schritte

1. Detail-Preise mit Marktanalyse validieren.
2. Eltern-Informations-Bereich im Spiel skizzieren.
3. Saisonpass-Builder-Spec für Phase 3.
4. Wirtschafts-Balance-Simulation für die ersten 30 Spieltage.

## Änderungsverlauf

| Datum | Version | Änderung | Autor |
|---|---|---|---|
| 2026-06-27 | 0.1 | Initiales Wirtschaftsdesign | Mavis (Agent) |
| 2026-06-27 14:25 | 0.2 | Refit: Gold (Massen) + Gems (selten) + Robux, KEIN Stamina (Anti-Frust), VIP-Komfort-Pass hinzugefügt | Mavis (Agent) |
| 2026-06-27 14:50 | 0.3 | Refit: Wonder World → Curio World (Naming-Kollision mit existierendem Roblox-Pet-Game aufgedeckt) | Mavis (Agent) |
| 2026-06-27 14:25 | 0.2 | Refit: Gold (Massen) + Gems (selten) + Robux, KEIN Stamina (Anti-Frust), VIP-Komfort-Pass hinzugefügt | Mavis (Agent) |