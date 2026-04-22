import 'package:base_project/common/resources/strings_manager.dart';
import 'package:base_project/featuers/home/view/home_view.dart';
import 'package:base_project/featuers/home/view/widgets/transport_header_widget.dart';
import 'package:base_project/featuers/my_trips/view/trip_details_view.dart';
import 'package:base_project/featuers/my_trips/view/widgets/trip_details_card.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyTripsView extends StatefulWidget {
  const MyTripsView({super.key});

  @override
  State<MyTripsView> createState() => _MyTripsViewState();
}

class _MyTripsViewState extends State<MyTripsView> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBFBFF),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // Pinned Aesthetic Header with 'رحلاتي' title
          SliverPersistentHeader(
            pinned: true,
            delegate: TransportHeaderDelegate(title: ""),
          ),
          
          // List of trips
          SliverPadding(
            padding: EdgeInsets.symmetric(vertical: 20.h),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return TripDetailsCard(
                    price: index == 0 ? "60" : index == 1 ? "100" : index == 2 ? "90" : "70",
                    lineName: index == 0 ? "خط السواح" : index == 1 ? "خط اكتوبر" : index == 2 ? "خط الجيزة" : "خط القاهرة",
                    companyName: "الرايه",
                    city: "مدينة نصر",
                    busType: "High S",
                    routes: "الدائري- السويس",
                    departureTime: "7AM",
                    arrivalTime: "9AM",
                    isSelected: _selectedIndex == index,
                    onTap: () {
                      setState(() {
                        _selectedIndex = index;
                      });
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const TripDetailsView()),
                      );
                    },
                  );
                },
                childCount: 4, // Shows exactly 4 different trips
              ),
            ),
          ),
          
          // Footer spacing
          SliverToBoxAdapter(child: SizedBox(height: 100.h)),
        ],
      ),
    );
  }
}
