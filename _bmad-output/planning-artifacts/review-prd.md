---
title: Review Report — PRD FinEdge Africa
status: completed
date: 2026-08-20
lenses: [adversarial, edge-case-hunter, verification-gap, structure]
target: _bmad-output/planning-artifacts/prd.md
---

# 🔍 Rapport de Revue Critique (Multi-Lenses) — PRD FinEdge Africa

## 1. ⚔️ Lens Adversarial (Critique & Lacunes Métier)

1. **Lacune Authentification & Perte d'appareil (FR-ONB-02)** :
   * *Problème* : L'authentification par OTP SMS est coûteuse en Afrique de l'Ouest (taux d'échec de livraison des SMS de 15 à 30%) et l'utilisateur change fréquemment de carte SIM.
   * *Recommandation* : Prévoir une authentification fallback (code PIN local ou Magic Link / WhatsApp OTP) et une politique claire pour le mode invité (sauvegarde locale chiffrée avec invitation à lier un compte après X leçons).
2. **Définition insuffisante de la boucle économique du Simulateur (FR-SIM-02)** :
   * *Problème* : Aucun barème ou modèle de calcul n'est spécifié pour le chiffre d'affaires, les marges et la faillite virtuelle du commerce.
   * *Recommandation* : Spécifier une matrice de règles déterministe (Stock initial: 50 000 XOF, Coût unitaire, Prix de vente recommandé, Taux de défaut sur crédit client).
3. **Gestion des devises et des disparités régionales (FR-LRN-04)** :
   * *Problème* : Bien que le Franc CFA (XOF/XAF) soit la devise de base, la Guinée (GNF), le Ghana (GHS) et le Nigéria (NGN) ont des devises différentes avec des ordres de grandeur très disparates.
   * *Recommandation* : Paramétrer la devise au niveau du profil utilisateur pour adapter les montants des quiz et du simulateur sans recréer les cours.
4. **Modèle de coûts et quotas de l'Assistant IA (FR-AIA-01)** :
   * *Problème* : Un accès 24/7 sans quota expose le projet à une explosion des coûts LLM ou à des abus (scraping, requêtes hors sujet).
   * *Recommandation* : Introduire un quota quotidien de tokens/questions (ex: 10 requêtes gratuites/jour) et un mécanisme de suggestions prédéfinies gratuites (FAQ guidée).
5. **Gestion de la conformité réglementaire locale (BCEAO)** :
   * *Problème* : Le mot "conseiller" ou "conseil financier" peut tomber sous la régulation bancaire stricte de la BCEAO/CREPMF.
   * *Recommandation* : Remplacer tout terme de "conseil" par "accompagnement pédagogique" et afficher un avertissement légal systématique.

---

## 2. 🎯 Lens Edge-Case Hunter (Chasse aux Cas Limites)

1. **Conflit de synchronisation Offline -> Online (NFR-OFF-02)** :
   * *Cas limite* : L'utilisateur joue 5 leçons hors ligne sur un téléphone A, puis se connecte sur un téléphone B en ligne, puis reconnecte A.
   * *Résolution requise* : Règle de résolution des conflits de score (Stratégie *Max-Progress* / fusion non destructive des XP et timestamps les plus récents).
2. **Crash ou coupure réseau en plein Quiz ou Simulation** :
   * *Cas limite* : L'application est fermée ou la batterie meurt au milieu d'un tour de simulation ou d'une leçon.
   * *Résolution requise* : Persistance locale de l'état du tour (`draft_state`) pour reprise instantanée sans perte de progression ni pénalité.
3. **Données personnelles dans le Chat IA (FR-ADM-03)** :
   * *Cas limite* : L'utilisateur colle son numéro Wave ou son code secret dans le prompt de l'assistant IA.
   * *Résolution requise* : Filtre regex côté client / API qui masque automatiquement les numéros de téléphone et suites de chiffres critiques avant l'envoi au LLM et avant l'enregistrement dans la base d'administration.
4. **Changement de fuseau horaire et Streak de jours consécutifs (FR-LRN-02)** :
   * *Cas limite* : L'utilisateur manipule l'horloge de son téléphone pour tricher sur la série quotidienne (*streak*).
   * *Résolution requise* : Validation du streak basée sur l'horodatage serveur lors de la synchronisation, avec une tolérance locale de 24h glissantes.

---

## 3. 📐 Lens Structure & Spécifications Avales (Pour l'Architecture & les Devs)

1. **Critères d'Acceptation (AC) manquants** :
   * Chaque FR doit disposer de critères d'acceptation testables (format GIVEN / WHEN / THEN) pour permettre à l'équipe de dev (**Amelia**) d'écrire des tests unitaires et E2E.
2. **Schéma de données du CMS** :
   * Spécifier l'arborescence des contenus : `Parcours -> Modules -> Leçons -> Écrans de contenu (Théorie / Quiz / Feedback)`.
