# Autonomes Entwicklungsbriefing: Roblox-Lernspiel für 9–16 Jahre

## Ziel des Dokuments

Dieses Briefing definiert den vollständigen Auftrag für einen autonomen AI-Agenten, der ein kommerziell tragfähiges, pädagogisch wertvolles und plattformkonformes Community-Spiel für Roblox konzipieren, recherchieren, entwickeln, testen, dokumentieren und zur LiveOps-Reife vorbereiten soll. Roblox unterstützt Creator-Monetarisierung über mehrere Mechanismen, gleichzeitig aber nur innerhalb klarer Plattform-, Sicherheits- und Jugendschutzregeln, weshalb Produktstrategie, Economy, Community-Design und Compliance von Beginn an gemeinsam gedacht werden müssen.[cite:11][cite:13][cite:16]

Das Spiel richtet sich an Kinder und Jugendliche von 9 bis 16 Jahren und soll Jump-and-Run-, Adventure-, Social- und Progressionssysteme mit altersgerechten Lernbeiträgen verbinden, ohne dass sich das Erleben wie Schule anfühlt. Forschung zu adaptiven Lernspielen deutet darauf hin, dass adaptive Schwierigkeitssteuerung Motivation und Lernerfolg verbessern kann, wenn Aufgaben zum Leistungsstand passen und die Spielerfahrung nicht durch ständige Prüfungssituationen gebremst wird.[cite:31][cite:33][cite:34]

## Kernauftrag an den Agenten

Der Agent soll ein vollständiges Spielsystem erschaffen, das folgende Ziele gleichzeitig erfüllt:

- Hohe Spielmotivation durch Bewegung, Sammeln, Freischalten, Kooperation, visuelle Belohnung und soziale Wiederkehr.
- Unsichtbar integriertes Lernen in Physik, Chemie, Mathematik, Englisch, Informatik, Logik, Sprache, Gedächtnis, Planen und Organisieren.
- Adaptives Schwierigkeitssystem nach Altersgruppe und Kompetenzstand.
- Anime-kindlich-jugendlich-süße Art Direction für Figuren, Welt und UI.
- Roblox-first-Umsetzung für Multiplayer, Monetarisierung, Community und LiveOps.
- Blender-basierte Asset-Pipeline für Charaktere, Props, Landmarken und modulare Weltbausteine.
- Vollständige Dokumentation aller Entscheidungen, Assets, Systeme, Risiken, Tests und Research-Ergebnisse.

Der Agent arbeitet nicht nur als Umsetzer, sondern auch als Researcher, Systems Designer, Narrative Designer, Technical Designer, Economy Designer, QA-Lead, Safety Lead und Documentation Lead. Alle Zwischenstände, Hypothesen, Entscheidungen, Trade-offs, offenen Risiken und empirischen Begründungen müssen fortlaufend dokumentiert werden.

## Produktvision

Das Zielprodukt ist ein persistent spielbares Community-Adventure in einer vernetzten Mega-Stadt aus stilisierten Bezirken, die von großen Weltmetropolen inspiriert sind, aber als fantasievolle, sichere und kindgerechte Anime-Welten interpretiert werden. Roblox nutzt Content-Maturity- und Sicherheitsmechanismen zur Einordnung von Erlebnissen, daher muss das Spiel bewusst im familien- und jugendgeeigneten Bereich bleiben und soziale Funktionen so gestalten, dass sie für jüngere Nutzer geeignet sind.[cite:21][cite:22][cite:25]

Die Spielwelt soll wie ein lebendiger Themenpark aus Entdecken, Parkour, Teamaufgaben, kleinen Rätseln, Sammelzielen, Story-Hooks, Community-Building und saisonalen Events wirken. Lerninhalte dürfen nicht als Fragebogen, Klassenzimmer oder Prüfmodus erscheinen, sondern als natürliche Voraussetzung, um Türen zu öffnen, Maschinen zu steuern, Wege freizuschalten, NPCs zu helfen, Rezepte zu verstehen, Hinweise zu entschlüsseln oder gemeinsame Bauprojekte abzuschließen.[cite:37][cite:42]

## Pflichtprinzipien

### 1. Spiel zuerst

Jede Lernmechanik muss zuerst als spaßige Spielmechanik funktionieren. Wenn ein Lerninhalt nicht elegant in Bewegung, Experiment, Exploration, Entscheidung, Crafting oder Kooperation eingebettet werden kann, muss der Agent die Mechanik neu formulieren statt sie als sichtbare Quizfrage aufzuzwingen.

### 2. Lernen ohne Schulgefühl

Das Spiel soll Kompetenzaufbau erzeugen, ohne schulische Symbolik, Bewertungsangst oder Belehrungsästhetik. Geeignete Methoden sind eingebettete Rätsel, wiederkehrende Mustererkennung, implizites Feedback, narrative Motivation und aktives Erinnern an bereits Erlebtes; Retrieval Practice verbessert das Behalten bei Kindern, wenn Wissen aktiv abgerufen statt nur wiedererkannt wird.[cite:29]

### 3. Anpassung statt Überforderung

Das System muss Spielerleistung fortlaufend schätzen und die nächste Aufgabe dynamisch justieren. Adaptive Lernspiele zeigen besonders dann Potenzial, wenn Schwierigkeit, Feedback und Herausforderung in einem Bereich bleiben, der Erfolgserlebnisse erlaubt und dennoch kognitive Aktivierung auslöst.[cite:31][cite:33][cite:34]

### 4. Community, aber sicher

Das Spiel soll sozial, kooperativ und lebendig sein, darf aber nicht als ungefilterter Social-Hangout konzipiert werden. Roblox hat Sicherheits-, Chat-, Zivilitäts- und Jugendschutzstandards sowie zusätzliche Einschränkungen für bestimmte soziale Erlebnisformen bei jüngeren Nutzern, weshalb Interaktion an strukturierte Aktivitäten, sichere Kommunikation und Moderationsmechanismen gebunden werden muss.[cite:13][cite:16][cite:17][cite:22]

### 5. Monetarisierung ohne Pay-to-Win

Roblox erlaubt verschiedene Monetarisierungsformen wie Abogebühren, Zugangspreise oder In-Experience-Käufe, doch in einem Kinderspiel muss das System ethisch, transparent und nicht ausbeuterisch gestaltet sein. Verkäufe sollen vor allem auf Kosmetik, Ausdruck, Komfort, Sammlerstücke, Housing, saisonale Inhalte und sanfte Beschleunigung zielen, nicht auf unfaire Machtvorteile.[cite:11][cite:13]

### 6. Neurodivergenz-freundliche Gestaltung

Der Agent soll das Spiel so gestalten, dass es abwechslungsreich, belohnend, klar strukturiert und reizregulierbar ist. Serious-Game-Forschung für Kinder mit spezifischen Lernschwierigkeiten stützt den Nutzen adaptiver, nicht stigmatisierender Systeme mit individueller Anpassung, wiederholbaren Schleifen und flexiblen Zugängen.[cite:39][cite:34]

## Rolle des Agenten

Der Agent übernimmt die Verantwortung für folgende Arbeitsstränge:

- Markt- und Plattformrecherche.
- Compliance- und Safety-Analyse.
- Zielgruppen- und Alterssegmentierung.
- Pädagogische Lernarchitektur.
- Game Design und Progression.
- Narrative Weltentwicklung.
- Roblox-Systemarchitektur.
- Blender-Asset-Strategie.
- UI/UX-Design.
- Multiplayer- und Community-Mechaniken.
- Economy- und Monetarisierungssysteme.
- Data- und Telemetry-Plan.
- QA, Balancing, User Testing.
- Dokumentation, Versionierung und Knowledge Base.

Der Agent darf keine wesentliche Produktentscheidung ohne dokumentierte Begründung treffen. Jede Empfehlung muss in einem Decision Log festgehalten werden, mit Problemstellung, Optionen, Bewertung, Entscheidung, erwarteter Wirkung, Risiken und Validierungsplan.

## Research-Mandat

Der Agent muss vor jeder finalen Entscheidung eigenständig recherchieren, welche Lösung für Roblox, Blender, kindgerechtes Multiplayer-Design und adaptive Lernmechaniken am besten passt. Roblox stellt Creator-Dokumentation für Monetarisierung, Sicherheitsressourcen und Community-Standards bereit; diese Quellen haben bei plattformspezifischen Entscheidungen Vorrang vor allgemeinen Blogquellen.[cite:11][cite:13][cite:16]

### Research-Pflichten

Der Agent recherchiert mindestens zu folgenden Themen:

- Aktuelle Roblox-Regeln zu Content Maturity, Community-Standards, Safety, Chat, Privacy und Experience-Eignung.[cite:16][cite:21][cite:22][cite:25]
- Roblox-Monetarisierungsoptionen und kindersensible Umsetzung.[cite:11]
- Grenzen und Chancen sozialer Erfahrungen für jüngere Nutzer auf Roblox.[cite:17][cite:22]
- Best Practices für adaptive game-based learning und altersgerechte Schwierigkeitssysteme.[cite:31][cite:33][cite:34][cite:37][cite:42]
- Forschung zu Gedächtnis, Abruflernen und Behalten bei Kindern.[cite:29]
- Nutzen projektbasierten Lernens für Planen, Organisieren und kollaboratives Arbeiten.[cite:30]
- Designmuster für Kinder- und Familiengames mit hoher Retention, aber ohne manipulative Dark Patterns.
- Technische Roblox-Limitierungen für Performance, Networking, Asset-Komplexität, UGC-Flows und Cross-Device-Spielbarkeit.
- Geeignete Blender-Workflows für stylisierte Low-/Mid-Poly-Assets mit robloxfreundlicher Pipeline.

### Research-Ausgabeformate

Der Agent erstellt und pflegt:

- `research_log.md`: Quellen, Notizen, Relevanz, offene Fragen.
- `compliance_matrix.md`: Plattformregeln und Umsetzungsfolgen.
- `age_band_analysis.md`: Unterschiede 9–11, 12–13, 14–16.
- `learning_design_review.md`: Evidenz für Lernmechaniken und Adaptivität.
- `competitor_scan.md`: Referenzspiele, Lücken, Chancen.
- `art_direction_references.md`: Stil- und Asset-Referenzen.

## Zielgruppe

### Primäre Altersbänder

| Altersband | Spielerprofil | Empfohlene Lern- und Spieltiefe |
|---|---|---|
| 9–11 | Neugierig, sammel- und belohnungsorientiert, klare Ziele wichtig | Kurze Loops, visuelle Ursache-Wirkung, einfache Mehrschrittaufgaben, konkrete Hilfen |
| 12–13 | Mehr Autonomie, mehr Teamspiel, stärkerer Wunsch nach Identität und Ausdruck | Verzahnte Systeme, erste strategische Entscheidungen, stärkere Rollen- und Eventsysteme |
| 14–16 | Höhere Systemkompetenz, sozialer Status, Optimierung, Bau- und Mastery-Motivation | Tiefere Kombinatorik, komplexere Quests, Projektketten, optimierbare Builds und Tools |

Der Agent darf Inhalte nicht bloß nach Alter, sondern auch nach Kompetenz, Fortschritt, Frustrationstoleranz und Präferenzprofil differenzieren. Adaptive versus nicht-adaptive digitale Lernspiele wurden wiederholt verglichen; die Literatur zeigt Vorteile adaptiver Systeme besonders dann, wenn Aufgaben fein abgestimmt, motivierend und wiederholt spielbar bleiben.[cite:33][cite:34]

## Spielkonzept

### Arbeitstitel

Ein interner Arbeitstitel kann zunächst `MetroMinds Adventures` oder `StarCity Quest` lauten. Der Agent darf Branding und Naming systematisch testen, muss aber eine Namensentscheidung mit Zielgruppenfit, Verständlichkeit, Internationalisierbarkeit, Einprägsamkeit und Roblox-Kontext begründen.

### Genre-Mix

- 3D Jump-and-Run.
- Adventure-Exploration.
- Leichte Rätsel- und Systemsimulation.
- Community-Metagame.
- Sammel- und Progressionsspiel.
- Saisonales LiveOps-Spiel.
- Unsichtbar integriertes Lernspiel.

### Core Fantasy

Spieler sind junge City-Ranger, Erfinder, Entdecker und Kollektivbauer, die eine vernetzte Wunderstadt aus verschiedenen Kultur- und Science-Distrikten erkunden, reparieren, erweitern und schützen. Jede Aktivität vermittelt das Gefühl, Teil einer lebendigen Community zu sein, in der man gemeinsam Herausforderungen löst und der Welt sichtbar beim Wachsen hilft.

## Welt und Bezirke

Die Welt besteht aus einem zentralen Hub und mehreren Metro-Distrikten, die sich locker an ikonischen Weltmetropolen orientieren. Die visuellen Vorbilder dienen der Stimmung, Silhouette und Vielfalt, dürfen aber nicht als enge, realistische Kopie missverstanden werden.

### Pflichtbezirke

- **SkyBridge Bay**: inspiriert von San Francisco, mit roter Brücke, Steigungen, Schienensystemen, Wind, Kabelbahnen und Hügel-Parkour.
- **Liberty Blocks**: inspiriert von New York, mit Rooftops, U-Bahn-Linien, Freiheitsinsel-Silhouette, Hochhaus-Challenges und schneller Stadtenergie.
- **Neo Sakura District**: inspiriert von Tokio, mit Neon, Robotik, Popkultur, Tech-Hubs, Automaten, vertikalen Wegen und Arcades.
- **Harbor Forge**: inspiriert von Hamburg, mit Hafenbecken, Kränen, Speicherhäusern, Wasserlogistik und Werftmechaniken.
- **Moon Bazaar**: inspiriert von Istanbul, mit Basaren, Brücken, Gassen, Laternen, Gewürzlaboren und Erinnerungsrätseln.

### Zusätzliche kreative Bezirke

Der Agent soll weitere Bezirke prüfen, etwa:

- Lernwald / Bio-Dome.
- Cloud Campus.
- Underrail Labs.
- Memory Museum.
- Sky Garden Observatory.
- Volcano Workshop.

Für jeden Bezirk dokumentiert der Agent:

- Lernfokus.
- Bewegungsstil.
- Gegner- oder Hindernistypen.
- Sammelobjekte.
- Sozialmechaniken.
- Art-Direction-Keywords.
- Technische Asset-Anforderungen.

## Lernarchitektur

### Lernprinzip

Lernen ist kein separater Modus, sondern in die spielerische Weltfunktion eingebaut. Spieler sollen Wissen anwenden, nicht beantworten. Geeignete Formen sind Rätsel, Baupläne, Maschinensteuerung, Dialogverständnis, Umweltbeobachtung, Musterrekonstruktion, Experimentieren und das spätere Erinnern an bereits gesehene Hinweise.[cite:29][cite:37][cite:42]

### Fächer und Übersetzung in Spielmechaniken

| Bereich | Ingame-Übersetzung | Beispiel |
|---|---|---|
| Mathematik | Muster, Mengen, Winkel, Taktung, Ressourcen, Koordinaten | Berechne die nötige Plattformfolge, um eine Magnetbahn zu stabilisieren |
| Physik | Impuls, Gravitation, Hebel, Strom, Fluss | Stelle Ventile und Gewichte so ein, dass eine Maschine startet |
| Chemie | Mischung, Zustände, Reaktionen, Stoffeigenschaften | Kombiniere sichere Zutaten zu Leuchtfarben für eine Festivalmaschine |
| Englisch | Kontextsprache, Reisen, Symbole, Begriffe, Dialoge | Verstehe Hinweise internationaler NPCs, um ein Ziel zu erreichen |
| Informatik | Wenn-Dann-Logik, Schleifen, Pfade, Zustände | Programmiere einen Mini-Bot, der Schalter in richtiger Reihenfolge aktiviert |
| Logik | Deduktion, Reihenfolge, Ausschluss, Muster | Löse ein Türpuzzle über Symbole und Bedingungen |
| Sprache | Story-Verstehen, Synonyme, Reihenfolgen, Erzählen | Ordne Aussagen, um einer Figur zu helfen |
| Gedächtnis | Aktives Erinnern, räumliches Merken, Sequenzen | Rekonstruiere einen Pfad, den du im letzten Distrikt gesehen hast |
| Planen/Organisieren | Projektlisten, Prioritäten, Ressourcen, Rollen | Baue im Team ein Event-Objekt mit Material- und Zeitplan |

### Altersgerechte Ausgestaltung

Der Agent definiert pro Lernsystem drei Tiefenstufen:

- **Basis** für 9–11: konkret, visuell, kurz, mit Hilfen und Feedback.
- **Mitte** für 12–13: zwei bis drei verknüpfte Regeln, weniger Hilfen, mehr Transfer.
- **Fortgeschritten** für 14–16: mehrstufig, kombinatorisch, mit Optimierungs- und Teamkomponenten.

### Adaptives Schwierigkeitssystem

Das adaptive System soll mindestens folgende Signale auswerten:

- Erfolgsquote.
- Bearbeitungszeit.
- Anzahl Hilfen.
- Fehlermuster.
- Abbruchverhalten.
- Wiederholungsbedarf.
- Präferenz für Spieltyp.
- Kooperationsverhalten.

Aus diesen Signalen schätzt das System diskret einen Kompetenzwert pro Domäne und passt dann an:

- Komplexität der Aufgabe.
- Menge paralleler Informationen.
- Hilfetiefe.
- Sprachkomplexität.
- Tempo und Zeitdruck.
- Anzahl notwendiger Schritte.
- Grad der Abstraktion.
- Seltenheit und Wiederholung von Erinnerungsaufgaben.

Forschung zu adaptiver Schwierigkeit in Lernspielen sowie zu adaptiven Serious Games zeigt, dass solche Systeme motivierend und lernförderlich sein können, wenn sie transparent im Ergebnis, aber unsichtbar in der Steuerung bleiben und Kinder nicht beschämen.[cite:31][cite:34][cite:39][cite:42]

## Gedächtnis, Behalten und Transfer

Der Agent soll ein Memory-Design entwickeln, das systematisch auf spätere Erinnerung setzt. Retrieval-basierte Lernforschung bei Kindern zeigt, dass aktives Abrufen dem bloßen Wiederlesen oder Wiedererkennen beim Behalten überlegen sein kann.[cite:29]

### Pflichtmechaniken für Erinnerung

- Wiederkehrende Hinweise mit leicht veränderter Anwendung.
- Story-Artefakte, die später erneut gebraucht werden.
- Sammelbücher mit „Recall Challenges“ statt reiner Checkliste.
- Weg-, Symbol- und Mustererinnerung.
- Teamaufgaben, in denen Informationen zwischen Spielern ergänzt werden.
- Zeitversetzte Quests, die Vorwissen belohnen.

### Transferziel

Kinder sollen nicht nur einzelne Antworten lernen, sondern Kompetenzen entwickeln wie:

- Probleme zerlegen.
- Zusammenhänge beobachten.
- Informationen merken und wiederverwenden.
- Projekte planen.
- Arbeitsschritte priorisieren.
- In Teams Rollen verteilen.
- Systemisch denken.

Projektbasiertes Lernen wird in der Literatur mit Vorteilen für Planung, Eigenverantwortung, Zusammenarbeit und praxisnahe Anwendung verbunden; der Agent soll diese Prinzipien in Teamquests und Bauprojekte übersetzen.[cite:30]

## Game Loop und Progression

### Primärer Loop

1. Einen Distrikt erkunden.
2. Parkour oder Adventure-Route meistern.
3. Eine Mission, ein Rätsel oder Community-Event entdecken.
4. Ein eingebettetes Lernproblem spielerisch lösen.
5. Belohnungen, Materialien, Kosmetik, Blaupausen oder Story-Fortschritt erhalten.
6. Zur Hub-Welt oder zum Teamprojekt zurückkehren.
7. Neue Bezirke, Aufgaben, Deko, Companions oder Bauoptionen freischalten.

### Sekundäre Loops

- Tägliche Micro-Quests.
- Wöchentliche Community-Ziele.
- Saisonale Festivals.
- Bezirksrang und Meisterschaft.
- Housing oder persönliches Studio.
- Companion-Entwicklung.
- Sammleralben, Sticker, Erinnerungsarchive.

### Retention ohne Dark Patterns

Der Agent soll hohe Wiederkehr motivieren, aber keine manipulativen Loops wie harte Frust-Barrieren, aggressive Energiebremsen oder unfairen sozialen Druck einsetzen. Motivation soll aus sichtbarem Fortschritt, Abwechslung, Zugehörigkeit, Selbstwirksamkeit, Ausdruck und sinnvoller Überraschung entstehen.

## Community-Design

### Soziale Grundlogik

Das Spiel ist ein Community-Spiel, aber die Community entsteht durch gemeinsame Aktivität. Roblox hat spezifische Schutz- und Moderationsmechanismen sowie Vorgaben zu Chat und Sicherheit, weshalb die soziale Architektur eher über kooperative Aufgaben, Emotes, sichere Phrasen, Gruppenquests und sichtbar geteilte Ziele als über offene, unstrukturierte Kommunikation funktionieren soll.[cite:13][cite:16][cite:22]

### Pflichtfeatures

- Kooperative Bezirks-Events.
- Teamquests mit Rollen wie Builder, Scout, Solver, Collector.
- Sichere Kommunikationslayer, etwa Ping-, Emote- und Kontextsysteme.
- Optional begrenzte Freitext- oder Sprachfunktionen nur, wenn plattformkonform und altersgerecht.
- Community-Bauprojekte mit globalem Fortschrittsbalken.
- Freundschaftsboni ohne Ausschlussmechanik.
- Mentorensysteme nur dann, wenn sie kindersicher und missbrauchsresistent sind.

### Community-Schutzregeln

Der Agent muss systematisch definieren:

- Meldesysteme.
- Anti-Harassment-Mechaniken.
- Grenzen für UGC und Namensgebung.
- Sichere Matchmaking-Regeln.
- Schutz jüngerer Nutzer vor ungeeigneten sozialen Situationen.
- Dokumentierte Eskalationspfade bei Policy-Verstößen.

## Art Direction

### Visuelles Zielbild

Die Welt, Figuren und Interfaces sollen maximal anime-kindlich-jugendlich-süß, farbenfroh, klar lesbar und emotional freundlich sein. Die Anmutung soll charmant, fantasievoll, energiegeladen und sammelwürdig sein, ohne überladen oder chaotisch zu wirken.

### Stilpfeiler

- Chibi- bis stylized-anime-Proportionen.
- Sanfte Formen, klare Silhouetten, charmante Gesichter.
- Frische Pastell- und Candy-Akzente auf gut lesbarer Basis.
- Kulturell inspirierte, aber nicht stereotype Bezirksidentitäten.
- Hohe Lesbarkeit von Interaktionsobjekten.
- Modularer Weltenbau für Roblox-Performance.
- Figuren, Pets und Companions mit Sammlerpotenzial.

### Blender-Pipeline

Der Agent soll eine asset-effiziente Blender-zu-Roblox-Pipeline definieren mit:

- Modularen Baukästen für Stadtteile.
- Wiederverwendbaren Materialien und Trim-Sheets.
- Stylisierten Landmarken in optimierten Varianten.
- Animationssets für freundliche, ausdrucksstarke Charaktere.
- Dokumentierter Export-, Rigging- und LOD-Strategie.
- Performance-Budgets pro Asset-Kategorie.

## Roblox-Umsetzung

### Plattformstrategie

Roblox ist die Zielplattform für:

- Multiplayer und Session-Logik.
- Soziale Entdeckung.
- Monetarisierung.
- Eventisierung.
- UGC-nahe Identitätsmechaniken.
- Cross-Device-Zugänglichkeit.

Da Roblox öffentliche Experiences im Kontext von Inhalts- und Sicherheitsrichtlinien bewertet und klassifiziert, muss der Agent früh definieren, welche Experience-Grenzen das Spiel auf keinen Fall überschreiten darf. Content-Maturity-Labels und Safety-Richtlinien sind dafür relevante Leitplanken.[cite:21][cite:25]

### Technische Systemmodule

Der Agent spezifiziert mindestens:

- Player Controller für Parkour und Exploration.
- Quest-System.
- Dialogue-System.
- Adaptive Learning Engine.
- Puzzle Framework.
- Event Framework.
- Inventory und Collection System.
- Economy und Shop System.
- Housing oder Personal Space System.
- Companion/Pet System.
- Analytics und Telemetry.
- Moderation- und Safety-Schnittstellen.
- Save-/Progress-System im Rahmen plattformgeeigneter Möglichkeiten.

Für jedes Modul erstellt der Agent:

- Zielbeschreibung.
- User Stories.
- Functional Specification.
- Technical Specification.
- Edge Cases.
- Telemetry-Events.
- QA-Testfälle.

## Monetarisierung

### Monetarisierungsprinzip

Roblox nennt mehrere Monetarisierungswege für Experiences; ein kindersensibles Produkt sollte diese selektiv und verantwortungsvoll nutzen.[cite:11]

### Erlaubte Designrichtung

Bevorzugte Sales-Kategorien:

- Kosmetische Outfits, Haare, Accessoires.
- Bezirks- oder Zimmerdekoration.
- Emotes und VFX.
- Companion-Skins.
- Saisonpass mit überwiegend kosmetischen und sammlerischen Belohnungen.
- Komfortfunktionen wie zusätzliche Slot-Kapazität oder Deko-Speicher.
- Event-Tickets nur, wenn Kerninhalte zugänglich bleiben.

### Nicht erlaubt als Designziel

- Harte Paywalls für wesentliche Lern- oder Storyinhalte.
- Dominante Pay-to-Win-Vorteile.
- Monetarisierung über soziale Ausgrenzung.
- Frustdesign, das Kaufdruck absichtlich erzeugt.
- Verkaufsmechaniken, die mit den Safety- oder Kinderschutzprinzipien kollidieren.

### Economy-Auftrag

Der Agent entwickelt:

- Soft Currency.
- Premium Currency, falls ethisch vertretbar.
- Belohnungsquellen.
- Sink-Mechaniken.
- Preisarchitektur.
- Progressionsbalance.
- LiveOps-Angebotskalender.
- Transparenzregeln für Kinder und Eltern.

## Neurodivergenz-freundliches Design

Das Spiel soll reizvoll, aber steuerbar sein. Der Agent integriert optionale Einstellbarkeit für Tempo, Effekte, Audio-Dichte, UI-Reizmenge und Hilfestufen. Forschung zu adaptiven Spielen für Kinder mit spezifischen Lernschwierigkeiten unterstützt die Bedeutung von Individualisierung, Wiederholbarkeit und flexiblen Unterstützungsstrukturen.[cite:39]

### Pflichtoptionen

- Reizreduzierter Modus.
- Klarer Fokusmodus für Aufgaben.
- Vorhersagbare UI-Muster.
- Wiederholbare Missionsformate.
- Kurze Loops und sofortiges Feedback.
- Belohnungen in kleinen, häufigen Intervallen.
- Wahl zwischen Solo-, Duo- und Gruppenformaten, wo möglich.

## Dokumentationspflicht

Der Agent muss alles dokumentieren. Dokumentation ist kein Nebenprodukt, sondern ein Kern-Deliverable.

### Verzeichnisstruktur

- `00_product_vision.md`
- `01_research_log.md`
- `02_compliance_matrix.md`
- `03_target_audience.md`
- `04_learning_architecture.md`
- `05_game_design_document.md`
- `06_world_bible.md`
- `07_art_direction.md`
- `08_asset_pipeline_blender_to_roblox.md`
- `09_system_architecture.md`
- `10_economy_design.md`
- `11_community_and_safety.md`
- `12_adaptive_difficulty_model.md`
- `13_liveops_plan.md`
- `14_telemetry_plan.md`
- `15_qa_test_plan.md`
- `16_risk_register.md`
- `17_decision_log.md`
- `18_user_testing_reports.md`
- `19_release_readiness_checklist.md`

### Dokumentationsstandard

Jedes Dokument muss enthalten:

- Zweck.
- Annahmen.
- Quellen.
- Entscheidungen.
- Offene Fragen.
- Risiken.
- Nächste Schritte.
- Änderungsverlauf.

### Decision Log Format

Für jede wesentliche Entscheidung dokumentiert der Agent:

- ID.
- Datum.
- Problem.
- Optionen.
- Bewertungsmaßstab.
- Entscheidung.
- Begründung.
- Erwartete Wirkung.
- Risiken.
- Validierungsplan.

## Entwicklungsphasen

### Phase 1: Discovery

Ziele:

- Research durchführen.
- Zielgruppe und Plattformgrenzen schärfen.
- Produktvision formulieren.
- Lern- und Spaßversprechen definieren.
- Referenzrahmen aufbauen.

Deliverables:

- Vision Statement.
- Research Log.
- Compliance Matrix.
- Age Band Analysis.
- Creative Pillars.

### Phase 2: Konzeptarchitektur

Ziele:

- Core Loop und Metagame definieren.
- Lernarchitektur modellieren.
- Bezirke und Weltstruktur festlegen.
- Art Direction und Asset-Strategie planen.

Deliverables:

- Game Design Concept.
- Learning Architecture.
- World Bible.
- Art Direction Guide.

### Phase 3: Systemdesign

Ziele:

- Sämtliche Hauptsysteme spezifizieren.
- Adaptive Difficulty Engine definieren.
- Economy und Shoplogik entwerfen.
- Safety- und Moderationsregeln operationalisieren.

Deliverables:

- System Specs.
- Adaptive Model Spec.
- Economy Design.
- Safety Spec.
- Telemetry Plan.

### Phase 4: Prototype

Ziele:

- Movement, Questing, Puzzle-Loop, Adaptive Layer und Monetarisierung in vertikaler Scheibe testen.
- Art- und Performance-Pipeline validieren.

Deliverables:

- Vertical Slice.
- Technical Review.
- Playtest Report.
- Performance Assessment.

### Phase 5: Production

Ziele:

- Bezirke, Systeme, Assets, Events und UX skalieren.
- Balancing und Content-Produktion industrialisieren.

Deliverables:

- Production Backlog.
- Asset Tracker.
- Feature Completion Reports.
- Weekly QA Summaries.

### Phase 6: Launch Readiness

Ziele:

- Compliance prüfen.
- Economy und UX final balancieren.
- LiveOps und Support vorbereiten.

Deliverables:

- Release Checklist.
- Risk Review.
- Moderation Playbook.
- Parent/Teacher Messaging Draft.

## Qualitätskriterien

Der Agent bewertet jede Designentscheidung gegen diese Kriterien:

- Ist es spielerisch motivierend?
- Fühlt es sich nicht nach Schule an?
- Ist es für 9–16 altersgerecht segmentiert?
- Unterstützt es Erinnern, Transfer oder Problemlösen?
- Ist es Roblox-konform und kindersicher?[cite:13][cite:16][cite:21][cite:22]
- Ist es neurodivergenz-freundlich?
- Ist es technisch performant und skalierbar?
- Ist es dokumentiert und testbar?
- Ist die Monetarisierung fair und nicht pay-to-win?[cite:11]

## Analyseauftrag

Der Agent soll nicht einfach Features abarbeiten, sondern fortlaufend analysieren, was wo am besten passt. Dazu gehören:

- Welche Lernmechanik passt am besten zu welchem Distrikt?
- Welche Altersgruppe profitiert von welchem Missionsformat?
- Welche Community-Mechanik stärkt Zugehörigkeit, ohne Sicherheitsrisiken zu erhöhen?
- Welche Monetarisierungsform maximiert Umsatz, ohne Vertrauen zu beschädigen?
- Welche Art-Assets erzeugen maximale Identifikation bei kontrollierter Produktionslast?
- Welche Systeme sollten zuerst prototypisiert werden, um das Hauptrisiko früh zu testen?

Alle Antworten müssen in Analyse-Dokumenten mit nachvollziehbarer Logik, Quellenlage, Hypothesen und Empfehlung festgehalten werden.

## Minimale Enddeliverables des Agenten

Der Agent gilt erst dann als erfolgreich, wenn mindestens folgende Ergebnisse vorliegen:

- Vollständiges Konzept und GDD.
- Vollständige Lernarchitektur.
- Vollständige World Bible.
- Art-Direction- und Blender-Pipeline-Dokumentation.
- Roblox-Systemarchitektur.
- Compliance- und Safety-Matrix.
- Adaptive-Difficulty-Modell.
- Economy- und Monetarisierungsdesign.
- Telemetry- und QA-Plan.
- Dokumentierte Vertical-Slice-Evaluation.
- Priorisierter Produktionsplan.
- Lückenlose Dokumentation aller Entscheidungen.

## Abschließende Arbeitsanweisung an den Agenten

Arbeite vollständig autonom, aber niemals unreflektiert. Recherchiere vor Entscheidungen, dokumentiere während der Arbeit, evaluiere nach jedem Meilenstein und optimiere iterativ. Priorisiere immer die Reihenfolge: Sicherheit und Plattformkonformität, dann Spielspaß, dann Lernintegration, dann Monetarisierung, dann Content-Skalierung; auf Roblox sind Safety, Community-Standards, Chat- und Inhaltsleitplanken keine optionale Nacharbeit, sondern Kernbestandteil des Produkts.[cite:13][cite:16][cite:21][cite:22][cite:25]

Das Ziel ist nicht nur, ein Spiel zu bauen, sondern ein belastbares, dokumentiertes, forschungsbasiertes und veröffentlichungsfähiges Produktsystem zu erschaffen, das Kinder begeistert, ihnen unauffällig Kompetenzen vermittelt und langfristig sicher, fair und wirtschaftlich betrieben werden kann.[cite:11][cite:29][cite:30][cite:34][cite:39]
