':
      return ref.watch(ginItemProvider).items.cast<RateableItem>();
    case 'wine':  // ADD THIS
      return ref.watch(wineItemProvider).items.cast<RateableItem>();
    default:
      return [];
  }
}
```

**Methods to update (15 total):**
- [ ] `getItems()`
- [ ] `getFilteredItems()`
- [ ] `isLoading()`
- [ ] `hasLoadedOnce()`
- [ ] `getErrorMessage()`
- [ ] `getSearchQuery()`
- [ ] `getActiveFilters()`
- [ ] `getFilterOptions()`
- [ ] `loadItems()`
- [ ] `refreshItems()`
- [ ] `clearFilters()`
- [ ] `clearTabSpecificFilters()`
- [ ] `updateSearchQuery()`
- [ ] `setCategoryFilter()`
- [ ] `getItemById()`

**Tip:** Use find-and-replace. Copy the entire gin case, replace 'gin' with 'wine'.

---

### **Step 10: Update ItemTypeHelper** (~3 min)

**File:** `lib/models/rateable_item.dart`

```dart
static IconData getItemTypeIcon(String itemType) {
  switch (itemType.toLowerCase()) {
    case 'cheese': return Icons.local_pizza;
    case 'gin': return Icons.local_bar;
    case 'wine': return Icons.wine_bar;  // ADD
    default: return Icons.category;
  }
}

static Color getItemTypeColor(String itemType) {
  switch (itemType.toLowerCase()) {
    case 'cheese': return Colors.orange;
    case 'gin': return Colors.teal;
    case 'wine': return Colors.purple;  // ADD
    default: return Colors.grey;
  }
}

static bool isItemTypeSupported(String itemType) {
  const supportedTypes = ['cheese', 'gin', 'wine'];  // ADD 'wine'
  return supportedTypes.contains(itemType.toLowerCase());
}
```

**Checklist:**
- [ ] Icon added
- [ ] Color added
- [ ] Added to supported types list

---

### **Step 11: Add to Home Screen** (~2 min)

**File:** `lib/screens/home/home_screen.dart`

```dart
// In build() method:

// Add state watch
final wineItemState = ref.watch(wineItemProvider);

// Add data loading
if (!wineItemState.hasLoadedOnce && !wineItemState.isLoading) {
  WidgetsBinding.instance.addPostFrameCallback((_) {
    ref.read(wineItemProvider.notifier).loadItems();
  });
}

// Add wine card (after gin card)
_buildItemTypeCard(
  context,
  ItemTypeLocalizer.getLocalizedItemType(context, 'wine'),
  'wine',
  Icons.wine_bar,
  Colors.purple,
  wineItemState.items.length,
  _getUniqueItemCount(ratingState.ratings, 'wine'),
),

// Update refresh handler
onRefresh: () async {
  ref.read(cheeseItemProvider.notifier).refreshItems();
  ref.read(ginItemProvider.notifier).refreshItems();
  ref.read(wineItemProvider.notifier).refreshItems();  // ADD
  ref.read(ratingProvider.notifier).refreshRatings();
},
```

**Checklist:**
- [ ] State watcher added
- [ ] Data loading added
- [ ] Wine card added to grid
- [ ] Refresh handler updated

---

### **Step 12: Add Item Type Switcher** (~1 min)

**File:** `lib/screens/items/item_type_screen.dart`

In `_buildItemTypeSwitcher()` method, add wine option:

```dart
PopupMenuItem(
  value: 'wine',
  child: Row(
    children: [
      Icon(
        Icons.wine_bar,
        color: widget.itemType == 'wine' ? Colors.purple : null,
      ),
      const SizedBox(width: AppConstants.spacingS),
      Text(
        ItemTypeLocalizer.getLocalizedItemType(context, 'wine'),
        style: TextStyle(
          fontWeight: widget.itemType == 'wine' ? FontWeight.bold : FontWeight.normal,
          color: widget.itemType == 'wine' ? Colors.purple : null,
        ),
      ),
    ],
  ),
),
```

**Checklist:**
- [ ] Wine option added to popup menu

---

### **Step 13: Add Localization** (~5 min)

**File:** `lib/l10n/app_en.arb`

```json
{
  "wine": "Wine",
  "wines": "Wines",
  "varietalLabel": "Varietal",
  "vintageLabel": "Vintage",
  "enterWineName": "Enter wine name",
  "enterVarietal": "Enter varietal",
  "varietalHint": "e.g., Chardonnay, Pinot Noir, Cabernet Sauvignon",
  "enterVintage": "Enter vintage year",
  "vintageHelperText": "Optional - year of production",
  "wineCreated": "Wine created successfully!",
  "wineUpdated": "Wine updated successfully!",
  "wineDeleted": "Wine deleted successfully!",
  "createWine": "Create Wine",
  "editWine": "Edit Wine",
  "addWine": "Add Wine",
  "allWines": "All Wines",
  "myWineList": "My Wine List",
  "filterByVarietal": "Filter by varietal",
  "filterByVintage": "Filter by vintage",
  "noWinesFound": "No wines found",
  "loadingWines": "Loading wines...",
  "varietalRequired": "Varietal is required"
}
```

**File:** `lib/l10n/app_fr.arb`

```json
{
  "wine": "Vin",
  "wines": "Vins",
  "varietalLabel": "Cépage",
  "vintageLabel": "Millésime",
  "enterWineName": "Entrer le nom du vin",
  "enterVarietal": "Entrer le cépage",
  "varietalHint": "ex: Chardonnay, Pinot Noir, Cabernet Sauvignon",
  "enterVintage": "Entrer l'année du millésime",
  "vintageHelperText": "Optionnel - année de production",
  "wineCreated": "Vin créé avec succès !",
  "wineUpdated": "Vin mis à jour avec succès !",
  "wineDeleted": "Vin supprimé avec succès !",
  "createWine": "Créer un Vin",
  "editWine": "Modifier le Vin",
  "addWine": "Ajouter un Vin",
  "allWines": "Tous les Vins",
  "myWineList": "Ma Liste de Vins",
  "filterByVarietal": "Filtrer par cépage",
  "filterByVintage": "Filtrer par millésime",
  "noWinesFound": "Aucun vin trouvé",
  "loadingWines": "Chargement des vins...",
  "varietalRequired": "Le cépage est requis"
}
```

**Generate localization files:**
```bash
flutter gen-l10n
```

**Checklist:**
- [ ] ~20 keys added to `app_en.arb`
- [ ] ~20 keys added to `app_fr.arb`
- [ ] `flutter gen-l10n` executed successfully
- [ ] No compilation errors

---

## ✅ Final Testing (~10 min)

### **Test Checklist:**

**Backend Running:**
```bash
cd alacarte-api
RUN_SEEDING=true WINE_DATA_SOURCE=../alacarte-seed/wines.json go run main.go
```

**Frontend:**
```bash
cd alacarte-client
flutter run -d linux
```

**Complete Flow Test:**
- [ ] Home screen shows wine card with correct item count
- [ ] Click wine card → navigates to `/items/wine`
- [ ] "All Wines" tab loads and displays wines
- [ ] "My Wine List" tab shows empty state (no ratings yet)
- [ ] Click wine item → detail screen shows all fields
- [ ] Community stats badge appears (if ratings exist)
- [ ] Click "Rate Wine" FAB → rating form opens
- [ ] Create rating → rating saves and appears in "My Wine List"
- [ ] Click edit button in wine detail → edit form opens with data
- [ ] Modify wine → saves successfully
- [ ] Click "Add Wine" FAB → create form opens
- [ ] Create new wine → wine appears in list
- [ ] Share wine rating → sharing works
- [ ] Switch language FR ↔ EN → all wine strings translate
- [ ] Item type switcher → wine appears in dropdown
- [ ] Switch between cheese/gin/wine → all work correctly

---

## 🎉 What You've Accomplished

With wine fully implemented, you now have:

✅ **Complete wine CRUD** - Create, read, update, delete wines  
✅ **Wine rating system** - Rate wines with stars and notes  
✅ **Wine sharing** - Share wine ratings with friends  
✅ **Wine discovery** - Browse all wines, filter, search  
✅ **Personal wine list** - Track wines you've rated  
✅ **Community stats** - See aggregate wine ratings  
✅ **Full localization** - French and English support  
✅ **Offline support** - Works offline with cached data  
✅ **Type-safe implementation** - Compile-time guarantees  

**And it only took ~50 minutes!** 🚀

---

## 📊 Architecture Benefits

### **Strategy Pattern for Forms**

The new Strategy Pattern (October 2025) provides:

**Zero Conditionals:**
```dart
// Generic form has NO item-type logic!
final item = _strategy.buildItem(_controllers, widget.itemId);
final provider = _strategy.getProvider();
await ref.read(provider.notifier).createItem(item);
```

**Easy Extension:**
- Add strategy class (~10 min)
- Register in registry (~1 min)
- Done! Forms work automatically

**Full Localization:**
- All strings use builder functions
- Context-aware translations
- Works with any language

**See:** [Form Strategy Pattern Documentation](docs/form-strategy-pattern.md)

---

## 🚀 Next Item Types

**Recommended Order:**
1. **Beer** - Similar to wine (style, ABV, brewery)
2. **Coffee** - Similar structure (roast, origin, process)
3. **Restaurant** - More complex (location, cuisine, dish ratings)

**Each should take ~50 minutes following this guide.**

---

## 💡 Pro Tips

### **Development:**
- Copy an existing model/service/provider as template
- Use find-and-replace for bulk updates (gin → wine)
- Test incrementally (model → service → provider → forms)
- Run `flutter gen-l10n` after localization changes

### **Debugging:**
- Check Riverpod provider state in Flutter Inspector
- Verify API endpoints return correct JSON format
- Use browser network tab to debug API calls
- Check console for provider loading logs

### **Best Practices:**
- Keep field keys consistent with model properties
- Always use localization builders in strategies
- Test both create and edit flows
- Verify French and English translations
- Test offline behavior

---

## 📚 Related Documentation

### **Architecture & Patterns:**
- **[Form Strategy Pattern](docs/form-strategy-pattern.md)** - Detailed strategy pattern documentation
- **[Developer Onboarding](../README.md#🚀-developer-onboarding-guide)** - Understanding the codebase

### **Reference Guides:**
- **[New Item Type Checklist](docs/new-item-type-checklist.md)** - Step-by-step checklist
- **[Internationalization](docs/internationalization.md)** - Localization system details

### **System Documentation:**
- **[Rating System](docs/rating-system.md)** - How ratings work
- **[Filtering System](docs/filtering-system.md)** - Search and filtering
- **[Sharing Implementation](docs/sharing-implementation.md)** - Rating sharing

---

**Last Updated:** October 2025  
**Status:** ✅ Current and Accurate (Post-Strategy Pattern Refactoring)  
**Pattern:** Generic Architecture + Strategy Pattern + ItemProviderHelper
