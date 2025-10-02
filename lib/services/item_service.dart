import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/rateable_item.dart';
import '../models/cheese_item.dart';
import '../models/gin_item.dart';
import '../models/api_response.dart';
import '../services/api_service.dart';

/// Generic service for managing any type of rateable item
abstract class ItemService<T extends RateableItem> extends ApiService {
  String get itemTypeEndpoint;
  T Function(dynamic) get fromJson; // Changed to match ApiService signature
  List<String> Function(T) get validateItem;

  /// Get all items of this type
  Future<ApiResponse<List<T>>> getAllItems() async {
    return handleListResponse<T>(get('$itemTypeEndpoint/all'), fromJson);
  }

  /// Get item by ID
  Future<ApiResponse<T>> getItemById(int id) async {
    return handleResponse<T>(get('$itemTypeEndpoint/$id'), fromJson);
  }

  /// Create new item
  Future<ApiResponse<T>> createItem(T item) async {
    final validationErrors = validateItem(item);
    if (validationErrors.isNotEmpty) {
      return ApiResponseHelper.error(
        'Validation failed: ${validationErrors.join(', ')}',
      );
    }

    return handleResponse<T>(
      post('$itemTypeEndpoint/new', data: item.toJson()),
      fromJson,
    );
  }

  /// Update existing item
  Future<ApiResponse<T>> updateItem(int id, T item) async {
    final validationErrors = validateItem(item);
    if (validationErrors.isNotEmpty) {
      return ApiResponseHelper.error(
        'Validation failed: ${validationErrors.join(', ')}',
      );
    }

    return handleResponse<T>(
      put('$itemTypeEndpoint/$id', data: item.toJson()),
      fromJson,
    );
  }

  /// Delete item
  Future<ApiResponse<bool>> deleteItem(int id) async {
    return handleEmptyResponse(delete('$itemTypeEndpoint/$id'));
  }
}

/// Concrete implementation for Cheese items
class CheeseItemService extends ItemService<CheeseItem> {
  // Cache for avoiding duplicate API calls
  ApiResponse<List<CheeseItem>>? _cachedResponse;
  DateTime? _cacheTime;
  static const Duration _cacheExpiry = Duration(minutes: 5);
  
  @override
  String get itemTypeEndpoint => '/api/cheese';

  @override
  CheeseItem Function(dynamic) get fromJson =>
      (dynamic json) => CheeseItem.fromJson(json as Map<String, dynamic>);

  @override
  List<String> Function(CheeseItem) get validateItem => _validateCheeseItem;
  
  @override
  Future<ApiResponse<List<CheeseItem>>> getAllItems() async {
    // Check if we have valid cached data
    if (_cachedResponse != null && _cacheTime != null) {
      final age = DateTime.now().difference(_cacheTime!);
      if (age < _cacheExpiry) {
        return _cachedResponse!;
      }
    }
    
    // Make API call and cache result
    final response = await handleListResponse<CheeseItem>(get('$itemTypeEndpoint/all'), fromJson);
    
    // Cache successful responses
    if (response is ApiSuccess<List<CheeseItem>>) {
      _cachedResponse = response;
      _cacheTime = DateTime.now();
    }
    
    return response;
  }
  
  /// Clear cache (useful for testing or after data changes)
  void clearCache() {
    _cachedResponse = null;
    _cacheTime = null;
  }

  static List<String> _validateCheeseItem(CheeseItem cheese) {
    final errors = <String>[];

    if (cheese.name.trim().isEmpty) {
      errors.add('Name is required');
    }

    if (cheese.type.trim().isEmpty) {
      errors.add('Type is required');
    }

    if (cheese.origin.trim().isEmpty) {
      errors.add('Origin is required');
    }

    if (cheese.producer.trim().isEmpty) {
      errors.add('Producer is required');
    }

    if (cheese.description != null && cheese.description!.trim().isEmpty) {
      errors.add('Description cannot be empty if provided');
    }

    return errors;
  }

  /// Get unique cheese types for filtering
  Future<ApiResponse<List<String>>> getCheeseTypes() async {
    final response = await getAllItems();
    return response.when(
      success: (cheeses, _) {
        final types = CheeseItemExtension.getUniqueTypes(cheeses);
        return ApiResponseHelper.success(types);
      },
      error: (message, statusCode, errorCode, details) =>
          ApiResponseHelper.error<List<String>>(
            message,
            statusCode: statusCode,
            errorCode: errorCode,
          ),
      loading: () => ApiResponseHelper.loading<List<String>>(),
    );
  }

  /// Get unique cheese origins for filtering
  Future<ApiResponse<List<String>>> getCheeseOrigins() async {
    final response = await getAllItems();
    return response.when(
      success: (cheeses, _) {
        final origins = CheeseItemExtension.getUniqueOrigins(cheeses);
        return ApiResponseHelper.success(origins);
      },
      error: (message, statusCode, errorCode, details) =>
          ApiResponseHelper.error<List<String>>(
            message,
            statusCode: statusCode,
            errorCode: errorCode,
          ),
      loading: () => ApiResponseHelper.loading<List<String>>(),
    );
  }

  /// Search cheeses by query
  Future<ApiResponse<List<CheeseItem>>> searchItems(String query) async {
    final response = await getAllItems();
    return response.when(
      success: (cheeses, _) {
        final filteredCheeses = cheeses
            .where(
              (cheese) => cheese.searchableText.contains(query.toLowerCase()),
            )
            .toList();
        return ApiResponseHelper.success(filteredCheeses);
      },
      error: (message, statusCode, errorCode, details) =>
          ApiResponseHelper.error<List<CheeseItem>>(
            message,
            statusCode: statusCode,
            errorCode: errorCode,
          ),
      loading: () => ApiResponseHelper.loading<List<CheeseItem>>(),
    );
  }

  /// Filter cheeses by category
  Future<ApiResponse<List<CheeseItem>>> filterByCategory(
    String categoryKey,
    String categoryValue,
  ) async {
    final response = await getAllItems();
    return response.when(
      success: (cheeses, _) {
        final filteredCheeses = cheeses
            .where(
              (cheese) =>
                  cheese.categories[categoryKey]?.toLowerCase() ==
                  categoryValue.toLowerCase(),
            )
            .toList();
        return ApiResponseHelper.success(filteredCheeses);
      },
      error: (message, statusCode, errorCode, details) =>
          ApiResponseHelper.error<List<CheeseItem>>(
            message,
            statusCode: statusCode,
            errorCode: errorCode,
          ),
      loading: () => ApiResponseHelper.loading<List<CheeseItem>>(),
    );
  }
}

/// Provider for CheeseItemService
final cheeseItemServiceProvider = Provider<CheeseItemService>(
  (ref) => CheeseItemService(),
);

/// Concrete implementation for Gin items
class GinItemService extends ItemService<GinItem> {
  // Cache for avoiding duplicate API calls
  ApiResponse<List<GinItem>>? _cachedResponse;
  DateTime? _cacheTime;
  static const Duration _cacheExpiry = Duration(minutes: 5);
  
  @override
  String get itemTypeEndpoint => '/api/gin';

  @override
  GinItem Function(dynamic) get fromJson =>
      (dynamic json) => GinItem.fromJson(json as Map<String, dynamic>);

  @override
  List<String> Function(GinItem) get validateItem => _validateGinItem;
  
  @override
  Future<ApiResponse<List<GinItem>>> getAllItems() async {
    // Check if we have valid cached data
    if (_cachedResponse != null && _cacheTime != null) {
      final age = DateTime.now().difference(_cacheTime!);
      if (age < _cacheExpiry) {
        return _cachedResponse!;
      }
    }
    
    // Make API call and cache result
    final response = await handleListResponse<GinItem>(get('$itemTypeEndpoint/all'), fromJson);
    
    // Cache successful responses
    if (response is ApiSuccess<List<GinItem>>) {
      _cachedResponse = response;
      _cacheTime = DateTime.now();
    }
    
    return response;
  }
  
  /// Clear cache (useful for testing or after data changes)
  void clearCache() {
    _cachedResponse = null;
    _cacheTime = null;
  }

  static List<String> _validateGinItem(GinItem gin) {
    final errors = <String>[];

    if (gin.name.trim().isEmpty) {
      errors.add('Name is required');
    }

    if (gin.producer.trim().isEmpty) {
      errors.add('Producer is required');
    }

    if (gin.origin.trim().isEmpty) {
      errors.add('Origin is required');
    }

    if (gin.profile.trim().isEmpty) {
      errors.add('Profile is required');
    }

    if (gin.description != null && gin.description!.trim().isEmpty) {
      errors.add('Description cannot be empty if provided');
    }

    return errors;
  }

  /// Get unique gin producers for filtering
  Future<ApiResponse<List<String>>> getGinProducers() async {
    final response = await getAllItems();
    return response.when(
      success: (gins, _) {
        final producers = GinItemExtension.getUniqueProducers(gins);
        return ApiResponseHelper.success(producers);
      },
      error: (message, statusCode, errorCode, details) =>
          ApiResponseHelper.error<List<String>>(
            message,
            statusCode: statusCode,
            errorCode: errorCode,
          ),
      loading: () => ApiResponseHelper.loading<List<String>>(),
    );
  }

  /// Get unique gin origins for filtering
  Future<ApiResponse<List<String>>> getGinOrigins() async {
    final response = await getAllItems();
    return response.when(
      success: (gins, _) {
        final origins = GinItemExtension.getUniqueOrigins(gins);
        return ApiResponseHelper.success(origins);
      },
      error: (message, statusCode, errorCode, details) =>
          ApiResponseHelper.error<List<String>>(
            message,
            statusCode: statusCode,
            errorCode: errorCode,
          ),
      loading: () => ApiResponseHelper.loading<List<String>>(),
    );
  }

  /// Get unique gin profiles for filtering
  Future<ApiResponse<List<String>>> getGinProfiles() async {
    final response = await getAllItems();
    return response.when(
      success: (gins, _) {
        final profiles = GinItemExtension.getUniqueProfiles(gins);
        return ApiResponseHelper.success(profiles);
      },
      error: (message, statusCode, errorCode, details) =>
          ApiResponseHelper.error<List<String>>(
            message,
            statusCode: statusCode,
            errorCode: errorCode,
          ),
      loading: () => ApiResponseHelper.loading<List<String>>(),
    );
  }
}

/// Provider for GinItemService
final ginItemServiceProvider = Provider<GinItemService>(
  (ref) => GinItemService(),
);
