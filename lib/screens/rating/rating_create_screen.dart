import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/auth_provider.dart';
import '../../providers/item_provider.dart';
import '../../providers/rating_provider.dart';
import '../../services/item_service.dart';
import '../../models/rateable_item.dart';
import '../../models/cheese_item.dart';
import '../../models/api_response.dart';
import '../../utils/constants.dart';
import '../../utils/localization_utils.dart';
import '../../utils/safe_navigation.dart';
import '../../widgets/forms/form_scaffold.dart';
import '../../widgets/forms/star_rating_input.dart';

class RatingCreateScreen extends ConsumerStatefulWidget {
  final String itemType;
  final int itemId;

  const RatingCreateScreen({
    super.key,
    required this.itemType,
    required this.itemId,
  });

  @override
  ConsumerState<RatingCreateScreen> createState() => _RatingCreateScreenState();
}

class _RatingCreateScreenState extends ConsumerState<RatingCreateScreen> {
  final _noteController = TextEditingController();
  int _selectedRating = 0;
  RateableItem? _item;
  bool _isLoadingItem = true;
  String? _loadError;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadItemData();
    });
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _loadItemData() async {
    if (widget.itemType != 'cheese') {
      setState(() {
        _loadError = context.l10n.itemTypeNotSupported;
        _isLoadingItem = false;
      });
      return;
    }

    setState(() {
      _isLoadingItem = true;
      _loadError = null;
    });

    try {
      // First check if item is in cache
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
            _loadError = message;
          },
          loading: () {
            // This shouldn't happen for completed async calls
          },
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingItem = false;
        });
      }
    }
  }

  void _onRatingChanged(int rating) {
    setState(() {
      _selectedRating = rating;
    });
  }

  bool get _canSubmit {
    return _selectedRating > 0 && _item != null;
  }

  Future<void> _submitRating() async {
    if (!_canSubmit) return;

    final authState = ref.read(authProvider);
    final currentUserId = authState.user?.id;

    if (currentUserId == null) {
      _showErrorSnackBar('No authenticated user');
      return;
    }

    final success = await ref
        .read(ratingProvider.notifier)
        .createRating(
          grade: _selectedRating.toDouble(),
          note: _noteController.text.trim(),
          itemType: widget.itemType,
          itemId: widget.itemId,
        );

    if (success) {
      _showSuccessSnackBar(context.l10n.ratingCreated);
      // Navigate back to item detail screen
      if (mounted) {
        // Use a delay to ensure the snackbar is shown before navigation
        await Future.delayed(const Duration(milliseconds: 500));
        if (mounted) {
          SafeNavigation.goBackFromRatingCreation(
            context,
            widget.itemType,
            widget.itemId,
          );
        }
      }
    } else {
      final error =
          ref.read(ratingProvider).error ?? context.l10n.couldNotSaveRating;
      _showErrorSnackBar(error);
    }
  }

  void _showSuccessSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.white, size: 24),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  message,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(milliseconds: 2000),
          margin: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );
    }
  }

  void _showErrorSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Theme.of(context).colorScheme.error,
          behavior: SnackBarBehavior.floating,
          action: SnackBarAction(
            label: context.l10n.dismiss,
            textColor: Colors.white,
            onPressed: () {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
            },
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final ratingState = ref.watch(ratingProvider);

    // Show loading screen while loading item data
    if (_isLoadingItem) {
      return FormScaffold(
        title: context.l10n.rateItem,
        isLoading: true,
        child: const Center(child: CircularProgressIndicator()),
      );
    }

    // Show error screen if item couldn't be loaded
    if (_loadError != null || _item == null) {
      return FormScaffold(
        title: context.l10n.rateItem,
        child: Center(
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
                _loadError ?? context.l10n.itemNotFound,
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppConstants.spacingM),
              ElevatedButton(
                onPressed: () => SafeNavigation.goBackFromRatingCreation(
                  context,
                  widget.itemType,
                  widget.itemId,
                ),
                child: Text(context.l10n.goBack),
              ),
            ],
          ),
        ),
      );
    }

    return FormScaffold(
      title: context.l10n.rateItemName(_item!.name),
      isLoading: ratingState.isLoading,
      onBack: () => SafeNavigation.goBackFromRatingCreation(
        context,
        widget.itemType,
        widget.itemId,
      ),
      onCancel: () => SafeNavigation.goBackFromRatingCreation(
        context,
        widget.itemType,
        widget.itemId,
      ),
      onSubmit: _submitRating,
      submitButtonText: context.l10n.saveRating,
      isSubmitEnabled: _canSubmit,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Item context card
          _buildItemContextCard(),

          const SizedBox(height: AppConstants.spacingXL),

          // Rating input section
          StarRatingInput(
            initialRating: _selectedRating,
            onRatingChanged: _onRatingChanged,
            label: context.l10n.yourRating,
            helperText: context.l10n.selectRating,
          ),

          const SizedBox(height: AppConstants.spacingXL),

          // Notes input section
          _buildNotesSection(),
        ],
      ),
    );
  }

  Widget _buildItemContextCard() {
    return Card(
      child: Padding(
        padding: AppConstants.cardPadding,
        child: Row(
          children: [
            // Item icon
            Container(
              padding: const EdgeInsets.all(AppConstants.spacingM),
              decoration: BoxDecoration(
                color: AppConstants.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppConstants.radiusL),
              ),
              child: Icon(
                Icons.local_pizza, // TODO: Use ItemTypeHelper when available
                size: AppConstants.iconL,
                color: AppConstants.primaryColor,
              ),
            ),

            const SizedBox(width: AppConstants.spacingM),

            // Item info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _item!.name,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: AppConstants.spacingXS),
                  if (_item is CheeseItem) ...[
                    Text(
                      '${(_item as CheeseItem).type} • ${(_item as CheeseItem).origin}',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withOpacity(0.7),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.l10n.addNotes,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: AppConstants.spacingS),
        TextField(
          controller: _noteController,
          maxLines: 4,
          decoration: InputDecoration(
            hintText: context.l10n.notesHelper,
            border: const OutlineInputBorder(),
            alignLabelWithHint: true,
          ),
          textInputAction: TextInputAction.newline,
        ),
      ],
    );
  }
}
