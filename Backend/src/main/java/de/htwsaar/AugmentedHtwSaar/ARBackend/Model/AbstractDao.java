package de.htwsaar.AugmentedHtwSaar.ARBackend.Model;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.SerializationFeature;

import javax.persistence.*;

/**
 * @author Peter Klein, Robin Bachmann, Matthias Tritt
 * <p>
 * Sueprclass for all hibernate Dao classes
 */
@MappedSuperclass
public class AbstractDao implements DaoEntityInterface {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id", unique = true)
    protected String Id;

    public String getId() {
        return Id;
    }

    public void setId(String id) {
        Id = id;
    }

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
