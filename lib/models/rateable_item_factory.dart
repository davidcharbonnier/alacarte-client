import 'rateable_item.dart';

/// Factory for creating RateableItem instances from JSON
class RateableItemFactory {
  // Registry of item type constructors
  static final Map<String, RateableItem Function(Map<String, dynamic>)> _constructors = {};
  
  /// Register a constructor for an item type
  static void registerItemType(String itemType, RateableItem Function(Map<String, dynamic>) constructor) {
    _constructors[itemType.toLowerCase()] = constructor;
  }
  
  /// Create a RateableItem from JSON based on item type
  static RateableItem? fromJson(Map<String, dynamic> json, String itemType) {
    final constructor = _constructors[itemType.toLowerCase()];
    return constructor?.call(json);
  }
  
  /// Get all supported item types
  static List<String> get supportedItemTypes => _constructors.keys.toList();
  
  /// Check if item type is supported
  static bool isItemTypeSupported(String itemType) {
    return _constructors.containsKey(itemType.toLowerCase());
  }
}
