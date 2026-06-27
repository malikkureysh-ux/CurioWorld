# Feature-Audit: M-09 bis M-15 + Services (Sozial/Save/Telemetrie/Moderation)

**Verfasser:** Mavis (Eigen-Audit, da Team-Worker Timeout)
**Datum:** 2026-06-27
**Zweck:** Production-Readiness-Review der sekundären Curio-World-Module.
**Methode:** Direkte Code-Lesung + Cross-Reference Docs/Decisions.

> **Hinweis:** Dieses Audit wurde vom Owner (Mavis) selbst durchgeführt, weil
> der ursprüngliche Team-Plan-Worker nach 15 Min Timeout abgebrochen wurde.
> Die Methodik ist dieselbe wie bei M-01..M-08 — Code-Lesung aller Module +
> Vergleich gegen docs/09_system_architecture.md und decisions/D-*.

---

## Modul-Status-Übersicht

| Modul | Datei | Status | Production-Ready? |
|---|---|---|---|
| **M-09 Event** | `src/shared/Modules/M09_Event.lua` | SKELETON | NEIN |
| **M-10 Housing** | `src/shared/Modules/M10_Housing.lua` | SKELETON | NEIN |
| **M-11 Companion** | `src/shared/Modules/M11_Companion.lua` | SKELETON | NEIN |
| **M-12 Telemetry** | `src/server/Services/TelemetryService.lua` | PARTIAL | TEILWEISE |
| **M-13 Moderation** | `src/shared/Modules/M13_Moderation.lua` | SKELETON | NEIN |
| **M-14 Save** | `src/server/Services/SaveService.lua` | PARTIAL | TEILWEISE |
| **M-15 Localization** | `src/shared/Modules/M15_Localization.lua` + `Data/locales.lua` | DONE | JA (mit Lücken) |
| **ServiceRegistry** | `src/shared/Util/ServiceRegistry.lua` | DONE (post-C-1 fix) | JA |
| **Log** | `src/shared/Util/Log.lua` | DONE | JA |
| **Bootstrap** | `src/server/Bootstrap.server.lua` | DONE | JA |
| **TestRunner** | `src/server/TestRunner.server.lua` | PARTIAL (post-pattern-fix) | TEILWEISE |

**Gesamtbild:** Auch in dieser Schicht sind 4 von 7 Modulen reine Skeletons.
M-12/M-14/M-15 haben funktionale Implementierungen, M-09/M-10/M-11/M-13
sind Type-Definitionen ohne Logik.

---

## M-09 Event Framework

**Datei:** `src/shared/Modules/M09_Event.lua`
**Spec-Referenz:** docs/09_system_architecture.md § M-09

### User Story
Als Spieler:in möchte ich, dass meine Aktionen (Kran-Klick, Boot-Start,
Quest-Abschluss) Events auslösen, die andere Systeme (Achievements,
Adaptive-Engine, Telemetry) abonnieren können.

### Erwartetes Verhalten
- Event-Bus mit `On(eventName)` / `Emit(eventName, payload)`
- Type-sichere Event-Handler
- Persistente Event-History für Achievement-Tracking

### Tatsächliches Verhalten
```lua
export type EventHandler = (payload: any) -> ()
M09_Event.Handlers = {}  -- leer
function M09_Event:Emit(_name: string, _payload: any): ()
    -- TODO Phase 3
end
```

**Status:** SKELETON
**Blocker:**
- Kein Emit/On-Mechanismus implementiert
- EventHistory fehlt komplett
- Keine Tests

---

## M-10 Housing

**Datei:** `src/shared/Modules/M10_Housing.lua`
**Spec-Referenz:** docs/09_system_architecture.md § M-10

### User Story
Als Spieler:in möchte ich mein eigenes kleines Hafen-Haus haben und es
mit Möbeln dekorieren, die ich im Shop kaufe.

### Erwartetes Verhalten
- House-Ownership pro Player
- Furniture-Placement (Server-validiert)
- Save/Load der Möbel-Anordnung

### Tatsächliches Verhalten
```lua
export type FurnitureItem = {
    id: string,
    position: Vector3,
    rotation: Vector3,
}
M10_House = {}  -- leer
```

**Status:** SKELETON
**Blocker:**
- Kein Housing-System
- Keine Furniture-Logik
- Keine Save-Integration

---

## M-11 Companion

**Datei:** `src/shared/Modules/M11_Companion.lua`
**Spec-Referenz:** docs/09_system_architecture.md § M-11, decisions/D-005/D-011

### User Story
Als Spieler:in möchte ich einen niedlichen Begleiter (z.B. Hafen-Katze
Sumi) sammeln und mitnehmen, der mich emotional bindet aber KEINE
spielmechanischen Vorteile bietet.

### Erwartetes Verhalten
- Companion-Slot-Management (M-07 Economy: max 1 ohne VIP, +1 mit VIP)
- Companion-Appearance (Mesh + Idle-Animation)
- Companion-Bonding-Stat (kosmetisch)

### Tatsächliches Verhalten
```lua
M11_Companion.Companions = {
    Sumi = { Name = "Hafen-Katze", ... },
    Piko = { Name = "Werkstatt-Roboter", ... },
    Mochi = { Name = "Bio-Dome-Igel", ... },
}
-- Sonst leer
```

**Status:** SKELETON
**Blocker:**
- Kein Companion-Slot-Management
- Keine Mesh-Instanziierung (nur Daten-Tabelle)
- Keine Animation-Hooks

---

## M-12 Telemetry

**Datei:** `src/server/Services/TelemetryService.lua`
**Spec-Referenz:** docs/14_safety_privacy.md, decisions/D-013

### User Story
Als Studio-Operator möchte ich anonymisierte Telemetrie-Daten sammeln
(Quest-Completion-Rates, Performance-Metriken) um die Spielerfahrung
zu verbessern, ohne dabei gegen DSGVO/COPPA zu verstoßen.

### Erwartetes Verhalten
- Anonyme Event-Collection (kein PII)
- HTTP-Push zu Analytics-Backend
- Local-Fallback wenn Backend offline
- Consent-Management

### Tatsächliches Verhalten
```lua
TelemetryService.Buffer = {}
function TelemetryService:Track(player, eventName, properties)
    table.insert(self.Buffer, {...})
    if #self.Buffer >= 100 then self:Flush() end
end
```

**Status:** PARTIAL
**Blocker:**
- HTTP-Stub (kein echter Push)
- Kein Consent-Management (DSGVO-Risiko für Kinder)
- PID-Hashing vorhanden, aber PII-Filter unvollständig
- Kein Schema für Event-Types (jeder Caller kann beliebige Properties senden)

---

## M-13 Moderation

**Datei:** `src/shared/Modules/M13_Moderation.lua`
**Spec-Referenz:** decisions/D-009 (Age-Tier-Chat), D-011 (Community-Protection)

### User Story
Als Spieler:in zwischen 9-16 möchte ich in einem sicheren Chat schreiben
können, der automatisch altersgerecht filtert (9-11 keine freie Texteingabe,
12-13 max 6 Wörter, 14-16 voller Chat mit Filter).

### Erwartetes Verhalten
- Age-Band-Erkennung via Roblox-API
- Wort-Filter (Blacklist)
- Rate-Limiting
- Auto-Eskalation bei Beleidigungen

### Tatsächliches Verhalten
```lua
M13_Moderation.AgeBands = {
    ["9-11"] = { MaxWords = 0, AllowFreeText = false },
    ["12-13"] = { MaxWords = 6, AllowFreeText = true },
    ["14-16"] = { MaxWords = 999, AllowFreeText = true },
}
M13_Moderation.Filter = { ["bad_word"] = true }  -- 5 Einträge
-- Keine Logik implementiert
```

**Status:** SKELETON
**Blocker:**
- Keine Filter-Funktion (nur Type-Definition)
- Keine Rate-Limit-Logik
- Keine Reporting-Funktion
- **KRITISCH für Minderjährigen-Schutz**: aktuell KEINE active Filterung

---

## M-14 Save

**Datei:** `src/server/Services/SaveService.lua`
**Spec-Referenz:** docs/14_safety_privacy.md, decisions/D-014

### User Story
Als Spieler:in möchte ich, dass meine Coins, Quests und Inventar
automatisch gespeichert werden, sodass ich beim nächsten Login alles
wieder habe.

### Erwartetes Verhalten
- DataStoreService.AutoSave alle 60s
- AES-Encryption sensibler Felder
- Roblox-Server-Shutdown-Handling
- ProfilService-Integration (in Phase 3)

### Tatsächliches Verhalten
```lua
SaveService.DataStore = game:GetService("DataStoreService"):GetDataStore(...)
function SaveService:Save(player, data)
    pcall(function() self.DataStore:SetAsync(key, data) end)
end
```

**Status:** PARTIAL
**Blocker:**
- AES-Encryption-Stub (nur Platzhalter, NICHT echte Verschlüsselung)
- Kein ProfilService (empfohlen für Production)
- AutoSave alle 60s vorhanden, aber keine Error-Recovery
- Keine Validierung der geladenen Daten

---

## M-15 Localization

**Datei:** `src/shared/Modules/M15_Localization.lua` + `Data/locales.lua`
**Spec-Referenz:** decisions/D-008 (9 Sprachen)

### User Story
Als Spieler:in aus Deutschland, Türkei, Indien etc. möchte ich das
gesamte Spiel in meiner Muttersprache spielen, mit korrekter RTL-Darstellung
für Arabisch.

### Erwartetes Verhalten
- 9 Sprachen mit Übersetzungen
- RTL-Support für Arabisch
- Plural-Forms
- Number-Format (Tausender-Trennzeichen)

### Tatsächliches Verhalten
- locales.lua hat 9 Sprachen (DE/EN/ES/FR/TR/HI/ZH/JA/AR) ✓
- M15_Localization unterstützt `T(key, lang)` ✓
- RTL-Test vorhanden ✓
- Multi-Placeholder funktioniert ✓

**Status:** DONE (gut implementiert, mit kleinen Lücken)

**Blocker (Minor):**
- Coverage variiert pro Sprache (DE/EN voll, andere teils lückenhaft)
- Keine Plural-Forms (`{n} file(s)`)
- Hindi-Schriftarten könnten kleiner ausfallen

---

## Bootstrap (Re-Audit nach MapBuilder-Fixes)

**Datei:** `src/server/Bootstrap.server.lua`

### Erwartetes Verhalten
- Dependency-Order: Utilities → Map → NPCs → Services
- Map-Validate vor Build (Fail-Loud)
- Service-Registrierung
- NPC-Spawn nach MapBuild

### Tatsächliches Verhalten (nach Audit-Fixes)
- Reihenfolge korrekt ✓
- Map-Validate + Build ✓
- Services registriert ✓
- NPC-Spawner aufgerufen ✓
- NpcSpawner importiert M16 erfolgreich ✓

**Status:** DONE

---

## ServiceRegistry (Re-Audit)

**Datei:** `src/shared/Util/ServiceRegistry.lua`

### Erwartetes Verhalten
- Thread-safe Register/Lookup
- TOCTOU-Race-Prevention (waiter-based)
- List-API für Debug

### Tatsächliches Verhalten (nach C-1-Fix)
- TOCTOU-Race gefixt (commit 7851e2b) ✓
- API stabil ✓

**Status:** DONE

---

## Log (Re-Audit)

**Datei:** `src/shared/Util/Log.lua`

### Tatsächliches Verhalten
- Level-Setter (`Debug`/`Info`/`Warn`/`Error`)
- Roblox-Output-Mirror
- Studio-Debug-Override

**Status:** DONE

---

## TestRunner (Re-Audit nach Pattern-Fix)

**Datei:** `src/server/TestRunner.server.lua`

### Erwartetes Verhalten
- Auto-Discovery `*.spec.lua`
- TestEZ-Integration (graceful wenn nicht installiert)

### Tatsächliches Verhalten (nach Pattern-Fix)
- Pattern korrigiert (`%.spec` statt `%.spec$`) ✓
- TestEZ-fallback vorhanden ✓

**Status:** PARTIAL (TestEZ-Paket fehlt, Auto-Discovery funktioniert sobald Paket installiert)

---

## Gap-Summary (Priorisiert)

### Priorität 1 — CRITICAL (Production-Blocker)
1. **M-13 Moderation** implementieren — Kinder-Chat-Filterung fehlt komplett
2. **M-09 Event Framework** — viele Quests hängen von Events ab, die nicht funktionieren
3. **M-14 Save AES** — Encryption-Stub ist nur ein Kommentar, kein echtes Crypto

### Priorität 2 — HIGH
4. **M-11 Companion Spawn** — Companion-Meshes instanziieren
5. **M-10 Housing** — Player-Häuser-System
6. **M-12 Consent** — DSGVO-konformes Consent-Management

### Priorität 3 — MEDIUM
7. **M-15 Plural-Forms** — `{n} file` statt `1 file` / `2 files`
8. **M-15 Coverage** — HI/ZH/JA/AR Strings vervollständigen

### Priorität 4 — LOW
9. **M-09 EventHistory** — Persistente History für Achievements
10. **M-12 Schema** — TypeScript-like Event-Types
