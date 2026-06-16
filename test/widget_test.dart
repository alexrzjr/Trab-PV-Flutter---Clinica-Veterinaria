import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'package:clinica_veterinaria/core/providers/auth_provider.dart';
import 'package:clinica_veterinaria/core/utils/password_utils.dart';
import 'package:clinica_veterinaria/core/utils/validators.dart';
import 'package:clinica_veterinaria/main.dart';

void main() {
  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  group('Validators', () {
    test('CPF válido passa', () {
      expect(Validators.cpf('52998224725'), isNull);
    });

    test('CPF inválido falha', () {
      expect(Validators.cpf('11111111111'), isNotNull);
    });

    test('E-mail válido passa', () {
      expect(Validators.email('teste@email.com'), isNull);
    });
  });

  group('PasswordUtils', () {
    test('Hash e verificação funcionam', () {
      final hash = PasswordUtils.hash('senha123');
      expect(PasswordUtils.verify('senha123', hash), isTrue);
      expect(PasswordUtils.verify('errada', hash), isFalse);
    });

    test('Compatibilidade com senha legada em texto', () {
      expect(PasswordUtils.verify('admin123', 'admin123'), isTrue);
    });
  });

  testWidgets('App inicia na tela de login', (WidgetTester tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => AuthProvider(),
        child: const VetClinicApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Bem-vindo'), findsOneWidget);
    expect(find.text('Entrar'), findsOneWidget);
  });
}
