package com.protrdrs.util;

import javax.crypto.Cipher;
import javax.crypto.Mac;
import javax.crypto.spec.SecretKeySpec;
import java.util.Base64;

public class EncryptionUtil {
    private static final String ENCRYPTION_KEY = "MySecret12345678"; // 16 chars
    private static final String HMAC_KEY = "AnotherSecretKey";

    public static String encrypt(String data) throws Exception {
        SecretKeySpec key = new SecretKeySpec(ENCRYPTION_KEY.getBytes(), "AES");
        Cipher cipher = Cipher.getInstance("AES/ECB/PKCS5Padding");

        cipher.init(Cipher.ENCRYPT_MODE, key);
        byte[] encrypted = cipher.doFinal(data.getBytes());

        String encryptedBase64 = Base64.getUrlEncoder().withoutPadding().encodeToString(encrypted);
        String hmac = hmacSha256(encryptedBase64);

        return encryptedBase64 + "." + hmac;
    }

    public static String decrypt(String token) throws Exception {
        String[] parts = token.split("\\.");
        if (parts.length != 2) throw new IllegalArgumentException("Invalid token");

        String encryptedBase64 = parts[0];
        String hmac = parts[1];

        if (!hmac.equals(hmacSha256(encryptedBase64))) {
            throw new SecurityException("Token tampering detected!");
        }

        SecretKeySpec key = new SecretKeySpec(ENCRYPTION_KEY.getBytes(), "AES");
        Cipher cipher = Cipher.getInstance("AES/ECB/PKCS5Padding");

        cipher.init(Cipher.DECRYPT_MODE, key);
        byte[] decrypted = cipher.doFinal(Base64.getUrlDecoder().decode(encryptedBase64));
        return new String(decrypted);
    }

    private static String hmacSha256(String data) throws Exception {
        Mac mac = Mac.getInstance("HmacSHA256");
        SecretKeySpec keySpec = new SecretKeySpec(HMAC_KEY.getBytes(), "HmacSHA256");
        mac.init(keySpec);
        byte[] rawHmac = mac.doFinal(data.getBytes());
        return Base64.getUrlEncoder().withoutPadding().encodeToString(rawHmac);
    }
}
