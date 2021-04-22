import 'package:flutter/material.dart';
import 'package:pdil/blocs/blocs.dart';
import 'package:pdil/models/models.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:pdil/services/services.dart';
import 'package:pdil/utils/utils.dart';

part 'font_size_event.dart';
part 'font_size_state.dart';

class FontSizeBloc extends Bloc<FontSizeEvent, FontSizeState> {
  FontSizeBloc() : super(FontSizeResult(title: title, subtitle: subtitle, body: body));

  @override
  Stream<FontSizeState> mapEventToState(FontSizeEvent event) async* {
    if (event is FetchFontSize) {
      double titleFontSize = await FontSizeServices.getFontSize() ?? 20;
      yield FontSizeResult(
        title: title.copyWith(fontSize: titleFontSize),
        subtitle: subtitle.copyWith(fontSize: titleFontSize - 4),
        body: body.copyWith(fontSize: titleFontSize - 8),
      );
    } else if (event is SaveFontSize) {
      await FontSizeServices.saveFontSize(event.fontSize);
      yield FontSizeResult(
        title: title.copyWith(fontSize: event.fontSize),
        subtitle: subtitle.copyWith(fontSize: event.fontSize - 4),
        body: body.copyWith(fontSize: event.fontSize - 8),
      );
    }
  }
}
