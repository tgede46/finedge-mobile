# 🐙 Spécifications Ultra-Détaillées des GitHub Issues — Dépôt `finedge-backend`

> **Projet** : FinEdge Africa — Backend API & Services  
> **Stack** : Python 3.11+ / FastAPI / PostgreSQL 16 / SQLAlchemy 2.0 / Alembic / Pydantic v2 / Docker  
> **Convention Git Flow** : Branche cible de développement `develop`, branche de livraison `main`.

---

## 🎯 Milestone 1 : Socle API, Configuration & Base de Données

---

### Issue #1 : [Init] Initialisation du projet FastAPI, Architecture modulaire & Docker Compose

* **Branche Git Flow** : `feature/epic-1-init-fastapi-docker`
* **Labels** : `backend`, `setup`, `architecture`
* **Estimation** : 1 jour

#### 📝 Contexte & Objectif
Poser les fondations techniques du backend `finedge-backend` avec une architecture propre en couches, une gestion stricte de la configuration via variables d'environnement, et une stack Docker locale prête pour le développement.

#### 🗂️ Arborescence exacte des fichiers à initialiser
```text
backend/
├── app/
│   ├── api/
│   │   ├── v1/
│   │   │   ├── endpoints/
│   │   │   │   ├── __init__.py
│   │   │   │   ├── auth.py            # Auth, MFA modulaire, RBAC
│   │   │   │   ├── health.py          # GET /healthz
│   │   │   │   ├── cms.py             # CRUD cours pour formateurs
│   │   │   │   ├── sync.py            # Synchro offline
│   │   │   │   └── mascot.py          # Passerelle IA
│   │   │   └── api.py                 # Router principal V1
│   │   └── __init__.py
│   ├── core/
│   │   ├── __init__.py
│   │   ├── config.py                  # Settings Pydantic v2 (.env)
│   │   └── security.py                # Hash Argon2/Bcrypt, JWT, TOTP MFA
│   ├── db/
│   │   ├── __init__.py
│   │   └── session.py                 # AsyncSession SQLAlchemy & engine
│   ├── models/
│   │   └── __init__.py
│   ├── schemas/
│   │   └── __init__.py
│   ├── services/
│   │   ├── pii_anonymizer.py          # Filtrage PII Regex
│   │   └── ai_client.py               # Client HTTP vers API Équipe IA
│   └── main.py                        # Point d'entrée FastAPI, CORS, middlewares
├── .env.example
├── .gitignore
├── Dockerfile
├── docker-compose.yml
├── requirements.txt
└── README.md
```

---

### Issue #2 : [Database] Schéma Relationnel PostgreSQL 16, Modèles SQLAlchemy 2.0 & Alembic

* **Branche Git Flow** : `feature/epic-1-database-schema-alembic`
* **Labels** : `backend`, `database`, `sql`
* **Estimation** : 1.5 jours

#### 🗄️ Schéma SQL & Modèles à implémenter

```mermaid
erDiagram
    USERS ||--o{ USER_PROGRESS : tracks
    USERS ||--o| USER_STREAKS : owns
    USERS ||--o{ AI_CHAT_LOGS : generates
    USERS ||--o| USER_MFA_CONFIG : configures
    COURSE_PATHS ||--o{ MODULES : contains
    MODULES ||--o{ LESSONS : contains
    LESSONS ||--o{ USER_PROGRESS : records

    USERS {
        uuid id PK
        string email UK "Optionnel / Admins"
        string phone_hash UK "Index hashé SHA-256"
        string role "learner | pedagogy_trainer | marketing_growth | super_admin"
        string auth_provider "guest | phone_otp | email_password"
        string profile_type "merchant | salary | student"
        int total_xp "Points cumulés"
        datetime created_at
        datetime updated_at
    }

    USER_MFA_CONFIG {
        uuid user_id PK_FK
        boolean is_mfa_enabled "Choix libre de l'utilisateur"
        string totp_secret "Optionnel (Google/Microsoft Auth)"
        boolean sms_otp_enabled "Optionnel"
        boolean whatsapp_otp_enabled "Optionnel"
        boolean email_otp_enabled "Optionnel"
    }

    COURSE_PATHS {
        uuid id PK
        string slug UK
        string title "ex: Fondamentaux du Commerce"
        int order_index
        boolean is_published
    }

    MODULES {
        uuid id PK
        uuid path_id FK
        string title "ex: Gérer sa Caisse de Pagnes"
        int reward_xp "Points attribués (ex: 150 XP)"
        int order_index
    }

    LESSONS {
        uuid id PK
        uuid module_id FK
        string type "theory | quiz | comic_scenario"
        string title
        jsonb content_payload "Contenu fiches, questions, dialogues BD"
        int order_index
        int content_version "Numéro de version incrémentale"
    }

    USER_PROGRESS {
        uuid id PK
        uuid user_id FK
        uuid lesson_id FK
        string status "locked | active | completed"
        int stars "0 à 3 étoiles"
        datetime completed_at
    }

    USER_STREAKS {
        uuid user_id PK_FK
        int current_streak "Flammes de jours consécutifs"
        int longest_streak
        date last_activity_date
    }

    AI_CHAT_LOGS {
        uuid id PK
        uuid user_id FK "Optionnel / Nullable"
        text anonymized_prompt "Message sans PII"
        text response_text
        string category_detected "epargne | commerce | mobile_money"
        int response_latency_ms
        int user_feedback "1 (positif) ou -1 (négatif)"
        datetime created_at
    }
```

---

### Issue #3 : [Auth & MFA] Authentification, MFA Flexible au Choix & RBAC

* **Branche Git Flow** : `feature/epic-1-auth-flexible-mfa-rbac`
* **Labels** : `backend`, `auth`, `mfa`, `rbac`
* **Estimation** : 1.5 jours

#### 📝 Contexte & Objectif
Implémenter l'authentification avec support de **MFA modulaire à la carte** (l'utilisateur ou l'admin choisit les facteurs qu'il active, ou aucun) et contrôle d'accès basé sur les rôles (**RBAC**).

#### 🔌 Endpoints Spécifiés
* `POST /api/v1/auth/guest` : Session invité instantanée (sans mot de passe).
* `POST /api/v1/auth/login` : Connexion mot de passe ou téléphone OTP.
* `POST /api/v1/auth/mfa/setup` : Activation/désactivation des méthodes MFA (TOTP, WhatsApp, SMS, Email).
* `POST /api/v1/auth/mfa/verify` : Validation du second facteur lors du login.

---

## 🎯 Milestone 2 : API CMS & Synchronisation Hors-Ligne

---

### Issue #4 : [CMS API] Endpoints REST pour la Gestion des Cours & Scénarios BD
* **Branche Git Flow** : `feature/epic-5-cms-api-courses`
* **Labels** : `backend`, `cms`, `api`

### Issue #5 : [Sync Engine] Moteur de Synchronisation Offline-First & Résolution de Conflits
* **Branche Git Flow** : `feature/epic-2-offline-sync-engine`
* **Labels** : `backend`, `sync`, `offline-first`

---

## 🎯 Milestone 3 : Passerelle Mascotte IA & Contrat Équipe IA

---

### Issue #6 : [AI Gateway] Service de Filtrage Regex PII & Contextualisation Mascotte
* **Branche Git Flow** : `feature/epic-4-ai-pii-anonymizer`
* **Labels** : `backend`, `ai`, `security`

### Issue #7 : [AI Client] Client HTTP Asynchrone vers l'API de l'Équipe IA Dédiée
* **Branche Git Flow** : `feature/epic-4-ai-team-http-client`
* **Labels** : `backend`, `ai`, `integration`

### Issue #8 : [AI Logs] Journalisation Anonymisée & Export des Données pour l'Équipe IA
* **Branche Git Flow** : `feature/epic-5-ai-logs-export`
* **Labels** : `backend`, `analytics`, `ai`
