# 📋 Plan d'implementation par phases

Plan derive de [`docs/SUGGESTIONS.md`](SUGGESTIONS.md). Chaque phase est livrable et testable.

## 📊 État d'avancement

| Phase                      | Etat                                                        |
| -------------------------- | ----------------------------------------------------------- |
| Phase 1 — Fondations       | ✅ Fait (validations, rescue_from 404, flash messages)      |
| Phase 2 — Authentification | ✅ Fait (Devise, inscription/connexion/deconnexion, navbar) |
| Phase 3 — CRUD Gossips     | ✅ Fait (CRUD complet, auth, autorisation auteur, page ville) |
| Phase 4 — Commentaires     | ✅ Fait (liste, create, edit, destroy, compteur index)        |
| Phase 5 — Likes et Tags    | ✅ Fait (tags form + page tag, like/unlike + compteurs)       |
| Phases 6 à 10              | ⏳ À faire                                                  |

---

## 📅 Correspondance THP Semaine 4

| Jour       | Programme THP                                                                                                                                                                                                                                                                                                       | Elements du plan                                                                     |
| ---------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------ |
| **Jour 1** | Premières views : app + import BDD, pages team/contact, welcome/:first_name, Bootstrap (CDN) + header, index gossips (cards), show gossip (titre, contenu, auteur, date), show user (profil), liens entre pages                                                                                                     | Deja en place (v0.2.0). Phase 6 (amelioration index) complete le rendu.              |
| **Jour 2** | Validations modeles (dont Gossip : title 3–14 car., content present). Creation potin : routes REST,`gossips#new` / `#create`, formulaire (form_tag), alertes Bootstrap (succes / erreur). Utilisateur anonyme en BDD pour l'auteur.                                                                                 | Phase 1 (validations + flash) ; Phase 3 (CRUD) partie new/create.                    |
| **Jour 3** | Front Bootstrap. Show city (nom + liste potins des users de la ville). CRUD complet gossips : edit, update, destroy. Commentaires : formulaire sur show gossip, liste des commentaires, edit/destroy commentaire, compteur de commentaires sur l'index. Bonus : tags a la creation/edition (select, seed ~10 tags). | Phase 3 (edit, update, destroy) ; Phase 4 (commentaires) ; Phase 5 (tags en partie). |

**Hors J1–J3** : Authentification (THP prevu plus tard), pagination, messagerie, likes, DevOps, etc. — voir phases suivantes. (Gestion 404 via `rescue_from` implementee en Phase 1.)

**Ressources THP liees** : Routes 100 % REST (`resources` obligatoire). Jour 2 : `form_tag` pour creation, `params`, redirect vs render, `@gossip.errors`. Jour 2 : desactiver Turbo Drive sur liens/formulaires si besoin (Bootstrap JS) via `data: { turbo: false }`. Jour 3 : nested resources pour commentaires (`resources :gossips do resources :comments end`) si besoin.

---

## 1. 🧱 Fondations (qualite et UX de base) — ✅ Fait

**THP** : Jour 2 (validations, alertes).

**Objectif** : Validations, gestion des erreurs, flash messages. Aucune nouvelle feature visible, mais base saine pour la suite.

| Tache               | Detail                                                                                                                              |
| ------------------- | ----------------------------------------------------------------------------------------------------------------------------------- |
| Validations modeles | User (email, age), Gossip (titre 3–14 car., contenu obligatoire — THP Jour 2), Comment (contenu), Tag (titre), City (nom, zip_code) |
| Gestion des erreurs | `rescue_from ActiveRecord::RecordNotFound` dans `ApplicationController` ; pages 404/500 personnalisees (hors THP)                   |
| Flash messages      | Partial dans le layout pour `notice` / `alert` avec styles Bootstrap (THP : alertes vertes/rouges)                                  |

**📦 Livrable** : L'app ne change pas pour l'utilisateur ; les donnees invalides et les URLs inexistantes sont gerees proprement.

---

## 2. 🔐 Authentification — ✅ Fait

**Hors THP J1–J3** (prevu plus tard dans la semaine THP). **Objectif** : Inscription, connexion, deconnexion. Prerequis pour toute action d'ecriture.

| Tache                                 | Detail                                        |
| ------------------------------------- | --------------------------------------------- |
| Gem et configuration                  | `devise` (ou `bcrypt` + sessions manuelles)   |
| Inscription / Connexion / Deconnexion | Vues et routes Devise (ou equivalent)         |
| Integration navbar                    | Liens conditionnels (connecte / non connecte) |

**📦 Livrable** : Un utilisateur peut s'inscrire, se connecter, se deconnecter. Les actions ecriture restent a proteger en phase 3.

---

## 3. ✏️ CRUD Gossips — ✅ Fait

**THP** : Jour 2 (new/create), Jour 3 (edit, update, destroy). **Objectif** : Creer, modifier, supprimer un potin.

| Tache      | Detail                                                                                                                                            |
| ---------- | ------------------------------------------------------------------------------------------------------------------------------------------------- |
| Routes     | `resources :gossips` obligatoire (THP : pas de routes a la main)                                                                                  |
| Controller | `new`, `create`, `edit`, `update`, `destroy`. THP : auteur = utilisateur anonyme en BDD ; plus tard : autorisation (utilisateur courant = auteur) |
| Vues       | `_form.html.erb`, `new.html.erb`, `edit.html.erb` ; Bootstrap. Pre-remplir le formulaire d'edition (THP Jour 3)                                   |
| Liens      | "Nouveau potin", "Modifier", "Supprimer" (destroy avec `data-method="DELETE"` + confirmation) ; redirection apres destroy vers index              |
| Page ville | THP Jour 3 : page show city (nom + liste des potins des users de la ville), accessible depuis show user et show gossip                            |

**📦 Livrable** : CRUD complet sur les gossips, avec formulaires et feedback flash. En place : `resources :gossips` et `resources :cities, only: [:show]`, GossipsController (auth + autorisation auteur), vues _form/new/edit, page ville, liens ville (user/show et gossip/show).

---

## 4. 💬 Commentaires — ✅ Fait

**THP** : Jour 3. **Objectif** : Afficher et creer des commentaires sur un gossip ; edit/destroy commentaire.

| Tache          | Detail                                                                                             |
| -------------- | -------------------------------------------------------------------------------------------------- |
| Affichage      | Sur `gossips#show`, liste des commentaires (auteur, texte) ; THP : lien "modifier" par commentaire |
| Creation       | Formulaire sur la page gossip ;`CommentsController` (create). THP : auteur = utilisateur anonyme   |
| Edit / Destroy | THP : page edit commentaire, bouton supprimer ; apres destroy redirection adaptee                  |
| Compteur       | THP Jour 3 : sur la page d'index, chaque potin affiche le nombre de commentaires                   |
| Optionnel      | Commentaires imbriques (reponses) ; affichage en arbre ou liste plate                              |

**📦 Livrable** : Chaque gossip affiche ses commentaires, creation + modification + suppression (THP). Compteur sur l'index.

---

## 5. ❤️ Likes et Tags — ✅ Fait

**THP** : Jour 3 (bonus tags a la creation/edition potin). **Objectif** : Tags sur gossips ; likes ; filtrage.

| Tache        | Detail                                                                                                                                                                         |
| ------------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| Tags         | THP bonus : seed ~10 tags ; select (ou select_tag) dans formulaire creation + edition potin ; controller met a disposition les tags ; GOD MODE : plusieurs tags (nested forms) |
| Tags (suite) | Afficher les tags sur chaque gossip ; page `tags#show` (gossips par tag) ; filtrage/recherche par tag (optionnel)                                                              |
| Likes        | Bouton like/unlike (gossips et commentaires) ; compteur sur la page gossip et sur les cards d'accueil (hors THP J3)                                                            |

**📦 Livrable** : Tags associes aux potins (creation/edition) ; page par tag ; like/unlike si implemente.

---

## 6. 🏠 Amelioration page d'accueil et pagination

**Objectif** : Accueil plus lisible et performant.

| Tache      | Detail                                                                                                                       |
| ---------- | ---------------------------------------------------------------------------------------------------------------------------- |
| Cards      | Apercu du contenu (troncature), date de publication, nombre de commentaires et likes ; tri par date (plus recent en premier) |
| Pagination | Gem `pagy` ou `kaminari` sur l'index des gossips                                                                             |

**📦 Livrable** : Page d'accueil enrichie et paginee.

---

## 7. ✉️ Messagerie privee (UI)

**Objectif** : Inbox, conversation, envoi de messages.

| Tache        | Detail                                                           |
| ------------ | ---------------------------------------------------------------- |
| Inbox        | Liste des conversations (messages recus/envoyes)                 |
| Conversation | Vue thread d'une conversation avec un ou plusieurs destinataires |
| Envoi        | Formulaire nouveau message (destinataire(s), contenu)            |
| Optionnel    | Notifications de nouveaux messages                               |

**📦 Livrable** : Utilisateurs connectes peuvent s'envoyer des messages prives.

---

## 8. 🔧 Qualite et DevOps

**Objectif** : Tests, lint, securite, CI.

| Tache    | Detail                                                                                     |
| -------- | ------------------------------------------------------------------------------------------ |
| Tests    | Modeles (validations, associations), controllers (reponses, variables), systeme (Capybara) |
| Linter   | Rubocop : executer et corriger les offenses                                                |
| Securite | Brakeman : scan et correction des alertes                                                  |
| CI       | Workflow GitHub Actions : tests + lint (Rubocop)                                           |
| Docker   | Verifier build et run du Dockerfile ; ajuster si besoin                                    |

**📦 Livrable** : Suite de tests verte, code linté, CI qui valide chaque push.

---

## 9. 👤 Avatars et recherche

**Objectif** : Profils plus riches et decouverte de contenu.

| Tache     | Detail                                                                                 |
| --------- | -------------------------------------------------------------------------------------- |
| Avatars   | Active Storage ou Gravatar (photo de profil)                                           |
| Recherche | Par titre/contenu gossip, nom d'utilisateur, tag (scope ou gem `ransack` selon besoin) |

**📦 Livrable** : Avatars visibles ; recherche fonctionnelle.

---

## 10. 🚀 Fonctionnalites avancees (bonus)

A traiter selon priorite projet ; ordre indicatif.

| Ordre | Tache                    | Contenu                                                                         |
| ----- | ------------------------ | ------------------------------------------------------------------------------- |
| 1     | Turbo / Stimulus         | Turbo Frames (commentaires sans rechargement), Stimulus (like, compteur, etc.)  |
| 2     | API JSON                 | Endpoints `/api/v1/*` (jbuilder ou serializers) pour gossips, users, etc.       |
| 3     | Notifications            | Table `notifications` (polymorphique), notif comment/like, affichage dans l'app |
| 4     | Follow / fil d'actualite | Table `follows`, fil des gossips des utilisateurs suivis                        |
| 5     | Admin                    | Roles (admin), dashboard, moderation (pundit/cancancan)                         |
| 6     | Mailers                  | Email bienvenue, notification commentaire/message                               |
| 7     | Images sur gossips       | Active Storage +`image_processing` pour illustrer les potins                    |

---

## 🔗 Resume des dependances

- **Phase 1** : aucune (demarrer en premier). THP : faire en debut Jour 2.
- **Phase 2** : independante. THP : pas au programme J1–J3 (utilisateur anonyme a la place).
- **Phase 3** : sans auth THP (anonymous) ; avec auth en production necessite Phase 2.
- **Phases 4, 5** : en THP avec utilisateur anonyme ; en production necessitent Phase 2 pour creer commentaires/likes.
- **Phase 6** : peut etre faite en parallele ou apres 4/5 (amelioration index). THP Jour 1 suggere cards + elements Bootstrap.
- **Phase 7** : necessite Phase 2 (auth).
- **Phase 8** : peut etre entamee tot (tests sur phases deja livrees) et renforcee apres chaque phase.
- **Phases 9 et 10** : apres coeur metier (CRUD, commentaires, likes, tags, messagerie).
