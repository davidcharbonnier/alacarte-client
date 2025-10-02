# Adding New Item Types - Frontend Guide (Post-Refactoring)

**Document Updated:** October 1, 2025  
**Status:** ItemProviderHelper pattern implemented ✅  
**Item Types:** Cheese, Gin

---

## 🎯 Overview

After the October 2025 refactoring, adding new item types is dramatically simpler:

- **Time:** ~20 minutes (was 48 minutes)
- **Code changes:** Minimal - just update switch statements
- **Screen changes:** ZERO - screens work automatically!

---

## ✨ What Changed (Post-Refactoring)

### Before Refactoring
- Had to duplicate ~400 lines of screen code per item type
- ItemTypeScreen needed cheese/gin specific methods
- ItemDetailScreen had type-specific loading logic
- High risk of bugs from missed updates

### After Refactoring ✅
- **ItemProviderHelper** handles all type-specific logic
- Screens are 100% generic - work with any item type
- Just update switch statements in helper
- Compiler catches any missed cases

---

## 📋 Quick Checklist

Adding a new item type (e.g., Wine):

1. ✅ Create model (`wine_item.dart`) - 10 min
2. ✅ Create service (`WineItemService`) - 10 min  
3. ✅ Register provider (`wineItemProvider`) - 5 min
4. ✅ Update `ItemProviderHelper` switch statements - 5 min
5. ✅ Update `ItemTypeHelper` (icons, colors) - 3 min
6. ✅ Add to home screen card - 2 min
7. ✅ Add localization strings - 5 min
8. ✅ Test - 10 min

**Total: ~50 minutes** (everything included)

---

## 🏗️ Step-by-Step Implementation

### Step 1: Create Model (~10 min)

**File:** `lib/models/wine_item.dart`

```dart
import 'package:flutter/material.dart';
import 'rateable_item.dart';

class WineItem implements RateableItem {
  @override
  final int? id;
  
  @override
  final String name;
  
  final String producer;
  final String origin;
  final String varietal;  // Wine-specific
  final String? description;

  const WineItem({
    this.id,
    required this.name,
    required this.producer,
    required this.origin,
    required this.varietal,
    this.description,
  });

  @override
  String get itemType => 'wine';

  @override
  String get displayTitle => name;

  @override
  String get displaySubtitle => '$producer • $origin';

  @override
  String get searchableText => 
    '$name $producer $origin $varietal ${description ?? ''}'.toLowerCase();

  @override
  Map<String, String> get categories => {
    'producer': producer,
    'origin': origin,
    'varietal': varietal,
  };

  @override
  List<DetailField> get detailFields => [
    DetailField(label: 'Producer', value: producer, icon: Icons.business),
    DetailField(label: 'Origin', value: origin, icon: Icons.location_on),
    DetailField(label: 'Varietal', value: varietal, icon: Icons.wine_bar),
    if (description != null && description!.isNotEmpty)
      DetailField(label: 'Description', value: description!, isDescription: true),
  ];

  @override
  Map<String, dynamic> toJson() => {
    'ID': id,
    'name': name,
    'producer': producer,
    'origin': origin,
    'varietal': varietal,
    'description': description,
  };

  factory WineItem.fromJson(Map<String, dynamic> json) => WineItem(
    id: json['ID'] as int?,
    name: json['name'] ?? '',
    producer: json['producer'] ?? '',
    origin: json['origin'] ?? '',
    varietal: json['varietal'] ?? '',
    description: json['description'],
  );

  @override
  WineItem copyWith(Map<String, dynamic> updates) => WineItem(
    id: updates['id'] ?? id,
    name: updates['name'] ?? name,
    producer: updates['producer'] ?? producer,
    origin: updates['origin'] ?? origin,
    varietal: updates['varietal'] ?? varietal,
    description: updates['description'] ?? description,
  );
}

// Extension for filtering
extension WineItemExtension on WineItem {
  static List<String> getUniqueProducers(List<WineItem> wines) =>
    wines.map((w) => w.producer).toSet().toList()..sort();
  
  static List<String> getUniqueOrigins(List<WineItem> wines) =>
    wines.map((w) => w.origin).toSet().toList()..sort();
  
  static List<String> getUniqueVarietals(List<WineItem> wines) =>
    wines.map((w) => w.varietal).toSet().toList()..sort();
}
```

---

### Step 2: Create Service (~10 min)

**File:** `lib/services/item_service.dart` (add to end of file)

```dart
/// Concrete implementation for Wine items
class WineItemService extends ItemService<WineItem> {
  ApiResponse<List<WineItem>>? _cachedResponse;
  DateTime? _cacheTime;
  static const Duration _cacheExpiry = Duration(minutes: 5);
  
  @override
  String get itemTypeEndpoint => '/api/wine';

  @override
  WineItem Function(dynamic) get fromJson =>
      (dynamic json) => WineItem.fromJson(json as Map<String, dynamic>);

  @override
  List<String> Function(WineItem) get validateItem => _validateWineItem;
  
  @override
  Future<ApiResponse<List<WineItem>>> getAllItems() async {
    if (_cachedResponse != null && _cacheTime != null) {
      final age = DateTime.now().difference(_cacheTime!);
      if (age < _cacheExpiry) return _cachedResponse!;
    }
    
    final response = await handleListResponse<WineItem>(
      get('$itemTypeEndpoint/all'), 
      fromJson
    );
    
    if (response is ApiSuccess<List<WineItem>>) {
      _cachedResponse = response;
      _cacheTime = DateTime.now();
    }
    
    return response;
  }
  
  void clearCache() {
    _cachedResponse = null;
    _cacheTime = null;
  }

  static List<String> _validateWineItem(WineItem wine) {
    final errors = <String>[];
    if (wine.name.trim().isEmpty) errors.add('Name is required');
    if (wine.producer.trim().isEmpty) errors.add('Producer is required');
    if (wine.origin.trim().isEmpty) errors.add('Origin is required');
    if (wine.varietal.trim().isEmpty) errors.add('Varietal is required');
    return errors;
  }

  Future<ApiResponse<List<String>>> getWineProducers() async {
    final response = await getAllItems();
    return response.when(
      success: (wines, _) => ApiResponseHelper.success(
        WineItemExtension.getUniqueProducers(wines)
      ),
      error: (msg, code, errCode, details) => 
        ApiResponseHelper.error<List<String>>(msg, statusCode: code),
      loading: () => ApiResponseHelper.loading<List<String>>(),
    );
  }

  // Similar methods for getWineOrigins() and getWineVarietals()
}

final wineItemServiceProvider = Provider<WineItemService>(
  (ref) => WineItemService(),
);
```

**Don't forget:** Add import at top: `import '../models/wine_item.dart';`

---

### Step 3: Register Provider (~5 min)

**File:** `lib/providers/item_provider.dart`

```dart
// Add import
import '../models/wine_item.dart';

// Register provider (add to end of file)
final wineItemProvider = StateNotifierProvider<WineItemProvider, ItemState<WineItem>>(
  (ref) => WineItemProvider(ref.read(wineItemServiceProvider)),
);

class WineItemProvider extends ItemProvider<WineItem> {
  WineItemProvider(WineItemService wineService) : super(wineService);

  @override
  Future<void> _loadFilterOptions() async {
    final wineService = _itemService as WineItemService;
    
    final producersResponse = await wineService.getWineProducers();
    // ... similar to gin implementation
  }

  void setProducerFilter(String? producer) => setCategoryFilter('producer', producer);
  void setOriginFilter(String? origin) => setCategoryFilter('origin', origin);
  void setVarietalFilter(String? varietal) => setCategoryFilter('varietal', varietal);
}

// Update cache clearing in createItem()
if (_itemService is WineItemService) {
  (_itemService as WineItemService).clearCache();
}
```

---

### Step 4: Update ItemProviderHelper (~5 min) ⭐

**File:** `lib/utils/item_provider_helper.dart`

Add `case 'wine':` to **ALL 15 switch statements**:

```dart
static List<RateableItem> getItems(WidgetRef ref, String itemType) {
  switch (itemType.toLowerCase()) {
    case 'cheese':
      return ref.watch(cheeseItemProvider).items.cast<RateableItem>();
    case 'gin':
      return ref.watch(ginItemProvider).items.cast<RateableItem>();
    case 'wine':  // ADD THIS LINE
      return ref.watch(wineItemProvider).items.cast<RateableItem>();
    default:
      return [];
  }
}
```

**Repeat for all methods:**
- `getItems()`
- `getFilteredItems()`
- `isLoading()`
- `hasLoadedOnce()`
- `getErrorMessage()`
- `getSearchQuery()`
- `getActiveFilters()`
- `getFilterOptions()`
- `loadItems()`
- `refreshItems()`
- `clearFilters()`
- `clearTabSpecificFilters()`
- `updateSearchQuery()`
- `setCategoryFilter()`
- `getItemById()`

**Tip:** Use find-and-replace to speed this up. Search for the gin case and duplicate it for wine.

---

### Step 5: Update ItemTypeHelper (~3 min)

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

---

### Step 6: Add to Home Screen (~2 min)

**File:** `lib/screens/home/home_screen.dart`

```dart
// In build() method:
final wineItemState = ref.watch(wineItemProvider);  // ADD

// Load wine data if needed
if (!wineItemState.hasLoadedOnce && !wineItemState.isLoading) {
  WidgetsBinding.instance.addPostFrameCallback((_) {
    ref.read(wineItemProvider.notifier).loadItems();
  });
}

// Add wine card
_buildItemTypeCard(
  context,
  ItemTypeLocalizer.getLocalizedItemType(context, 'wine'),
  'wine',
  Icons.wine_bar,
  Colors.purple,
  wineItemState.items.length,
  _getUniqueItemCount(ratingState.ratings, 'wine'),
),

// Update refresh
onRefresh: () async {
  ref.read(cheeseItemProvider.notifier).refreshItems();
  ref.read(ginItemProvider.notifier).refreshItems();
  ref.read(wineItemProvider.notifier).refreshItems();  // ADD
  ref.read(ratingProvider.notifier).refreshRatings();
},
```

---

### Step 7: Add Localization (~5 min)

**Files:** `lib/l10n/app_en.arb` and `lib/l10n/app_fr.arb`

**English:**
```json
{
  "wine": "Wine",
  "wines": "Wines",
  "varietalLabel": "Varietal",
  "enterWineName": "Enter wine name",
  "enterVarietal": "Enter varietal",
  "varietalHint": "e.g., Cabernet Sauvignon, Chardonnay",
  "wineCreated": "Wine created successfully!",
  "wineUpdated": "Wine updated successfully!",
  "wineDeleted": "Wine deleted successfully!",
  "createWine": "Create Wine",
  "editWine": "Edit Wine",
  "addWine": "Add Wine",
  "allWines": "All Wines",
  "myWineList": "My Wine List",
  "filterByVarietal": "Filter by varietal",
  "noWinesFound": "No wines found",
  "loadingWines": "Loading wines..."
}
```

**French:**
```json
{
  "wine": "Vin",
  "wines": "Vins",
  "varietalLabel": "Cépage",
  "enterWineName": "Entrer le nom du vin",
  "enterVarietal": "Entrer le cépage",
  "varietalHint": "ex: Cabernet Sauvignon, Chardonnay",
  "wineCreated": "Vin créé avec succès !",
  "wineUpdated": "Vin mis à jour avec succès !",
  "wineDeleted": "Vin supprimé avec succès !",
  "createWine": "Créer un Vin",
  "editWine": "Modifier le Vin",
  "addWine": "Ajouter un Vin",
  "allWines": "Tous les Vins",
  "myWineList": "Ma Liste de Vins",
  "filterByVarietal": "Filtrer par cépage",
  "noWinesFound": "Aucun vin trouvé",
  "loadingWines": "Chargement des vins..."
}
```

**Generate:**
```bash
flutter gen-l10n
```

---

### Step 8: Test (~10 min)

1. **Backend:** Ensure wine endpoints work
2. **Generate localization:** `flutter gen-l10n`
3. **Run app:** `flutter run -d linux`
4. **Test flow:**
   - ✅ Home shows wine card
   - ✅ Click wine → navigates to wine list
   - ✅ Both tabs load
   - ✅ Click wine → detail screen loads
   - ✅ Rate wine → rating created
   - ✅ Share rating → sharing works
   - ✅ Switch item types → works seamlessly

---

## 🎉 What Works Automatically

Thanks to the refactoring, these features work **without any additional code:**

✅ **Navigation** - All routes work automatically  
✅ **Item List Screen** - Both "All Items" and "My List" tabs  
✅ **Item Detail Screen** - Complete item information display  
✅ **Rating System** - Full CRUD for ratings  
✅ **Sharing** - Share ratings with other users  
✅ **Community Stats** - Aggregate rating display  
✅ **Offline Support** - Connectivity handling  
✅ **Theme Support** - Light/dark mode  
✅ **Search** - Text search (if enabled for type)  
✅ **Filtering** - Category filters  

**You literally just added wine to switch statements and everything works!**

---

## 📊 Time Comparison

### Before Refactoring (September 2025)
- Create model: 10 min
- Create service: 10 min
- Register provider: 5 min
- Update ItemTypeScreen: **30 min** (duplicate 400 lines)
- Update ItemDetailScreen: **10 min** (duplicate loading logic)
- Update helper: 3 min
- Add to home: 5 min
- Localization: 15 min
- **Total: ~88 minutes**

### After Refactoring (October 2025) ✅
- Create model: 10 min
- Create service: 10 min
- Register provider: 5 min
- Update ItemProviderHelper: **5 min** (just switch statements)
- Update ItemTypeHelper: 3 min
- Add to home: 2 min
- Localization: 5 min
- **Total: ~50 minutes**

**Savings: 38 minutes per item type (43% faster!)**

---

## 🚀 Next Steps

After adding wine:

1. **Validate** - Wine should work identically to cheese and gin
2. **Add Beer** - Should take ~50 minutes
3. **Add Coffee** - Should take ~50 minutes
4. **Consider** - Enable search/filter for all types

---

## 📚 Related Documentation

- **[Item List/Detail Refactoring](item-list-detail-refactoring.md)** - Details of the refactoring
- **[Backend Guide](adding-new-item-types.md)** - Backend implementation
- **[Item Type Summary](item-type-implementation-summary.md)** - Complete overview

---

**Updated:** October 1, 2025  
**Status:** ✅ Production Ready
