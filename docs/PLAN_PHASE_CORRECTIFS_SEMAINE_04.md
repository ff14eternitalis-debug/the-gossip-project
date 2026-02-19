# Plan de phase — Correctifs alignement Semaine 4 THP

Document dérivé de `docs/CORRESPONDANCE_SEMAINE_04_THP.md`. Objectif : planifier les correctifs possibles pour rapprocher le projet du programme THP Semaine 4, en limitant les régressions.

---

## 1. Synthèse des écarts concernés

| Référence | Attendu THP | Projet actuel | Statut |
|-----------|-------------|---------------|--------|
| Jour 2 — 2.2.2 | `form_tag` pour création potin | `form_with model: @gossip` | Écart |
| Jour 2 — Ressource | Désactiver Turbo si besoin | `local: true` sur form_with | Partiel |
| Jour 4 — 2.1 | Inscription avec bcrypt, **sans gem d’auth** | Devise (mot de passe hasché) | Écart |
| Jour 5 — 2.2 / 2.3 | Cookies / remember me à la main | Devise `:rememberable` | Écart |

---

## 2. Plan de phase

### Phase 1 — Correctif formulaire création potin (form_tag)

**Objectif :** Aligner le formulaire de **création** de potin sur la consigne THP (`form_tag`) sans casser le flux ni le controller.

**Périmètre :**
- Fichier : `app/views/gossips/_form.html.erb` lorsqu’il est utilisé par `new.html.erb` uniquement, **ou** créer un partiel dédié `_form_new.html.erb` en `form_tag` et garder `_form.html.erb` en `form_with` pour l’édition.
- Alternative plus simple : un seul formulaire en `form_tag` pour new et edit, avec `url` et `method` dynamiques (new → `gossips_path`, post ; edit → `gossip_path(@gossip)`, patch). THP ne demande `form_tag` que pour la **création** ; l’édition peut rester en `form_with` si on isole le formulaire de création.

**Recommandation :** Introduire un formulaire de création distinct en `form_tag` :
- Vue : `app/views/gossips/new.html.erb` utilise un partiel `_form_new.html.erb` (ou le contenu inline) avec `form_tag gossips_path, method: :post`.
- Champs avec noms structurés : `gossip[title]`, `gossip[content]`, `gossip[tag_ids][]`, `gossip[image]`, pour que `params.require(:gossip).permit(...)` et `gossip_params` restent inchangés.
- Conserver `_form.html.erb` en `form_with` pour `edit`/`update` (pas exigé par THP pour form_tag).

**Vérifications pour ne rien casser :**
- Controller : `create` continue d’utiliser `gossip_params` → aucun changement.
- Création potin (titre, contenu, tags, image) : test manuel ou scénario system (connexion, new, submit).
- Affichage des erreurs de validation : le partiel actuel affiche `@gossip.errors` ; avec `form_tag` et redirection `render :new`, `@gossip` est toujours renseigné → garder le bloc d’erreurs tel quel.
- CI : lancer les tests (GossipsController, system gossips) après modification.

**Risque :** Faible si les noms de champs restent `gossip[attr]`.

---

### Phase 2 — Turbo Drive (documentation / optionnel)

**Objectif :** Clarifier que le comportement est conforme (soumission classique, pas de conflit Bootstrap/JS).

**Périmètre :**
- Aucun correctif obligatoire : `local: true` sur les formulaires concernés donne déjà une soumission non-Turbo.
- Optionnel : ajouter `data: { turbo: false }` sur le formulaire de création de potin si on veut une désactivation explicite pour alignement avec la “ressource THP”.

**Vérifications :**
- Soumission du formulaire de création potin : rechargement de page, pas de remplacement partiel du DOM non voulu.
- Aucun changement de controller nécessaire.

**Risque :** Nul si on ne fait que documenter ; faible si on ajoute `data: { turbo: false }`.

---

### Phase 3 — Authentification (Devise vs bcrypt manuel) — **Non recommandé**

**Objectif THP :** Création utilisateur et login avec bcrypt et sessions/cookies à la main, **sans** Devise/Clearance.

**Périmètre actuel du projet :**
- Devise utilisé partout : `User` (confirmable, rememberable, etc.), `authenticate_user!`, `current_user`, routes Devise, vues Devise, `Users::RegistrationsController`, reset password, etc.
- Nombreux contrôleurs et vues dépendent de `current_user` et des helpers Devise.

**Impact d’un correctif :**
- Remplacer Devise par une implémentation manuelle (bcrypt, `sessions_controller`, `remember_token`/digest, etc.) toucherait :
  - `User` (champs, callbacks, méthodes)
  - Routes et contrôleurs d’auth
  - Toutes les vues d’inscription/connexion/mot de passe
  - `ApplicationController` (méthode d’auth courante)
  - Tous les `before_action :authenticate_user!` et `user_signed_in?`
- Risque de régression très élevé et charge de travail importante.

**Recommandation :** Ne pas inclure ce correctif dans le plan de phase. Le documenter comme **écart assumé** : objectifs métier (inscription, mot de passe hasché, sessions, remember me) remplis ; contrainte pédagogique THP (tout coder à la main) non remplie.

**Si alignement strict THP requis à long terme :** traiter comme un projet séparé (branche dédiée, refonte auth complète, suite de tests et recette).

---

### Phase 4 — Cookies / Remember me à la main — **Non recommandé**

**Objectif THP :** Remplacer les sessions par des cookies et implémenter “Se souvenir de moi” à la main (remember_token, remember_digest, etc.).

**Constat :** Entièrement lié à Devise (`:rememberable`). Supprimer Devise ou le remplacer implique de refaire toute la couche auth (voir Phase 3).

**Recommandation :** Même décision que Phase 3 — hors périmètre du plan de correctifs, à documenter comme écart assumé.

---

## 3. Récapitulatif des actions recommandées

| Phase | Action | Fichiers principaux | Risque | Priorité |
|-------|--------|---------------------|--------|----------|
| 1 | Formulaire création potin en `form_tag` (noms `gossip[attr]`) | `app/views/gossips/new.html.erb`, partiel dédié ou `_form.html.erb` | Faible | Recommandé si alignement pédagogique souhaité |
| 2 | Documenter Turbo / optionnel `data: { turbo: false }` | Doc ou `_form_new.html.erb` | Nul / faible | Optionnel |
| 3 | Remplacer Devise par bcrypt/sessions manuel | — | Élevé | Non recommandé |
| 4 | Cookies / remember me manuel | — | Élevé | Non recommandé |

---

## 4. Checklist avant déploiement d’un correctif (Phase 1)

- [ ] Noms des champs du formulaire : `gossip[title]`, `gossip[content]`, `gossip[tag_ids][]`, `gossip[image]`.
- [ ] Aucune modification de `gossip_params` ni de `create`/`update`.
- [ ] Bloc d’erreurs `@gossip.errors` conservé sur la vue de création.
- [ ] Tests GossipsController (new, create) passent.
- [ ] Tests system (création potin après login) passent.
- [ ] Vérification manuelle : création avec/sans tags, avec/sans image, validation (titres trop courts/longs).

---

*Document créé pour planifier les correctifs d’alignement avec la Semaine 4 THP tout en limitant les régressions. Référence : `docs/CORRESPONDANCE_SEMAINE_04_THP.md`.*
