---
title: Product Requirements Document (PRD) — FinEdge Africa
status: draft
created: 2026-08-20
updated: 2026-08-20
author: John (Product Manager) & Mary (Business Analyst)
---

# Product Requirements Document (PRD) — FinEdge Africa

## 1. Vision & Objectifs Stratégiques

**FinEdge Africa** est une solution mobile d'éducation et d'autonomisation financière adaptée aux réalités socio-économiques de l'Afrique de l'Ouest. Elle permet aux particuliers et aux petits commerçants de développer de saines habitudes financières grâce à un micro-apprentissage ludique, un simulateur de commerce immersif et un assistant conversationnel IA contextualisé.

### 1.1 Objectifs Clés (KPIs)
* **Engagement** : Taux de complétion des modules de cours > 65%.
* **Rétention** : Rétention J+30 > 40% portée par la gamification (streaks) et le simulateur.
* **Impact Pédagogique** : +50% d'amélioration du score aux quiz de mise en situation après simulation.
* **Autonomie Équipe** : 100% des contenus de cours et ajustements de quiz administrables sans déploiement de code.

---

## 2. Parcours Utilisateurs Cibles (User Journeys)

### Journey 1 : Awa, Commerçante de Pagnes à Cotonou (Micro-entrepreneure)
* **Contexte** : Awa vend des pagnes au marché. Elle mélange souvent la caisse du commerce et ses dépenses familiales, ce qui provoque des ruptures de stock inattendues.
* **Déroulement** :
  1. À l'ouverture de FinEdge, Awa répond à 3 questions simples et choisit son objectif : *"Mieux gérer mon commerce"*.
  2. L'app lui propose un parcours sur-mesure centré sur la gestion de caisse et le calcul de marge.
  3. Awa teste le **Simulateur de commerce** : elle gère une boutique virtuelle de pagnes, fait face à une demande de vente à crédit d'un parent fictif et apprend à refuser poliment ou à provisionner le risque.
  4. Elle pose une question à l'**Assistant IA** : *"Comment calculer mon bénéfice net après transport et taxe de marché ?"*. L'IA lui répond avec des exemples en Franc CFA simples et applicables immédiatement.

### Journey 2 : Ibrahim, Jeune Salarié / Freelance à Abidjan
* **Contexte** : Ibrahim utilise quotidiennement Wave et Orange Money. Il a du mal à épargner et subit des frais de transfert non anticipés.
* **Déroulement** :
  1. Ibrahim complète le diagnostic initial et sélectionne *"Créer une épargne de sécurité"*.
  2. Chaque jour dans les transports, il effectue une micro-leçon de 3 minutes (Quiz interactif avec gains de points XP et maintien de sa série/streak).
  3. Il consulte l'Assistant IA pour simuler la règle budgétaire (50/30/20 adaptée aux tontines et imprévus).

---

## 3. Exigences Fonctionnelles (Functional Requirements)

### 3.1 Onboarding & Profiling Adaptatif
* **FR-ONB-01** : Questionnaire d'accueil express (3 questions max) : objectif prioritaire, niveau d'aisance financière, type d'activité (salarié, commerçant, étudiant).
* **FR-ONB-02** : Création de compte simplifiée par numéro de téléphone (OTP SMS ou WhatsApp) ou mode invité.
* **FR-ONB-03** : Génération instantanée d'une feuille de route d'apprentissage personnalisée basée sur les réponses.

### 3.2 Moteur de Micro-Learning & Gamification
* **FR-LRN-01** : Modules découpés en micro-leçons (2 à 4 minutes max) avec théorie illustrée et questions à choix multiples (QCM).
* **FR-LRN-02** : Système de récompenses : Points XP, Badges de maîtrise, Séries quotidiennes (Daily Streaks).
* **FR-LRN-03** : Support multimédia : Format texte concis avec option de synthèse vocale / lecture audio des leçons `[ASSUMPTION]`.
* **FR-LRN-04** : Thématiques ancrées localement : Franc CFA (XOF), Mobile Money (Wave, MTN, Orange, Moov), Tontines, Gestion de cahier de caisse, Prêts informels.

### 3.3 Simulateur de Gestion de Commerce (Business Simulator)
* **FR-SIM-01** : Scénario de départ configurable (ex: Vente de pagnes, Kiosque d'alimentation générale).
* **FR-SIM-02** : Boucle de jeu par tours/journées : Achat de stock fournisseur, fixation des prix de vente, gestion des créances/crédits clients, paiement des charges.
* **FR-SIM-03** : Événements aléatoires réalistes (intempéries, fêtes saisonnières, pannes, demandes d'emprunt familial).
* **FR-SIM-04** : Débriefing pédagogique automatique à chaque fin de cycle de simulation (bilan de trésorerie, erreurs évitables, conseils pratiques).

### 3.4 Assistant Financier Intelligent (IA Coach)
* **FR-AIA-01** : Interface de chat conversationnel fluide disponible 24/7.
* **FR-AIA-02** : Contexte et mémoire de session adaptés au profil de l'utilisateur (budget, objectifs).
* **FR-AIA-03** : Garde-fous éthiques et juridiques stricts (interdiction de conseil boursier spéculatif ou recommandation de placements risqués ; rappel du rôle purement éducatif).
* **FR-AIA-04** : Support d'entrée/sortie vocale (envoi de notes vocales par l'utilisateur et réponse audio) `[ASSUMPTION: Roadmap V1.1]`.

### 3.5 Back-Office d'Administration (CMS & Cockpit Équipe)
* **FR-ADM-01** : Gestionnaire de contenu (CMS) pour créer, modifier, ordonner et publier les cours, modules, quiz et scénarios du simulateur sans intervention technique.
* **FR-ADM-02** : Tableau de bord Analytics : Utilisateurs actifs (DAU/MAU), taux de complétion par leçon, taux d'abandon, métriques de gamification.
* **FR-ADM-03** : Cockpit de Supervision IA Anonymisée : Analyse des tendances de requêtes, détection des questions sans réponse satisfaisante, anonymisation automatique (masquage noms, téléphones, montants personnels).

---

## 4. Exigences Non Fonctionnelles (NFR)

* **NFR-PERF-01 (Légèreté de l'app)** : Taille du binaire mobile < 30 Mo pour faciliter le téléchargement sur réseaux 3G/4G.
* **NFR-OFF-02 (Mode Offline-First)** : Les leçons et le simulateur doivent être jouables sans connexion Internet active. Synchronisation des scores et progrès dès reconnexion.
* **NFR-SEC-03 (Confidentialité des données)** : Chiffrement des données en transit (HTTPS/TLS) et au repos. Aucune donnée financière personnelle sensible n'est vendue ou partagée.
* **NFR-REL-04 (Disponibilité)** : Disponibilité de l'API et du back-office > 99.5%.

---

## 5. Découpage du Périmètre (Scope & Roadmap)

| Phase | Périmètre Mobile | Périmètre Back-Office |
| :--- | :--- | :--- |
| **V1 (MVP)** | Onboarding + Parcours personnalisé + 3 modules clés + Simulateur Pagnes V1 + Chat IA texte + Mode Offline basique | CMS de cours complet + Dashboard statistiques de base + Logs IA anonymisés |
| **V2** | Audio / Voix-off + Support langues locales + Nouveaux scénarios simulateur + Défis communautaires / Tontines virtuelles | Analytics avancés de rétention + A/B testing de contenus + Alertes automatiques |

---

## 6. Risques & Stratégies d'Atténuation

| Risque identifié | Niveau | Stratégie d'atténuation |
| :--- | :--- | :--- |
| **Hallucination ou mauvais conseil de l'IA** | Élevé | Guardrails système stricts, filtrage RAG sur base de connaissances validée, disclaimer visible. |
| **Abandon après l'onboarding** | Moyen | Onboarding ultra-rapide (moins de 60 secondes), première leçon immédiatement gratifiante (+100 XP). |
| **Coûts API LLM élevés** | Moyen | Mise en cache des réponses fréquentes, limitation du nombre de requêtes quotidiennes par utilisateur gratuit. |
