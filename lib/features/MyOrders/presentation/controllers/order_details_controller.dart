import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hcs_driver/features/MyOrders/data/models/order_details_share.dart';

part 'order_details_controller.freezed.dart';

@freezed
class OrderDetailsState with _$OrderDetailsState {
  const factory OrderDetailsState.initial() = _Initial;
  const factory OrderDetailsState.loading() = _Loading;
  const factory OrderDetailsState.loaded(OrderDetailsShare order) = _Loaded;
  const factory OrderDetailsState.error(String errMsg) = _Error;
}
