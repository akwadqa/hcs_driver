import 'package:equatable/equatable.dart';
import 'package:hcs_driver/src/enums/request_state.dart';

class SubmitServiceState extends Equatable {
  //SubmitService
  final RequestStates submitServiceStates;
  final String? submitServiceMessage;

  const SubmitServiceState({
    //SubmitService
    this.submitServiceStates = RequestStates.init,
    this.submitServiceMessage = '',
  });
  SubmitServiceState copyWith({
    //SubmitService
    RequestStates? submitServiceStates,
    String? submitServiceMessage,
  }) {
    return SubmitServiceState(
      //SubmitService
      submitServiceStates: submitServiceStates ?? this.submitServiceStates,
      submitServiceMessage: submitServiceMessage ?? this.submitServiceMessage,
    );
  }

  @override
  List<Object?> get props => [
    //SubmitService
    submitServiceStates,
    submitServiceMessage,
  ];
}
