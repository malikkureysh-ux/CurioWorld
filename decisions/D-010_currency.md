# D-010 — Währungsdesign: Gold + Gems + Robux (KEIN Stamina)

**Status:** entschieden (Validierung in Phase 5)
**Datum:** 2026-06-27 (v0.1), 2026-06-27 14:18 (v1.0 — Refit nach Draft-Konzepten)
**Owner:** Economy Lead

## Problem

Welche Währungen verwenden wir? Die Draft-Konzepte zeigen drei Währungen (Gold, Gems, Energy/Stamina) — diese müssen mit dem Anti-Frust-Prinzip und dem Compliance-Versprechen vereinbart werden.

## Options

### Option A — Gold + Gems + Robux, KEIN Stamina (gewählt)

- **Gold (Soft):** Hauptwährung, durch Gameplay verdient. Für Standard-Cosmetics, Deko, Foto-Filter.
- **Gems (Soft-Selten):** Seltenere Währung, durch besondere Aktivitäten (Quest-Abschluss, monatliche Events). Für Premium-Cosmetics, exklusive Companions, Saisonpass-Items.
- **Robux (Echtgeld-Premium):** Für VIP-Pass, exklusive Cosmetics, Companion-Slots, Foto-Filter.
- **KEIN Stamina / Energy:** Anti-Frust. Alle Aktivitäten sind unbegrenzt spielbar. Daily-Caps nur als Belohnungs-Boost (z.B. +50 % Gold-Bonus für die ersten 3 Quests pro Tag), nicht als Sperre.

### Option B — Spark + Robux (verworfen)

- Spark als einzige Soft-Währung.
- Funktioniert in 2-Slot-Modellen, **aber Draft-Konzepte zeigen 3-Währungs-HUD** → User-Vision ist 3 Slots.

### Option C — Drei-Währungs-Modell mit eigener Premium-Currency (verworfen)

- Eigene Premium-Currency (z.B. „Wonder-Coins") + Robux.
- Zusätzliche Compliance-Anforderungen und Spieler:innen-Verwirrung.
- Doppelt Zahlungsmittel ist auf Roblox unüblich.

### Option D — Drei-Währungen MIT Stamina (verworfen)

- Wie Draft gezeigt, aber Stamina beibehalten.
- **Verstößt gegen Anti-Frust-Prinzip** (Briefing-Pflicht): Keine künstlichen Wartezeiten für Kinder.

## Bewertungsmaßstab

- Konsistenz mit User-Vision
- Anti-Frust (keine Stamina)
- Compliance
- Spieler:innen-Erfahrung
- Wirtschafts-Balance

## Entscheidung

**Option A — Gold + Gems + Robux, KEIN Stamina.**

## Begründung

- **User-Vision:** Die Draft-HUDs zeigen drei Währungs-Slots. Das ist die Designentscheidung des Users; sie wird respektiert.
- **Anti-Frust:** Stamina (Energy 84/100, „Use Stamina"-Daily) ist in Draft 2 sichtbar. Das widerspricht dem Anti-Frust-Prinzip und dem Compliance-Versprechen. Lösung: **Stamina wird zu einem reinen Belohnungs-Boost**, kein Verbrauchs-Resource. Die Anzeige kann als „Daily-Bonus-Status" uminterpretiert werden (z.B. „Bonus-Slot 84/100 — nächste Quest gibt +20 % Gold").
- **Wirtschafts-Trennung:** Gold (Massen), Gems (selten, wertvoll), Robux (Echtgeld) — klare Trennung zwischen Free-Play und Premium.
- **Compliance:** Keine eigene Premium-Currency außer Robux → keine zusätzlichen Compliance-Anforderungen.
- **Anti-Shame:** Daily-Bonus ist ANONYMOUS (kein Ranking, keine öffentliche Anzeige).

## Erwartete Wirkung

- Klare 3-Stufen-Wirtschaft, die sich für Spieler:innen natürlich anfühlt.
- Anti-Frust: niemand muss warten.
- Conversion: Gems sind attraktiv genug für Casual-Käufe, Robux für VIP-Pass.
- Elternfreundlich: kein „Pay-to-skip-wait"-Modell.

## Währungs-Tabelle

| Währung | Typ | Quelle | Verwendung | Erhältlich via |
|---|---|---|---|---|
| **Gold** | Soft (Massen) | Quests, Events, Daily-Login | Standard-Cosmetics, Foto-Filter, Deko, Standard-Companion-Skins | Gameplay |
| **Gems** | Soft (Selten) | Hauptquests, Saison-Events, Freundschafts-Boni | Premium-Cosmetics, exklusive Companions, Saison-Items, Foto-Filter-Upgrades | Gameplay (langsam) |
| **Robux** | Echtgeld-Premium | Eltern kaufen | VIP-Pass, exklusive Cosmetics, Companion-Slots | Echtgeld |
| ~~Stamina~~ | — | — | — | **ENTFERNT — Anti-Frust-Prinzip** |

## Risiken

- **R-1:** Gems könnten als „Pay-to-skip" missinterpretiert werden, wenn sie für XP-Boosts einsetzbar wären.
  - Mitigation: Gems NUR für Kosmetik, Deko, Sammlerstücke — niemals für Gameplay-Boosts. Compliance-Audit prüft.
- **R-2:** 3-Währungs-Modell könnte jüngere Spieler:innen (9–11) verwirren.
  - Mitigation: HUD zeigt klar beschriftete Icons mit Hover-Tooltips; Tutorial erklärt jede Währung; erste 30 Minuten nur Gold.
- **R-3:** Gold-Inflation bei langfristigen Spieler:innen.
  - Mitigation: Sink-Mechaniken (Spenden, Deko-Upgrades, Cosmetics), Balance-Simulationen.
- **R-4:** Daily-Bonus-Status (ehem. Stamina-Slot) könnte als „Energy" missverstanden werden.
  - Mitigation: UI-Text ändert sich („Tages-Bonus" statt „Energy"), Icon ändert sich (Geschenk-Box statt Blitz), nie als Verbrauchs-Resource.

## Validierungsplan

| Phase | Aktion |
|---|---|
| Phase 2 | Marktanalyse: 3-Währungs-Modelle auf Roblox (Pet Simulator, Blox Fruits etc.) |
| Phase 4 | Spieler:innen-Befragung zur Währungs-Verständlichkeit (alle 3 Altersbänder) |
| Phase 5 | Wirtschafts-Simulation 30 Spieltage |
| Phase 5 | Compliance-Audit: Sind Gems kaufbar? Nein (Gameplay-only). |
| Phase 6 | Live-Konversion + Wirtschafts-Monitoring |

## Quellen

- `draft images/ChatGPT Image 27. Juni 2026, 13_48_25 (2).png` (HUD mit Gold/Gems/Energy)
- `draft images/ChatGPT Image 27. Juni 2026, 13_48_25 (3).png` (Daily-Tasks inkl. „Use Stamina")
- `roblox_ai_briefing.md` (Wirtschaft + Anti-Frust)
- `02_compliance_matrix.md` (C-019, Anti-Frust)

## Änderungsverlauf

| Datum | Version | Änderung | Autor |
|---|---|---|---|
| 2026-06-27 | 0.1 | Initial (Spark + Robux) | Mavis (Agent) |
| 2026-06-27 14:18 | 1.0 | Refit: Gold + Gems + Robux, Stamina entfernt (Anti-Frust) | Mavis (Agent) |