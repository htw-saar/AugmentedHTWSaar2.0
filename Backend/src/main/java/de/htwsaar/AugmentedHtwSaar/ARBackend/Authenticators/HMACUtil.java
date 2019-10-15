package de.htwsaar.AugmentedHtwSaar.ARBackend.Authenticators;

import de.htwsaar.AugmentedHtwSaar.ARBackend.Logging.Loggable;
import de.htwsaar.AugmentedHtwSaar.ARBackend.Logging.StaticLogger;

import javax.crypto.Mac;
import javax.crypto.spec.SecretKeySpec;
import java.security.InvalidKeyException;
import java.security.NoSuchAlgorithmException;
import java.util.Collections;
import java.util.Formatter;
import java.util.HashSet;
import java.util.Set;
import java.util.stream.Collectors;

/**
 * @author Peter Klein, Robin Bachmann, Matthias Tritt
 * <p>
 * Handy util class for easy hmac handling of hmac signatures
 */
public class HMACUtil implements Loggable {

    public static final String ALGO_HMAC_SHA1 = "HmacSHA1";
    public static final String ALGO_HMAC_SHA256 = "HmacSHA256";
    public static final String ALGO_HMAC_SHA512 = "HmacSHA512";

    public static final Integer NONCE_LENGTH_MIN = 8;
    public static final Integer TIME_MAX_DRIFT = 60;

    private static final Set<String> SupportedAlgorithms;

    static {
        Set<String> SupportedAlgorithmsTemp = new HashSet<>();
        SupportedAlgorithmsTemp.add(ALGO_HMAC_SHA1);
        SupportedAlgorithmsTemp.add(ALGO_HMAC_SHA256);
        SupportedAlgorithmsTemp.add(ALGO_HMAC_SHA512);
        SupportedAlgorithms = Collections.unmodifiableSet(SupportedAlgorithmsTemp);
    }

    public static Boolean isSupportedAlgorithm(String algorithm) {
        return SupportedAlgorithms.contains(algorithm);
    }

    public static Boolean isValidNonce(String nonce) {
        return nonce.length() >= NONCE_LENGTH_MIN;
    }

    public static Boolean isValidTimestamp(Long timestamp) {
        Long currentTimestamp = (System.currentTimeMillis() / 1000);
        return (
                timestamp <= currentTimestamp + TIME_MAX_DRIFT
                        &&
                        timestamp >= currentTimestamp - TIME_MAX_DRIFT
        );
    }

    public static String calculateDigest(String algorithm, String inputData, String secretKey) throws InvalidKeyException, NoSuchAlgorithmException {
        StaticLogger.trace(HMACUtil.class, "Calculating digest for '{}' with algo ''", algorithm, inputData);
        switch (algorithm) {
            case ALGO_HMAC_SHA1:
                return calculateDigestSHA1(inputData, secretKey);
            case ALGO_HMAC_SHA256:
                return calculateDigestSHA256(inputData, secretKey);
            case ALGO_HMAC_SHA512:
                return calculateDigestSHA512(inputData, secretKey);
            default:
                StaticLogger.error(HMACUtil.class, "No such algorithm assumed '{}'. Supported algorithms are: {}", algorithm, SupportedAlgorithms.parallelStream().collect(Collectors.joining(",")));
                throw new NoSuchAlgorithmException("No such algorithm assumed " + algorithm);
        }
    }

    private static String calculateDigestSHA1(String inputData, String secretKey) throws NoSuchAlgorithmException, InvalidKeyException {
        final String hmacIdentifier = "HmacSHA1";
        SecretKeySpec signingKey = new SecretKeySpec(secretKey.getBytes(), hmacIdentifier);
        Mac macInstance = Mac.getInstance(hmacIdentifier);
        macInstance.init(signingKey);
        return byteArrayToHexString(macInstance.doFinal(inputData.getBytes()));
    }

    private static String calculateDigestSHA256(String inputData, String secretKey) throws NoSuchAlgorithmException, InvalidKeyException {
        final String hmacIdentifier = "HmacSHA256";
        SecretKeySpec signingKey = new SecretKeySpec(secretKey.getBytes(), hmacIdentifier);
        Mac macInstance = Mac.getInstance(hmacIdentifier);
        macInstance.init(signingKey);
        return byteArrayToHexString(macInstance.doFinal(inputData.getBytes()));
    }

    private static String calculateDigestSHA512(String inputData, String secretKey) throws NoSuchAlgorithmException, InvalidKeyException {
        final String hmacIdentifier = "HmacSHA512";
        SecretKeySpec signingKey = new SecretKeySpec(secretKey.getBytes(), hmacIdentifier);
        Mac macInstance = Mac.getInstance(hmacIdentifier);
        macInstance.init(signingKey);
        return byteArrayToHexString(macInstance.doFinal(inputData.getBytes()));
    }

    private static String byteArrayToHexString(byte[] bytes) {
        Formatter formatter = new Formatter();
        for (byte b : bytes)
            formatter.format("%02x", b);
        return formatter.toString();
    }

    public static Boolean digestEquals(String digest1, String digest2) {
        return digest1.equals(digest2);
    }
}
