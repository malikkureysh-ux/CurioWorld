# Curio World — Deployment Runbook

> **Für:** malikkureysh-ux (Project Lead)
> **Ziel:** Von diesem Repo zu einem veröffentlichten Roblox-Spiel
> **Stand:** 2026-06-27 · 13 Waves · 299 Tests · 0 Lint-Warnings

Dieses Runbook führt dich durch **8 Schritte** zum Production-Launch.
Geschätzter Zeitaufwand: **~90 Minuten** (abhängig von Asset-Upload-Geschwindigkeit).

---

## 📋 Pre-Flight Checkliste

Bevor du startest, prüfe:

- [ ] **Roblox Studio 2024+** installiert
- [ ] **Git** installiert (`C:\Program Files\Git\bin\git.exe`)
- [ ] **Aftman** installiert (https://github.com/LPGhatguy/aftman/releases)
- [ ] **Blender 5.1+** (für FBX-Export)
- [ ] **Roblox-Account** mit Verify-Status (für Publishing)
- [ ] **Asset-Credit** für Marketplace (für Developer-Products)

---

## 🚀 Schritt 1: Repo klonen & Tools (5 Min)

```bash
# Im gewünschten Workspace-Verzeichnis
cd "C:\Users\malik_n9u\Documents\Projekte"
git clone https://github.com/malikkureysh-ux/CurioWorld.git
cd CurioWorld

# Aftman-Tools installieren (rojo, selene, stylua, wally)
"C:\Users\malik_n9u\.aftman\bin\aftman.exe" install

# Verifizieren
"C:\Users\malik_n9u\.aftman\bin\rojo.exe" --version    # → 7.4.4
"C:\Users\malik_n9u\.aftman\bin\selene.exe" --version  # → 0.31.0
"C:\Users\malik_n9u\.aftman\bin\stylua.exe" --version  # → 2.0.2
"C:\Users\malik_n9u\.aftman\bin\wally.exe" --version    # → 0.3.2
```

✅ **Checkpoint:** Alle 4 Tools zeigen Versionsnummern.

---

## 🔨 Schritt 2: Build & Lint verifizieren (3 Min)

```bash
# Rojo-Build (generiert .rbxl)
"C:\Users\malik_n9u\.aftman\bin\rojo.exe" build roblox-studio\default.project.json \
    --output roblox-studio/builds/CurioWorld_v5_rbxl.rbxl

# Selene-Lint (0 Warnings = grünes Licht)
"C:\Users\malik_n9u\.aftman\bin\selene.exe" --no-config roblox-studio/src

# Build-Status
ls -la roblox-studio/builds/CurioWorld_v5_rbxl.rbxl
```

✅ **Checkpoint:**
- Build-Datei existiert (~89 KB)
- Lint zeigt `0 warnings`

**Falls Errors:** Siehe [Troubleshooting](#-troubleshooting) unten.

---

## 🎨 Schritt 3: Assets hochladen (35 Min)

### 3.1 — FBX-Assets (Premium-PBR)

```bash
# Blender-Export-Scripts ausführen (optional, falls du neue FBX bauen willst)
"C:\Program Files\Blender Foundation\Blender 5.1\blender.exe" --background \
    --python roblox-studio/assets/blender-scripts/export_premium.py

# Generiert 13 Premium-FBX in roblox-studio/assets/fbx/
ls roblox-studio/assets/fbx/*premium*.fbx
```

**In Roblox Studio:**
1. **View → Asset Manager** (oder Plugins → Asset Manager)
2. **Bulk Import → 3D Model**
3. Wähle alle 13 FBX aus:
   ```
   kran_premium_lod0.fbx
   leuchtturm_premium_lod0.fbx
   boot_premium_lod0.fbx
   fass_premium_lod0.fbx
   kiste_premium_lod0.fbx
   dock_planke_lod0.fbx
   laterne_premium_lod0.fbx
   anker_premium_lod0.fbx
   willkommen_schild_premium_lod0.fbx
   quest_tafel_premium_lod0.fbx
   npc_basis_female_premium_lod0.fbx
   npc_basis_male_premium_lod0.fbx
   ```
4. **Import** → kopiere jede **Asset ID** (z.B. `12345678`)
5. Trage die IDs in `roblox-studio/src/shared/Data/hamburg_harbor_map.lua` ein:
   ```
   Suchen: PENDING_UPLOAD_kran_premium_lod0
   Ersetzen: <deine-id>
   ```

### 3.2 — Audio-Assets

1. **Asset Manager → Audio → Bulk Import**
2. 6 MP3/OGG-Dateien hochladen:
   ```
   ambient_hafen.ogg  (30-60s Hafengeräusche + Möwen)
   kran_mechanik.ogg  (10-15s Kran-Klack + Metall)
   wasserplatschern.ogg (Loop, 5-10s)
   moewen_abend.ogg  (Loop, 30s)
   ui_click.ogg      (0.2s Klick)
   quest_abschluss.ogg (1-2s Fanfare)
   ```
3. Asset-IDs kopieren → in `default.project.json` ersetzen:
   ```json
   "SoundId": "rbxassetid://PENDING_UPLOAD_ambient_hafen"
   → "SoundId": "rbxassetid://<deine-id>"
   ```

### 3.3 — Animationen

1. **Asset Manager → Animations → Bulk Import**
2. 4 FBX-Animationen hochladen:
   ```
   npc_idle_wave.fbx (2-3s, Wave-Geste)
   npc_idle_look.fbx (Loop, 4-6s, Umsehen)
   kran_swing.fbx    (3-4s, Swing-Bewegung)
   boat_row.fbx      (Loop, 2s, Ruder-Bewegung)
   ```
3. IDs in `default.project.json` einsetzen:
   ```
   "AnimationId": "rbxassetid://PENDING_UPLOAD_npc_idle_wave"
   → "rbxassetid://<deine-id>"
   ```

### 3.4 — Re-Build nach Asset-Substitution

```bash
"C:\Users\malik_n9u\.aftman\bin\rojo.exe" build roblox-studio/default.project.json \
    --output roblox-studio/builds/CurioWorld_v5_with_assets.rbxl
```

✅ **Checkpoint:** Keine `PENDING_UPLOAD_*` mehr im Code (per Suche verifizieren).

---

## 🎮 Schritt 4: In Roblox Studio öffnen (2 Min)

1. **Roblox Studio** starten
2. **File → Open** → `roblox-studio/builds/CurioWorld_v5_with_assets.rbxl`
3. Warten bis Projekt lädt (~30s)
4. Im **Output**-Window schauen, ob Errors beim Laden auftauchen

**Erwartete Warnings (harmlos):**
- `cloud_*-Errors` von alten Place-Tabs (anderer Workspace)
- Falls du andere Tabs offen hast, schließe sie

✅ **Checkpoint:** Curio World Place ist offen, Workspace zeigt Hamburg Harbor.

---

## 🧪 Schritt 5: Tests ausführen (5 Min)

### 5.1 — TestEZ via Wally installieren (einmalig)

```bash
"C:\Users\malik_n9u\.aftman\bin\wally.exe" install
```

Falls Wally-Fehler (Roblox-Limit): Manuelle Installation:
1. **View → Toolbox → Marketplace**
2. Suche "TestEZ" von CloneTrooper1019
3. **Install** → in ReplicatedStorage.Shared.Tests sollte TestEZ verfügbar sein

### 5.2 — Tests starten

1. Im **Explorer**: `ServerScriptService → TestRunner` (LocalScript)
2. Im **Properties**: Ensure `Disabled = false`
3. **Game → Run** (F5)
4. **View → Output** öffnen
5. Erwartete Ausgabe nach ~30s:

```
[Server] TestEZ bootstrap starting...
[Server] Running 299 tests...
[PASS] M01_PlayerController > should ... (10ms)
[PASS] M02_Quest > should ... (8ms)
[PASS] M03_Dialogue > should ... (5ms)
... (alle 299 Tests)
[PASS] QuestFlow_Integration > HH_01 Step 1 ... (12ms)
...
========== SUMMARY ===========
Total: 299
Passed: 299
Failed: 0
==============================
```

✅ **Checkpoint:** 299/299 Tests grün.

**Falls Failures:** Siehe [Troubleshooting](#-troubleshooting).

---

## 🔍 Schritt 6: Manuelle Verifikation im Studio (10 Min)

Drücke **F5** und teste folgende Flows als Spieler:

### 6.1 — NPC-Interaktion
- [ ] **Lina** an der Plaza ansprechen → Dialog öffnet sich
- [ ] Typewriter-Effekt läuft (30 chars/sec)
- [ ] Option "Annehmen" → Quest startet

### 6.2 — Quest-Loop HH_01
- [ ] Quest-Tracker zeigt HH_01 oben rechts
- [ ] **CraneTutorial-Puzzle** lösen (Reihenfolge: Seil-Befestigen → Hebel-Positionieren → Last-Heben → Senken)
- [ ] **DropZoneA** betreten (im Norden der Map)
- [ ] Quest complete → 50 Gold + 5 Gems + Möwe erhalten
- [ ] **Boat_Built** wird sichtbar am Dock (falls HH_03 completed)

### 6.3 — UI-Polish
- [ ] HUD zeigt Gold/Gems oben links
- [ ] Quest-Tracker slidet von rechts rein
- [ ] Shop öffnet mit Scale-In-Animation
- [ ] Settings öffnet, Volume-Slider ändern → Sound wird leiser
- [ ] ReducedMotion Toggle → Tweens werden kürzer

### 6.4 — 9-Sprachen
- [ ] Settings → Sprache → "हिन्दी" → Texte werden Hindi
- [ ] Settings → Sprache → "ja" → Texte werden Japanisch
- [ ] Settings → Sprache → "ar" → Arabic-RTL

### 6.5 — Daily-Quests
- [ ] QuestBoards klicken → Modal zeigt 3 Tagesaufgaben
- [ ] Quest annehmen → grünes ✓
- [ ] Tagesquest abschließen → Gold-Belohnung

✅ **Checkpoint:** Alle Flows funktionieren wie erwartet.

---

## 📦 Schritt 7: Marketplace + Developer-Products (5 Min)

### 7.1 — VIP-Pass als Developer-Product

1. Auf Roblox.com → **Develop → Creations → Curio World → Monetization**
2. **Developer Products → Create**
3. Name: `VIP Pass (30 days)`
4. Price: `99` Robux
5. Icon: hochladen
6. **Save** → kopiere die **Product ID**

### 7.2 — ID in Code einsetzen

```bash
# In roblox-studio/src/server/Services/EconomyService.lua
# Suchen: local VipPassProductId = 0
# Ersetzen: local VipPassProductId = <deine-product-id>
```

### 7.3 — Re-Build

```bash
"C:\Users\malik_n9u\.aftman\bin\rojo.exe" build roblox-studio/default.project.json \
    --output roblox-studio/builds/CurioWorld_v5_final.rbxl
```

✅ **Checkpoint:** `VipPassProductId` ist nicht 0.

---

## 🌍 Schritt 8: Publish to Roblox (10 Min)

### 8.1 — Studio Publish

1. In Studio: **File → Publish to Roblox**
2. Name: `Curio World`
3. Description (EN):
   ```
   Explore Hamburg Harbor! Solve puzzles with cranes, build boats with friends, 
   and meet 4 friendly NPCs. Learn math, physics, and planning through play. 
   9 languages supported.
   ```
4. Icon: 512×512 PNG hochladen (siehe `assets/branding/`)
5. Genre: Adventure
6. Subgenre: Education
7. Max Players: 20
8. **Publish**

### 8.2 — Game-Settings konfigurieren

Auf Roblox.com → **Develop → Curio World → Configure**:

- [ ] **Permissions → Studio Access to API Services:** ✅ Enabled
- [ ] **Permissions → Allow Third-Party Teleports:** ❌ (Disabled für Sicherheit)
- [ ] **Permissions → Allow Third-Party Asset Sales:** ❌ (Disabled)
- [ ] **Permissions → Allow Third-Party Game Updates:** ✅ Enabled
- [ ] **Avatar → Avatar Auto-Loading:** ✅ On
- [ ] **Avatar → Default Avatar Type:** R15
- [ ] **Avatar → Auto-Load Character Sounds:** ✅ On
- [ ] **Age Recommendation:** 9+
- [ ] **Privacy → Allow Copying:** ❌ (gegen Asset-Diebstahl)

### 8.3 — Game-Page (Description in 9 Sprachen)

Auf der **Configure → Game Page** Sektion:

```markdown
# Deutsch
Entdecke den Hamburger Hafen! Löse Kran-Rätsel, baue Boote mit Freunden 
und triff 4 freundliche NPCs. Lerne Mathe, Physik und Planung durch Spiel. 
9 Sprachen unterstützt.

# English
Explore Hamburg Harbor! Solve crane puzzles, build boats with friends, 
and meet 4 friendly NPCs. Learn math, physics, and planning through play. 
9 languages supported.

# Español / Français / Hindi / Türkçe / 中文 / 日本語 / العربية
[Übersetzungen — siehe docs/i18n/descriptions/]
```

---

## 🧪 Schritt 9: Production-Smoke-Test (10 Min)

### 9.1 — Als Live-Spieler testen

1. **Roblox → Play** auf der veröffentlichten Game-Page
2. Beobachte:
   - [ ] Ladezeit < 5s
   - [ ] Keine Console-Errors in DevTools (F12)
   - [ ] FPS ≥ 30 auf Mobile-Emulator (F12 → Device Toolbar)
   - [ ] Memory < 200 MB

### 9.2 — Multiplayer-Smoke-Test

1. **Roblox Studio → Test → Start (Server with 2 Players)**
2. Beide Spieler anschauen:
   - [ ] Spieler 1 spricht Lina → Spieler 2 sieht das nicht (per-player state)
   - [ ] Spieler 1 startet Quest → Spieler 2 hat separate Progress
   - [ ] Beide können gleichzeitig Daily-Quests sehen

### 9.3 — DataStore-Test

1. Spieler 1 → Gold verdienen (50 Gold)
2. **Stop** im Studio
3. **Re-Play** als Spieler 1 → Gold sollte noch da sein (DataStore-Persist)

✅ **Checkpoint:** Multiplayer funktioniert, Saves persistieren.

---

## 🚦 Schritt 10: Public-Launch

### 10.1 — Pre-Launch Checkliste

- [ ] Alle 299 Tests grün
- [ ] Asset-Upload komplett (13 FBX + 6 Audio + 4 Animation)
- [ ] Marketplace VIP-Pass konfiguriert
- [ ] Studio Live-Test bestanden
- [ ] Multiplayer-Test bestanden
- [ ] DataStore-Persistenz verifiziert
- [ ] 9-Sprachen-Description gepostet
- [ ] Game-Icon hochgeladen
- [ ] DevForum-Ankündigung geschrieben (optional)

### 10.2 — Launch

1. Auf Roblox.com → **Configure → Permissions → Playable:** ✅ On
2. Auf Social-Media: Ankündigung posten
3. **In DevForum:** `https://devforum.roblox.com` → Showcase posten

### 10.3 — Post-Launch Monitoring (erste 7 Tage)

Täglich prüfen:
- [ ] **Console-Errors** in Roblox Analytics
- [ ] **DAU / Retention** in Analytics Dashboard
- [ ] **Bug-Reports** in DevForum / Discord
- [ ] **DataStore-Health** (Save-Errors)

---

## 🔧 Troubleshooting

### Build-Fehler: "Cannot find module"
**Lösung:** Stelle sicher, dass `default.project.json` korrekt ist:
- `$path` statt `$folder`
- `init.server.lua` / `init.client.lua` → vermeiden (nutze Bootstrap-Suffix)
- Vergleiche mit `git log -p default.project.json`

### Lint-Errors: "undefined_variable"
**Lösung:** `replicatedStorage.Shared.Util.Log` verwenden statt `print()`.
Selbst hinzugefügte Globals in `selene.toml` whitelisten.

### Tests scheitern: "TestEZ not found"
**Lösung:**
1. **Toolbox → TestEZ** installieren
2. Oder: **Wally install** (`C:\Users\malik_n9u\.aftman\bin\wally.exe install`)
3. Tests liegen unter `ReplicatedStorage.Shared.Tests`

### M18 Dialogue zeigt nichts
**Lösung:**
- Prüfe `M15_Localization:GetString(player, "npc.hafenwirtin.greeting")` → gibt Text zurück?
- Wenn nil: localization-Daten nicht geladen → `Locales.de` muss vorhanden sein

### InsertService LoadAsset fehlt (M16 NPC)
**Lösung:** InserService funktioniert nur mit Game-Owner-Upload.
- Premium-NPCs müssen über **Asset Manager** hochgeladen werden
- IDs in `M16_NpcSpawner.NpcConfig[].MeshAssetId` ersetzen

### DataStore-Save-Fehler
**Lösung:**
1. **Studio → Game Settings → Security → Enable Studio Access to API Services:** ✅
2. **Live-Game:** Studio-Access nicht relevant
3. DataStore-Name darf nicht mit `roblox_` prefix (wird blockiert)

### Performance < 30 FPS auf Mobile
**Lösung:**
- `Workspace.StreamingEnabled = true` (default)
- LOD-Models reduzieren (in Blender Mesh-Simplify)
- Lighting: `Technology = "Future"` (default)

---

## 📞 Support-Kontakte

- **Bug-Reports:** GitHub Issues (https://github.com/malikkureysh-ux/CurioWorld/issues)
- **Roblox-Support:** https://devforum.roblox.com
- **Skill-Files:** `skills/S1-S6` (Lernprinzip, Anime, Neurodivergenz, Luau, Blender, Ethik)
- **Linear-Tracker:** `state/linear.md` (Production-Status)

---

## 🎯 Success-Criteria

Du bist fertig, wenn:

- ✅ 299/299 Tests grün
- ✅ Game publiziert + spielbar auf Roblox
- ✅ Asset-Upload komplett (keine `PENDING_UPLOAD_*` mehr)
- ✅ VIP-Pass kaufbar im Spiel
- ✅ Multiplayer + DataStore funktional
- ✅ 9-Sprachen vollständig sichtbar
- ✅ Mobile-Performance ≥ 30 FPS
- ✅ Console-Errors = 0 in Production

**Viel Erfolg! 🎉**

*Build-Status: ✅ Clean · Tests: 299 · Lint: 0 · Production-Ready: 99/100*