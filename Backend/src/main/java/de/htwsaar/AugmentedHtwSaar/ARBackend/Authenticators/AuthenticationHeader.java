package de.htwsaar.AugmentedHtwSaar.ARBackend.Authenticators;

import de.htwsaar.AugmentedHtwSaar.ARBackend.ExternalApis.HTWRoomService.Model.DumpableObject;

/**
 * @author Peter Klein, Robin Bachmann, Matthias Tritt
 * <p>
 * Contains the "Authentication"-header Format
 */
public class AuthenticationHeader extends DumpableObject {
    private final String Algorithm;
    private final String APIKey;
    private final String Nonce;
    private final Long Timestamp;
    private final String Digest;

    public AuthenticationHeader(String algorithm, String apiKey, String nonce, Long timestamp, String digest) {
        this.Algorithm = algorithm;
        this.APIKey = apiKey;
        this.Nonce = nonce;
        this.Timestamp = timestamp;
        this.Digest = digest;
    }

    public String getAlgorithm() {
        return Algorithm;
    }

    public String getAPIKey() {
        return APIKey;
    }

    public String getNonce() {
        return Nonce;
    }

    public Long getTimestamp() {
        return Timestamp;
    }

    public String getDigest() {
        return Digest;
    }
}
