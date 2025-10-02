# Quick Reference: Adding a New Item Type (Frontend)

**Use this checklist when implementing a new item type frontend**

**Time Estimate:** ~50 minutes (post-refactoring)

---

## 📋 Frontend Implementation Checklist

### **Prerequisites**
- [ ] Backend implementation complete
- [ ] Backend running with seed data
- [ ] API endpoints tested and working

---

### **1. Create Model** (~10 min)
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
  final String varietal;  // Item-specific field
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

extension WineItemExtension on WineItem {
  static List<String> getUniqueProducers(List<WineItem> wines) =>
    wines.map((w) => w.producer).toSet().toList()..sort();
  
  static List<String> getUniqueOrigins(List<WineItem> wines) =>
    wines.map((w) => w.origin).toSet().toList()..sort();
  
  static List<String> getUniqueVarietals(List<WineItem> wines) =>
    wines.map((w) => w.varietal).toSet().toList()..sort();
}
```

**Checklist:**
- [ ] File created: `lib/models/wine_item.dart`
- [ ] All RateableItem methods implemented
- [ ] JSON serialization matches backend
- [ ] Extension methods for filtering
- [ ] 4-6 fields + description

---

### **2. Add Service** (~10 min)
**File:** `lib/services/item_service.dart` (add to end)

```dart
import '../models/wine_item.dart';  // Add import at top

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
    if (response is ApiSuccess<List<WineItem>>) {
      return ApiResponseHelper.success(
        WineItemExtension.getUniqueProducers(response.data)
      );
    }
    return ApiResponseHelper.error('Failed to load producers');
  }
  
  // Similar: getWineOrigins(), getWineVarietals()
}

final wineItemServiceProvider = Provider<WineItemService>(
  (ref) => WineItemService(),
);
```

**Checklist:**
- [ ] Import added at top of file
- [ ] Service class created at end of file
- [ ] 5-minute caching implemented
- [ ] Validation method added
- [ ] Filter helper methods added
- [ ] Provider registered

---

### **3. Register Provider** (~5 min)
**File:** `lib/providers/item_provider.dart`

```dart
import '../models/wine_item.dart';  // Add import

// Add at end of file
final wineItemProvider = StateNotifierProvider<WineItemProvider, ItemState<WineItem>>(
  (ref) => WineItemProvider(ref.read(wineItemServiceProvider)),
);

class WineItemProvider extends ItemProvider<WineItem> {
  WineItemProvider(WineItemService wineService) : super(wineService);

  @override
  Future<void> _loadFilterOptions() async {
    final wineService = _itemService as WineItemService;
    
    final producersResponse = await wineService.getWineProducers();
    final originsResponse = await wineService.getWineOrigins();
    final varietalsResponse = await wineService.getWineVarietals();

    producersResponse.when(
      success: (producers, _) {
        final currentOptions = Map<String, List<String>>.from(state.filterOptions);
        currentOptions['producer'] = producers;
        state = state.copyWith(filterOptions: currentOptions);
      },
      error: (_, __, ___, ____) {},
      loading: () {},
    );
    
    // Similar for origins and varietals
  }

  void setProducerFilter(String? producer) => setCategoryFilter('producer', producer);
  void setOriginFilter(String? origin) => setCategoryFilter('origin', origin);
  void setVarietalFilter(String? varietal) => setCategoryFilter('varietal', varietal);
}

final filteredWineItemsProvider = Provider<List<WineItem>>((ref) {
  final itemState = ref.watch(wineItemProvider);
  return itemState.filteredItems;
});

final hasWineItemDataProvider = Provider<bool>((ref) {
  final itemState = ref.watch(wineItemProvider);
  return itemState.items.isNotEmpty;
});
```

**Also update cache clearing in `createItem()`:**
```dart
if (_itemService is WineItemService) {
  (_itemService as WineItemService).clearCache();
}
```

**Checklist:**
- [ ] Import added
- [ ] Provider registered
- [ ] Provider class created
- [ ] Filter options loading implemented
- [ ] Filter methods added
- [ ] Computed providers added
- [ ] Cache clearing updated

---

### **4. Update ItemProviderHelper** (~5 min) ⭐
**File:** `lib/utils/item_provider_helper.dart`

Add `case 'wine':` to **ALL 15 methods**:

```dart
static List<RateableItem> getItems(WidgetRef ref, String itemType) {
  switch (itemType.toLowerCase()) {
    case 'cheese':
      return ref.watch(cheeseItemProvider).items.cast<RateableItem>();
    case 'gin':
      return ref.watch(ginItemProvider).items.cast<RateableItem>();
    case 'wine':  // ADD THIS
      return ref.watch(wineItemProvider).items.cast<RateableItem>();
    default:
      return [];
  }
}
```

**Methods to update:**
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

**Tip:** Use find-and-replace: copy the gin case, replace 'gin' with 'wine'

---

### **5. Update ItemTypeHelper** (~3 min)
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
- [ ] Icon added to `getItemTypeIcon()`
- [ ] Color added to `getItemTypeColor()`
- [ ] Added to `isItemTypeSupported()` list

---

### **6. Add to Home Screen** (~2 min)
**File:** `lib/screens/home/home_screen.dart`

```dart
// In build() method:
final wineItemState = ref.watch(wineItemProvider);

// Load wine data
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

**Checklist:**
- [ ] Wine state watched
- [ ] Wine data loading added
- [ ] Wine card added to grid
- [ ] Refresh handler updated

---

### **7. Add Item Type Switcher** (~1 min)
**File:** `lib/screens/items/item_type_screen.dart`

```dart
PopupMenuItem(
  value: 'wine',
  child: Row(
    children: [
      Icon(Icons.wine_bar, color: widget.itemType == 'wine' ? Colors.purple : null),
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
- [ ] Wine added to popup menu

---

### **8. Add Localization** (~5 min)
**Files:** `lib/l10n/app_en.arb` and `lib/l10n/app_fr.arb`

**English** (`app_en.arb`):
```json
{
  "wine": "Wine",
  "wines": "Wines",
  "varietalLabel": "Varietal",
  "enterWineName": "Enter wine name",
  "enterVarietal": "Enter varietal",
  "varietalHint": "e.g., Chardonnay, Pinot Noir",
  "varietalHelperText": "Optional - grape variety",
  "wineCreated": "Wine created successfully!",
  "wineUpdated": "Wine updated successfully!",
  "wineDeleted": "Wine deleted successfully!",
  "createWine": "Create Wine",
  "editWine": "Edit Wine",
  "addWine": "Add Wine",
  "allWines": "All Wines",
  "myWineList": "My Wine List",
  "filterByProducer": "Filter by producer",
  "filterByOrigin": "Filter by origin",
  "filterByVarietal": "Filter by varietal",
  "noWinesFound": "No wines found",
  "loadingWines": "Loading wines...",
  "varietalRequired": "Varietal is required"
}
```

**French** (`app_fr.arb`):
```json
{
  "wine": "Vin",
  "wines": "Vins",
  "varietalLabel": "Cépage",
  "enterWineName": "Entrer le nom du vin",
  "enterVarietal": "Entrer le cépage",
  "varietalHint": "ex: Chardonnay, Pinot Noir",
  "varietalHelperText": "Optionnel - variété de raisin",
  "wineCreated": "Vin créé avec succès !",
  "wineUpdated": "Vin mis à jour avec succès !",
  "wineDeleted": "Vin supprimé avec succès !",
  "createWine": "Créer un Vin",
  "editWine": "Modifier le Vin",
  "addWine": "Ajouter un Vin",
  "allWines": "Tous les Vins",
  "myWineList": "Ma Liste de Vins",
  "filterByProducer": "Filtrer par producteur",
  "filterByOrigin": "Filtrer par origine",
  "filterByVarietal": "Filtrer par cépage",
  "noWinesFound": "Aucun vin trouvé",
  "loadingWines": "Chargement des vins...",
  "varietalRequired": "Le cépage est requis"
}
```

**Generate localization:**
```bash
flutter gen-l10n
```

**Checklist:**
- [ ] ~24 keys added to `app_en.arb`
- [ ] ~24 keys added to `app_fr.arb`
- [ ] `flutter gen-l10n` executed successfully
- [ ] No build errors

---

### **9. Test Complete Flow** (~10 min)

```bash
# Start backend with wine data
cd alacarte-api
RUN_SEEDING=true \
  CHEESE_DATA_SOURCE=../alacarte-seed/cheeses.json \
  GIN_DATA_SOURCE=../alacarte-seed/gins.json \
  WINE_DATA_SOURCE=../alacarte-seed/wines.json \
  go run main.go

# Run frontend
cd alacarte-client
flutter run -d linux
```

**Checklist:**
- [ ] Home shows wine card with item count
- [ ] Click wine → Navigates to wine list
- [ ] "All Wines" tab loads items
- [ ] "My Wine List" tab shows empty state
- [ ] Click wine item → Detail screen loads
- [ ] All fields display correctly (name, producer, origin, varietal, description)
- [ ] Community stats display
- [ ] FAB appears to rate wine
- [ ] Rate wine → Rating created successfully
- [ ] Rating appears in "My Wine List"
- [ ] Share rating → Sharing works
- [ ] Switch to cheese/gin → All types work
- [ ] Both French and English work

---

## 🎉 What Works Automatically (Post-Refactoring)

Thanks to **ItemProviderHelper**, these features work **without any screen code changes:**

- ✅ **Item List Screen** - Both tabs automatically work
- ✅ **Item Detail Screen** - Loads and displays wine data
- ✅ **Navigation** - All routing works automatically
- ✅ **Rating System** - Full CRUD for wine ratings
- ✅ **Sharing** - Share wine ratings
- ✅ **Community Stats** - Aggregate ratings display
- ✅ **Offline Support** - Connectivity handling
- ✅ **Theme Support** - Light/dark mode
- ✅ **Search** - Text search works
- ✅ **Filtering** - Category filters work

**You only updated switch statements - everything else just works!** 🚀

---

## ⚡ Time Comparison

### Before Refactoring
- Create model: 10 min
- Create service: 10 min
- Register provider: 5 min
- Update screens: **40 min** (duplicate code)
- Update helpers: 3 min
- Add to home: 5 min
- Localization: 5 min
- **Total: ~88 min**

### After Refactoring ✅
- Create model: 10 min
- Create service: 10 min
- Register provider: 5 min
- Update ItemProviderHelper: **5 min** (switch statements only)
- Update ItemTypeHelper: 3 min
- Add to home: 2 min
- Add to switcher: 1 min
- Localization: 5 min
- **Total: ~50 min**

**Savings: 38 minutes (43% faster!)**

---

## 🚨 Critical Reminders

### **Required After Localization Changes**
```bash
flutter gen-l10n
```
**Must run** after updating `.arb` files or app won't compile!

### **Backend Must Be Running**
Ensure backend is running with wine data before testing frontend:
```bash
cd alacarte-api
RUN_SEEDING=true WINE_DATA_SOURCE=../alacarte-seed/wines.json go run main.go
```

### **Don't Bypass ItemProviderHelper**
Always update the helper switch statements - don't add type-specific code to screens!

---

## 📚 Related Documentation

- **[Complete Frontend Guide](adding-new-item-types.md)** - Detailed implementation
- **[Refactoring Details](item-list-detail-refactoring.md)** - Architecture explanation
- **[Backend Checklist](../../alacarte-api/docs/new-item-type-checklist.md)** - Backend tasks

---

**Last Updated:** October 1, 2025  
**Status:** Post-refactoring, current and accurate
