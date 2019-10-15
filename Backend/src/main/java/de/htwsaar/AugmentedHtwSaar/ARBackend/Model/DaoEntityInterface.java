package de.htwsaar.AugmentedHtwSaar.ARBackend.Model;

import com.fasterxml.jackson.annotation.JsonIgnore;
import de.htwsaar.AugmentedHtwSaar.ARBackend.Logging.Loggable;
import de.htwsaar.AugmentedHtwSaar.ARBackend.Logging.StaticLogger;

import javax.persistence.Column;
import javax.persistence.Id;
import java.lang.reflect.Field;
import java.util.*;

/**
 * @author Peter Klein, Robin Bachmann, Matthias Tritt
 * <p>
 * Interface for easy access of reflection fields
 */

public interface DaoEntityInterface extends Loggable {

    @JsonIgnore
    static Boolean isCollectionType(Class inputType) {
        Boolean typeResult = null;
        typeResult = List.class.isAssignableFrom(inputType) || Map.class.isAssignableFrom(inputType) || Set.class.isAssignableFrom(inputType);
        StaticLogger.trace(DaoEntityInterface.class, "isCollectionType {} -> {}", inputType, Boolean.toString(typeResult));
        return typeResult;
    }

    @JsonIgnore
    static Boolean isComplexType(Class currentType) {
        Boolean typeResult = (DaoEntityInterface.class.isAssignableFrom(currentType) || DaoEntityInterface.class.isAssignableFrom(currentType));
        StaticLogger.trace(DaoEntityInterface.class, "isComplexType {} -> (isAssignableFrom HibernateEntity {}) || (isAssignableFrom HibernateEntity {}) -> {}",
                currentType,
                Boolean.toString(DaoEntityInterface.class.isAssignableFrom(currentType)),
                Boolean.toString(DaoEntityInterface.class.isAssignableFrom(currentType)),
                Boolean.toString(typeResult)
        );
        return typeResult;
    }

    String getId();

    @JsonIgnore
    default List<String> getFieldNames(boolean withIdentity) {
        Field[] declaredFields = getClass().getDeclaredFields();
        List<String> FieldList = new ArrayList<String>();
        for (Field field : declaredFields) {
            if (field.getAnnotationsByType(Id.class).length > 0 && withIdentity == false) {
                // Überspringe ID Feld
            } else if (field.getAnnotationsByType(Column.class).length > 0) {
                FieldList.add(field.getName());
            }
        }
        return FieldList;
    }

    @JsonIgnore
    default Map<String, Object> getFieldsAsMap() {
        List<Field> declaredFields = getAllFields(new LinkedList<Field>(), getClass());

        Map<String, Object> keyValueMap = new TreeMap<>();

        for (Field field : declaredFields) {
            field.setAccessible(true);
            try {
                trace("Gathering field {} of type {} -> {}", field.getName(), field.getType(), field.get(this));
                if (field.get(this) instanceof DaoEntityInterface)
                    keyValueMap.put(field.getName(), field.get(this));
                else if (field.get(this) == null)
                    keyValueMap.put(field.getName(), null);
                else if (field.get(this) instanceof List || field.get(this) instanceof Map || field.get(this) instanceof Set)
                    trace("Skipping collect for collection");
                else
                    keyValueMap.put(field.getName(), field.get(this));
            } catch (IllegalAccessException e) {
                error(e.getMessage());
            }
        }
        trace("getFieldsAsMap() returned map with size {}", keyValueMap.size());
        return keyValueMap;
    }

    @JsonIgnore
    default Map<String, Class> getFieldTypesAsMap() {
        List<Field> declaredFields = getAllFields(new LinkedList<Field>(), getClass());
        Map<String, Class> keyValueMap = new TreeMap<>();

        for (Field field : declaredFields) {
            field.setAccessible(true);
            try {
                if (field.get(this) instanceof DaoEntityInterface)
                    keyValueMap.put(field.getName(), field.get(this).getClass());
                else if (field.get(this) == null)
                    keyValueMap.put(field.getName(), field.getType());
                else if (field.get(this) instanceof List || field.get(this) instanceof Map || field.get(this) instanceof Set)
                    trace("Skipping collect for collection");
                else
                    keyValueMap.put(field.getName(), field.get(this).getClass());
            } catch (IllegalAccessException e) {
                error(e.getMessage());
            }
        }
        return keyValueMap;
    }

    @JsonIgnore
    default Map<String, Object> getSearchableFieldsAsMap() {
        Map<String, Class> typesMap = getFieldTypesAsMap();
        Map<String, Object> searchableFields = new TreeMap<>();

        for (Map.Entry<String, Object> entry : getFieldsAsMap().entrySet()) {
            Class currentFieldType = typesMap.get(entry.getKey());
            if (isCollectionType(currentFieldType) || isComplexType(currentFieldType))
                continue;
            searchableFields.put(entry.getKey(), entry.getValue());
        }
        return searchableFields;
    }

    @JsonIgnore
    default List<Field> getAllFields(List<Field> fields, Class<?> type) {
        fields.addAll(Arrays.asList(type.getDeclaredFields()));

        if (type.getSuperclass() != null) {
            getAllFields(fields, type.getSuperclass());
        }

        return fields;
    }
}