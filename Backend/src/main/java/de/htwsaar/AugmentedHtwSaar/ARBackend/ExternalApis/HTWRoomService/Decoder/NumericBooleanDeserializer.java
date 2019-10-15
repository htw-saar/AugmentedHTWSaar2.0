package de.htwsaar.AugmentedHtwSaar.ARBackend.ExternalApis.HTWRoomService.Decoder;

import com.fasterxml.jackson.core.JsonParser;
import com.fasterxml.jackson.databind.DeserializationContext;
import com.fasterxml.jackson.databind.JsonDeserializer;

import java.io.IOException;

/**
 * @author Peter Klein, Robin Bachmann, Matthias Tritt
 * <p>
 * Decoder to handle numeric boolean values submitted from the
 * htw-Saar Raumservice Api
 */
public class NumericBooleanDeserializer extends JsonDeserializer<Boolean> {

    @Override
    public Boolean deserialize(JsonParser parser, DeserializationContext context) throws IOException {
        return !"0".equals(parser.getText());
    }
}
