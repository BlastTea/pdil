import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'export_data_event.dart';
part 'export_data_state.dart';

class ExportDataBloc extends Bloc<ExportDataEvent, ExportDataState> {
  ExportDataBloc() : super(ExportDataInitial());

  @override
  Stream<ExportDataState> mapEventToState(ExportDataEvent event) async* {
    if (event is ExportDataExport) {
      double persentase = event.row / event.maxRow;
      print('exporting : $persentase');
      yield ExportDataProgress(persentase, event.message);
    }
  }
}
