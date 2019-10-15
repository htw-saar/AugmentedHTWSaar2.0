package de.htwsaar.AugmentedHtwSaar.ARBackend.ConfigUtils;

import org.springframework.boot.context.properties.ConfigurationProperties;

import java.util.HashSet;
import java.util.Set;

/**
 * @author Peter Klein, Robin Bachmann, Matthias Tritt
 * <p>
 * Configuration properties defined in the spring
 * application configuration file
 */

@ConfigurationProperties("augmentedbackend.api")
public class AugmentedBackendSpringProperties {
    private Set<String> SkipAuthenticationForPaths = new HashSet<>();
    private String roomServiceApiBaseUrl = "";
    private String roomServiceApiToken = "";

    public Set<String> getSkipAuthenticationForPaths() {
        return SkipAuthenticationForPaths;
    }

    public void setSkipAuthenticationForPaths(Set<String> skipAuthenticationForPaths) {
        SkipAuthenticationForPaths = skipAuthenticationForPaths;
    }

    public String getRoomServiceApiBaseUrl() {
        return roomServiceApiBaseUrl;
    }

    public void setRoomServiceApiBaseUrl(String roomServiceApiBaseUrl) {
        this.roomServiceApiBaseUrl = roomServiceApiBaseUrl;
    }

    public String getRoomServiceApiToken() {
        return roomServiceApiToken;
    }

    public void setRoomServiceApiToken(String roomServiceApiToken) {
        this.roomServiceApiToken = roomServiceApiToken;
    }
}
