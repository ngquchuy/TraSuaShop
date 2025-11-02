import 'package:milktea_shop/features/shipping%20address/models/address.dart';

class AddressRepository {
  List<Address> getAddresses() {
    return const [
      Address(
        id: '1',
        label: 'Nhà',
        fullAddress: '45 Ngõ 521 Trương Định, Quận Hoàng Mai',
        city: 'Hà Nội',
        isDefault: true,
        type: AddressType.home,
      ),
      Address(
        id: '1',
        label: 'Văn phòng công ty',
        fullAddress: 'Tòa nhà A, 10 Nguyễn Huệ, P. Bến Nghé, Q.1',
        city: 'Hồ Chí Minh',
        isDefault: false,
        type: AddressType.home,
      ),
    ];
  }

  Address? getDefaultAddress() {
    return getAddresses().firstWhere(
      (address) => address.isDefault,
      orElse: () => getAddresses().first,
    );
  }
}
