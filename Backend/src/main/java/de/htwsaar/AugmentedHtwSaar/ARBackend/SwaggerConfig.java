package de.htwsaar.AugmentedHtwSaar.ARBackend;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import springfox.documentation.builders.ApiInfoBuilder;
import springfox.documentation.builders.PathSelectors;
import springfox.documentation.builders.RequestHandlerSelectors;
import springfox.documentation.service.ApiInfo;
import springfox.documentation.service.Contact;
import springfox.documentation.spi.DocumentationType;
import springfox.documentation.spring.web.plugins.Docket;
import springfox.documentation.swagger2.annotations.EnableSwagger2;

/**
 * @author Peter Klein, Robin Bachmann, Matthias Tritt
 * <p>
 * Configuration class for the swagger api-doc util
 */
@Configuration
@EnableSwagger2
public class SwaggerConfig {
    @Bean
    public Docket api() {
        return new Docket(DocumentationType.SWAGGER_2)
                .apiInfo(apiEndPointsInfo())
                .select()
                .apis(RequestHandlerSelectors.basePackage("de.htwsaar"))
                .paths(PathSelectors.any())
                .build();
    }

    private ApiInfo apiEndPointsInfo() {

        return new ApiInfoBuilder().title("Augmented htwSaar Backend REST Api")
                .description("Das Backend der Augmented htwSaar REST Api")
                .contact(new Contact("Prof. Dr. Markus Esch", "https://github.com/htw-saar-informatik/AugmentedHtwSaar", "markus.esch@htwsaar.de"))
                .license("Apache 2.0")
                .licenseUrl("http://www.apache.org/licenses/LICENSE-2.0.html")
                .version("1.0.0")
                .build();
    }
}
