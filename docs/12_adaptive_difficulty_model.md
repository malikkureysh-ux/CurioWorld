# 12 — Adaptive Difficulty Model

## Zweck

Dieses Dokument definiert die adaptive Schwierigkeits-Engine von Curio World: Signale, Kompetenzschätzung, Anpassungshebel und Anti-Shame-Prinzipien. Es ist die technische und pädagogische Spezifikation der Lernanpassung.

## Annahmen

- Adaptive Systeme können Motivation und Lernerfolg verbessern, wenn Aufgaben zum Leistungsstand passen.
- Anpassung muss diskret und unsichtbar bleiben; sichtbare „Level-Wahl" oder Noten sind tabu.
- Anti-Shame ist Pflicht: kein öffentliches Ranking der Lernleistung.
- Mehrere Signale ergeben ein robustes Kompetenzbild.
- Hilfen sind Teil des Designs, kein Zeichen von Schwäche.

## Quellen

- `01_research_log.md` T-04 (Adaptive Lernspiele)
- `01_research_log.md` T-05 (Retrieval Practice)
- `01_research_log.md` T-08 (Neurodivergenz)
- `04_learning_architecture.md` (Lernprinzipien, Tiefenstufen)

## Datenmodell

### Player Competency Profile

```
CompetencyProfile {
  player_id: hash (anonymisiert)
  age_band: enum (junior, scout, architect)
  updated_at: timestamp
  
  domains: {
    [domain_name]: DomainCompetency
  }
}

DomainCompetency {
  level: float (0.0–1.0, normalisiert)
  confidence: float (0.0–1.0, wie sicher ist die Schätzung)
  recent_trend: enum (improving, stable, declining)
  last_task_at: timestamp
  signals_window: SignalSnapshot[]
}

SignalSnapshot {
  timestamp: timestamp
  success_rate: float (rolling)
  avg_time: float (rolling)
  hint_rate: float (rolling)
  failure_patterns: string[]
  abandonment: boolean
  repetition_count: int
}
```

### Domain-Namen (initial)

- math
- physics
- chemistry
- english
- informatics
- logic
- language
- memory
- planning

## Signale (Input)

Folgende Signale werden pro Quest oder Puzzle erfasst:

| Signal | Beschreibung | Erhebung |
|---|---|---|
| Erfolgsquote | Anteil erfolgreich abgeschlossener Aufgaben | Quest/Puzzle-Abschluss |
| Bearbeitungszeit | Zeit von Start bis Lösung | Timer-Log |
| Hilfenutzung | Anzahl Hilfen, die angefordert wurden | Hilfe-Event |
| Fehlermuster | Welche Fehlerarten traten auf (z. B. „Sortierreihenfolge falsch") | Puzzle-Logs |
| Abbruchverhalten | Spieler:in hat Aufgabe verlassen ohne Lösung | Abbruch-Event |
| Wiederholungsbedarf | Wie oft wurde Aufgabe wiederholt | Wiederholungs-Event |
| Präferenz-Spieltyp | Welche Missionen wurden gewählt | Quest-Auswahl-Log |
| Kooperationsverhalten | Solo/Duo/Team-Modus | Quest-Start |
| Altersband | Initialfilter aus Roblox-Profil | Profil (anonymisiert) |

Diese Signale werden in einem rollierenden Fenster von ca. 30 Tagen ausgewertet.

## Kompetenzschätzung (Algorithmus-Skizze)

### Pro Domäne

```
estimated_level = (
  base_age_band_level * 0.3
  + rolling_success_rate * 0.3
  + normalized_speed_score * 0.15
  + hint_efficiency_score * 0.15
  + recent_improvement_bonus * 0.1
)

confidence = (
  sample_count_factor
  + consistency_factor
  + recency_factor
)
```

- `base_age_band_level`: Startwert je Altersband.
- `rolling_success_rate`: Erfolgsquote der letzten N Versuche.
- `normalized_speed_score`: Verhältnis zur durchschnittlichen Zeit für diese Aufgabe.
- `hint_efficiency_score`: Wenig Hilfenutzung bei erfolgreichem Abschluss = höherer Wert.
- `recent_improvement_bonus`: Wenn Spieler:in sich verbessert, leichter Bonus.
- `sample_count_factor`: Mehr Daten = höhere Konfidenz.
- `consistency_factor`: Wenig Varianz = höhere Konfidenz.
- `recency_factor`: Aktuelle Daten = höhere Konfidenz.

### Anpassungshebel (Output)

Bei jeder Quest-Empfehlung wird berechnet:

| Hebel | Wirkung |
|---|---|
| Tiefenstufe | Basis / Mitte / Fortgeschritten |
| Aufgabenkomplexität | Anzahl kognitiver Schritte |
| Hilfetiefe | Verfügbare Hilfen pro Aufgabe |
| Sprachkomplexität | Satzlänge, Wortwahl |
| Tempo | Optionaler Sprint-Modus für 14–16 |
| Wiederholungsfrequenz | Wie oft wird dieselbe Mechanik wiederholt |
| Abstraktionsgrad | Konkret (Bilder) vs. abstrakt (Symbole) |

### Beispiel-Auswahl

```
Spieler:in ist im Junior-Band, math-Domäne hat Level 0.4, Confidence 0.7
→ Empfehlung: Basis-Stufe, mittlere Aufgabenkomplexität, volle Hilfen verfügbar,
  einfache Sprache, mehr Wiederholung

Spieler:in ist im Architect-Band, informatics-Domäne hat Level 0.85, Confidence 0.9
→ Empfehlung: Fortgeschritten, hohe Komplexität, weniger Hilfen,
  abstraktere Symbole, seltenere Wiederholung
```

## Update-Regeln

- Bei Aufgabe: Sofortige Schätzungs-Aktualisierung.
- Bei Aufgabe mit 3+ erfolgreichen Lösungen hintereinander: Stufe anheben (eine Stufe).
- Bei Aufgabe mit 1+ Hilfenutzung oder 2+ Fehlversuchen: Stufe senken (eine Stufe).
- Niemals mehr als eine Stufe pro Aufgabe verschieben (Stabilität).
- Niemals unter Stufe 1 oder über Stufe 3 für die Altersbänder.

## Anti-Shame-Prinzipien

- **Keine öffentliche Leistungsanzeige.** Spieler:in sieht keine Punktzahlen, keine „Highscores" für Lernleistung.
- **Belohnung statt Bewertung.** Anpassung wird als „mehr Herausforderung" oder „leichtere Hilfen" kommuniziert, nicht als „Level".
- **Belohnung in kleinen Häppchen.** Auch bei niedrigerer Stufe gibt es sichtbare Erfolge (Items, Deko, Begleiter).
- **Hilfe ist Normalfall.** Hilfenutzung wird als „Teil des Spiels" dargestellt, nicht als Versagen.
- **Keine Vergleiche.** Es gibt keine Liste „die besten Mathematiker".
- **Daten privat.** Spieler:innen sehen ihre eigenen Fortschritte nur auf Wunsch (Sammelbuch-Modus), Eltern sehen eine aggregierte, nicht-vergleichende Übersicht.

## Hilfetiefe-Design

Pro Puzzle gibt es bis zu drei Hilfestufen:

| Stufe | Inhalt | Beispiel |
|---|---|---|
| 1 | Visueller Hinweis | „Schau dir die Größen genauer an." |
| 2 | Konkreter Hinweis | „Sortiere erst nach Größe." |
| 3 | Lösung mit Erklärung | „Die richtige Reihenfolge ist: … weil …" |

Hilfen werden progressiv angeboten, mit klarer Animation („Hilfe 1 / 3").

## Anti-Frust-Design

- Aufgabe wird automatisch leichter, wenn Spieler:in scheitert (nicht Bestrafung, sondern Entlastung).
- Aufgabe wird nicht „wiederholt aufgezwungen" — stattdessen leichtere Variante.
- Pausen werden aktiv empfohlen (kleine Symbole, freundliche Hinweise).
- Optionaler Fokus-Modus blendet Hintergrund-VFX aus.

## Neurodivergenz-Optionen

| Option | Wirkung |
|---|---|
| Reizreduzierter Modus | Hintergrund-VFX auf Minimum, sanftere Musik |
| Fokus-Modus | Hintergrund-VFX aus, klare UI-Highlights |
| Vorhersehbare UI | Konsistente Icons und Positionen |
| Wiederholbare Missionen | Jede Mission jederzeit spielbar |
| Kurze Loops | Mehrere kurze Missionen statt einer langen |
| Solo/Sozial-Wahl | Spieler:in kann Solo oder mit Anderen spielen |

## Telemetrie-Integration

- Jedes Puzzle löst ein `puzzle_completed` Event mit Domain, Erfolg, Zeit, Hilfen aus.
- Adaptive Engine liest Events live und aktualisiert das Profil.
- Profil wird alle 5 Minuten im DataStore gespeichert.

## Beispiel-Szenarien

### Szenario 1: Junge Spielerin im Junior-Band, scheitert oft

- Domain math: success_rate 0.4, avg_time hoch, hint_rate hoch.
- Konfidenz wächst langsam.
- Empfehlung: Basis-Stufe, mehr visuelle Hilfen, kürzere Aufgaben.
- Nach 3 erfolgreichen Aufgaben: Stufe Mitte.

### Szenario 2: Erfahrene Spielerin, langweilt sich

- Domain logic: success_rate 0.95, avg_time niedrig, hint_rate 0.
- Konfidenz hoch.
- Empfehlung: Fortgeschritten, mehr Komplexität, weniger Wiederholung.
- Nach 5 erfolgreichen Aufgaben: optionale Spezialquests freischalten.

### Szenario 3: Spieler mit kurzer Aufmerksamkeit

- Abbruchquote hoch, kurze Sessions.
- Empfehlung: kürzere Missionen anbieten, Mini-Quests statt langer Story.

## Sichtbare vs. unsichtbare Anpassung

| Aspekt | Sichtbar? | Wie |
|---|---|---|
| Aufgabe wird leichter | unsichtbar | Einfachere Variante erscheint |
| Aufgabe wird schwerer | unsichtbar | Komplexere Variante erscheint |
| Hilfen | sichtbar (Spieler:in fordert sie an) | „Hilfe anfordern"-Button |
| Erfolg | sichtbar | Animation + Belohnung |
| Konfidenz | unsichtbar | n/a |
| Profil-Level | unsichtbar im Standard-UI | nur im optionalen Sammelbuch-Modus |

## Risiken

- **Überanpassung:** Spieler:in wird zu schnell in schwierige Aufgaben geschoben. Mitigation: Update-Regeln mit Dämpfung.
- **Unterforderung:** Spieler:in wird künstlich leicht gehalten. Mitigation: Konfidenzbasierte Hebel-Anwendung.
- **Datenschutz:** Kompetenzprofile sind sensible Daten. Mitigation: anonymisiert, nur intern, DSGVO-konform.
- **Stigma:** Auch unsichtbare Anpassung kann wahrgenommen werden. Mitigation: Kommunikation an Eltern und Lehrkräfte.

## Offene Fragen

- Welche Schwellenwerte für Erfolgsquote, Zeit und Hilfen sind empirisch optimal? (Phase 2-3 mit Tests.)
- Wie gehen wir mit Lernfortschritt außerhalb des Spiels um? (Phase 6.)
- Wie visualisieren wir Eltern-Fortschritt ohne Bewertung? (Phase 6.)

## Nächste Schritte

1. Algorithmus als Luau-Modul implementieren (Phase 3).
2. Test-Suite mit simulierten Spieler-Profilen.
3. Pilot-Telemetrie: 100 Testspieler:innen über 4 Wochen (Phase 4).
4. Eltern-Feedback zur Anpassungs-Transparenz (Phase 6).

## Änderungsverlauf

| Datum | Version | Änderung | Autor |
|---|---|---|---|
| 2026-06-27 | 0.1 | Initiales Adaptive-Difficulty-Modell | Mavis (Agent) |
| 2026-06-27 14:25 | 0.2 | Refit: Curio World + 5-District-Plan + Gold/Gems/Robux (kein Stamina) + VIP-Komfort-Pass | Mavis (Agent) |
| 2026-06-27 14:50 | 0.3 | Refit: Wonder World → Curio World (Naming-Kollision mit existierendem Roblox-Pet-Game aufgedeckt) | Mavis (Agent) |
| 2026-06-27 | 0.1 | Initiales Adaptive-Difficulty-Modell | Mavis (Agent) |