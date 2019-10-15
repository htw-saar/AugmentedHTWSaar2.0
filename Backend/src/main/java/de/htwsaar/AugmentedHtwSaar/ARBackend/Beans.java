package de.htwsaar.AugmentedHtwSaar.ARBackend;

import de.htwsaar.AugmentedHtwSaar.ARBackend.ConfigUtils.AugmentedBackendSpringProperties;
import de.htwsaar.AugmentedHtwSaar.ARBackend.ExternalApis.HTWRoomService.RoomServiceApi;
import feign.jackson.JacksonDecoder;
import feign.jackson.JacksonEncoder;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.stereotype.Component;

import java.util.ArrayList;

/**
 * @author Peter Klein, Robin Bachmann, Matthias Tritt
 * <p>
 * Misc class for many beans
 */

@Component
public class Beans {
    @Autowired
    private AugmentedBackendSpringProperties augmentedBackendSpringProperties;

    @Bean
    public RoomServiceApi requestRoomServiceApi() {
        return new RoomServiceApi(augmentedBackendSpringProperties.getRoomServiceApiBaseUrl(), augmentedBackendSpringProperties.getRoomServiceApiToken(), new JacksonEncoder(), new JacksonDecoder(), new ArrayList<>());
    }
}
