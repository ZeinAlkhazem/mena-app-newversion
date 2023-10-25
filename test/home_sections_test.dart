import 'package:flutter_test/flutter_test.dart';
import 'package:mena/core/functions/main_funcs.dart';
import 'package:mena/modules/home_screen/cubit/home_screen_cubit.dart';
import 'package:mena/modules/home_screen/home_screen.dart';


void main() {
  late HomeScreenCubit homeScreenCubitUT;
  /// try to un something here
  setUp(() => null);

  test(
    'initial test testing',

    () {
      logg('testing test started');
      return 'done';
    },
  );

testWidgets('test home widget', (WidgetTester tester) async{
  tester.pumpWidget(HomeScreen());
  expect(find.text('provider'), findsOneWidget);
  return null;
});
  // group('description', () { });

}


