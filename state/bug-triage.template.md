# Bug-Triage — Stand {{TIMESTAMP}}

## Offene Bugs (sortiert nach Severity)

### S1 — Sicherheit / Datenverlust (sofort fixen)
| ID | Kurz | Owner | Status | ETA |
|---|---|---|---|---|
| {{BUG_ID}} | {{TEXT}} | {{WHO}} | {{STATUS}} | {{ETA}} |

### S2 — Hauptmechanik kaputt (heute)
| ID | Kurz | Owner | Status | ETA |
|---|---|---|---|---|
| {{BUG_ID}} | {{TEXT}} | {{WHO}} | {{STATUS}} | {{ETA}} |

### S3 — Sekundärmechanik / Polish (diese Woche)
| ID | Kurz | Owner | Status | ETA |
|---|---|---|---|---|
| {{BUG_ID}} | {{TEXT}} | {{WHO}} | {{STATUS}} | {{ETA}} |

### S4 — Cosmetic / Nice-to-have (Backlog)
| ID | Kurz | Owner | Status |
|---|---|---|---|
| {{BUG_ID}} | {{TEXT}} | {{WHO}} | {{STATUS}} |

### S5 — Won't fix / by design
| ID | Grund |
|---|---|
| {{BUG_ID}} | {{TEXT}} |

## Reproduktions-Schritte (für jeden S1/S2 Bug)
**Bug {{ID}}:**
1. {{STEP_1}}
2. {{STEP_2}}
3. {{EXPECTED}} → {{ACTUAL}}

## Eskalationen
- {{BUG_ID}} → eskaliert an {{HUMAN_OR_LOOP}} wegen {{REASON}}

---

**Heartbeat:** Bug-Heartbeat | **Loop:** B | **Trigger:** on-bug-report
**Sub-Agents:** Triage-Agent (Maker) + Code-Reviewer (Checker)
**Stop:** Bug triagiert + Owner zugewiesen, oder 8 Iterationen ohne Konsens