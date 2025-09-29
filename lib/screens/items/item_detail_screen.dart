import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/auth_provider.dart';
import '../../providers/item_provider.dart';
import '../../providers/rating_provider.dart';
import '../../providers/app_provider.dart';
import '../../models/cheese_item.dart';
import '../../models/rating.dart';
import '../../models/rateable_item.dart';
import '../../models/api_response.dart';
import '../../services/rating_service.dart';
import '../../services/item_service.dart';
import '../../services/api_service.dart';
import '../../routes/route_names.dart';
import '../../utils/constants.dart';
import '../../utils/localization_utils.dart';
import '../../utils/appbar_helper.dart';
import '../../utils/safe_navigation.dart';
import '../../widgets/items/item_detail_header.dart';
import '../../widgets/items/my_rating_section.dart';
import '../../widgets/items/shared_ratings_list.dart';
import '../../widgets/items/rating_summary_card.dart';

class ItemDetailScreen extends ConsumerStatefulWidget {
  final String itemType;
  final int itemId;

  const ItemDetailScreen({
    super.key,
    required this.itemType,
    required this.itemId,
  });

  @override
  ConsumerState<ItemDetailScreen> createState() => _ItemDetailScreenState();
}

class _ItemDetailScreenState extends ConsumerState<ItemDetailScreen> {
  RateableItem? _item;
  List<Rating> _itemRatings = []; // User's own ratings + shared ratings
  Map<String, dynamic>? _communityStats; // True community statistics
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadItemData();
    });
  }

  Future<void> _loadItemData() async {
    if (widget.itemType != 'cheese') return;

    setState(() {
      _isLoading = true;
    });

    try {
      // Get item details
      final cheeseItemState = ref.read(cheeseItemProvider);
      _item = cheeseItemState.items
          .where((item) => item.id == widget.itemId)
          .firstOrNull;

      // If not in cache, load from API
      if (_item == null) {
        final service = ref.read(cheeseItemServiceProvider);
        final response = await service.getItemById(widget.itemId);

        response.when(
          success: (item, message) {
            _item = item;
          },
          error: (message, statusCode, errorCode, details) {
            print('Error loading item: $message');
          },
          loading: () {},
        );
      }

      final ratingService = ref.read(ratingServiceProvider);
      final authState = ref.read(authProvider);
      final currentUserId = authState.user?.id;

      // Load true community statistics (anonymous aggregate data)
      final apiService = ref.read(apiServiceProvider);
      final communityStatsResponse = await apiService.getCommunityStats(
        widget.itemType,
        widget.itemId,
      );
      communityStatsResponse.when(
        success: (stats, message) {
          _communityStats = stats;
        },
        error: (message, statusCode, errorCode, details) {
          print('Error loading community stats: $message');
          _communityStats = null;
        },
        loading: () {},
      );

      // Load user-specific ratings (own ratings + ratings shared with user)
      if (currentUserId != null) {
        final viewerRatingsResponse = await ratingService.getRatingsByViewer(
          currentUserId,
        );

        viewerRatingsResponse.when(
          success: (viewerRatings, message) {
            // Filter to only ratings for this specific item
            _itemRatings = viewerRatings
                .where(
                  (r) =>
                      r.itemType == widget.itemType &&
                      r.itemId == widget.itemId,
                )
                .toList();
          },
          error: (message, statusCode, errorCode, details) {
            print('Error loading viewer ratings: $message');
            _itemRatings = [];
          },
          loading: () {},
        );
      } else {
        _itemRatings = [];
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _navigateBack() {
    SafeNavigation.goBackToItemType(context, widget.itemType);
  }

  void _navigateToSettings() {
    // Settings functionality is now in the AuthStatusWidget
  }

  void _navigateToRating() {
    GoRouter.of(
      context,
    ).go('${RouteNames.ratingCreate}/${widget.itemType}/${widget.itemId}');
  }

  void _navigateToEditItem() {
    if (widget.itemType == 'cheese') {
      GoRouter.of(context).go('${RouteNames.cheeseEdit}/${widget.itemId}');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Editing ${widget.itemType} items is not yet supported',
          ),
          backgroundColor: Theme.of(context).colorScheme.secondary,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final currentUserId = authState.user?.id;

    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: Text(context.l10n.loading),
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          leading: IconButton(
            onPressed: _navigateBack,
            icon: const Icon(Icons.arrow_back),
          ),
          actions: AppBarHelper.buildStandardActions(
            context,
            ref,
            showUserProfile: false,
          ),
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_item == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text(context.l10n.itemNotFound),
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          leading: IconButton(
            onPressed: _navigateBack,
            icon: const Icon(Icons.arrow_back),
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 80,
                color: Theme.of(context).colorScheme.error,
              ),
              const SizedBox(height: AppConstants.spacingL),
              Text(
                context.l10n.itemNotFound,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: AppConstants.spacingM),
              ElevatedButton(
                onPressed: _navigateBack,
                child: Text(context.l10n.goBack),
              ),
            ],
          ),
        ),
      );
    }

    // Separate user's rating from shared ratings
    final myRating = currentUserId != null
        ? _itemRatings.where((r) => r.authorId == currentUserId).firstOrNull
        : null;

    final sharedRatings = currentUserId != null
        ? _itemRatings.where((r) => r.authorId != currentUserId).toList()
        : <Rating>[];

    return Scaffold(
      appBar: AppBar(
        title: Text(_item!.name),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        leading: IconButton(
          onPressed: _navigateBack,
          icon: const Icon(Icons.arrow_back),
        ),
        actions: AppBarHelper.buildStandardActions(
          context,
          ref,
          showUserProfile: true,
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _loadItemData,
        child: SingleChildScrollView(
          padding: AppConstants.screenPadding,
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: AppConstants.maxContentWidth,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Item header with all details
                  ItemDetailHeader(
                    item: _item!,
                    onEditPressed: _navigateToEditItem,
                  ),

                  const SizedBox(height: AppConstants.spacingL),

                  // Community statistics section using reusable widget
                  RatingSummaryCard(
                    item: _item!,
                    communityStats: _communityStats,
                    isLoading: _isLoading,
                  ),

                  const SizedBox(height: AppConstants.spacingL),

                  // My rating section
                  MyRatingSection(
                    myRating: myRating,
                    item: _item!,
                    onRatingAdded: _loadItemData,
                  ),

                  const SizedBox(height: AppConstants.spacingL),

                  // Shared ratings
                  SharedRatingsList(sharedRatings: sharedRatings, item: _item!),

                  const SizedBox(height: AppConstants.spacingXL),
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: myRating == null
          ? FloatingActionButton.extended(
              onPressed: _navigateToRating,
              icon: const Icon(Icons.star),
              label: Text(context.l10n.rateItemName(_item!.name)),
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Colors.white,
            )
          : null,
    );
  }

  // Removed custom community stats section - now using RatingSummaryCard widget
}
