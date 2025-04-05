---

### 📘 **Structure du rapport (5 à 10 pages)**

#### **1. Introduction** *(1/2 page à 1 page)*
- Présentation du projet.
- Objectif : entraîner une voiture à naviguer sur un circuit grâce au reinforcement learning.
- Outils utilisés : Godot + Godot-RL.
- Plan du rapport.

#### **2. Théorie du Reinforcement Learning (RL)** *(1 à 2 pages)*
- Définition du RL.
- Concepts fondamentaux :
  - Agent, Environnement, État, Action, Récompense.
  - Politique, Fonction de valeur (V), Q-Learning, Exploration vs Exploitation.
- Algorithmes possibles utilisés par la librairie (DQN, PPO, etc.).
- Pourquoi le RL est adapté à ce problème.

> ✅ **Tâche pour 1 personne** : rédiger la partie théorique avec schéma explicatif simple si possible.

#### **3. Présentation de Godot & Godot-RL** *(1 à 1.5 page)*
- Introduction à Godot :
  - Moteur de jeu open-source, système de scènes/nœuds.
  - Pourquoi il est adapté à ce projet (2D/3D léger, open).
- Mise en place de l’environnement :
  - Comment on a modélisé le circuit, les capteurs de la voiture.
  - Interaction entre Godot et Godot-RL.
- Présentation de la librairie [Godot-RL](https://github.com/edbeeching/godot_rl_agents) :
  - Communication via sockets.
  - Environnement → Observation → Action → Reward.

> ✅ **Tâche pour 1 personne** : expliquer l’aspect technique de la mise en place de l’environnement.

#### **4. Entraînement de l’agent** *(1 à 2 pages)*
- Configuration de l'entraînement :
  - Type de capteurs (lidar, raycasts, etc.), observation space, reward function.
  - Hyperparamètres utilisés (learning rate, epsilon, etc.).
- Méthode d’apprentissage utilisée (ex : PPO).
- Courbe d’évolution de l’apprentissage si possible.

> ✅ À partager avec celui qui s'occupe de la partie test.

#### **5. Tests effectués et retours d’expérience** *(2 à 3 pages)*
- Tests réussis :
  - Description de la configuration, résultats obtenus, comportement de l’agent.
- Tests échoués :
  - Ce qui a été tenté, pourquoi ça a échoué (ex : reward mal définie, overfitting, mauvais sensors).
  - Comment vous avez corrigé ou ce que vous avez appris.
- Comparaison de différents réglages.

> ✅ **Tâche pour 1 personne** : documenter les essais/erreurs, captures d’écran utiles ici.

#### **6. Conclusion & Perspectives** *(1 page)*
- Résumé des résultats.
- Limites rencontrées.
- Idées d’améliorations (ex : multi-agents, meilleure perception, circuits plus complexes).
- Ce que vous avez appris sur le RL, Godot, et le travail en équipe.

---

### ✅ **Conseils supplémentaires**

- Faites attention à la clarté des schémas : même un dessin simple du cycle RL ou de l’agent dans le circuit peut rendre votre rapport plus pro.
- Mentionnez les versions des outils utilisés.
- Si possible, ajoutez une **annexe** avec du code ou des logs.

---
