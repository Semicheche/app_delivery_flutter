import 'package:delivery_app/services/auth/atuh_save_credential.dart';
import 'package:local_auth/local_auth.dart';

class Biometry {
  final LocalAuthentication auth = LocalAuthentication();

  Future<bool> authenticate() async {
    return await auth.authenticate(
        localizedReason: 'Acesse a Biometria para fazer a authenticação!',
        options: const AuthenticationOptions(
          stickyAuth: true,
        ),
      );
  }

  Future<bool> activeBiometry() async {
    AuthSaveCredentials _credentials = AuthSaveCredentials();
    
    return await _credentials.getByKey('biometria') == '1';
  }

  Future<bool> hasBiometric() async {
    

    bool canCheckBiometrics = false;
    try {
      canCheckBiometrics = await auth.canCheckBiometrics;
    } catch (e) {
      print("error biome trics $e");
    }
    print('hasBiometric => $canCheckBiometrics');
    return canCheckBiometrics;
  }
}