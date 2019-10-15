package de.htwsaar.AugmentedHtwSaar.ARBackend.Model.Hibernate;

/**
 * @author Peter Klein, Robin Bachmann, Matthias Tritt
 */

public class EquipmentImpl {
    String name;
    Boolean present;
    String details;

    public EquipmentImpl(String name, Boolean present) {
        this.name = name;
        this.present = present;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public Boolean getPresent() {
        return present;
    }

    public void setPresent(Boolean present) {
        this.present = present;
    }

    public String getDetails() {
        return details;
    }

    public void setDetails(String details) {
        this.details = details;
    }
}


