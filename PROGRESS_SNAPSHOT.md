## Goal
- Bring Curio World to production-ready Roblox game with full autonomy, multi-agent support, 5-min heartbeat, status updates.

## Critical Issue — Naming Collision (MUSS VOR LAUNCH GELÖST WERDEN)

**„Curio World!" existiert bereits auf Roblox:**
- URL: https://www.roblox.com/games/99742364063199/Wonder-World
- Genre: Pet-Raising (ähnlich Adopt Me)
- Status: aktiv, laufende Events (KOALA EVENT), Premium Eggs

**Was das bedeutet:**
- Roblox-Suche priorisiert etablierte Titel → Spieler:innen finden das Pet-Game statt unseres.
- Thematische Verwechslungsgefahr mit Adopt Me + Curio World.
- Marketing-Kommunikation muss differenzieren.

**Optionen für Sub-Title:**
1. Curio World Adventures
2. Curio World Hub
3. Curio World: 5 Cities
4. Curio World: City Rangers
5. Curio World: Beyond the Sky

## Progress
### Done
- 20 Docs refitted auf Curio World + 5-District-Plan + Gold/Gems/Robux (kein Stamina) + VIP-Pass
- 15 Decisions refitted (D-001/002/004/010 detail-files neu geschrieben)
- 15 Lua-Module (M-01 bis M-15) im roblox-studio/-Skeleton
- EconomyService aktiv mit Compliance-Audit (kein Pay-to-Win)
- Localization (DE+EN) aktiv
- SaveService, TelemetryService aktiv
- Blender-Pipeline: export_kran.py für Hamburg-Harbor-Kran
- Phase 2 Marktanalyse: research/phase_2_market_analysis_2026-06-27.md
- 5-min Heartbeat-Cron aktiv

### In Progress
- Naming-Konflikt — wartet auf User-Entscheidung (Sub-Title)
- Weitere Blender-Test-Assets (Leuchtturm, Speicherhaus)

### Blocked
- Studio-Sync und echtes Game-Testing brauchen User-Entscheidung zum Naming (Asset-Beschriftung hängt davon ab)

## Key Decisions (Refit-Stand 14:25)
- **D-001:** Curio World (NAMING-KOLLISION — User-Entscheidung nötig)
- **D-002:** 5 Districts + Hamburg Harbor als Vertical Slice
- **D-004:** Kosmetik + VIP-Komfort-Pass
- **D-010:** Gold (Massen) + Gems (selten) + Robux (Echtgeld), KEIN Stamina

## Next Steps
- **JETZT:** Naming-Entscheidung (Sub-Title wählen)
- Blender: Leuchtturm + Speicherhaus-Hafen testen
- Studio: erste echte Quest-Implementierung für Hamburg Harbor
- Phase 4 Playtest-Plan schreiben