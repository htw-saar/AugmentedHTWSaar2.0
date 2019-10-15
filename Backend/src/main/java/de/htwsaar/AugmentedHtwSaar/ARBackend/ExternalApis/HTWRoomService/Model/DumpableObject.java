package de.htwsaar.AugmentedHtwSaar.ARBackend.ExternalApis.HTWRoomService.Model;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.SerializationFeature;
import de.htwsaar.AugmentedHtwSaar.ARBackend.Logging.Loggable;

/**
 * @author Peter Klein, Robin Bachmann, Matthias Tritt
 * <p>
 * Represents a dumpable obejct and adds a custom
 * toString method which utilizes a json mapper
 * to print the full object
 */
public class DumpableObject implements Loggable {

    public String toString(Boolean withIndent) {
        ObjectMapper objectMapper = new ObjectMapper();
        try {
            if (withIndent)
                objectMapper.enable(SerializationFeature.INDENT_OUTPUT);
            return objectMapper.writeValueAsString(this);
        } catch (JsonProcessingException e) {
            error(e);
        }
        return null;
    }

    @Override
    public String toString() {
        final String envVariableName = "LOGGER_INDENT_MULTILINE";
        if ((System.getenv(envVariableName) != null) && (System.getenv(envVariableName).toLowerCase().equals("true") || System.getenv(envVariableName).toLowerCase().equals("false")))
            return toString(Boolean.parseBoolean(System.getenv(envVariableName)));
        return toString(false);
    }
}
