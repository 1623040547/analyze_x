import 'package:source_gen/source_gen.dart';
import 'package:build/build.dart';

import 'gen.dart';

LibraryBuilder myBuilder(BuilderOptions options) => LibraryBuilder(AutoGenerator());
