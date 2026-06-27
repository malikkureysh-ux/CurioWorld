# Curio World — Projekt-Index

## Was ist das?

Vollständige Design-, Forschungs- und Produktdokumentation für **Curio World** — ein Roblox-Community-Adventure für Kinder und Jugendliche von 9–16 Jahren mit unsichtbar integriertem Lernen, adaptiver Schwierigkeit, fairer Monetarisierung (Kosmetik-only + VIP-Komfort-Pass), Anime-Cute Art Direction und 5 einzigartigen Districts rund um den Globus.

## Working Title & Codename

- **Produktname:** Curio World
- **Codename:** CW
- **Vertical-Slice-Bezirk:** Hamburg Harbor (Hamburg-inspiriert)
- **Vollplan-Districts:** SkyBridge Bay (San Francisco), Liberty Blocks (New York), Neo Sakura (Tokyo), Hamburg Harbor (Hamburg), Moon Bazaar (Istanbul)
- **Zielplattform:** Roblox
- **Asset-Pipeline:** Blender → Roblox Studio (FBX)

## Verzeichnisstruktur

```
.
├── roblox_ai_briefing.md          # Ursprüngliches Briefing (Input)
├── README.md                       # Diese Datei
├── PROGRESS_SNAPSHOT.md            # Live-Status des Projekts
├── docs/                           # 20 Pflichtdokumente (00–19)
├── decisions/                      # 15 Decision-Detail-Dateien
├── draft images/                   # 10 User-Konzeptbilder (Juni 2026)
├── research/
│   └── phase_2_market_analysis_2026-06-27.md  # Naming-Konflikt + Marktanalyse
└── roblox-studio/                  # Produktions-Skeleton mit 15 Modulen
    ├── README.md
    ├── default.project.json        # Rojo-Konfiguration
    ├── src/                        # Server/Client/Shared Luau-Code
    └── assets/
        ├── blender-scripts/        # Pipeline-Skripte
        ├── fbx/                    # Quell-FBX aus Blender
        └── exports/                # Finale Roblox-Assets
```

## Dokumentationsstandard

Jedes Dokument in `docs/` enthält die Pflichtsektionen:
- **Zweck**
- **Annahmen**
- **Quellen**
- **Entscheidungen**
- **Offene Fragen**
- **Risiken**
- **Nächste Schritte**
- **Änderungsverlauf**

## Sprachen

Das Produkt wird von Anfang an in folgenden Sprachen ausgeliefert:
DE, TR, EN, HI, ES, FR, ZH, JA, AR.

Die i18n-Strategie ist in `09_system_architecture.md` und `17_decision_log.md` (siehe D-008) dokumentiert.

## Wirtschaft (Kurzfassung)

- **Gold (Soft-Massen)** — durch Gameplay
- **Gems (Soft-Selten)** — durch besondere Aktivitäten
- **Robux (Echtgeld-Premium)** — VIP-Pass, exklusive Cosmetics
- **KEIN Stamina** (Anti-Frust, Compliance)

Volldetails in `decisions/D-010_currency.md`.

## Aktueller Status

- **Phase:** 2 — Konzeptarchitektur (Marktanalyse abgeschlossen, Refit auf Curio World)
- **Vertical Slice:** Hamburg Harbor
- **Stand:** 2026-06-27 14:50 (Refit auf Curio World abgeschlossen)

## So liest du dieses Projekt

1. Starte mit `docs/00_product_vision.md` für den Überblick.
2. `docs/17_decision_log.md` zeigt alle wichtigen Entscheidungen mit Verweis auf Detail-Dateien.
3. `docs/06_world_bible.md` beschreibt alle 5 Districts; Hamburg Harbor ist am ausführlichsten dokumentiert.
4. `docs/16_risk_register.md` zeigt die größten aktuellen Risiken.
5. `research/phase_2_market_analysis_2026-06-27.md` enthält die Naming-Collision-Analyse (warum nicht „Wonder World").

## Naming-Geschichte (Audit Trail)

| Datum | Name | Status | Grund |
|---|---|---|---|
| 2026-06-27 v0.1 | MetroMinds Adventures | verworfen | User-Drafts trugen anderen Namen |
| 2026-06-27 14:18 v1.0 | Wonder World | verworfen | Naming-Kollision mit existierendem Roblox-Pet-Game |
| **2026-06-27 14:50 v2.0** | **Curio World** | **aktiv** | Kein Roblox-Konflikt, passt zur Vision, kurz + mehrsprachig |

Detaillierte Begründung in `decisions/D-001_naming.md`.