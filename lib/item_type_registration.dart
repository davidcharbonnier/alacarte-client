import 'models/rateable_item_factory.dart';
import 'models/cheese_item.dart';

/// Initialize all rateable item types in the factory
void initializeRateableItemTypes() {
  // Register cheese item type
  RateableItemFactory.registerItemType('cheese', CheeseItem.fromJson);
  
  // TODO: Register other item types as they're implemented
  // RateableItemFactory.registerItemType('wine', WineItem.fromJson);
  // RateableItemFactory.registerItemType('gin', GinItem.fromJson);
  // RateableItemFactory.registerItemType('restaurant', RestaurantItem.fromJson);
}
