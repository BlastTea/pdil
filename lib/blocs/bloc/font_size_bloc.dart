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
  FontSizeBloc() : super(FontSizeResult(title: title, subtitle: subtitle, body1: body1));

  @override
  Stream<FontSizeState> mapEventToState(FontSizeEvent event) async* {
    if (event is FetchFontSize) {
      double titleFontSize = await FontSizeServices.getFontSize() ?? 24;
      yield FontSizeResult(
        title: title.copyWith(fontSize: titleFontSize),
        subtitle: subtitle.copyWith(fontSize: titleFontSize - 6),
        body1: body1.copyWith(fontSize: titleFontSize - 10),
        body2: body2.copyWith(fontSize: titleFontSize - 12),
        width: titleFontSize - 24,
      );
    } else if (event is SaveFontSize) {
      FontSizeServices.saveFontSize(event.fontSize);
      yield FontSizeResult(
        title: title.copyWith(fontSize: event.fontSize),
        subtitle: subtitle.copyWith(fontSize: event.fontSize - 6),
        body1: body1.copyWith(fontSize: event.fontSize - 10),
        body2: body2.copyWith(fontSize: event.fontSize - 12),
        width: event.fontSize - 24,
      );
    }
  }
}
