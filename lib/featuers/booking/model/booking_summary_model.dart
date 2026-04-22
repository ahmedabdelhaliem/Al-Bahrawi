class BookingSummaryModel {
  final String line;
  final String time;
  final String station;
  final String date;
  final String busType;
  final double seatPrice;
  final double discount;
  final double bookingFees;

  BookingSummaryModel({
    required this.line,
    required this.time,
    required this.station,
    required this.date,
    required this.busType,
    required this.seatPrice,
    required this.discount,
    required this.bookingFees,
  });

  double get total => seatPrice - discount + bookingFees;
}

enum BookingType { morning, night, daily, monthly }

extension BookingTypeExtension on BookingType {
  double get price {
    switch (this) {
      case BookingType.morning:
        return 100.0;
      case BookingType.night:
        return 180.0;
      case BookingType.daily:
        return 200.0;
      case BookingType.monthly:
        return 900.0;
    }
  }
}
