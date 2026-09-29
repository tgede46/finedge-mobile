# 🐙 Spécifications Complètes & Détaillées des GitHub Issues — Dépôt `finedge-mobile`

> **Projet** : FinEdge Africa — Application Mobile Grand Public  
> **Stack** : Flutter 3.x (Dart) / Isar DB (Offline-First) / Riverpod / GoRouter / JustAudio / Lottie / Dio  
> **Convention Git Flow** : Branche cible `develop`, branche de production `main`.

---

## 🎯 Milestone 1 : Socle Flutter, Design System Fintech & Onboarding Express

---

### Issue #1 : [Init] Initialisation Flutter 3.x, Tokens Fintech (Orange/Marron/Blanc), Police Matt & Barre 4 Onglets

* **Branche Git Flow** : `feature/epic-1-init-flutter-design-system`
* **Labels** : `mobile`, `setup`, `ui`, `fintech`
* **Estimation** : 1.5 jours

#### 📝 Contexte & Objectif
Poser l'architecture de l'application mobile `finedge-mobile` sous **Flutter 3.x** avec le thème officiel **Fintech Africaine** (Terracotta cuivrée `#D95A1E`, Dégradé `#FF6B00 ➔ #7B3E19`, Marron `#5C3A21`, Blanc `#FFFFFF` et police `Matt`), et la barre de navigation principale à 4 onglets fixes.

#### 🗂️ Arborescence des Fichiers
```text
mobile/
├── assets/
│   ├── fonts/                         # Famille Matt (Bold, Medium, Regular, Black)
│   ├── icons/                         # Icônes SVG Fintech & Mascotte
│   └── animations/                    # Flammes de streak et confettis Lottie
├── lib/
│   ├── core/
│   │   ├── theme/
│   │   │   ├── app_colors.dart        # Tokens Hex Fintech
│   │   │   ├── app_typography.dart    # Styles Matt
│   │   │   └── app_theme.dart         # ThemeData Flutter
│   │   ├── router/
│   │   │   └── app_router.dart        # GoRouter avec 4 onglets
│   │   └── network/
│   │       └── api_client.dart        # Dio client vers le backend FastAPI
│   ├── features/
│   └── main.dart
└── pubspec.yaml
```

#### 📋 Critères d'Acceptation (Given / When / Then)
* **GIVEN** l'application lancée sur émulateur ou smartphone réel (Android/iOS)
* **WHEN** l'écran d'accueil s'affiche
* **THEN** la barre de navigation inférieure présente les 4 onglets fixes :
  1. 📚 **Sentier** (Accueil Micro-Learning)
  2. 🏪 **Simulateur BD** (Boutique de commerce)
  3. 🦉 **Coach IA** (Chat Mascotte)
  4. 👤 **Profil & Trophées**
* **AND** tous les textes et montants utilisent la police `Matt`.

---

### Issue #2 : [Onboarding] Diagnostic Initial (<60s), Mode Invité Persistant & MFA Flexible à la Carte

* **Branche Git Flow** : `feature/epic-1-onboarding-diagnostic-mfa`
* **Labels** : `mobile`, `onboarding`, `auth`, `mfa`
* **Estimation** : 1.5 jours

#### 📝 Contexte & Objectif
Permettre à un nouvel utilisateur de commencer à apprendre en **moins de 60 secondes** grâce à un questionnaire express en 3 étapes. L'utilisateur peut jouer immédiatement en **mode invité** et choisir librement d'activer ou non une méthode **MFA** (WhatsApp OTP, SMS OTP, Authenticator ou Aucun) depuis son profil.

#### 📋 Étapes du Diagnostic Initial
1. **Activité** : Commerçant / Vendeur de pagnes / Salarié / Étudiant.
2. **Objectif Prioritaire** : Mieux gérer ma caisse / Épargner pour les imprévus / Maîtriser le Mobile Money.
3. **Temps Quotidien** : 3 min/jour (Tranquille) / 5 min/jour (Recommandé) / 10 min/jour (Intense).

#### ✅ Critères d'Acceptation
* **GIVEN** un nouvel utilisateur installant l'application
* **WHEN** il complète les 3 questions du questionnaire
* **THEN** un compte invité avec identifiant local Isar est généré immédiatement sans mot de passe.
* **AND** le sentier d'apprentissage se positionne sur le module correspondant à son activité.
* **AND** l'utilisateur peut configurer ses options de sécurité MFA à la carte dans l'onglet Profil.

---

## 🎯 Milestone 2 : Sentier Duolingo-like, Micro-Learning & Gamification

---

### Issue #3 : [Path] Composant Sentier de Progression Vertical avec Nœuds 3D & Coffres de Chapitres

* **Branche Git Flow** : `feature/epic-2-vertical-duolingo-path`
* **Labels** : `mobile`, `gamification`, `ui`
* **Estimation** : 2 jours

#### 📝 Contexte & Objectif
Développer l'écran principal d'apprentissage sous forme de **sentier vertical sinueux** (style Duolingo/Babbel), avec nœuds 3D animés, états dynamiques et coffres de fin de chapitre.

#### 🎨 États des Nœuds du Sentier
* **Nœud Actif** : Bouton 3D en relief avec dégradé Orange-Marron animé et halo pulsant.
* **Nœud Complété** : Bouton doré avec 1 à 3 étoiles et coche verte de validation.
* **Nœud Verrouillé** : Bouton gris neutre avec cadenas discret.
* **Coffre de Récompense** : Coffre au trésor à la fin de chaque chapitre qui s'ouvre avec une explosion de confettis Lottie (+100 XP).

#### ✅ Critères d'Acceptation
* **GIVEN** l'onglet Sentier affiché
* **WHEN** l'utilisateur fait défiler le chemin vertical
* **THEN** l'animation de défilement est fluide (60 fps) sans saccade.
* **AND** cliquer sur un nœud actif ouvre la feuille de micro-leçon correspondante.

---

### Issue #4 : [Lessons] Lecteur de Fiches Pédagogiques, Lecteur Audio Vocal & Quiz Interactif

* **Branche Git Flow** : `feature/epic-2-lesson-quiz-player`
* **Labels** : `mobile`, `learning`, `audio`, `quiz`
* **Estimation** : 2 jours

#### 📝 Contexte & Objectif
Créer le moteur de lecture des micro-leçons de 3 minutes ancrées dans les réalités ouest-africaines (FCFA, frais Mobile Money, calcul de marge, tontines) avec support audio pour écouter la leçon et quiz interactif final.

#### 📋 Fonctionnalités du Lecteur
- [ ] Carrousel horizontal de fiches synthétiques avec cartes illustrées.
- [ ] Lecteur audio intégré (`just_audio`) avec bouton Play/Pause pour écouter l'explication vocale.
- [ ] Écran de Quiz interactif (QCM à 3 ou 4 choix).
- [ ] Animation de feedback immédiat :
  * **Bonne Réponse** : Fiche verte éclatante `#00C076`, son de victoire et message d'encouragement.
  * **Erreur** : Fiche orange bienveillante avec explication pédagogique claire de la Mascotte.

#### ✅ Critères d'Acceptation
* **GIVEN** une leçon ouverte
* **WHEN** l'utilisateur répond correctement au quiz final
* **THEN** l'écran de victoire s'affiche avec le gain d'XP (+50 XP) et le nœud suivant du sentier se déverrouille.

---

### Issue #5 : [Gamification] Moteur d'XP, Flammes de Séries Quotidiennes (Streaks) & Système de Trophées

* **Branche Git Flow** : `feature/epic-2-gamification-streaks-badges`
* **Labels** : `mobile`, `gamification`, `retention`
* **Estimation** : 1.5 jours

#### 📝 Contexte & Objectif
Implémenter le moteur de motivation et de fidélisation pour transformer l'apprentissage financier en habitude quotidienne.

#### 📋 Éléments de Gamification
- [ ] **Flamme de Streak Quotidien** : Compteur de jours consécutifs avec flamme animée Lottie dans le Header.
- [ ] **Gains de Points XP** : Compteur cumulatif affiché avec animation d'incrémentation.
- [ ] **Écran de Trophées (Onglet Profil)** : Badges déverrouillables (*"Premier Pas"*, *"Maître de la Caisse"*, *"Série de 7 Jours"*, *"As de la Négociation"*).

#### ✅ Critères d'Acceptation
* **GIVEN** un utilisateur terminant sa première leçon de la journée
* **WHEN** le résultat est enregistré
* **THEN** la flamme de streak s'allume pour le jour en cours et le compteur augmente de +1.

---

## 🎯 Milestone 3 : Simulateur de Commerce BD & Mode Offline-First Isar

---

### Issue #6 : [Simulator BD] Simulateur de Vente de Pagnes en Format Visual Novel avec Cockpit Caisse & Choix Tactiles

* **Branche Git Flow** : `feature/epic-3-simulator-comic-visual-novel`
* **Labels** : `mobile`, `simulator`, `comic`, `gameplay`
* **Estimation** : 2.5 jours

#### 📝 Contexte & Objectif
Développer le **Simulateur de Commerce Interactif en BD** (Onglet 2) où l'utilisateur incarne un vendeur de pagnes sur un marché d'Afrique de l'Ouest.

```mermaid
graph TD
    subgraph 📱 Écran du Simulateur BD
        Cockpit["💰 Cockpit Caisse Flottant : 50 000 FCFA | 📦 Stock : 10 Pagnes"]
        Scene["🏪 Scène BD Illustrée : Tante Henriette arrive au stand"]
        Bubble["💬 Bulle de Dialogue : 'Mon neveu, donne-moi 2 pagnes à crédit !'"]
        Choices["🔘 Choix Tactiles :<br/>[1. Comptant 10 000 F]  [2. Acompte 50%]  [3. Refus Poli]"]
        Debrief["🦉 Débriefing Mascotte : Analyse de marge et règle d'or"]

        Cockpit --- Scene
        Scene --- Bubble
        Bubble --- Choices
        Choices ==>|Action Joueur| Debrief
    end
```

#### 📋 Fonctionnalités du Simulateur
- [ ] **Cockpit Caisse en Direct** : Solde de trésorerie en FCFA, stock de pagnes, créances en attente.
- [ ] **Scènes Narratives BD** : Décors de marché et personnages expressifs (Tante Henriette, grossiste, client pressé).
- [ ] **Boutons d'Actions Tactiles** : Choix immédiats avec impacts financiers calculés instantanément.
- [ ] **Moteur d'Événements Aléatoires** : Pluie torrentielle sur le marché, fête de quartier, demande d'emprunt d'un cousin.
- [ ] **Bilan de Fin de Journée** : Débriefing de la Mascotte calculant le bénéfice net et formulant 2 conseils concrets.

#### ✅ Critères d'Acceptation
* **GIVEN** une session de vente démarrée avec 50 000 FCFA et 10 pagnes
* **WHEN** l'utilisateur accepte un acompte de 50% sur 2 pagnes vendus à 10 000 FCFA
* **THEN** la caisse augmente de +5 000 FCFA, le stock passe à 8 pagnes et une dette client de 5 000 FCFA est enregistrée.

---

### Issue #7 : [Offline-First] Moteur de Persistance Locale Isar & Synchronisation Automatique

* **Branche Git Flow** : `feature/epic-2-offline-sync-isar-engine`
* **Labels** : `mobile`, `database`, `offline-first`, `sync`
* **Estimation** : 2 jours

#### 📝 Contexte & Objectif
Garantir que **100% de l'application (cours, quiz, simulateur BD) fonctionne parfaitement sans aucune connexion Internet**, et que les données se synchronisent automatiquement en arrière-plan dès le retour du réseau.

#### 📋 Tâches Techniques
- [ ] Configurer la base de données locale **Isar** avec schémas typés (`LocalLesson`, `LocalProgress`, `LocalStreak`, `LocalSimulatorState`).
- [ ] Développer le service de synchronisation en tâche de fond (`SyncService`).
- [ ] Implémenter la résolution de conflit **Max-Progress** et le cumul additif des XP.
- [ ] Optimisation de la taille de l'APK (< 25 Mo) avec compression des assets SVG et audio.

#### ✅ Critères d'Acceptation
* **GIVEN** l'appareil en mode avion (aucune connexion)
* **WHEN** l'utilisateur termine 3 leçons et progresse dans le simulateur BD
* **THEN** toutes les données sont enregistrées localement dans Isar sans aucun message d'erreur.
* **AND** dès la reconnexion au réseau, les progrès sont transmis au backend FastAPI sans action requise.

---

## 🎯 Milestone 4 : Coach Mascotte IA Conversationnel

---

### Issue #8 : [Mascot AI] Interface de Chat avec la Mascotte Animée & Carrousel de Pilules de Questions Rapides

* **Branche Git Flow** : `feature/epic-4-mascot-ai-chat-ui`
* **Labels** : `mobile`, `ai`, `chat`, `ui`
* **Estimation** : 1.5 jours

#### 📝 Contexte & Objectif
Développer l'onglet **Coach IA** (Onglet 3) avec une interface de messagerie fluide et bienveillante avec la Mascotte FinEdge.

#### 📋 Fonctionnalités de l'Interface de Chat
- [ ] Mascotte animée (Koko le Calao / Kini le Caméléon) avec expressions adaptées (sourire, réflexion, encouragement).
- [ ] Carrousel horizontal de suggestions de questions en 1 clic (*"Comment calculer ma marge ?"*, *"Aide pour mon budget Wave"*, *"Gérer un crédit client"*).
- [ ] Fil de discussion fluide avec bulles stylisées Fintech (Blanc et Orange-Marron).
- [ ] Gestion du mode dégradé : si l'appareil est hors-ligne, la mascotte propose instantanément des réponses pré-enregistrées aux questions les plus fréquentes.

#### ✅ Critères d'Acceptation
* **GIVEN** l'ouverture de l'onglet Coach IA
* **WHEN** l'utilisateur clique sur une pilule de question suggérée
* **THEN** la question s'envoie immédiatement et la réponse vulgarisée en Francs CFA s'affiche en moins de 1.5s.
