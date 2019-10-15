package de.htwsaar.AugmentedHtwSaar.ARBackend.Service;

import de.htwsaar.AugmentedHtwSaar.ARBackend.Logging.Loggable;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.nio.charset.Charset;
import java.util.Map;
import java.util.Properties;
import java.util.stream.Collectors;

/**
 * @author Peter Klein, Robin Bachmann, Matthias Tritt
 * <p>
 * Service controller for the translation path
 */
@RestController
@RequestMapping("/api/v1/translation")
public class TranslationService implements Loggable {


    @RequestMapping(value = "/{locale}", method = RequestMethod.GET)
    public ResponseEntity<Map<String, String>> getTranslation(@PathVariable("locale") String locale) {
        InputStream stream = TranslationService.class.getResourceAsStream("/translations/" + locale + ".properties");
        if (stream == null) {
            error("StreamInput null");
            return ResponseEntity.badRequest().build();
        }
        Properties prop = new Properties();
        try {
            prop.load(new InputStreamReader(stream, Charset.forName("UTF-8")));
        } catch (IOException e) {
            error(e);
            return ResponseEntity.status(500).build();
        }

        Map<String, String> translationsMap = prop
                .entrySet()
                .parallelStream()
                .collect(Collectors.toMap(
                        x -> x.getKey().toString(),
                        x -> x.getValue().toString())
                );

        return ResponseEntity.ok().body(translationsMap);
    }
}
