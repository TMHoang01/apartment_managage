enum BookingStatus {
  pending,
  accepted,
  rejected,
  completed;

  String toName() {
    switch (this) {
      case BookingStatus.pending:
        return 'Chờ xử lý';
      case BookingStatus.accepted:
        return 'Đã nhận';
      case BookingStatus.rejected:
        return 'Từ chối';
      case BookingStatus.completed:
        return 'Hoàn thành';
      default:
        return '';
    }
  }

  String toJson() => name;
  static BookingStatus fromJson(String json) => values.byName(json);
}

enum BookingRepeatType {
  weekly,
  monthly;

  String toJson() => name;
  static BookingRepeatType fromJson(String json) => values.byName(json);

  String toName() {
    switch (this) {
      case BookingRepeatType.weekly:
        return 'Hàng tuần';
      case BookingRepeatType.monthly:
        return 'Hàng tháng';
      default:
        return '';
    }
  }
}

enum ServiceType {
  peopleCare,
  petCare,
  houseCleaning,
  applianceRepair,
  painting,
  computerRepair,
  tutoring,
  eventPlanning,
  beauty,
  legal,
  // financial,
  // realEstate,
  other;

  String toJson() => name;
  static ServiceType fromJson(String json) {
    try {
      return values.byName(json);
    } catch (e) {
      return ServiceType.other;
    }
  }

  String toName() {
    return switch (this) {
      ServiceType.peopleCare => 'Chăm sóc người già, trẻ em',
      ServiceType.petCare => 'Trông thú cưng',
      ServiceType.houseCleaning => 'Dọn dẹp nhà cửa',
      ServiceType.applianceRepair => 'Sửa chữa thiết bị gia dụng',
      ServiceType.painting => 'Sơn nhà',
      ServiceType.computerRepair => 'Sửa máy tính',
      ServiceType.tutoring => 'Gia sư',
      ServiceType.eventPlanning => 'Tổ chức sự kiện',
      ServiceType.beauty => 'Làm đẹp',
      ServiceType.other => 'Khác',
      _ => '',
    };
  }
}

// loại hình tính dịch tiền dịch vụ
enum PriceType {
  fixed,
  hourly,
  package,
  other;

  String toJson() => name;
  static PriceType fromJson(String json) => values.byName(json);

  String toName() {
    return switch (this) {
      PriceType.fixed => 'Cố định',
      PriceType.hourly => 'Theo giờ',
      PriceType.package => 'Gói dịch vụ',
      PriceType.other => 'Tham khảo',
    };
  }
}
