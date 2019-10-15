package de.htwsaar.AugmentedHtwSaar.ARBackend;

import de.htwsaar.AugmentedHtwSaar.ARBackend.ConfigUtils.AugmentedBackendSpringProperties;
import de.htwsaar.AugmentedHtwSaar.ARBackend.ExternalApis.HTWRoomService.RoomServiceApi;
import de.htwsaar.AugmentedHtwSaar.ARBackend.Model.Hibernate.UserImpl;
import de.htwsaar.AugmentedHtwSaar.ARBackend.Model.Repository.UserRepository;
import org.springframework.beans.factory.InitializingBean;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.context.properties.EnableConfigurationProperties;
import org.springframework.context.annotation.Bean;
import org.springframework.web.filter.CommonsRequestLoggingFilter;

/**
 * @author Peter Klein, Robin Bachmann, Matthias Tritt
 * <p>
 * The Server class.
 * <p>
 * Initilizes the db in the InitializingBean
 */
@SpringBootApplication
@EnableConfigurationProperties(AugmentedBackendSpringProperties.class)
public class Server {

    @Autowired
    UserRepository userRepository;

    @Autowired
    RoomServiceApi roomServiceApi;

    public static void main(String[] args) {
        SpringApplication.run(Server.class, args);
    }

    @Bean
    InitializingBean setDbBaseline() {
        return () -> {
            userRepository.save(new UserImpl("peter", "secret", "Peter", "Test"));
        };
    }

    @Bean
    public CommonsRequestLoggingFilter requestLoggingFilter() {
        CommonsRequestLoggingFilter loggingFilter = new CommonsRequestLoggingFilter();
        loggingFilter.setIncludeClientInfo(true);
        loggingFilter.setIncludeQueryString(true);
        loggingFilter.setIncludePayload(true);
        loggingFilter.setIncludeHeaders(false);
        return loggingFilter;
    }
}
