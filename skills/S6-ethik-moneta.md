# Skill S6 — Ethische Monetarisierung

> *Wir bauen ein Spiel für Kinder. Alles, was wie ein Trick aussieht, ist einer.*

## Zweck
Stellt sicher, dass Monetarisierung **fair, transparent und kinder-freundlich** ist. Verhindert Dark Patterns und schützt die Zielgruppe.

**Premium-Anspruch:** Monetarisierung ist **ethisch premium**. Eltern empfehlen das Spiel weiter, weil sie der Preisgestaltung vertrauen. Marketing-Standards auf Adult-Game-Niveau, ohne Adult-Game-Tricks. Volle Definition: AGENTS.md §11.

## Wann anwenden
- **Bei:** jeder Erwägung, etwas kaufbar zu machen; jedem Shop-Update; jeder Sale-Aktion
- **Loop:** B (Produkt)
- **Sub-Agent-Rolle:** Ethics-Guardian Veto-Recht (kann blocken)

## Die 5 harten Regeln

```
☐ 1. LERN-VORTEILE SIND IMMER GRATIS
   Niemals kann ein Spieler durch Geld einen Lern-Vorteil kaufen.
   Kein "XP-Boost", kein "Lösung-Hint-Pack", kein "schwierigere
   Quests freischalten".

☐ 2. PAY-TO-WIN IST VERBOTEN
   Was man kauft, ist IMMER rein kosmetisch oder rein komfort-
   bezogen (z.B. schneller reisen). Es darf NIE die Kern-
   Gameplay-Schleife beeinflussen.

☐ 3. KEIN FOMO (Fear Of Missing Out)
   Items müssen dauerhaft oder zumindest saisonal-rotierend
   verfügbar sein. Keine "Nur heute für 24h"-Sonderangebote.
   "Saisonpass-FOMO" ist okay (zeitlich befristet, aber ohne
   künstliche Knappheit bei Cosmetics).

☐ 4. KEINE WAIT-TO-PAY-MECHANIKEN
   "Warte 4 Stunden oder zahle 1€ für sofort" → VERBOTEN.
   "Limit 1x pro Tag, kannst du zurücksetzen mit €" → VERBOTEN.
   Spieler-Zeit wird nicht in Cash umgerechnet.

☐ 5. ELTERN SEHEN VOR KINDERN, WAS ES KOSTET
   Jeder Kauf braucht Eltern-Bestätigung (Roblox-In-App-Purchase
   mit Eltern-PIN). Keine "heimlichen" Käufe möglich.
```

## Was darf verkauft werden?

| Kategorie | Erlaubt? | Beispiele |
|---|---|---|
| Battle Pass (saisonal, 90 Tage) | ✅ | Neue Quests, Cosmetics, Emotes |
| Charakter-Skins (rein optisch) | ✅ | Outfit-Variationen, Frisuren |
| Lumi-Skins (saisonal) | ✅ | Farb-Variationen, Accessoires |
| Accessoires (rein optisch) | ✅ | Brillen, Hüte, Rucksäcke |
| Emotes / Tänze | ✅ | "Lumi-Tanz", "Wellen-Wave" |
| Hub-Dekoration | ✅ | Eigener Hub-Ort mit Cosmetics |
| XP-Boost | ❌ | Verboten |
| Lösungs-Hints | ❌ | Verboten |
| Schwierigere/leichtere Quests | ❌ | Verboten |
| Energie-Boost | ❌ | Verboten |
| "Überspringe Werbung" | ❌ | Wir haben keine Werbung |
| Random Loot-Box mit Echtgeld | ❌ | Verboten (In-Game-Drops ja, ohne Zahlen) |

## Preis-Range

```
Kleines Item:        1–3€ (Robux 100–300)
Battle Pass:         5–10€ (Robux 500–1000)
Skin-Bundle:         3–8€ (Robux 300–800)
Größere Erweiterung: 8–15€ (Robux 800–1500)
```

**Obergrenze pro Monat (Eltern setzbar):** Roblox-Konto hat eigenes Limit, wir empfehlen Eltern 15€/Monat.

## Eltern-Dashboard

```
☐ Monatliches Kosten-Limit setzbar
☐ Wöchentlicher Lern-Fortschritts-Report
☐ Bildschirmzeit-Tools (Tageslimit, Pause-Erinnerungen)
☐ Welche Items hat das Kind diese Woche gekauft? (Transparenz)
☐ Welche Skills werden trainiert? (Lern-Reports)
☐ Werbefrei-Garantie
```

## Anti-Patterns (DARK PATTERNS — verboten)

| Pattern | Warum verboten |
|---|---|
| "Nur noch 2 Min umsonst, dann kostet's" | Erzeugt Druck bei Kindern |
| "Deine Freunde haben X schon" | Sozialer Druck als Sales-Trick |
| "Limitierte Auflage!" bei Dauer-Items | Künstliche Knappheit |
| Zufällige Belohnung statt Auswahl | Loot-Box-Mentalität |
| Countdown-Timer auf permanente Items | Künstliche Dringlichkeit |
| Vorausgewählte Max-Pakete beim Checkout | Upselling-Trick |
| "Willst du wirklich NICHT?" als Default | Nudge-Manipulation |

## Werbe-Tone

**Erlaubt:**
- "Entdecke die neue Saison in Tokyo"
- "Triff Lumi in einer neuen Skin"
- "Zeig deinem Avatar einen neuen Look"

**Verboten:**
- "Werde schlauer mit dem Lern-Boost"
- "Dein Kind lernt schneller mit..."
- "Schluss mit schlechten Noten" (Schul-Trigger)
- "Andere Kinder haben das schon" (Sozial-Druck)

## Eskalations-Pfad

Wenn Ethics-Guardian eine geplante Monetarisierung ablehnt:
1. Begründung dokumentieren (in `/state/decision-log.md`)
2. ADR erstellen
3. Strategy-Lead reviewt gemeinsam mit Ethics-Guardian
4. Bei Uneinigkeit: User (Mensch) entscheidet

## Verbindlich mit anderen Skills
- **Skill S3** (Neurodivergenz) — keine Monetarisierung von Inklusions-Features
- **Verifier V4** (Community-Safety-Gate) — Monetarisierung muss V4 passieren

## Version
v1.0 — Juni 2026 — Initial definiert