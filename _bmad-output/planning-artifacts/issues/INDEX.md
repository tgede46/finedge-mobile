# 📋 Registre Général des Issues & Branches Git Flow — FinEdge Africa

Convention Git Flow pour tous les dépôts :
* Branche de production : `main`
* Branche d'intégration : `develop`
* Format des branches : `feature/epic-{N}-story-{M}-{nom-court}`

---

## 🐙 Les 3 Dépôts GitHub du Projet

**Chantier actuel** : l'app mobile se construit **dans ce dépôt** (`findge`). Backend et admin restent des dépôts séparés.

| Dépôt GitHub | Stack Technologique | Rôle Principal | Fichier des Spécifications |
| :--- | :--- | :--- | :--- |
| **`finedge-backend`** | FastAPI, PostgreSQL 16, Alembic, Docker | API REST, Moteur Sync, MFA, Passerelle IA | 📄 [`BACKEND_GITHUB_ISSUES.md`](BACKEND_GITHUB_ISSUES.md) |
| **`finedge-admin`** | Next.js 16, Tailwind, shadcn/ui, TanStack | Landing Page, CMS Miroir BD, Multi-Rôles, Analytics | 📄 [`ADMIN_GITHUB_ISSUES.md`](ADMIN_GITHUB_ISSUES.md) |
| **`findge` (ce dépôt = mobile)** | Flutter 3.x, MVC MVP, Matt Font | App Grand Public, Sentier, BD Vente de Pagnes | 📄 [`MOBILE_GITHUB_ISSUES.md`](MOBILE_GITHUB_ISSUES.md) |

---

## 🎯 Synthèse des 21 Issues Prêtes à Déployer

### 1. `finedge-backend` (8 Issues)
* **#1** : [Init] Initialisation FastAPI, Architecture Modulaire & Docker Compose
* **#2** : [DB] Schéma PostgreSQL 16 (Users, MFA, Roles, Lessons, Progress) & Alembic
* **#3** : [Auth & MFA] Service d'Auth, MFA Modulaire à la carte & Contrôle RBAC
* **#4** : [CMS API] Endpoints REST pour la Gestion des Cours & Scénarios BD
* **#5** : [Sync Engine] Moteur de Synchronisation Offline-First & Conflits
* **#6** : [AI Gateway] Service de Filtrage Regex PII & Contextualisation Mascotte
* **#7** : [AI Client] Client HTTP Async vers l'API de l'Équipe IA Dédiée
* **#8** : [AI Logs] Journalisation Anonymisée & Export pour l'Équipe IA

### 2. `finedge-admin` (7 Issues)
* **#0** : [Landing] Vitrine Publique Fintech & Présentation de la Plateforme
* **#1** : [Setup] Next.js 16, Tailwind Fintech (Orange/Marron/Blanc), Matt & shadcn/ui
* **#2** : [Auth & MFA] Connexion avec MFA Flexible au Choix & Redirection RBAC
* **#3** : [Espace Formateur] CMS No-Code des Leçons, Parcours & Quiz
* **#4** : [Espace Formateur BD] Éditeur de Scénarios BD avec Miroir Mobile en Direct
* **#5** : [Espace Marketing] Dashboard Analytics, Rétention & Campagnes
* **#6** : [Espace Super Admin] Supervision des Échanges IA & Export Équipe IA

### 3. `finedge-mobile` (8 Issues)
* **#1** : [Init] Initialisation Flutter 3.x, Tokens Fintech (Orange/Marron/Blanc), Police Matt & Barre 4 Onglets
* **#2** : [Onboarding] Diagnostic Initial (<60s), Mode Invité Persistant & MFA Flexible à la Carte
* **#3** : [Path] Composant Sentier de Progression Vertical avec Nœuds 3D & Coffres de Chapitres
* **#4** : [Lessons] Lecteur de Fiches Pédagogiques, Lecteur Audio Vocal & Quiz Interactif
* **#5** : [Gamification] Moteur d'XP, Flammes de Séries Quotidiennes (Streaks) & Système de Trophées
* **#6** : [Simulator BD] Simulateur de Vente de Pagnes en Format Visual Novel avec Cockpit Caisse & Choix Tactiles
* **#7** : [Offline-First] Moteur de Persistance Locale Isar & Synchronisation Automatique
* **#8** : [Mascot AI] Interface de Chat avec la Mascotte Animée & Carrousel de Pilules de Questions Rapides
