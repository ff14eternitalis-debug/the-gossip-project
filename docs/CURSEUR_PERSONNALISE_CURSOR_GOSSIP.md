# Curseur personnalisé — cursor_gossip.svg

Documentation en phases pour utiliser `public/icons/cursor_gossip.svg` comme curseur de la souris sur l’ensemble du site The Gossip Project.

**Fichier cible :** `public/icons/cursor_gossip.svg` (icône 32×32, type “bulle / gossip”).

**Contrainte navigateurs :** la propriété CSS `cursor: url(...)` est supportée par tous les navigateurs modernes. Les images de curseur sont souvent limitées à 32×32 px ; le SVG actuel respecte cette taille. Le support du **SVG** en tant que curseur varie (Firefox : oui ; Chrome/Edge : selon version ; Safari : variable). En fallback, on conserve un curseur système.

---

## Phase 1 — Vérifier que l’asset est servi

**Objectif :** s’assurer que le fichier est accessible en HTTP.

1. Lancer l’application (`rails server` ou `bin/dev`).
2. Ouvrir dans le navigateur : `http://localhost:3000/icons/cursor_gossip.svg`.
3. Vérifier que l’image s’affiche (icône bleue type bulle).  
   Les fichiers dans `public/` sont servis à la racine du site, donc l’URL est bien `/icons/cursor_gossip.svg`.

**Si l’image ne s’affiche pas :** vérifier le chemin du fichier (`public/icons/cursor_gossip.svg`) et les permissions.

---

## Phase 2 — Définir le curseur par défaut en CSS

**Objectif :** appliquer ce curseur à tout le corps de la page.

1. Ouvrir le fichier de styles utilisé par le layout principal (ex. `app/assets/stylesheets/application.css` — ou le fichier inclus via `stylesheet_link_tag` dans `app/views/layouts/application.html.erb`).
2. Ajouter une règle sur l’élément qui englobe tout le contenu (en général `body`, ou `html` si besoin) :
   - Propriété : `cursor`
   - Valeur : `url('/icons/cursor_gossip.svg') 0 0, auto`
   - Explication :
     - `url('/icons/cursor_gossip.svg')` : image du curseur (chemin racine du site).
     - `0 0` : point de “hot spot” (coordonnées x y du pixel qui représente le clic). Ici (0, 0) = coin supérieur gauche. On peut ajuster plus tard (ex. `8 8`) si le curseur doit “pointer” plus au centre.
     - `auto` : fallback si l’image ne charge pas ou n’est pas supportée (curseur par défaut du système).

3. Sauvegarder, recharger la page et vérifier que le curseur change sur l’ensemble du site.

**Remarque :** ne pas oublier le fallback `, auto` ; sans lui, certains navigateurs peuvent ignorer la règle ou afficher un curseur vide.

---

## Phase 3 — Conserver les curseurs système sur les zones interactives (optionnel)

**Objectif :** garder le comportement attendu (pointeur sur les liens, texte sur les champs, etc.) tout en gardant le curseur personnalisé ailleurs.

1. Identifier les sélecteurs déjà utilisés pour les liens (`a`), boutons (`button`, `.btn`), champs de formulaire (`input`, `textarea`), etc.
2. Pour les **liens et boutons cliquables** : soit ne pas surcharger `cursor` (ils hériteront du `body`), soit définir explicitement `cursor: url('/icons/cursor_gossip.svg') 0 0, pointer` pour garder le même visuel tout en sémantique “pointer”.
3. Pour les **zones de texte** (saisie) : ajouter une règle du type `cursor: text` sur `input`, `textarea`, et éventuellement sur les zones `contenteditable`, afin que le curseur reste “texte” dans ces zones (ou garder le curseur personnalisé si c’est voulu).
4. Tester clics, survols de liens, et saisie dans les champs pour valider le comportement.

**Alternative :** tout le site en curseur personnalisé sans distinction (pas de règle supplémentaire). Dans ce cas, la Phase 3 se limite à un simple test de confort d’utilisation.

---

## Phase 4 — Ajuster le point de clic (hot spot) si besoin

**Objectif :** si le curseur “clique” à un endroit visuellement décalé par rapport à l’icône, ajuster les coordonnées du hot spot.

1. La syntaxe CSS est : `cursor: url('/icons/cursor_gossip.svg') <x> <y>, auto`
2. `<x>` et `<y>` sont en pixels (sans unité dans la spec CSS). Exemples :
   - `0 0` : coin supérieur gauche.
   - `16 16` : centre approximatif pour une image 32×32.
3. Modifier les valeurs dans la règle définie en Phase 2 (et Phase 3 si la même URL est utilisée), sauvegarder, recharger et tester jusqu’à obtenir un ressenti correct au clic.

---

## Phase 5 — Compatibilité et fallback (optionnel)

**Objectif :** améliorer la compatibilité sur les navigateurs qui gèrent mal les curseurs SVG ou les images > 32×32.

1. **Fallback déjà en place :** `, auto` assure un curseur système si l’URL échoue.
2. **PNG de secours (optionnel) :** créer une version PNG 32×32 de la même icône (`cursor_gossip.png`), la placer dans `public/icons/`, et utiliser une règle du type :  
   `cursor: url('/icons/cursor_gossip.svg') 0 0, url('/icons/cursor_gossip.png') 0 0, auto`  
   (le navigateur utilisera la première ressource qu’il supporte).
3. Tester sur les navigateurs cibles (Chrome, Firefox, Safari, Edge). Si le SVG ne s’affiche pas, le PNG ou `auto` prendront le relais.

---

## Récapitulatif des fichiers concernés

| Phase | Fichier(s) à modifier / à utiliser |
|-------|------------------------------------|
| 1 | Aucun (vérification URL `http://localhost:3000/icons/cursor_gossip.svg`) |
| 2 | Feuille de styles principale (ex. `app/assets/stylesheets/application.css`) — règle `body { cursor: ... }` (ou `html`) |
| 3 | Même feuille — règles ciblées sur `a`, `button`, `input`, `textarea` si besoin |
| 4 | Même feuille — ajustement des valeurs `x y` dans `url(...)` |
| 5 | Optionnel : ajout d’un PNG dans `public/icons/` et mise à jour de la règle `cursor` |

---

## Références

- [MDN — cursor](https://developer.mozilla.org/en-US/docs/Web/CSS/cursor)
- Spécification CSS : `cursor: url(...) [x y], <keyword>`
- Fichier du projet : `public/icons/cursor_gossip.svg` (32×32, déjà prêt pour usage comme curseur)
