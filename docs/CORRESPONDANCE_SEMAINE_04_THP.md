# Correspondance The Gossip Project / Semaine 4 THP

Documentation point par point et jour par jour entre le projet **the-gossip-project** et le programme **Semaine 4** du parcours Fullstack THP (02-Fullstack/Semaine-04).

---

## Jour 1 — Découverte de Rails, premières views

### 2.1. Les bases : application et models

| Attendu THP | Projet | Statut |
|-------------|--------|--------|
| Nouvelle app `the-gossip-project`, migrations/models/seed de l’ancien exercice | App Rails 8, BDD avec `users`, `cities`, `gossips`, etc. | OK |

### 2.2. Pages statiques team et contact

| Attendu THP | Projet | Statut |
|-------------|--------|--------|
| Page **team** sur `/team` | `get "/team", to: "static_pages#team"` ; vue avec présentation équipe (Morgan, Romain) | OK |
| Page **contact** sur `/contact` | `get "/contact", to: "static_pages#contact"` ; vue avec email, Twitter, adresse | OK |

### 2.3. Mise en forme (CSS, header, liens)

| Attendu THP | Projet | Statut |
|-------------|--------|--------|
| CSS dans `app/assets/stylesheets/application.css` et/ou CDN Bootstrap | Bootstrap 5.3.3 en CDN dans `application.html.erb` ; styles additionnels via Propshaft | OK |
| Header (navbar Bootstrap) sur toutes les pages | Navbar Bootstrap dans `layouts/application.html.erb` avec liens | OK |
| Liens team et contact dans le header | Liens "Team" et "Contact" dans la navbar | OK |

### 2.4. URL cachée / bienvenue

| Attendu THP | Projet | Statut |
|-------------|--------|--------|
| URL type `welcome/first_name` | `get "/welcome/:first_name", to: "static_pages#welcome"` | OK |
| Message du type « BIENVENUE first_name ! Ici c'est notre super site de potins... » | Vue `welcome.html.erb` : « BIENVENUE <%= @first_name %> ! » + texte demandé | OK |

### 2.5. Page d’accueil : liste des potins

| Attendu THP | Projet | Statut |
|-------------|--------|--------|
| Accueil = liste des potins | `root "gossips#index"` ; index affiche les potins | OK |
| Afficher `author.first_name` et `title` | Cartes avec titre, auteur (lien user), date, extrait contenu | OK |
| Lien vers l’accueil dans le header | Lien "Accueil" dans la navbar | OK |

### 2.6. Afficher un potin (show)

| Attendu THP | Projet | Statut |
|-------------|--------|--------|
| Page dédiée par potin avec détail auteur (lien), title, content, date | `gossips#show` : titre, auteur (lien user_path), ville (lien city), date, contenu | OK |
| Depuis l’index, lien vers la page de chaque potin | Lien "Voir plus" par carte vers `gossip_path(gossip)` | OK |

### 2.7. Afficher un utilisateur (page profil)

| Attendu THP | Projet | Statut |
|-------------|--------|--------|
| Page profil avec infos importantes de l’utilisateur | `users#show` : first_name, last_name, email, age, ville (lien), description, liste des potins | OK |
| Lien vers l’auteur depuis la page potin | Lien sur le prénom de l’auteur vers `user_path(@gossip.user)` | OK |

### 2.8. Display plus joli (cards Bootstrap)

| Attendu THP | Projet | Statut |
|-------------|--------|--------|
| Potins en cards Bootstrap sur l’accueil | Index en `card` Bootstrap (titre, auteur, extrait, tags, commentaires, likes) | OK |

---

## Jour 2 — Création d’un potin, formulaires, REST

### 2.1. Validations models

| Attendu THP | Projet | Statut |
|-------------|--------|--------|
| Validations sur les attributs importants | `Gossip` : `title` presence, length 3..14 ; `content` presence | OK |

### 2.2. Création de potin (routes, controller, view)

| Attendu THP | Projet | Statut |
|-------------|--------|--------|
| Controller `gossips` avec `#new` et `#create` | `GossipsController` avec `new`, `create` | OK |
| Routes REST (resources) | `resources :gossips` (pas de routes à la main pour gossips) | OK |
| View formulaire `gossips/new.html.erb` | Partiel `_form.html.erb` + `new.html.erb` | OK |
| Pas de view `create.html.erb`, redirection vers index/show | `create` redirige vers `@gossip` (show) | OK |

### 2.2.2. Formulaire de création

| Attendu THP | Projet | Statut |
|-------------|--------|--------|
| Utiliser `form_tag` pour le formulaire de création | Formulaire en `form_with model: @gossip` (Rails 8), pas `form_tag` | Écart |
| Champs title et content, soumission vers `#create` | Champs title, content (et tags, image) ; soumission vers create | OK (équivalent) |

### 2.2.3. Controller create

| Attendu THP | Projet | Statut |
|-------------|--------|--------|
| Récupérer les données, créer une instance, save ; redirect si succès, render new si échec | `current_user.gossips.build(gossip_params)` ; redirect_to @gossip si save, sinon render :new | OK |
| Potin associé à un utilisateur (pas anonymous en base) | Potin associé à `current_user` (authentification requise) | OK (mieux) |
| Affichage des erreurs de validation dans la view | Flash + erreurs via `@gossip.errors` (Devise/flash) | OK |
| Alertes Bootstrap (vert succès, rouge erreur) | `shared/_flash_messages` avec alertes Bootstrap (notice/alert) | OK |

### Ressource : Enlever Turbo Drive

| Attendu THP | Projet | Statut |
|-------------|--------|--------|
| Désactiver Turbo sur liens/formulaires si besoin pour Bootstrap/JS | `local: true` sur `form_with` où nécessaire ; pas de `data: { turbo: false }` explicite partout | Partiel (comportement équivalent via local: true) |

---

## Jour 3 — CRUD complet, commentaires, bonus tags

### 2.1. Front / Bootstrap

| Attendu THP | Projet | Statut |
|-------------|--------|--------|
| CDN Bootstrap connecté | Bootstrap 5.3.3 CDN dans le layout | OK |
| Rendu présentable (jumbotron, list-group, etc. au choix) | Cartes, navbar, thème dark, mise en page soignée | OK |

### 2.2.1. Page potin (show)

| Attendu THP | Projet | Statut |
|-------------|--------|--------|
| URL `/gossips/:id` → page du potin | `resources :gossips` → show | OK |
| Afficher titre, contenu, auteur, ville de l’auteur | Show : titre, contenu, auteur (lien), ville (lien), date | OK |
| Lien depuis l’index vers chaque page potin | Lien "Voir plus" sur chaque carte | OK |

### 2.2.2. Page utilisateur (show)

| Attendu THP | Projet | Statut |
|-------------|--------|--------|
| Page user avec prénom, nom, description, email, age, ville | `users#show` : first_name, last_name, description, email, age, ville (lien) | OK |
| Lien vers l’auteur depuis la page potin | Lien sur le nom de l’auteur vers user_path | OK |

### 2.2.3. Page ville (show)

| Attendu THP | Projet | Statut |
|-------------|--------|--------|
| Page ville : nom, liste des potins des users de la ville | `cities#show` : nom, zip_code, liste des potins (cards) | OK |
| Lien vers la ville depuis page user et depuis page potin | Liens `city_path` depuis user et depuis gossip show | OK |

### 2.3. Edit / Update

| Attendu THP | Projet | Statut |
|-------------|--------|--------|
| Page `/gossips/:id/edit` avec formulaire d’édition | `edit` + `edit.html.erb` avec formulaire (form_with) | OK |
| Formulaire pointe vers `#update`, mise à jour en BDD | `update` avec redirect si succès, render :edit si échec | OK |
| Champs pré-remplis avec les données du potin | `form_with model: @gossip` pré-remplit les champs | OK |

### 2.4. Détruire

| Attendu THP | Projet | Statut |
|-------------|--------|--------|
| Lien/bouton supprimer sur la page potin | Bouton "Supprimer" sur show (visible uniquement pour l’auteur) | OK |
| Après suppression, redirection vers index des potins | `redirect_to gossips_path` après destroy | OK |

### 2.5. Commentaires de potins

| Attendu THP | Projet | Statut |
|-------------|--------|--------|
| Formulaire pour ajouter un commentaire sur la page show du gossip | Formulaire (modale) sur `gossips#show` ; create en nested `gossips/:gossip_id/comments` | OK |
| Nouveau commentaire assigné à l’utilisateur (ou anonyme) | Commentaire associé à `current_user` | OK |
| Liste des commentaires sur la page show (auteur, texte, lien modifier) | Liste des commentaires avec auteur, texte, lien Modifier/Supprimer (auteur) | OK |
| Page edit du commentaire | `comments#edit` + `edit.html.erb` | OK |
| Destruction du commentaire (bouton) | `comments#destroy` + bouton Supprimer (auteur uniquement) | OK |
| Nombre de commentaires affiché sur l’index des potins | Compteur commentaires sur chaque carte de l’index | OK |

### 2.6. Tags (bonus THP)

| Attendu THP | Projet | Statut |
|-------------|--------|--------|
| Tags en base, seed avec une dizaine de tags | Table `tags`, `join_table_gossip_tags` ; seed avec tags | OK |
| Select (ou équivalent) pour choisir un tag à la création du potin | Formulaire new/edit avec `tag_ids: []` (checkboxes/select) | OK |
| Controller met à disposition la liste des tags | `@tags = Tag.order(:title)` dans new et edit | OK |
| Possibilité d’ajouter aussi à l’édition | Tags gérés dans edit/update (tag_ids dans gossip_params) | OK |
| Page tag (optionnel) | `resources :tags, only: [:show]` + vue tag avec gossips | OK (bonus) |

---

## Jour 4 — Login, sessions, likes, sécurisation

### 2.1. Création d’utilisateurs (mot de passe)

| Attendu THP | Projet | Statut |
|-------------|--------|--------|
| Création d’utilisateur avec mot de passe (non stocké en clair) | Inscription via **Devise** (password hashing par la gem) | Écart (voir ci-dessous) |
| Lien inscription dans la navbar | Liens "Connexion" / "Inscription" dans la navbar si non connecté | OK |
| Après inscription, redirection vers l’accueil | Redirection après sign_up (Devise) | OK |

**Écart Jour 4 :** THP impose **pas de gem d’auth type Devise/Clearance**, uniquement **bcrypt**. Ici le projet utilise **Devise** (avec mot de passe chiffré). Les objectifs métier (inscription, mot de passe hasché) sont remplis, mais la contrainte pédagogique THP (tout coder avec bcrypt/sessions) ne l’est pas.

### 2.2. Login / Logout

| Attendu THP | Projet | Statut |
|-------------|--------|--------|
| Écran de connexion (email + mot de passe) | `devise/sessions/new` | OK |
| Création de session si auth OK, redirection accueil | Devise gère session + redirect | OK |
| Login automatique après création de compte | Devise connecte après sign_up | OK |
| `sessions#destroy` pour déconnexion | `destroy_user_session_path` (Devise) | OK |
| Navbar : si non connecté → dropdown "S'inscrire / Se connecter" ; si connecté → bouton déconnexion | Navbar : Connexion / Inscription vs Mon compte, Déconnexion | OK (pas de dropdown, liens directs) |

### 2.3. Potins et commentaires liés à l’utilisateur connecté

| Attendu THP | Projet | Statut |
|-------------|--------|--------|
| Potin créé = associé à l’utilisateur connecté | `current_user.gossips.build(gossip_params)` | OK |
| Commentaire créé = associé à l’utilisateur connecté | `@comment.user = current_user` dans create | OK |

### 2.4. Impossible de commérer sans être connecté

| Attendu THP | Projet | Statut |
|-------------|--------|--------|
| `#new` et `#create` (gossips) : vérifier utilisateur connecté, sinon redirection login | `before_action :authenticate_user!, only: [:new, :create, ...]` (Devise) | OK |
| Idem pour affichage du potin (`show`) | `authenticate_user!` sur `show` | OK (plus restrictif que THP qui peut laisser show en public) |
| Idem pour création de commentaires | `authenticate_user!` sur `comments#create` | OK |
| Indice : `before_action` | Utilisation de `before_action` (via Devise + custom) | OK |

### 2.5. Édition et destruction réservées à l’auteur

| Attendu THP | Projet | Statut |
|-------------|--------|--------|
| Bouton éditer visible uniquement pour l’auteur du potin | `user_signed_in? && current_user == @gossip.user` pour afficher Modifier/Supprimer | OK |
| `gossips#edit`, `#update`, `#destroy` : vérifier que current_user est l’auteur | `before_action :authorize_gossip!, only: [:edit, :update, :destroy]` | OK |
| Idem pour commentaires (edit/update/destroy) | `authorize_comment!` pour edit/update/destroy (auteur uniquement) | OK |

### 2.6. Likes

| Attendu THP | Projet | Statut |
|-------------|--------|--------|
| Liker un potin (index, page ville, page potin) | Likes sur index, cities#show, gossips#show (bouton J’aime / Unlike) | OK |
| Like attribué à l’utilisateur connecté ; impossible si non connecté | Création/suppression de like liée à `current_user` ; boutons désactivés ou masqués si non connecté | OK |
| Afficher le nombre de likes par potin | Compteur `gossip.likes.size` sur index, show, city | OK |
| Déliker possible | `likes#destroy` (bouton Unlike) | OK |

---

## Jour 5 — Production, cookies, « Se souvenir de moi »

### 2.1. Mise en production

| Attendu THP | Projet | Statut |
|-------------|--------|--------|
| Mettre l’app en ligne (Heroku ou équivalent) | Doc `docs/DEPLOI_HEROKU_POSTGRESQL.md` ; Gemfile en SQLite dev, possibilité PostgreSQL prod ; pas de Heroku obligatoire (THP indique que c’est bonus si Heroku payant) | OK (doc + config) |

### 2.2. Système de cookies

| Attendu THP | Projet | Statut |
|-------------|--------|--------|
| Remplacer les sessions par des cookies pour persistance (rester connecté après fermeture) | **Devise** : module `:rememberable` (cookies persistants) ; sessions toujours utilisées en parallèle | Écart (implémentation manuelle THP vs Devise) |
| Cookie créé à l’inscription (se souvenir après signup) | Checkbox "Se souvenir de moi" au signup ; si cochée, `remember_me!` après création (RegistrationsController) | OK |

### 2.3. Remember me

| Attendu THP | Projet | Statut |
|-------------|--------|--------|
| Checkbox "Se souvenir de moi" au **signup** | Présente sur `registrations/new` ; prise en compte dans `Users::RegistrationsController` | OK |
| Checkbox "Se souvenir de moi" au **login** | Présente sur `sessions/new` (Devise) | OK |
| Si coché → cuisiner des cookies ; si non coché → pas de cookies (sessions restent pour ne pas bloquer) | Comportement Devise : remember_me gère durée et cookies ; sessions utilisées en parallèle | OK |

---

## Synthèse des écarts par rapport au programme THP

| Point | Programme THP | Projet | Commentaire |
|-------|----------------|--------|-------------|
| Formulaire création potin | `form_tag` | `form_with model: @gossip` | Choix Rails moderne (form_with). Comportement équivalent. |
| Authentification | bcrypt + sessions/cookies à la main, **sans Devise** | **Devise** (inscription, login, logout, remember_me) | Contrainte pédagogique THP non respectée ; objectifs fonctionnels atteints. |
| Cookies / Remember me | Implémentation manuelle (remember_token, remember_digest, etc.) | Devise `:rememberable` | Même résultat utilisateur ; implémentation différente. |
| Base de données prod | PostgreSQL pour Heroku | SQLite en dev ; doc PostgreSQL pour déploiement | Conforme à la doc THP (Heroku optionnel, PostgreSQL possible). |

---

## Bonus en place (hors programme THP)

Fonctionnalités présentes dans **the-gossip-project** qui ne font **pas** partie du programme Semaine 4 THP :

- **Devise** : authentification complète (inscription, connexion, déconnexion, remember me, reset password).
- **Messagerie privée** : `PrivateMessage`, `ConversationsController`, envoi de messages entre utilisateurs.
- **Follow / Feed** : modèle `Follow`, fil d’actualité (`/feed`) basé sur les utilisateurs suivis.
- **Notifications** : modèle `Notification`, page `/notifications` (notifiable polymorphique).
- **Recherche** : `SearchController`, page `/search` (form_tag GET).
- **Likes polymorphiques** : likes sur Gossip et Comment (modèle `Like` avec likeable).
- **Commentaires polymorphiques** : commentaires sur Gossip (et structure extensible à d’autres types).
- **Admin** : namespace `admin`, dashboard, rôle `admin` sur User.
- **API JSON** : `api/v1` (gossips, users en read).
- **Avatar / Active Storage** : pièce jointe image sur User et image sur Gossip.
- **Pagination** : gem Pagy sur l’index des potins.
- **PWA** : vues/manifest/service worker (optionnel, commenté dans les routes).
- **CI** : GitHub Actions (tests, lint, sécurité).
- **Déploiement** : documentation Heroku/PostgreSQL ; Kamal/Docker évoqués (bin/kamal, Dockerfile).
- **Accessibilité** : aria-labels, roles, structure sémantique (WCAG 2.1 AA).
- **Thème et UX** : thème Bootstrap dark, animations (fusée, étoiles), design soigné.

---

*Document généré pour vérifier la correspondance entre the-gossip-project et le programme Semaine 4 THP (Jour 1 à 5).*
