import 'dart:io';
import 'dart:isolate';
import 'dart:math';
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdil/blocs/blocs.dart';
import 'package:pdil/models/models.dart';
import 'package:pdil/services/navigation_helper.dart';
import 'package:pdil/services/services.dart';
import 'package:pdil/utils/utils.dart';
import 'package:pdil/views/animations/animations.dart';
import 'package:pdil/views/widgets/widgets.dart';
import 'package:excel/excel.dart';
import 'package:path/path.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' as xlsio;


import '../../utils/utils.dart';

part 'import_page.dart';
part 'input_page.dart';
part 'splash_screen.dart';
part 'settings_page.dart';
part 'export_page.dart';
part 'font_size_page.dart';
part 'format_page.dart';
part 'edit_format_page.dart';
part 'home_page.dart';
part 'customer_data_page.dart';
part 'pdil_search.dart';
