import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_libserialport/flutter_libserialport.dart';

part 'settings_event.dart';
part 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  SettingsBloc() : super(SettingsInitial()) {
    on<SettingsEvent>((event, emit) {
      // TODO: implement event handler
    });

    on<SettingsInit>((event, emit) {
      
    });

    on<SettingsSyncNotes>((event, emit) {
      List<String> ports = SerialPort.availablePorts;
      for (String port in ports) {
        SerialPort temp = SerialPort(port);
        // print(temp.vendorId);
        // print(temp.serialNumber);
        // print(temp.productName);
        // print(temp.description);
        // print(temp.manufacturer);
        // print(temp.productId);
        temp.dispose();
      }
    });
  }
}
