package de.htwsaar.AugmentedHtwSaar.ARBackend.ExternalApis.HTWRoomService.RequestInterceptor;

import feign.RequestInterceptor;
import feign.RequestTemplate;

import static feign.Util.checkNotNull;

/**
 * @author Peter Klein, Robin Bachmann, Matthias Tritt
 * <p>
 * RequestInterfeptor to append the api-key
 */
public class AuthenticationRequestInterceptor implements RequestInterceptor {
    private final String APIKey;

    /**
     * Creates an interceptor that authenticates all requests with the specified accessToken
     *
     * @param apiKey the accessToken to use for authentication
     */
    public AuthenticationRequestInterceptor(String apiKey) {
        checkNotNull(apiKey, "key");
        this.APIKey = apiKey;
    }

    @Override
    public void apply(RequestTemplate template) {
        template.query("key", APIKey);
    }
}
