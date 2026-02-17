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
| Phase 6 — Accueil et pagination | ✅ Fait (pagy, troncature, date, eager loading)          |
| Phase 7 — Messagerie privee | ✅ Fait (inbox, show, new, envoi, lien navbar + profil)     |
| Phase 8 — Qualite et DevOps | ✅ Fait (82 tests, Rubocop 0 offenses, Brakeman 0 warnings, CI) |
| Phase 9 — Avatars et recherche | ✅ Fait (Active Storage avatar, recherche multi-modele, navbar) |
| Phase 10 — Fonctionnalites avancees | ✅ Fait (Turbo, API, notifications, follow, admin, mailers, images) |

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

## 6. 🏠 Amelioration page d'accueil et pagination — ✅ Fait

**Objectif** : Accueil plus lisible et performant.

| Tache        | Detail                                                                                                                       | Etat |
| ------------ | ---------------------------------------------------------------------------------------------------------------------------- | ---- |
| Cards        | Apercu du contenu (troncature 120 car.), date de publication, nombre de commentaires et likes ; tri par date desc             | ✅   |
| Pagination   | Gem `pagy ~> 9.0`, 9 gossips/page, navigation Bootstrap                                                                     | ✅   |
| Eager loading | `includes(:user, :tags, :comments, :likes)` pour eviter les requetes N+1                                                   | ✅   |

**📦 Livrable** : Page d'accueil enrichie et paginee. En place : `pagy` (initializer + backend/frontend), `truncate` sur le contenu, date sur les cards, eager loading dans le controller.

---

## 7. ✉️ Messagerie privee (UI) — ✅ Fait

**Objectif** : Inbox, conversation, envoi de messages.

| Tache        | Detail                                                                          | Etat |
| ------------ | ------------------------------------------------------------------------------- | ---- |
| Inbox        | `/conversations` — liste des messages envoyes et recus, tri par date desc       | ✅   |
| Conversation | `/conversations/:id` — vue message avec expediteur, destinataires, bouton repondre | ✅   |
| Envoi        | `/conversations/new` — formulaire avec select multiple destinataires + contenu  | ✅   |
| Liens        | Lien "Messagerie" dans la navbar, bouton "Envoyer un message" sur profil user   | ✅   |
| Optionnel    | Notifications de nouveaux messages                                              | ⏳   |

**📦 Livrable** : Utilisateurs connectes peuvent s'envoyer des messages prives. En place : `ConversationsController` (index, show, new, create), vues inbox/show/new, validation content sur PrivateMessage, autorisation (seuls expediteur et destinataires accedent au message), eager loading, lien navbar + profil.

---

## 8. 🔧 Qualite et DevOps — ✅ Fait

**Objectif** : Tests, lint, securite, CI.

| Tache    | Detail                                                                                                                     | Etat |
| -------- | -------------------------------------------------------------------------------------------------------------------------- | ---- |
| Fixtures | 9 fichiers fixtures (cities, users, gossips, tags, join_table, comments, likes, private_messages, private_message_recipients) | ✅   |
| Tests modeles | 7 fichiers : City, User, Gossip, Tag, Comment, Like, PrivateMessage (validations, associations, dependent destroy)     | ✅   |
| Tests controllers | 4 fichiers : Gossips (12 tests), Comments (6), Likes (4), Conversations (8) — auth, autorisation, CRUD            | ✅   |
| Tests systeme | 1 fichier : parcours index, show, create gossip (Capybara + headless Chrome)                                         | ✅   |
| Linter   | Rubocop : 66 fichiers, 0 offenses                                                                                          | ✅   |
| Securite | Brakeman : 0 warnings                                                                                                      | ✅   |
| CI       | GitHub Actions : scan_ruby (Brakeman + bundler-audit), scan_js, lint (Rubocop), test, system-test                           | ✅   |
| Docker   | Dockerfile present (a verifier en deploiement)                                                                              | ⏳   |
| Bugfix   | Ajout `dependent: :destroy` sur `Gossip#join_table_gossip_tags` (FK constraint fix)                                         | ✅   |

**📦 Livrable** : 76 tests, 115 assertions, 0 failures, 0 errors. Rubocop 0 offenses. Brakeman 0 warnings. CI complete sur GitHub Actions.

---

## 9. 👤 Avatars et recherche — ✅ Fait

**Objectif** : Profils plus riches et decouverte de contenu.

| Tache     | Detail                                                                                                          | Etat |
| --------- | --------------------------------------------------------------------------------------------------------------- | ---- |
| Active Storage | Migration + `has_one_attached :avatar` sur User                                                            | ✅   |
| Upload avatar  | Champ file_field dans inscription et edition Devise, `configure_permitted_parameters` dans ApplicationController | ✅   |
| Affichage avatar | Helper `user_avatar(user, size:)` avec fallback initiales, visible sur profil, index gossips, show gossip, commentaires | ✅   |
| Recherche  | `SearchController#index` — recherche par titre/contenu gossip, nom/email utilisateur, titre tag (LIKE)          | ✅   |
| UI recherche | Barre de recherche dans la navbar, page `/search` avec resultats par section (gossips, users, tags)            | ✅   |
| Tests      | 6 tests search controller (acces, requetes, resultats)                                                          | ✅   |

**📦 Livrable** : Avatars Active Storage avec fallback initiales ; recherche multi-modele fonctionnelle. 82 tests, 0 failures.

---

## 10. 🚀 Fonctionnalites avancees (bonus) — ✅ Fait

| Ordre | Tache                    | Contenu                                                                                              | Etat |
| ----- | ------------------------ | ---------------------------------------------------------------------------------------------------- | ---- |
| 1     | Turbo / Stimulus         | Turbo Frame sur commentaires (rechargement partiel), Stimulus controller flash auto-dismiss (3s)     | ✅   |
| 2     | API JSON                 | `/api/v1/gossips` + `/api/v1/users` (index, show) — `ActionController::API`, JSON natif              | ✅   |
| 3     | Notifications            | Table `notifications` (polymorphique), notif comment/like/follow, page `/notifications`, badge navbar | ✅   |
| 4     | Follow / fil d'actualite | Table `follows` (unique index), bouton follow/unfollow profil, `/feed` pagine, compteurs abonnes     | ✅   |
| 5     | Admin                    | Colonne `admin` (boolean), `Admin::BaseController` avec guard, dashboard (`/admin`) avec stats       | ✅   |
| 6     | Mailers                  | `UserMailer` : welcome (after_create_commit) + new_comment, vues HTML                                | ✅   |
| 7     | Images sur gossips       | `has_one_attached :image` sur Gossip, upload dans formulaire, affichage sur show                     | ✅   |

**📦 Livrable** : Toutes les fonctionnalites avancees implementees. 82 tests, 0 failures. Rubocop 0 offenses. Brakeman 0 warnings.

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
