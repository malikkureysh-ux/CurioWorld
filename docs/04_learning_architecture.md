# 04 — Learning Architecture

## Zweck

Dieses Dokument definiert, wie Lernen in Curio World in Spielmechaniken eingebettet wird, ohne dass es sich nach Schule anfühlt. Es ist die Brücke zwischen Fachwissen und Game Design.

## Annahmen

- Lernen passiert durch Handeln, nicht durch Frage-Antwort-Formate.
- Mehrere Wiederbegegnungen mit demselben Wissen, in veränderten Kontexten, vertiefen den Lerneffekt.
- Adaptive Anpassung verbessert Lernerfolg und Motivation.
- Kinder lernen besser, wenn Aufgaben Erfolgserlebnisse und gleichzeitig kognitive Aktivierung bieten.
- Retrieval (aktives Abrufen) ist dem Wiedererkennen überlegen.
- Projektbasiertes Lernen stärkt Planung, Eigenverantwortung und Zusammenarbeit.

## Quellen

- Lernforschung zu adaptiven Spielen (`01_research_log.md` T-04)
- Retrieval-Practice-Forschung (`01_research_log.md` T-05)
- Projektbasiertes Lernen (`01_research_log.md` T-06)
- Briefing-Zielmatrix Fächer → Spielmechanik

## Lernprinzipien

### LP-1: Tun, nicht antworten

Wissen wird angewendet, um eine spielerische Aktion auszulösen. Beispiel: Spieler:in beobachtet drei Symbole an einer Maschine, sortiert sie nach ihrer Größe (Mathematik: Ordnungsrelation), gibt die Reihenfolge ein, die Maschine startet.

### LP-2: Eingebettet, nicht befragt

Die Lernaufgabe ist die Spielaufgabe. Es gibt keinen separaten Lernmodus, kein Quiz, keine Klassenzimmer-Symbolik. NPCs erklären höchstens im Vorbeigehen, nicht frontal.

### LP-3: Mehrfachbegegnung in neuen Kontexten

Hinweise, Symbole, Konzepte tauchen in mehreren Missionen in veränderter Form wieder. Beispiel: Das Symbol für „Magnet" erscheint in Hamburg Harbor (Maschine), SkyBridge Bay (Kabelbahn) und Neo Sakura (Robotik-Bau).

### LP-4: Retrieval statt Recognition

Spieler:innen erinnern aktiv, statt nur wiederzuerkennen. Beispiel: Eine zuvor gesammelte Information (z. B. eine Karte, ein Rezept, eine NPC-Aussage) wird später benötigt, um eine Mission zu lösen.

### LP-5: Adaptive Anpassung

Die Schwierigkeit wird intern auf Basis von Erfolgsquote, Zeit, Hilfenutzung und Fehlermustern justiert (siehe `12_adaptive_difficulty_model.md`).

### LP-6: Projektbasierte Anwendung

Teamquests erfordern Planung, Rollenverteilung und Materialmanagement — projektbasiertes Lernen ohne Klassenzimmer-Setting.

## Fächerübersetzung

| Bereich | Lernziel | Ingame-Übersetzung | Beispiel |
|---|---|---|---|
| **Mathematik** | Mengen, Muster, Winkel, Taktung, Koordinaten | Ressourcen-Aufteilung, Plattformfolge, Zeitsteuerung | Magnetbahn: berechne Plattformfolge, damit die Bahn stabil läuft |
| **Physik** | Impuls, Gravitation, Hebel, Strom, Fluss | Maschinensteuerung, Ventile, Gewichte | Hafen-Kran: justiere Gegengewicht, damit Last schwingungsfrei schwebt |
| **Chemie** | Stoffeigenschaften, Mischung, Zustände, Reaktionen | Rezepturen, Materialkombination, Sicherheitsregeln | Festivalmaschine: kombiniere sichere Zutaten zu Leuchtfarbe |
| **Englisch** | Kontextsprache, Symbole, Dialogverständnis | Internationale NPCs, Hinweisschilder, Codewörter | Reisender NPC gibt Weg in englischen Sätzen, Spieler:in erkennt Schlüsselwort |
| **Informatik** | Wenn-Dann-Logik, Schleifen, Pfade, Zustände | Mini-Bot-Programmierung, Schalter-Sequenzen | Programmiere einen Bot, der drei Schalter in richtiger Reihenfolge aktiviert |
| **Logik** | Deduktion, Ausschluss, Mustererkennung | Tür-Puzzles, Symbol-Rätsel, Beweis-Aufgaben | Tür öffnet sich nur, wenn Bedingungen erfüllt sind |
| **Sprache** | Story-Verstehen, Synonyme, Reihenfolgen | Aussagen ordnen, Figuren helfen | NPC erzählt verwürfelt, Spieler:in ordnet Aussagen für die richtige Reihenfolge |
| **Gedächtnis** | Aktives Erinnern, räumliches Merken, Sequenzen | Recall Challenges, Pfad-Rekonstruktion | „Wie viele Brückenpfeiler hast du im letzten Bezirk gezählt?" |
| **Planen/Organisieren** | Projektlisten, Prioritäten, Ressourcen, Rollen | Community-Bauquests, Event-Planung | Baue im Team eine Festmaschine mit Material- und Zeitplan |

## Tiefenstufen pro Bereich

Jeder Bereich hat drei Tiefenstufen, abhängig vom Altersband und vom Kompetenzstand.

| Stufe | Altersband | Charakteristik | Beispiel |
|---|---|---|---|
| Basis | 9–11 | konkret, visuell, kurz, mit Hilfen | „Sortiere nach Größe" mit Drag-and-Drop |
| Mitte | 12–13 | zwei bis drei verknüpfte Regeln | „Sortiere nach Größe UND Farbe" |
| Fortgeschritten | 14–16 | mehrstufig, kombinatorisch | „Sortiere nach Größe, optimiere zusätzlich für minimalen Materialverbrauch" |

Die adaptive Engine wählt die Stufe basierend auf beobachteter Leistung; bei Erfolg wird sie innerhalb von 2–3 erfolgreichen Aufgaben angehoben, bei Hilfenutzung sofort eine Stufe gesenkt.

## Bezirks-Zuordnung der Lernbereiche

| Bezirk | Primäre Lernbereiche | Sekundäre Lernbereiche |
|---|---|---|
| **SkyBridge Bay** | Physik (Schrägen, Seile), Englisch | Mathematik (Muster) |
| **Liberty Blocks** | Logik, Englisch | Mathematik (Mengen) |
| **Neo Sakura** | Informatik (Logik, Schleifen), Logik | Mathematik (Koordinaten) |
| **Hamburg Harbor** | Physik (Hebel, Kräfte), Mathematik (Mengen, Winkel) | Planen/Organisieren |
| **Moon Bazaar** | Sprache, Chemie (Mischungen), Gedächtnis | Englisch |
| *Bio-Dome* (optional) | Chemie, Biologie-Schnittstelle | Gedächtnis |
| *Cloud Campus* (optional) | Informatik, Mathematik | Logik |
| *Memory Museum* (optional) | Gedächtnis, Sprache | Geschichte |
| *Sky Garden Observatory* (optional) | Mathematik (Astronomie) | Gedächtnis |
| *Volcano Workshop* (optional) | Chemie, Physik | Logik |

## Memory-Design

### Mechaniken für aktives Erinnern

- **Wiederkehrende Hinweise:** Schlüsselbegriffe tauchen in mehreren Missionen auf, jeweils in anderem Kontext.
- **Story-Artefakte:** Ein in Mission A gesammeltes Objekt wird in Mission D gebraucht, um eine Entscheidung zu treffen.
- **Sammelbücher mit Recall Challenges:** Statt nur Checklisten gibt es Minispiele, in denen Spieler:innen Erinnerungsfragen aktiv beantworten.
- **Räumliche Erinnerung:** „An welcher Stelle im Hafen hast du die Boje gesehen?" — Spieler:in markiert die Position auf der Karte.
- **Team-Ergänzung:** In Teamquests bekommt jede Rolle nur einen Teil der Information; vollständige Lösung erfordert Ergänzung.
- **Zeitversetzte Quests:** Eine Mission in Hamburg Harbor verlangt Wissen, das in SkyBridge Bay vor drei Spieltagen erworben wurde.

### Transferziele

Das Spiel soll nicht Faktenwissen prüfen, sondern folgende Kompetenzen aufbauen:

- Probleme zerlegen.
- Zusammenhänge beobachten.
- Informationen merken und wiederverwenden.
- Projekte planen.
- Arbeitsschritte priorisieren.
- In Teams Rollen verteilen.
- Systemisch denken.

## Eingebettete vs. explizite Lernsignale

Wir unterscheiden:

- **Eingebettetes Signal:** Spieler:in löst eine Aufgabe, die ein bestimmtes Denkmuster erfordert. Beispiel: Plattformfolge berechnen. *Was die Spieler:in sieht:* Plattformen erscheinen, Bahn startet.
- **Explizites Signal:** Spieler:in bekommt Feedback zur Denkleistung. *Was die Spieler:in sieht:* Mini-Badge „Ingenieur:in", leuchtendes Stadtteil-Element.

Explizite Signale sind Belohnungen, keine Noten. Sie werden niemals öffentlich verglichen (kein „Top-Mathematiker").

## Anti-Pattern-Checkliste

| Anti-Pattern | Verboten in | Erlaubte Alternative |
|---|---|---|
| Quiz mit Multiple Choice | niemals | Eingebettetes Lösen in Aktion |
| Schulnote oder Punktzahl | niemals | Badge als Belohnung |
| Timer mit Frust-Druck | niemals | Optionaler „Sprint-Modus" für 14–16 |
| „Lerne jetzt"-Aufforderung | niemals | Hinweis im Vorbeigehen |
| Lehrerversion mit Bewertung | niemals | Optionaler Educator-Modus für Eltern/Lehrkräfte zur Information |
| Wiederholungspflicht bei Fehler | niemals | Aufgabe wird automatisch leichter |

## Bezug zu Adaptive-Difficulty-Modell

Das Lernarchitektur-Modell und das adaptive Modell arbeiten zusammen:
- Lernarchitektur definiert **was** gelernt wird.
- Adaptive Engine definiert **wie schwer** und **wie viel Hilfe**.

Beide sind über die Telemetrie (`14_telemetry_plan.md`) verbunden: jede gespielte Mission speist sowohl das Lern- als auch das Anpassungssystem.

## Risiken

- **Lern-Versteckung übertreiben:** Wenn Lernen zu sehr versteckt wird, sehen Eltern keinen Mehrwert. Mitigation: Educator-Modus und About-Bereich.
- **Schwere-Drift:** Adaptive Engine könnte schwerer machen, ohne dass Spieler:in Fortschritt sieht. Mitigation: Sichtbare Belohnungen und kleine Erfolge.
- **Kulturelle Bias:** Bestimmte Symbole oder Konzepte sind nicht in allen Kulturen gleich verständlich. Mitigation: Lokalisierungs-Team prüft alle Lerninhalte.

## Offene Fragen

- Welche Indikatoren (jenseits von Erfolgsquote) sind in Telemetrie verfügbar, ohne kindliche Daten zu sammeln? (Phase 3.)
- Wie messen wir Transferleistung außerhalb des Spiels? (Phase 6.)
- Welche Lerninhalte sind in den Pflichtbezirken wirklich umsetzbar? Detail-Katalog pro Mission (Phase 2-3).

## Nächste Schritte

1. Pro Bezirk: konkrete Missionen mit Lernbereich, Tiefenstufe und Mechanik katalogisieren.
2. Educator-Modus-Skizze: was zeigen wir Eltern/Lehrkräften?
3. Lokalisierungs-Audit der Lerninhalte für HI, ZH, JA, AR.

## Änderungsverlauf

| Datum | Version | Änderung | Autor |
|---|---|---|---|
| 2026-06-27 | 0.1 | Initiale Lernarchitektur aus Briefing | Mavis (Agent) |
| 2026-06-27 14:25 | 0.2 | Refit: Curio World + 5-District-Plan + Gold/Gems/Robux (kein Stamina) + VIP-Komfort-Pass | Mavis (Agent) |
| 2026-06-27 14:50 | 0.3 | Refit: Wonder World → Curio World (Naming-Kollision mit existierendem Roblox-Pet-Game aufgedeckt) | Mavis (Agent) |
| 2026-06-27 | 0.1 | Initiale Lernarchitektur aus Briefing | Mavis (Agent) |