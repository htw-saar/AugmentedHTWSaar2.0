package de.htwsaar.AugmentedHtwSaar.ARBackend.Authenticators;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

/**
 * @author Peter Klein, Robin Bachmann, Matthias Tritt
 * <p>
 * This class handles the injection of the authentication-filter
 * via spring annotation-scanning dependendcy-injection
 */
@Configuration
public class WebConfiguration {
    @Bean
    HMACAuthenticationFilter hmacFilter() {
        return new HMACAuthenticationFilter();
    }
}
