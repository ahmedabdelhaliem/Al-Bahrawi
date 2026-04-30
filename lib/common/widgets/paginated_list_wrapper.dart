import 'package:al_bahrawi/app/pagination_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PaginatedListWrapper extends StatefulWidget {
  final ScrollController scrollController;
  final PaginationHandler paginationHandler;
  final PaginateFunc fetchFunction;
  final Widget child;
  final Widget? loadingWidget;
  final Map<String, dynamic>? params;

  const PaginatedListWrapper({
    super.key,
    required this.scrollController,
    required this.paginationHandler,
    required this.fetchFunction,
    required this.child,
    this.loadingWidget,
    this.params,
  });

  @override
  State<PaginatedListWrapper> createState() => _PaginatedListWrapperState();
}

class _PaginatedListWrapperState extends State<PaginatedListWrapper> {
  @override
  void initState() {
    super.initState();
    widget.scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(_onScroll);
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      widget.paginationHandler.fetchData(widget.fetchFunction, params: widget.params);
    }
  }

  bool get _isBottom {
    if (!widget.scrollController.hasClients) return false;
    final maxScroll = widget.scrollController.position.maxScrollExtent;
    final currentScroll = widget.scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(child: widget.child),
        if (widget.paginationHandler.isLoadingMore)
          widget.loadingWidget ??
              Padding(
                padding: EdgeInsets.symmetric(vertical: 16.h),
                child: const Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                  ),
                ),
              ),
      ],
    );
  }
}
