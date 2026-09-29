---
title: Product Brief — FinEdge Africa
status: draft
created: 2026-08-20
updated: 2026-08-20
---

# Product Brief — FinEdge Africa

## 1. Vision & Proposition de Valeur

**FinEdge Africa** est une application mobile d'éducation et d'émancipation financière conçue spécifiquement pour les réalités économiques du quotidien en Afrique de l'Ouest. 

Loin des cours théoriques et magistraux, FinEdge agit comme un véritable **coach financier de poche, interactif et bienveillant**, qui guide l'utilisateur pas à pas pour :
- Apprendre à mieux épargner et optimiser ses flux de Mobile Money,
- Gérer efficacement un petit commerce ou une activité génératrice de revenus,
- Sortir de la précarité ou du surendettement grâce à des micro-décisions quotidiennes saines.

La solution intègre un écosystème en deux volets :
1. **L'application Mobile (Utilisateurs finaux)** : Ludique, personnalisée, pragmatique et assistée par IA.
2. **La plateforme d'Administration Web (Équipe FinEdge)** : Un CMS & cockpit analytics permettant d'enrichir le contenu et d'analyser l'usage en toute autonomie, sans intervention technique constante.

---

## 2. Utilisateurs Cibles & Personas

* **Le particulier / ménage en quête de stabilité** :
  * *Besoins* : Gérer son budget mensuel, maîtriser ses frais de mobile money, constituer une épargne d'urgence sans stress.
* **Le micro-entrepreneur / commerçant informel (ex. vente de pagnes, quincaillerie, restauration)** :
  * *Besoins* : Distinguer l'argent de la poche de celui de la caisse, calculer ses marges, fixer le bon prix de vente, anticiper les réapprovisionnements sans risquer son capital.
* **Le jeune actif / étudiant** :
  * *Besoins* : Développer une culture financière solide, comprendre l'investissement et les mécanismes d'épargne via une expérience interactive et stimulante (gamification).

---

## 3. Piliers Fonctionnels de l'Application Mobile

### 🎯 A. Onboarding & Diagnostic Personnalisé
* Questionnaire initial court et convivial évaluant la situation, le profil financier et les objectifs de l'utilisateur.
* Génération dynamique d'un **parcours d'apprentissage sur-mesure** (ex. : parcours *Commerçant*, parcours *Épargne & Budget*, parcours *Débutant*).

### 🎮 B. Micro-Learning & Gamification
* Modules de leçons concrètes, ultra-courtes (2 à 5 minutes) et interactives.
* Thématiques ciblées : *Maîtriser le Mobile Money, Créer une tontine/épargne sécurisée, Éviter les crédits pièges, Tenir un cahier de caisse*.
* Mécanismes d'engagement : Points d'expérience, badges, niveaux de maîtrise, séries de jours consécutifs (*streaks*).

### 🏪 C. Simulateur de Gestion de Commerce
* Mini-jeu de simulation en immersion (ex. boutique de vente de pagnes, kiosque).
* Prise de décisions en situation réelle : achat de stock, fixation des marges, gestion des créances clients, anticipation des imprévus.
* Apprentissage par l'erreur sans risque financier réel.

### 🤖 D. Assistant Financier IA Dédié
* Agent conversationnel intelligent accessible 24/7.
* Réponses personnalisées en langage naturel, vulgarisées et contextualisées à la réalité ouest-africaine.
* Capacité à répondre à des questions concrètes : *"Comment répartir mes bénéfices ce mois-ci ?"*, *"Combien dois-je garder en réserve de sécurité ?"*.

---

## 4. Back-office d'Administration & Gestion

* **CMS Pédagogique No-Code** : Création, modification, ordonnancement et publication des modules et questions sans dépendance envers les développeurs.
* **Tableau de bord Analytics & Engagement** : Visualisation des taux de complétion, des leçons populaires vs points de décrochage, et des dynamiques d'apprentissage.
* **Supervision & Amélioration Continue de l'IA** : Analyse anonymisée et agrégée des thématiques les plus consultées pour affiner les prompts, les règles de sécurité et les futurs modules pédagogiques, dans le strict respect de la vie privée.

---

## 5. Facteurs Clés de Succès & Contraintes

* **Accessibilité & Simplicité UX** : Interface légère, intuitive, adaptée aux smartphones d'entrée/milieu de gamme et aux connexions réseau variables.
* **Ancrage Culturel & Pratique** : Exemples ancrés dans les réalités locales (Franc CFA, Mobile Money, tontines, commerce de proximité).
* **Confidentialité & Éthique** : Données personnelles protégées, IA supervisée avec des garde-fous clairs sur le conseil financier non-régulé.

---

## 6. Prochaines Étapes Recommandées (Cycle BMad)

1. **Revue & Validation du Product Brief** (Ajustements selon vos retours).
2. **Élaboration du PRD Détaillé** (`bmad-prd`) : Spécification fine des règles métier, algorithme de recommandation de parcours, scoring du simulateur, prompt engineering de l'IA.
3. **Architecture & Spécifications UX** (`bmad-architecture` / `bmad-ux`) : Choix de la stack mobile (ex. Flutter / React Native), du backend (API, CMS, base de données) et wireframes de l'application.
