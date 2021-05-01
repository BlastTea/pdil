part of 'models.dart';

class Changing {
  Pdil currentPdil;
  Pdil pdilBefore;
  bool isSaved;
  bool isChanging;

  Changing(
    this.currentPdil,
    this.pdilBefore,
    this.isSaved,
    this.isChanging,
  );
}
