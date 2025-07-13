import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hcs_driver/features/Home/Customer/data/models/customers_model.dart';
import 'package:hcs_driver/src/theme/app_colors.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hcs_driver/features/Home/Customer/presentation/controllers/customer_controller.dart';
import 'package:hcs_driver/src/shared_widgets/fade_circle_loading_indicator.dart';

class PaginatedCustomerDropdown extends ConsumerStatefulWidget {
  final bool enabled;
  final ValueChanged<Customers?>? onChanged;

  const PaginatedCustomerDropdown({
    super.key,
    this.enabled = true,
    this.onChanged,
  });

  @override
  ConsumerState<PaginatedCustomerDropdown> createState() =>
      PaginatedCustomerDropdownState();
}

class PaginatedCustomerDropdownState
    extends ConsumerState<PaginatedCustomerDropdown> {
  Timer? _loadMoreTimer;
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlay;
  late ScrollController _scrollController;
  late TextEditingController _searchController;
  String _searchTerm = '';
  late double _targetWidth;
  late double _targetHeight;

  void closeOverlay() {
    _closeOverlay();
  }

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);
    _searchController = TextEditingController()..addListener(_onSearchChanged);
    WidgetsBinding.instance.addPostFrameCallback((_) => _initOverlay());
  }

  @override
  void dispose() {
    _loadMoreTimer?.cancel();
    _searchController.removeListener(_onSearchChanged);

    _closeOverlay();

    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() => _searchTerm = _searchController.text.toLowerCase());
    _overlay?.markNeedsBuild();
  }

  void _initOverlay() {
    if (mounted) _openOverlay();
  }

  void _onScroll() {
    final customerState = ref.read(customerControllerProvider);
    final hasMore = customerState.currentCustomersPage != null;

    if (_scrollController.position.pixels >
            _scrollController.position.maxScrollExtent - 100 &&
        hasMore) {
      _loadMoreTimer?.cancel();
      _loadMoreTimer = Timer(const Duration(milliseconds: 500), () {
        ref.read(customerControllerProvider.notifier).onLoadMoreCostumers();
      });
    }
  }

  void _openOverlay() {
    final renderBox = context.findRenderObject() as RenderBox?;
    if (renderBox == null || !mounted) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _openOverlay();
      });
      return;
    }

    _targetWidth = renderBox.size.width;
    _targetHeight = renderBox.size.height;

    _overlay = OverlayEntry(
      builder: (context) {
        return Consumer(
          builder: (context, ref, child) {
            final customerState = ref.watch(customerControllerProvider);
            final filteredItems = customerState.customers
                .where(
                  (cust) =>
                      cust.customerName.toLowerCase().contains(_searchTerm),
                )
                .toList();

            return Positioned(
              width: _targetWidth,
              child: CompositedTransformFollower(
                link: _layerLink,
                showWhenUnlinked: false,
                offset: Offset(0, _targetHeight + 5),
                child: Material(
                  elevation: 4,
                  borderRadius: BorderRadius.circular(8),
                  child: SizedBox(
                    height: 300.h,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            controller: _searchController,
                            decoration: InputDecoration(
                              hintText: 'Search customers...',
                              prefixIcon: const Icon(Icons.search),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              isDense: true,
                            ),
                          ),
                        ),
                        Expanded(
                          child: ListView.builder(
                            shrinkWrap: true,
                            controller: _scrollController,
                            itemCount:
                                filteredItems.length +
                                (customerState.currentCustomersPage != null
                                    ? 1
                                    : 0),
                            itemBuilder: (_, index) {
                              if (index >= filteredItems.length) {
                                return const Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Center(
                                    child: FadeCircleLoadingIndicator(),
                                  ),
                                );
                              }
                              final cust = filteredItems[index];
                              return ListTile(
                                title: Text(cust.customerName),
                                onTap: widget.enabled
                                    ? () {
                                        _selectItem(cust);
                                        _closeOverlay();
                                      }
                                    : null,
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );

    Overlay.of(context).insert(_overlay!);
  }

  void _selectItem(Customers c) {
    ref.read(customerControllerProvider.notifier).toggleCustomer(c);
    widget.onChanged?.call(c);
  }

  void _closeOverlay() {
    // Only clear & remove if we're still mounted
    if (_overlay != null) {
      _overlay!.remove();
      _overlay = null;
    }
    if (mounted) {
      _searchController.clear();
      _searchTerm = '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedCustomer = ref.watch(
      customerControllerProvider.select((state) => state.selectedCustomer),
    );

    return CompositedTransformTarget(
      link: _layerLink,
      child: GestureDetector(
        onTap: widget.enabled
            ? () {
                if (_overlay == null) {
                  _openOverlay();
                } else {
                  _closeOverlay();
                }
              }
            : null,
        child: InputDecorator(
          decoration: InputDecoration(
            hintText: selectedCustomer?.customerName ?? 'Select Customer',
            isDense: true,
            enabled: widget.enabled,
            filled: true,
            fillColor: widget.enabled ? Colors.white : AppColors.unSelectedGrey,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  selectedCustomer?.customerName ?? '',
                  style: Theme.of(context).inputDecorationTheme.hintStyle!
                      .copyWith(color: AppColors.blackText),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Icon(
                _overlay == null ? Icons.arrow_drop_down : Icons.arrow_drop_up,
                color: AppColors.blackText,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
