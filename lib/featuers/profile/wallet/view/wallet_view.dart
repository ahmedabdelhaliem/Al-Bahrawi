import 'package:base_project/common/resources/color_manager.dart';
import 'package:base_project/common/resources/strings_manager.dart';
import 'package:base_project/common/resources/styles_manager.dart';
import 'package:base_project/common/widgets/custom_app_bar.dart';
import 'package:base_project/featuers/profile/wallet/view/widgets/wallet_balance_card.dart';
import 'package:base_project/featuers/profile/wallet/view/widgets/wallet_transaction_item.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WalletView extends StatefulWidget {
  const WalletView({super.key, required this.title});

  final String title;

  @override
  State<WalletView> createState() => _WalletViewState();
}

class _WalletViewState extends State<WalletView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.bg,
      appBar: CustomAppBar(
        title: AppStrings.wallet.tr(),
        backgroundColor: ColorManager.bg,
      ),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverPadding(
            padding: EdgeInsets.fromLTRB(16.w, 24.h, 16.w, 8.h),
            sliver: SliverToBoxAdapter(
              child: const WalletBalanceCard(balance: 0.00),
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.fromLTRB(20.w, 24.h, 20.w, 12.h),
            sliver: SliverToBoxAdapter(
              child: Text(
                AppStrings.recent_transactions.tr(),
                style: getBoldStyle(
                  fontSize: 18.sp,
                  color: ColorManager.textColor,
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return Padding(
                    padding: EdgeInsets.only(bottom: 16.h),
                    child: WalletTransactionItem(
                      amount: '+200.00 ${AppStrings.egp.tr()}',
                      date: '02/02/2020 16:00AM',
                    ),
                  );
                },
                childCount: 3, // Dummy data count
              ),
            ),
          ),
          SliverToBoxAdapter(child: SizedBox(height: 20.h)),
        ],
      ),
    );
  }
}
