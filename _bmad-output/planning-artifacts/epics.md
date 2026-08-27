---
stepsCompleted: [step-01-validate-prerequisites, step-02-design-epics, step-03-create-stories, step-04-final-validation]
inputDocuments:
  - _bmad-output/planning-artifacts/prd.md
  - _bmad-output/planning-artifacts/architecture.md
  - _bmad-output/planning-artifacts/DESIGN.md
  - _bmad-output/planning-artifacts/EXPERIENCE.md
---

# FinEdge Africa - Epic Breakdown

## Overview

This document provides the complete epic and story breakdown for FinEdge Africa, decomposing the requirements from the PRD, UX Design specifications, and Architecture decisions into implementable, testable stories for development.

## Requirements Inventory

### Functional Requirements

- **FR-ONB-01** : Questionnaire d'accueil express (3 questions max) : profil d'activité (commerçant, salarié, étudiant), objectif prioritaire (épargne, commerce, mobile money), rythme quotidien.
- **FR-ONB-02** : Création de compte simplifiée par numéro de téléphone OTP (SMS/WhatsApp) et mode invité persistant.
- **FR-ONB-03** : Génération dynamique d'une feuille de route d'apprentissage personnalisée basée sur les réponses de l'onboarding.
- **FR-LRN-01** : Moteur de micro-leçons (2 à 4 min) avec fiches illustrées, explications et QCM interactifs.
- **FR-LRN-02** : Système de récompenses & gamification : Points XP, badges de maîtrise, séries de jours consécutifs (Daily Streaks).
- **FR-LRN-03** : Support audio / synthèse vocale pour écoute des leçons.
- **FR-LRN-04** : Thématiques pédagogiques contextualisées Afrique de l'Ouest : Franc CFA (XOF), Mobile Money (Wave, Orange, MTN, Moov), Tontines, gestion de cahier de caisse.
- **FR-SIM-01** : Scénario initial de commerce (Boutique de pagnes / Kiosque) avec état de caisse et de stock.
- **FR-SIM-02** : Boucle de jeu par journées : achat de stock grossiste, fixation des prix, vente au comptant vs crédit client.
- **FR-SIM-03** : Événements aléatoires réalistes (intempéries, fêtes saisonnières, demandes d'emprunt familial).
- **FR-SIM-04** : Débriefing pédagogique automatique à chaque fin de cycle de simulation avec conseils concrets.
- **FR-AIA-01** : Interface de messagerie conversationnelle avec la Mascotte disponible 24/7.
- **FR-AIA-02** : Contextualisation des réponses au profil de l'utilisateur (niveau, devise XOF, objectifs).
- **FR-AIA-03** : Garde-fous éthiques et conformité (interdiction de conseil spéculatif/boursier, rappel du rôle purement pédagogique).
- **FR-AIA-04** : Support des suggestions rapides de questions (pilules à une touche).
- **FR-ADM-01** : CMS No-Code pour créer, modifier, ordonner et publier les cours, quiz et scénarios du simulateur sans redéploiement technique.
- **FR-ADM-02** : Tableau de bord Analytics : DAU/MAU, taux de complétion par leçon, taux d'abandon, métriques de gamification.
- **FR-ADM-03** : Cockpit de supervision et export des requêtes anonymisées pour l'équipe IA.

### NonFunctional Requirements

- **NFR-PERF-01** : Taille du binaire mobile APK < 25-30 Mo pour téléchargement fluide sur réseaux 3G/4G.
- **NFR-OFF-02** : Mode Offline-First complet : leçons et simulateur 100% jouables sans connexion, synchronisation automatique en tâche de fond.
- **NFR-SEC-03** : Chiffrement HTTPS/TLS en transit et au repos, anonymisation automatique des PII (téléphones, montants personnels).
- **NFR-REL-04** : Disponibilité backend & back-office > 99.5%.

### Additional Requirements (Architecture)

- **ARCH-01** : Application Mobile développée en Flutter 3.x avec base locale Isar/Drift pour persistance Offline-First.
- **ARCH-02** : Backend API développé en FastAPI asynchrone (Python 3.11+) avec validation Pydantic V2.
- **ARCH-03** : Base de données relationnelle PostgreSQL 16 auto-hébergée avec modèles SQLAlchemy 2.0 et migrations Alembic.
- **ARCH-04** : Passerelle HTTP client vers l'API de l'équipe IA dédiée (GET/POST avec contexte et masquage PII).
- **ARCH-05** : Back-office d'administration Web en Next.js (App Router, Tailwind CSS, TypeScript) avec prévisualisation miroir sur mobile.
- **ARCH-06** : Protocole de synchronisation avec résolution de conflit Max-Progress et addition associative des XP.

### UX Design Requirements

- **UX-DR01** : Design System complet basé sur la couleur signature fusionnée Orange-Marron (#D95A1E), le dégradé signature (#FF6B00 vers #7B3E19) et le Blanc pur (#FFFFFF).
- **UX-DR02** : Typographie intégrée Matt Complete Family (Matt Bold, Medium, Regular) avec polices tabulaires pour montants FCFA.
- **UX-DR03** : Composant Sentier de progression vertical (Duolingo-style) avec nœuds 3D animés, états (verrouillé, actif, complété) et coffres de chapitre.
- **UX-DR04** : Interface du Simulateur de Commerce en BD Interactive (Visual Novel) : scène illustrée, bulle de dialogue personnage, touches de choix d'actions tactiles et cockpit de caisse flottant.
- **UX-DR05** : Interface de Chat avec la Mascotte animée bienveillante (Koko le Calao / Kini le Caméléon) et carrousel de pilules de questions rapides.
- **UX-DR06** : Navigation principale mobile à 4 onglets fixes (Accueil/Sentier, Simulateur BD, Mascotte Coach, Profil & Trophées).
- **UX-DR07** : Onboarding immersif en 3 étapes (< 60 secondes) sans blocage d'inscription immédiat.
- **UX-DR08** : Composant d'aperçu smartphone en miroir temps réel dans l'éditeur de cours Next.js.

---

### FR Coverage Map

* **FR-ONB-01** : Epic 1 (Story 1.2) - Questionnaire de diagnostic initial
* **FR-ONB-02** : Epic 1 (Story 1.3) - Authentification OTP & persistance mode invité
* **FR-ONB-03** : Epic 1 (Story 1.2) - Génération dynamique du sentier personnalisé
* **FR-LRN-01** : Epic 2 (Story 2.2) - Moteur de micro-leçons et quiz interactifs
* **FR-LRN-02** : Epic 2 (Story 2.3) - Système de gamification (XP, streaks, badges)
* **FR-LRN-03** : Epic 2 (Story 2.2) - Support audio des leçons
* **FR-LRN-04** : Epic 2 (Story 2.2) - Contenus pédagogiques Afrique de l'Ouest (CFA, Mobile Money)
* **FR-SIM-01** : Epic 3 (Story 3.1) - Modèle d'état du commerce (caisse, stock de pagnes)
* **FR-SIM-02** : Epic 3 (Story 3.2) - Boucle de simulation journalière
* **FR-SIM-03** : Epic 3 (Story 3.3) - Moteur d'événements aléatoires et crédits
* **FR-SIM-04** : Epic 3 (Story 3.4) - Débriefing pédagogique automatisé
* **FR-AIA-01** : Epic 4 (Story 4.1) - Interface de messagerie avec la Mascotte
* **FR-AIA-02** : Epic 4 (Story 4.2) - Contextualisation des requêtes au profil
* **FR-AIA-03** : Epic 4 (Story 4.2) - Masquage regex PII & Guardrails
* **FR-AIA-04** : Epic 4 (Story 4.1) - Pilules de questions rapides
* **FR-ADM-01** : Epic 5 (Story 5.1) - CMS No-Code des leçons
* **FR-ADM-02** : Epic 5 (Story 5.3) - Tableau de bord Analytics d'usage
* **FR-ADM-03** : Epic 5 (Story 5.3) - Cockpit & export des requêtes pour l'équipe IA

---

## Epic List

### Epic 1: Fondations, Onboarding & Parcours Personnalisé
Permettre à un nouvel utilisateur d'installer l'application, de réaliser le diagnostic d'accueil (< 60s), de générer son sentier d'apprentissage personnalisé et de créer/lier son profil (Mode invité / OTP).
**FRs couverts:** FR-ONB-01, FR-ONB-02, FR-ONB-03.

### Epic 2: Micro-Learning, Gamification & Mode Hors-Ligne (Sentier Duolingo-like)
Permettre à l'utilisateur de progresser sur son sentier d'apprentissage, d'effectuer des micro-leçons et quiz contextualisés (XOF, Mobile Money, épargne), de gagner des points XP, maintenir sa série quotidienne (streak) et continuer à jouer 100% hors-ligne avec synchronisation automatique.
**FRs couverts:** FR-LRN-01, FR-LRN-02, FR-LRN-03, FR-LRN-04.

### Epic 3: Simulateur de Commerce Narratif (BD Interactive - Vente de Pagnes)
Permettre à l'utilisateur d'incarner un petit commerçant, de vivre des scènes de vente interactives sous forme de BD (choix tactiles, aléas de crédit client, gestion de caisse et stock sans risque réel) et de recevoir un débriefing pédagogique immédiat.
**FRs couverts:** FR-SIM-01, FR-SIM-02, FR-SIM-03, FR-SIM-04.

### Epic 4: Assistant Financier Conversationnel (Mascotte & Passerelle HTTP IA)
Permettre à l'utilisateur de poser des questions financières à tout moment à la Mascotte FinEdge, recevoir des conseils vulgarisés contextualisés (CFA/Mobile Money) via l'API de l'équipe IA dédiée avec masquage automatique des données privées.
**FRs couverts:** FR-AIA-01, FR-AIA-02, FR-AIA-03, FR-AIA-04.

### Epic 5: Plateforme d'Administration CMS & Cockpit Équipe (Back-Office Web)
Permettre à l'équipe pédagogique et produit d'éditer les leçons et scénarios BD avec prévisualisation miroir sur mobile, de suivre les statistiques d'usage et d'exporter les requêtes anonymisées pour aider l'équipe IA.
**FRs couverts:** FR-ADM-01, FR-ADM-02, FR-ADM-03.

---

## Epic 1: Fondations, Onboarding & Parcours Personnalisé

Permettre à un nouvel utilisateur d'installer l'application, de réaliser le diagnostic d'accueil (< 60s), de générer son sentier d'apprentissage personnalisé et de créer/lier son profil (Mode invité / OTP).

### Story 1.1: Initialisation du Projet Mobile Flutter & Design System FinEdge
As a développeur mobile,
I want initialiser l'application Flutter avec les tokens de design FinEdge (Couleur Orange-Marron `#D95A1E`, Dégradé `#FF6B00 ➔ #7B3E19`, Blanc `#FFFFFF`, Police `Matt` et barre de 4 onglets),
So that toute l'interface repose sur des fondations graphiques cohérentes et fluides.

**Acceptance Criteria:**
**Given** l'application Flutter démarrée sur un appareil ou émulateur
**When** l'écran principal s'affiche
**Then** le thème visuel applique fidèlement la couleur Orange-Marron, le dégradé signature et la typographie `Matt`
**And** la barre de navigation inférieure présente 4 onglets fixes (Parcours, Simulateur, Coach IA, Profil) conformes à UX-DR06.

### Story 1.2: Questionnaire de Diagnostic Initial & Génération du Sentier Personnalisé
As a nouvel utilisateur,
I want répondre à 3 questions simples sur mon activité, mon objectif financier et mon temps disponible,
So that l'application génère immédiatement une feuille de route adaptée à ma situation personnelle.

**Acceptance Criteria:**
**Given** un utilisateur ouvrant l'application pour la première fois
**When** il répond aux 3 étapes du questionnaire (ex: Commerçant, Objectif Épargne & Caisse, 5 min/jour)
**Then** le diagnostic est complété en moins de 60 secondes sans obliger à la saisie d'un mot de passe
**And** le sentier pédagogique s'organise avec le premier nœud actif correspondant à son besoin prioritaire.

### Story 1.3: Authentification par Numéro de Téléphone OTP & Mode Invité Persistant
As a utilisateur régulier,
I want pouvoir utiliser l'application directement en mode invité ou lier mon compte par un numéro de téléphone avec code OTP,
So that mes progrès soient conservés localement et synchronisables en toute sécurité.

**Acceptance Criteria:**
**Given** un utilisateur en mode invité souhaitant sécuriser sa progression
**When** il renseigne son numéro de téléphone pour recevoir un code OTP
**Then** le backend FastAPI valide le code et associe son historique local au compte sans perdre ses points
**And** le numéro de téléphone est stocké sous forme hashée conforme aux exigences de sécurité NFR-SEC-03.

---

## Epic 2: Micro-Learning, Gamification & Mode Hors-Ligne (Sentier Duolingo-like)

Permettre à l'utilisateur de progresser sur son sentier d'apprentissage, d'effectuer des micro-leçons et quiz contextualisés (XOF, Mobile Money, épargne), de gagner des points XP, maintenir sa série quotidienne (streak) et continuer à jouer 100% hors-ligne avec synchronisation automatique.

### Story 2.1: Composant Sentier de Progression Vertical (Duolingo-Style)
As a apprenant,
I want voir mon sentier d'apprentissage sous forme de chemin vertical sinueux avec des étapes débloquées, actives et verrouillées,
So that je visualise clairement ma progression et mes prochains défis.

**Acceptance Criteria:**
**Given** l'écran d'accueil ouvert
**When** l'utilisateur fait défiler le sentier vertical
**Then** les nœuds s'affichent avec leur état distinct (Actif en dégradé Orange-Marron animé, Complété avec 3 étoiles dorées, Verrouillé avec cadenas)
**And** chaque fin de chapitre affiche un coffre de récompense cliquable.

### Story 2.2: Lecteur de Micro-Leçon & Moteur de Quiz Interactif
As a apprenant,
I want lire ou écouter des fiches concrètes de 3 minutes et répondre à des quiz interactifs sur le Mobile Money et la gestion d'argent en FCFA,
So that j'acquiers des réflexes financiers pratiques et applicables immédiatement.

**Acceptance Criteria:**
**Given** une leçon sélectionnée sur le sentier
**When** l'utilisateur fait défiler les fiches explicatives et valide sa réponse au quiz
**Then** un retour sonore et visuel immédiat confirme la bonne réponse (vert éclatant + confettis) ou explique l'erreur avec bienveillance
**And** le lecteur audio permet d'écouter la version parlée de la fiche.

### Story 2.3: Système de Gamification (Points XP, Flammes de Séries / Streaks & Trophées)
As a utilisateur motivé,
I want gagner des points XP et voir ma flamme de série quotidienne augmenter chaque jour où je termine une leçon,
So that je reste engagé sur la durée pour développer une habitude financière solide.

**Acceptance Criteria:**
**Given** une micro-leçon ou un quiz complété avec succès
**When** l'écran de fin de session apparaît
**Then** le compteur d'XP s'incrémente (ex: +50 XP) avec animation
**And** la flamme de streak s'allume pour le jour en cours
**And** si un palier est atteint (ex: 7 jours de suite), le badge correspondant se débloque sur l'onglet Profil.

### Story 2.4: Moteur de Persistance Locale Isar & Synchronisation Automatique
As a utilisateur souvent en déplacement sans connexion internet,
I want pouvoir suivre mes leçons et enregistrer mes progrès hors-ligne,
So that l'application fonctionne parfaitement partout et synchronise mes données dès le retour du réseau.

**Acceptance Criteria:**
**Given** l'appareil en mode avion / sans réseau
**When** l'utilisateur complète une ou plusieurs leçons
**Then** les progrès, points XP et états sont immédiatement sauvegardés dans la base locale Isar
**And** dès la restauration d'une connexion Internet, le moteur de sync envoie le delta au backend FastAPI sans intervention manuelle.

---

## Epic 3: Simulateur de Commerce Narratif (BD Interactive - Vente de Pagnes)

Permettre à l'utilisateur d'incarner un petit commerçant, de vivre des scènes de vente interactives sous forme de BD (choix tactiles, aléas de crédit client, gestion de caisse et stock sans risque réel) et de recevoir un débriefing pédagogique immédiat.

### Story 3.1: Cockpit du Commerce & Modèle de Données Économique
As a joueur commerçant,
I want consulter l'état de mon commerce (Solde de caisse en FCFA, stock de pagnes restants et dettes en cours),
So that j'ai une vision limpide de ma santé financière avant de prendre des décisions.

**Acceptance Criteria:**
**Given** l'ouverture de l'onglet Simulateur
**When** la boutique démarre avec le capital initial (50 000 FCFA et 10 pagnes)
**Then** le cockpit en haut d'écran affiche les montants exacts avec la typographie `Matt Bold` et met à jour les jauges en temps réel.

### Story 3.2: Scène de Vente Narrative Interactive en BD
As a joueur commerçant,
I want voir des personnages illustrés entrer dans ma boutique, me parler dans des bulles de dialogue et me proposer des situations d'achat ou de crédit,
So that je m'exerce à négocier et à prendre les bonnes décisions commerciales.

**Acceptance Criteria:**
**Given** un client virtuel entrant dans la boutique (ex: Tante Henriette demandant 2 pagnes à crédit)
**When** l'utilisateur sélectionne l'un des choix tactiles (Comptant, Acompte 50%, ou Refus poli)
**Then** la scène BD s'anime, résout la transaction et applique instantanément les conséquences sur la caisse et le stock.

### Story 3.3: Moteur d'Aléas du Marché & Événements Quotidiens
As a joueur commerçant,
I want faire face à des imprévus réalistes (pluie sur le marché, opportunité de promotion grossiste, demande d'emprunt familial),
So that j'apprenne à anticiper les chocs de trésorerie.

**Acceptance Criteria:**
**Given** le passage d'une nouvelle journée de simulation
**When** le moteur d'aléas se déclenche
**Then** un événement contextuel apparaît avec un choix stratégique
**And** les frais fixes quotidiens (1 000 FCFA taxe/transport) sont automatiquement déduits de la caisse.

### Story 3.4: Débriefing Pédagogique Automatisé de Fin de Session
As a joueur commerçant,
I want recevoir un bilan commenté par la Mascotte à la fin de chaque journée ou cycle de vente,
So that je comprenne précisément pourquoi mes choix m'ont enrichi ou mis en difficulté.

**Acceptance Criteria:**
**Given** la fin d'un cycle de vente ou une situation de caisse négative
**When** l'écran de bilan s'affiche
**Then** la Mascotte analyse le résultat (Marge brute réalisée, impact des crédits accordés) et délivre 2 règles d'or concrètes applicables dans la vraie vie.

---

## Epic 4: Assistant Financier Conversationnel (Mascotte & Passerelle HTTP IA)

Permettre à l'utilisateur de poser des questions financières à tout moment à la Mascotte FinEdge, recevoir des conseils vulgarisés contextualisés (CFA/Mobile Money) via l'API de l'équipe IA dédiée avec masquage automatique des données privées.

### Story 4.1: Interface de Chat Mascotte avec Pilules de Questions Rapides
As a utilisateur cherchant un conseil financier,
I want dialoguer avec la mascotte FinEdge via une interface de chat fluide et cliquer sur des suggestions de questions en un clic,
So that je pose facilement mes questions sans avoir à tout taper au clavier.

**Acceptance Criteria:**
**Given** l'onglet Coach IA ouvert
**When** l'utilisateur arrive sur l'écran
**Then** la mascotte l'accueille avec un message chaleureux et un carrousel horizontal de questions rapides (ex: *"Comment calculer ma marge ?"*, *"Aide pour mon budget Wave"*)
**And** cliquer sur une pilule envoie directement la question dans le fil de discussion.

### Story 4.2: Passerelle Backend FastAPI avec Anonymisation PII & Contextualisation
As a responsable de la confidentialité des utilisateurs,
I want que le backend FinEdge filtre tous les numéros de téléphone et montants privés avant d'envoyer la requête à l'API IA,
So that aucune donnée personnelle sensible ne soit transmise ou stockée en clair.

**Acceptance Criteria:**
**Given** un message utilisateur contenant un numéro de téléphone ou un identifiant Mobile Money
**When** le backend FastAPI traite la requête
**Then** les motifs sensibles sont anonymisés par regex (ex: `[NUMÉRO_MASQUÉ]`)
**And** les métadonnées de contexte (niveau de l'utilisateur, pays/devise XOF) sont injectées dans la requête transmise à l'équipe IA.

### Story 4.3: Client HTTP vers l'API de l'Équipe IA Dédiée & Gestion des Pannes Réseau
As a développeur backend,
I want consommer les endpoints HTTP (GET/POST) fournis par l'équipe qui développe le modèle IA et gérer gracieusement les coupures réseau,
So that l'application reste toujours stable et informative même sans connexion.

**Acceptance Criteria:**
**Given** une requête utilisateur envoyée à l'API de l'équipe IA
**When** l'API répond avec le format JSON convenu
**Then** la réponse est retransmise au mobile en moins de 1.5s
**And** si le réseau coupe ou si l'API IA est indisponible, la Mascotte affiche un message amical avec 3 conseils pré-enregistrés pertinents.

---

## Epic 5: Plateforme d'Administration CMS & Cockpit Équipe (Back-Office Web)

Permettre à l'équipe pédagogique et produit d'éditer les leçons et scénarios BD avec prévisualisation miroir sur mobile, de suivre les statistiques d'usage et d'exporter les requêtes anonymisées pour aider l'équipe IA.

### Story 5.1: Back-Office CMS Next.js pour l'Édition No-Code des Leçons
As a responsable pédagogique,
I want créer, réordonner et modifier des chapitres, fiches de cours et QCM depuis une interface web intuitive,
So that les nouveaux contenus soient publiés instantanément sur les applications mobiles sans mise à jour logicielle.

**Acceptance Criteria:**
**Given** un administrateur connecté au Back-Office Next.js
**When** il ajoute une nouvelle fiche de leçon ou modifie une question de quiz
**Then** les modifications sont enregistrées dans PostgreSQL avec un nouveau numéro de version incrémentale
**And** les mobiles synchronisent automatiquement ce nouveau contenu lors de leur prochaine session.

### Story 5.2: Éditeur de Scénarios BD avec Prévisualisation Smartphone Miroir
As a concepteur de scénarios pédagogiques,
I want rédiger les dialogues et choix du simulateur de commerce tout en visualisant le rendu exact sur un smartphone virtuel en temps réel,
So that je valide la lisibilité et l'impact visuel des scènes avant publication.

**Acceptance Criteria:**
**Given** l'éditeur de scénario BD ouvert dans le Back-Office
**When** le concepteur modifie la réplique d'un personnage ou les options d'action
**Then** la prévisualisation miroir sur la droite de l'écran s'actualise instantanément avec les polices `Matt` et les bulles stylisées.

### Story 5.3: Tableau de Bord Analytics & Export des Requêtes pour l'Équipe IA
As a chef de produit et partenaire de l'équipe IA,
I want visualiser les taux de complétion des cours et exporter un fichier CSV/JSON des questions anonymisées des utilisateurs,
So that l'équipe IA puisse affiner et perfectionner continuellement son modèle avec des données réelles du terrain.

**Acceptance Criteria:**
**Given** l'onglet Analytics & IA du Back-Office
**When** l'administrateur clique sur "Exporter les requêtes anonymisées"
**Then** un fichier JSON/CSV horodaté contenant les questions posées, la catégorie détectée et les scores de satisfaction est téléchargé
**And** aucune donnée personnelle n'est présente dans l'export.
