package com.sprestay.dtdapp007

import android.content.Context
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.security.KeyStore

class MainActivity: FlutterActivity() {

    private val channelName = "dtd/firebase_auth_crypto"

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, channelName)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "resetGenericIdpKeyset" -> {
                        try {
                            resetGenericIdpKeyset()
                            result.success(null)
                        } catch (e: Exception) {
                            result.error(
                                "KEYSET_RESET_FAILED",
                                e.message,
                                null
                            )
                        }
                    }
                    else -> result.notImplemented()
                }
            }
    }

    /**
     * Firebase Auth хранит Tink-ключ браузерного IDP-flow в SharedPreferences
     * "com.google.firebase.auth.api.crypto.<persistenceKey>", а мастер-ключ к нему —
     * в Android Keystore как "firebear_master_key_id.<persistenceKey>".
     *
     * Если Android Keystore инвалидирует мастер-ключ (обновление ОС, смена
     * экрана блокировки, сбой ключевого хранилища устройства), Tink уже не может
     * расшифровать keyset и браузерный вход падает с
     * "Failed to generate/retrieve public encryption key for Generic IDP flow".
     *
     * Удаляем keyset и мастер-ключ: при следующем входе Tink сгенерирует их заново.
     */
    private fun resetGenericIdpKeyset() {
        // "[DEFAULT]" — persistenceKey основного FirebaseApp.
        val prefsName = "com.google.firebase.auth.api.crypto.[DEFAULT]"
        val masterKeyAlias = "firebear_master_key_id.[DEFAULT]"

        val prefs = applicationContext.getSharedPreferences(prefsName, Context.MODE_PRIVATE)
        prefs.edit().clear().apply()

        val keyStore = KeyStore.getInstance("AndroidKeyStore")
        keyStore.load(null)
        if (keyStore.containsAlias(masterKeyAlias)) {
            keyStore.deleteEntry(masterKeyAlias)
        }
    }
}
